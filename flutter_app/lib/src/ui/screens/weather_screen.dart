import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models.dart';
import '../../data/providers.dart';
import '../tokens.dart';
import '../widgets/weather_card.dart';

/// Weather utility (`WEATHER-01`): today's overview, the week ahead and the
/// saved location, all from the server's `/weather`.
class WeatherScreen extends ConsumerStatefulWidget {
  const WeatherScreen({super.key});

  @override
  ConsumerState<WeatherScreen> createState() => _WeatherScreenState();
}

/// One suggested Vietnamese province / town for the picker.
class _CitySuggestion {
  const _CitySuggestion(this.name, this.lat, this.lon);

  final String name;
  final double lat;
  final double lon;
}

const List<_CitySuggestion> _cities = [
  _CitySuggestion('Hà Nội', 21.0285, 105.8542),
  _CitySuggestion('Hải Phòng', 20.8449, 106.6881),
  _CitySuggestion('Hạ Long', 20.9101, 107.1839),
  _CitySuggestion('Huế', 16.4637, 107.5909),
  _CitySuggestion('Đà Nẵng', 16.0544, 108.2022),
  _CitySuggestion('Nha Trang', 12.2388, 109.1967),
  _CitySuggestion('Đà Lạt', 11.9465, 108.4419),
  _CitySuggestion('TP. Hồ Chí Minh', 10.8231, 106.6297),
  _CitySuggestion('Cần Thơ', 10.0452, 105.7469),
  _CitySuggestion('Phú Quốc', 10.2899, 103.9840),
];

/// The three forecast views the design tabs (`Thời tiết · Tuần/Ngày/Theo giờ ·
/// Web`).
enum _ForecastTab {
  week('Tuần'),
  day('Ngày'),
  hour('Theo giờ');

  const _ForecastTab(this.label);

  final String label;
}

class _WeatherScreenState extends ConsumerState<WeatherScreen> {
  bool _saving = false;
  _ForecastTab _tab = _ForecastTab.week;

  /// Which daily row the `Ngày` tab is looking at.
  int _dayOffset = 0;

