import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/auth_provider.dart';
import '../../data/models.dart';
import '../../data/providers.dart';
import '../home/home_scale.dart';
import '../tokens.dart';
import '../weather/location_dialog.dart';
import '../weather/weather_chrome.dart';
import '../weather/weather_period_controls.dart';
import '../weather/weather_tabs.dart';
import '../widgets/app_header.dart';
import '../widgets/segmented_tabs.dart';
import '../widgets/weather_card.dart';
import 'calendar_screen.dart';
import 'month_grids_screen.dart';

/// Width of the `Thời tiết · … · Web` frames: 1280 with 36 px gutters.
const double kWeatherDesignWidth = 1280;

/// Content width of those frames: 1280 minus its 36 px gutters.
const double kWeatherContentWidth = 1208;

/// The three forecast views the design tabs (`Thời tiết · Tuần/Ngày/Theo giờ ·
/// Web`).
enum WeatherView {
  week('Tuần'),
  day('Ngày'),
  hour('Theo giờ');

  const WeatherView(this.label);

  final String label;
}

/// Weather utility (`WEATHER-01`), rebuilt from the `Thời tiết · Tuần/Ngày/
/// Theo giờ · Web` frames: the introduction block with its location controls,
/// the view switcher and the forecast regions of the selected view.
class WeatherScreen extends ConsumerStatefulWidget {
  const WeatherScreen({super.key});

