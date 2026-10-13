import 'package:flutter/material.dart';

import '../../data/models.dart';
import '../icons.dart';
import '../tokens.dart';

/// Best matching Figma weather icon for the backend's condition text.
///
/// The lookups and the forecast use their own names, so this is matched by
/// keyword and falls back to the generic `cloud`.
String weatherIconFor(String condition) {
  final c = condition.toLowerCase();
  if (c.contains('mưa') || c.contains('rain') || c.contains('drizzle')) {
    return 'cloud-rain';
  }
  if (c.contains('giông') || c.contains('thunder') || c.contains('storm')) {
    return 'storm';
  }
  if (c.contains('gió') || c.contains('wind')) {
    return 'wind';
  }
  if (c.contains('nắng') || c.contains('clear') || c.contains('sun')) {
    return 'sun';
  }
  if (c.contains('sương') || c.contains('fog') || c.contains('snow')) {
    return 'weather';
  }
  return 'cloud';
}

/// The Figma weather icon for a condition, tinted with the theme's brand
/// colour like every other `MemoirIcon`.
class WeatherIcon extends StatelessWidget {
  const WeatherIcon({super.key, required this.condition, required this.size});

  final String condition;
  final double size;

  @override
  Widget build(BuildContext context) =>
      MemoirIcon(weatherIconFor(condition), size: size);
}

/// "Hôm nay" hero card (`WEATHER-01`): big icon, temperature, condition,
/// location and the stale-reading chip.
class WeatherTodayCard extends StatelessWidget {
  const WeatherTodayCard({super.key, required this.forecast});

  final WeatherForecast forecast;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final current = forecast.current;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            if (current.condition.isNotEmpty) ...[
              WeatherIcon(condition: current.condition, size: 46),
              const SizedBox(width: 16),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    current.temperature == null
                        ? current.condition
                        : '${current.temperature!.round()}°C',
                    style: theme.textTheme.headlineLarge?.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    current.condition,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    forecast.locationName,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontSize: MemoirType.caption,
                    ),
                  ),
                ],
              ),
            ),
            if (forecast.isStale)
              Chip(
                label: Text(_staleLabel(current.updatedAt)),
                visualDensity: VisualDensity.compact,
              ),
          ],
        ),
      ),
    );
  }
}

/// "Tuần này": seven 76 px day tiles in a horizontal row, one per forecast
/// day.
class WeatherWeekStrip extends StatelessWidget {
  const WeatherWeekStrip({super.key, required this.forecast});

  final WeatherForecast forecast;

  static const _weekdays = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 116,
          child: forecast.daily.isEmpty
              ? Center(
                  child: Text(
                    'Chưa có dự báo tuần này.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                )
              : ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: forecast.daily.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemBuilder: (_, index) {
                    final day = forecast.daily[index];
                    return Container(
                      width: 76,
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 6,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _weekdays[day.date.weekday - 1],
                            style: theme.textTheme.labelSmall,
                          ),
                          WeatherIcon(condition: day.condition, size: 20),
                          Text(
                            '${_temp(day.tempMin)}/${_temp(day.tempMax)}',
                            style: theme.textTheme.labelSmall,
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }

  String _temp(double? value) => value == null ? '--' : '${value.round()}°';
}

/// Label for a cached reading: includes the time it was taken when the server
/// sent one, otherwise falls back to a plain warning.
String _staleLabel(String? updatedAt) {
  final parsed = updatedAt == null ? null : DateTime.tryParse(updatedAt);
  if (parsed == null) return 'Dữ liệu cũ';
  final local = parsed.toLocal();
  final hh = local.hour.toString().padLeft(2, '0');
  final mm = local.minute.toString().padLeft(2, '0');
  return 'Dữ liệu cũ · cập nhật $hh:$mm';
}