  /// The `Chọn địa điểm` picker (`46:9100`); a picked town is sent to
  /// `/weather/location` and the forecast is refetched.
  Future<void> _pickLocation() async {
    final place = await showDialog<_CitySuggestion>(
      context: context,
      builder: (_) => const _LocationDialog(),
    );
    if (place == null || !mounted) return;
    setState(() => _saving = true);
    try {
      await ref.read(weatherRepositoryProvider).setLocation(
            lat: place.lat,
            lon: place.lon,
            name: place.name,
          );
      ref.invalidate(weatherProvider);
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Đã chọn ${place.name}')));
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('$error')));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final weather = ref.watch(weatherProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Thời tiết'),
        actions: [
          IconButton(
            tooltip: 'Chọn địa điểm',
            icon: const Icon(Icons.place_outlined),
            onPressed: _saving ? null : _pickLocation,
          ),
          IconButton(
            tooltip: 'Tải lại',
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(weatherProvider),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _tabBar(context),
          const SizedBox(height: 14),
          weather.when(
            loading: () => const Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, _) => Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Không lấy được dữ liệu thời tiết.\n$error',
                  style: TextStyle(color: theme.colorScheme.error),
                ),
              ),
            ),
            data: (forecast) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'BẦU TRỜI NHỮNG NGÀY TỚI',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontSize: MemoirType.overlineEditorial,
                    letterSpacing: MemoirType.overlineEditorialLetterSpacing,
                  ),
                ),
                const SizedBox(height: 10),
                _viewFor(context, forecast),
                const SizedBox(height: 16),
                Text(
                  'Nguồn: Open-Meteo · Vị trí: ${forecast.locationName}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontSize: MemoirType.caption,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// The `Tuần | Ngày | Theo giờ` switch of the design's period controls.
  Widget _tabBar(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final tab in _ForecastTab.values) ...[
          if (tab != _ForecastTab.values.first) const SizedBox(width: 8),
          InkWell(
            borderRadius: BorderRadius.circular(MemoirRadius.control),
            onTap: () => setState(() => _tab = tab),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: _tab == tab
                    ? theme.colorScheme.primary
                    : theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(MemoirRadius.control),
              ),
              child: Text(
                tab.label,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: _tab == tab
                      ? theme.colorScheme.onPrimary
                      : theme.colorScheme.onSurfaceVariant,
                  fontSize: MemoirType.label,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _viewFor(BuildContext context, WeatherForecast forecast) {
    switch (_tab) {
      case _ForecastTab.week:
        return _weekView(context, forecast);
      case _ForecastTab.day:
        return _dayView(context, forecast);
      case _ForecastTab.hour:
        return _hourView(context, forecast);
    }
  }

  Widget _weekView(BuildContext context, WeatherForecast forecast) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WeatherTodayCard(forecast: forecast),
        const SizedBox(height: 10),
        Text(
          'TUẦN NÀY',
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.primary,
            fontSize: MemoirType.overlineEditorial,
            letterSpacing: MemoirType.overlineEditorialLetterSpacing,
          ),
        ),
        const SizedBox(height: 8),
        if (forecast.daily.isEmpty)
          Text(
            'Chưa có dự báo tuần này.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          )
        else
          Card(
            child: Column(
              children: [
                for (var i = 0; i < forecast.daily.length; i++)
                  _weekRow(
                    context,
                    forecast.daily[i],
                    isToday: i == 0,
                  ),
              ],
            ),
          ),
        const SizedBox(height: 12),
        WeatherWeekStrip(forecast: forecast),
      ],
    );
  }

  /// One row of the weekly table.
  Widget _weekRow(
    BuildContext context,
    WeatherDay day, {
    required bool isToday,
  }) {
    final theme = Theme.of(context);
    String two(int n) => n.toString().padLeft(2, '0');
    return ListTile(
      dense: true,
      leading: WeatherIcon(condition: day.condition, size: 24),
      title: Text(
        isToday ? 'Hôm nay' : _weekdayNames[day.date.weekday - 1],
        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: isToday ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
      subtitle: Text(
        '${two(day.date.day)}/${two(day.date.month)} · ${day.condition}',
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
          fontSize: MemoirType.caption,
        ),
      ),
      trailing: Text(
        '${_temp(day.tempMin)}° / ${_temp(day.tempMax)}°',
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  static const List<String> _weekdayNames = [
    'Thứ hai', 'Thứ ba', 'Thứ tư', 'Thứ năm',
    'Thứ sáu', 'Thứ bảy', 'Chủ nhật',
  ];

  static String _temp(double? value) => value == null ? '--' : '${value.round()}';

  Widget _dayView(BuildContext context, WeatherForecast forecast) {
    final theme = Theme.of(context);
    final days = forecast.daily;
    if (days.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text('Chưa có dự báo.', style: theme.textTheme.bodyMedium),
        ),
      );
    }
    final day = days[_dayOffset.clamp(0, days.length - 1)];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 84,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: days.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (_, i) => _dayChip(
              context,
              days[i],
              selected: i == _dayOffset,
              onTap: () => setState(() => _dayOffset = i),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                WeatherIcon(condition: day.condition, size: 40),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${_weekdayNames[day.date.weekday - 1]} · '
                        '${day.date.day}/${day.date.month}',
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        day.condition,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${_temp(day.tempMin)}° / ${_temp(day.tempMax)}°',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _dayChip(
    BuildContext context,
    WeatherDay day, {
    required bool selected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Container(
        width: 64,
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? theme.colorScheme.primary
              : theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _weekdayNames[day.date.weekday - 1],
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelSmall?.copyWith(
                color: selected
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.onSurfaceVariant,
                fontSize: MemoirType.caption,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${day.date.day}',
              style: theme.textTheme.labelLarge?.copyWith(
                color: selected
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.onSurface,
                fontSize: MemoirType.label,
              ),
            ),
            const SizedBox(height: 2),
            WeatherIcon(condition: day.condition, size: 18),
          ],
        ),
      ),
    );
  }

  /// "Theo giờ" — the design's timeline is a roadmap frame; the backend does
  /// not serve hourly data yet, so the tab says where it stands instead.
  Widget _hourView(BuildContext context, WeatherForecast forecast) {
    final theme = Theme.of(context);
    final condition =
        forecast.daily.isEmpty ? 'cloud' : forecast.daily.first.condition;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                WeatherIcon(condition: condition, size: 26),
                const SizedBox(width: 12),
                Text('Dự báo theo giờ', style: theme.textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'Dữ liệu theo giờ chưa được kết nối.',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 4),
            Text(
              'Khi backend có nguồn theo giờ, từng mốc 06:00–23:00 sẽ hiện ở '
              'tab này — giống frame “Thời tiết · Theo giờ · Web”.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontSize: MemoirType.caption,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

}

/// The `Chọn địa điểm` picker: the search narrows the suggested provinces and
/// tapping one returns it to the screen.
class _LocationDialog extends StatefulWidget {
  const _LocationDialog();

  @override
  State<_LocationDialog> createState() => _LocationDialogState();
}

class _LocationDialogState extends State<_LocationDialog> {
  final _query = TextEditingController();
  String _filter = '';

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final matches = _cities
        .where((c) =>
            _filter.isEmpty ||
            c.name.toLowerCase().contains(_filter.toLowerCase()))
        .toList();

    return Dialog(
      child: SizedBox(
        width: 440,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Chọn địa điểm', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _query,
                    autofocus: true,
                    decoration: const InputDecoration(
                      labelText: 'Tìm tỉnh / thành',
                      hintText: 'Ví dụ: Hà Nội',
                    ),
                    onChanged: (value) =>
                        setState(() => _filter = value.trim()),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: matches.length,
                itemBuilder: (context, index) {
                  final city = matches[index];
                  return ListTile(
                    leading: const Icon(Icons.place_outlined, size: 20),
                    title: Text(city.name),
                    onTap: () => Navigator.of(context).pop(city),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}