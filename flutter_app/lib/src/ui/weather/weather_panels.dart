import 'package:flutter/material.dart';

import '../theme.dart';
import '../tokens.dart';
import '../widgets/weather_card.dart';

/// `T2` … `CN` for [date]'s weekday.
String shortWeekday(DateTime date) =>
    const ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'][date.weekday - 1];

/// `Thứ hai` … `Chủ nhật` for [date]'s weekday.
String longWeekday(DateTime date) => const [
      'Thứ hai',
      'Thứ ba',
      'Thứ tư',
      'Thứ năm',
      'Thứ sáu',
      'Thứ bảy',
      'Chủ nhật',
    ][date.weekday - 1];

/// `11.10`.
String shortDate(DateTime date) =>
    '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}';

/// `11.10.2026`.
String fullDate(DateTime date) => '${shortDate(date)}.${date.year}';

/// `31° / 25°`, or `--` while the forecast carries no temperatures.
String temperaturePair(double? high, double? low) {
  String one(double? value) => value == null ? '--' : '${value.round()}°';
  return '${one(high)} / ${one(low)}';
}

/// A label / value stack, e.g. `Lượng mưa trong ngày · 12 mm`.
class WeatherMetricRows extends StatelessWidget {
  const WeatherMetricRows({super.key, required this.rows, required this.scale});

  /// (label, value) pairs, top to bottom.
  final List<(String, String)> rows;

  final double scale;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        for (final row in rows)
          Padding(
            padding: EdgeInsets.symmetric(vertical: MemoirSpace.s1 * scale),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    row.$1,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontSize: MemoirType.body,
                    ),
                  ),
                ),
                Text(
                  row.$2,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontSize: MemoirType.label,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

/// The `Selected day preview` / `Daily conditions` block: overline, the date,
/// the weather summary and the day's metric rows.
class WeatherDaySummary extends StatelessWidget {
  const WeatherDaySummary({
    super.key,
    required this.overline,
    required this.dateLabel,
    required this.condition,
    required this.temperatureLabel,
    required this.metrics,
    required this.scale,
    this.iconSize = 48,
    this.actionLabel,
    this.onAction,
  });

  final String overline;
  final String dateLabel;
  final String condition;
  final String temperatureLabel;
  final List<(String, String)> metrics;
  final double scale;
  final double iconSize;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurfaceVariant;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          overline,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.primary,
            fontSize: MemoirType.overlineEditorial,
            letterSpacing: MemoirType.overlineEditorialLetterSpacing,
          ),
        ),
        SizedBox(height: MemoirSpace.s1 * scale),
        Text(
          dateLabel,
          style: theme.textTheme.headlineSmall?.copyWith(
            color: theme.colorScheme.onSurface,
            fontSize: MemoirType.headingEditorial,
            height: MemoirType.headingEditorialLineHeight /
                MemoirType.headingEditorial,
          ),
        ),
        SizedBox(height: MemoirSpace.s2 * scale),
        Row(
          children: [
            WeatherIcon(condition: condition, size: iconSize),
            SizedBox(width: MemoirSpace.s3 * scale),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    temperatureLabel,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: theme.colorScheme.onSurface,
                      fontSize: MemoirType.heading1,
                      height: MemoirType.heading1LineHeight / MemoirType.heading1,
                    ),
                  ),
                  Text(
                    condition,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: muted,
                      fontSize: MemoirType.body,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: MemoirSpace.s3 * scale),
        WeatherMetricRows(rows: metrics, scale: scale),
        if (actionLabel != null) ...[
          SizedBox(height: MemoirSpace.s3 * scale),
          OutlinedButton.icon(
            onPressed: onAction,
            icon: const Icon(Icons.arrow_forward, size: 16),
            label: Text(actionLabel!),
          ),
        ],
      ],
    );
  }
}


/// `BẦU TRỜI & NHẬT KÝ` — the note that ties the forecast back to the journal.
class ForecastContextCard extends StatelessWidget {
  const ForecastContextCard({super.key, required this.scale});

  final double scale;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = MemoirPalette.of(context);
    final muted = theme.colorScheme.onSurfaceVariant;
    final body = theme.textTheme.bodySmall?.copyWith(
      color: muted,
      fontSize: MemoirType.caption,
      height: 1.5,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'BẦU TRỜI & NHẬT KÝ',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontSize: MemoirType.overlineEditorial,
                      letterSpacing: MemoirType.overlineEditorialLetterSpacing,
                    ),
                  ),
                  SizedBox(height: MemoirSpace.s2 * scale),
                  Text(
                    'Dự báo để chuẩn bị cho ngày mới. Cảm nhận về bầu trời vẫn '
                    'là của riêng bạn.',
                    style: body,
                  ),
                ],
              ),
            ),
            SizedBox(width: MemoirSpace.s3 * scale),
            Icon(
              Icons.eco_outlined,
              size: 46 * scale,
              color: palette.botanicalNote,
            ),
          ],
        ),
        SizedBox(height: MemoirSpace.s3 * scale),
        Text(
          'Dự báo độc lập với 5 lựa chọn tự ghi: Nắng / Mây / Mưa / Gió / Bão. '
          'Không thay đổi dữ liệu nhật ký.',
          style: body,
        ),
      ],
    );
  }
}
