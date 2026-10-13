import 'package:flutter/material.dart';

import '../../data/models.dart';

/// The weekly forecast, used by the weather utility
/// (Tiện ích → Thời tiết). It is deliberately not part of Home: Home is for
/// recording today, while reading the forecast lives in the utilities.
class WeatherForecastView extends StatelessWidget {
  const WeatherForecastView({super.key, required this.forecast});

  final WeatherForecast forecast;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final current = forecast.current;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(current.icon, style: const TextStyle(fontSize: 34)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        current.temperature == null
                            ? current.condition
                            : '${current.temperature!.round()}°C · ${current.condition}',
                        style: theme.textTheme.titleMedium,
                      ),
                      Text(
                        forecast.locationName,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
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
            if (forecast.daily.isNotEmpty) ...[
              const SizedBox(height: 14),
              SizedBox(
                height: 98,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: forecast.daily.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemBuilder: (_, index) =>
                      _DayTile(day: forecast.daily[index]),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
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

class _DayTile extends StatelessWidget {
  const _DayTile({required this.day});

  final WeatherDay day;

  static const _weekdays = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 76,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
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
          Text(day.icon, style: const TextStyle(fontSize: 20)),
          Text(
            '${_temp(day.tempMin)}/${_temp(day.tempMax)}',
            style: theme.textTheme.labelSmall,
          ),
        ],
      ),
    );
  }

  String _temp(double? value) => value == null ? '--' : '${value.round()}°';
}