  @override
  ConsumerState<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends ConsumerState<WeatherScreen> {
  WeatherView _view = WeatherView.week;

  /// Which forecast day the `Ngày` and `Theo giờ` views point at.
  int _dayIndex = 0;

  /// Which hour the `Theo giờ` view marks (the design opens on 15:00).
  int _hour = 15;

  /// Guards against a second location save while one is in flight.
  bool _saving = false;

  /// Saves a picked province and refreshes the forecast.
  Future<void> _applyPlace(WeatherPlace place) async {
    if (_saving) return;
    setState(() => _saving = true);
    try {
      await ref.read(weatherRepositoryProvider).setLocation(
            lat: place.lat,
            lon: place.lon,
            name: place.name,
          );
      ref.invalidate(weatherProvider);
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Đã chọn ${place.name}')));
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('$error')));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  /// Opens the `Chọn địa điểm` dialog (`46:9100`).
  Future<void> _openLocationDialog(String currentName) async {
    final place = await showDialog<WeatherPlace>(
      context: context,
      builder: (_) => LocationDialog(
        currentName: currentName,
        places: kWeatherPlaces,
      ),
    );
    if (place != null) await _applyPlace(place);
  }

  static String _titleFor(WeatherView view) => switch (view) {
        WeatherView.week => 'Thời tiết trong tuần',
        WeatherView.day => 'Thời tiết trong ngày',
        WeatherView.hour => 'Thời tiết từng giờ',
      };

  @override
  Widget build(BuildContext context) {
    final weather = ref.watch(weatherProvider);
    final displayName =
        ref.watch(authProvider).user?['display_name'] as String?;

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final scale = homeScaleFor(
            constraints.maxWidth,
            designWidth: kWeatherDesignWidth,
          );
          final textScale = homeTextScaleFor(
            constraints.maxWidth,
            designWidth: kWeatherDesignWidth,
          );
          final gutter = math.max(
            16.0,
            (constraints.maxWidth - kWeatherContentWidth * scale) / 2,
          );
          final media = MediaQuery.of(context);

          return MediaQuery(
            data: media.copyWith(
              textScaler: textScale == 1
                  ? media.textScaler
                  : HomeTextScaler(base: media.textScaler, factor: textScale),
            ),
            child: HomeScale(
              factor: scale,
              textFactor: textScale,
              child: SafeArea(
                bottom: false,
                child: Column(
                  children: [
                    AppHeader(
                      date: DateTime.now(),
                      initials: initialsOf(displayName),
                      name: displayName,
                      // The utilities sit under the home in the design's
                      // navigation, so none of the three destinations is the
                      // current page here.
                      destination: AppDestination.home,
                      onNavigate: (destination) {
                        if (destination == AppDestination.monthGrid) {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => const MonthGridsScreen(),
                            ),
                          );
                        } else if (destination ==
                            AppDestination.eventHistory) {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => const CalendarScreen(),
                            ),
                          );
                        }
                      },
                      showUtilities: true,
                      gutter: gutter,
                      onLogout: () => ref.read(authProvider.notifier).logout(),
                    ),
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.fromLTRB(
                          gutter,
                          MemoirSpace.s4 * scale,
                          gutter,
                          MemoirSpace.s8 * scale,
                        ),
                        children: [
                          WeatherBreadcrumb(
                            scale: scale,
                            onBack: () => Navigator.of(context).maybePop(),
                          ),
                          SizedBox(height: MemoirSpace.s3 * scale),
                          weather.when(
                            loading: () => Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: MemoirSpace.s14 * scale,
                              ),
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                            error: (error, _) =>
                                _errorCard(context, scale, '$error'),
                            data: (forecast) =>
                                _content(context, scale, forecast),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// The introduction block, the view switcher and the selected forecast.
  Widget _content(BuildContext context, double scale, WeatherForecast forecast) {
    final days = forecast.daily;
    final index = days.isEmpty ? 0 : _dayIndex.clamp(0, days.length - 1);
    final locationName =
        forecast.locationName.isEmpty ? 'Chọn địa điểm' : forecast.locationName;
    final illustrative = _view != WeatherView.week;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        WeatherHeading(
          overline: 'BẦU TRỜI NHỮNG NGÀY TỚI',
          title: _titleFor(_view),
          description: 'Một chút chuẩn bị, để ngày của bạn nhẹ nhàng hơn.',
          locationName: locationName,
          places: kWeatherPlaces,
          scale: scale,
          onOpenLocationDialog: () =>
              _openLocationDialog(forecast.locationName),
          onPickLocation: _applyPlace,
        ),
        SizedBox(height: MemoirSpace.s4 * scale),
        WeatherDataNotice(
          scale: scale,
          isWarning: forecast.isStale,
          message: forecast.isStale
              ? 'Dữ liệu cũ · cập nhật '
                  '${weatherUpdatedLabel(forecast.current.updatedAt)}'
              : 'Dữ liệu trực tiếp · Open-Meteo',
          onRefresh: () => ref.invalidate(weatherProvider),
        ),
        SizedBox(height: MemoirSpace.s4 * scale),
        WeatherPeriodControls<WeatherView>(
          options: [
            for (final view in WeatherView.values)
              SegmentedTab(view, view.label),
          ],
          selected: _view,
          onChanged: (view) => setState(() => _view = view),
          rangeLabel: weekRangeLabel(days),
          // The API only serves the window starting today, so the chevrons have
          // nowhere to go yet.
          inertTooltip: 'Chỉ có dự báo 7 ngày tới',
          scale: scale,
        ),
        if (illustrative && days.isNotEmpty) ...[
          SizedBox(height: MemoirSpace.s3 * scale),
          WeatherDaySelection(
            days: days,
            selectedIndex: index,
            onSelect: (value) => setState(() => _dayIndex = value),
            scale: scale,
          ),
        ],
        SizedBox(height: MemoirSpace.s4 * scale),
        if (days.isEmpty)
          _emptyCard(context, scale)
        else
          _body(context, scale, days, index),
        SizedBox(height: MemoirSpace.s5 * scale),
        WeatherSourceNote(
          message: 'Nguồn: Open-Meteo · Vị trí: $locationName'
              '${illustrative ? ' · Số liệu theo giờ và lượng mưa là minh họa.' : ''}',
          scale: scale,
        ),
      ],
    );
  }

  /// The forecast regions of the view currently on.
  Widget _body(
    BuildContext context,
    double scale,
    List<WeatherDay> days,
    int index,
  ) {
    switch (_view) {
      case WeatherView.week:
        return WeatherWeekTab(
          days: days,
          selectedIndex: index,
          onSelectDay: (value) => setState(() => _dayIndex = value),
          onOpenDay: () => setState(() => _view = WeatherView.day),
          scale: scale,
        );
      case WeatherView.day:
        return WeatherDayTab(
          day: days[index],
          scale: scale,
          onOpenHour: () => setState(() => _view = WeatherView.hour),
        );
      case WeatherView.hour:
        return WeatherHourTab(
          day: days[index],
          selectedHour: _hour,
          onSelectHour: (value) => setState(() => _hour = value),
          scale: scale,
        );
    }
  }

  /// Shown when the server has no forecast rows at all.
  Widget _emptyCard(BuildContext context, double scale) =>
      _messageCard(context, scale, Icons.cloud_outlined, 'Chưa có dự báo.');

  /// Shown when `/weather/current` could not answer.
  Widget _errorCard(BuildContext context, double scale, String message) =>
      _messageCard(
        context,
        scale,
        Icons.wifi_off_outlined,
        'Không tải được dự báo: $message',
        onRetry: () => ref.invalidate(weatherProvider),
      );

  Widget _messageCard(
    BuildContext context,
    double scale,
    IconData icon,
    String message, {
    VoidCallback? onRetry,
  }) {
    final theme = Theme.of(context);
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: EdgeInsets.all(MemoirSpace.s5 * scale),
        child: Column(
          children: [
            Icon(icon, size: 24 * scale, color: theme.colorScheme.primary),
            SizedBox(height: MemoirSpace.s3 * scale),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontSize: MemoirType.body,
              ),
            ),
            if (onRetry != null) ...[
              SizedBox(height: MemoirSpace.s3 * scale),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh, size: 16),
                label: const Text('Tải lại'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
