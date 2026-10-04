import 'package:flutter/material.dart';

import '../../data/models.dart';
import '../theme.dart';

/// A month calendar whose day cells are filled with the mood (or weather)
/// colour and carry no day number. Empty days stay neutral grey; the tooltip
/// reveals the date and the value.
class MonthGrid extends StatelessWidget {
  const MonthGrid({
    super.key,
    required this.cells,
    required this.onDayTap,
    required this.selectedDate,
  });

  /// Height of a day cell, the same as when the calendar still showed numbers.
  static const _cellHeight = 40.0;

  /// Gap applied to every side of every cell.
  static const _gap = 5.0;

  /// Grid cells returned by the API (one per logged day).
  final List<GridCell> cells;

  /// Only fires for days that have data.
  final ValueChanged<DateTime> onDayTap;

  final DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final emptyColor =
        theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.75);

    final colorByDay = <String, Color>{};
    final labelByDay = <String, String>{};
    for (final cell in cells) {
      if (!cell.hasData) continue;
      final key = _keyOf(cell.date);
      colorByDay[key] = colorFromHex(cell.color);
      labelByDay[key] = cell.label ?? '';
    }

    final month = selectedDate ?? DateTime.now();
    final firstDay = DateTime(month.year, month.month, 1);
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    // Monday-first offset for the opening week.
    final leadingBlanks = firstDay.weekday - DateTime.monday;
    // Only as many weeks as the month actually spans, instead of always six.
    final weeks = (leadingBlanks + daysInMonth + 6) ~/ 7;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN']
              .map(
                (d) => Expanded(
                  child: Center(
                    child: Text(
                      d,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 6),
        for (var week = 0; week < weeks; week++) ...[
          Row(
            // No stretch here: a Column hands its child an unbounded height,
            // and stretching to an infinite height throws away the whole row.
            children: List.generate(7, (weekday) {
              final dayNumber = week * 7 + weekday - leadingBlanks + 1;
              if (dayNumber < 1 || dayNumber > daysInMonth) {
                // Outside the month: keep the slot so the row stays level.
                return const Expanded(
                  child: SizedBox(height: _cellHeight),
                );
              }
              final date = DateTime(month.year, month.month, dayNumber);
              final key = _keyOf(date);
              final color = colorByDay[key];
              final isToday = _isSameDay(date, DateTime.now());

              return Expanded(
                child: Padding(
                  // Every side gets a gap. Padding one side only leaves the
                  // cells touching horizontally, so the grid reads as stripes.
                  padding: const EdgeInsets.all(_gap / 2),
                  child: Tooltip(
                    message: color == null
                        ? '$dayNumber · chưa ghi'
                        : '$dayNumber · ${labelByDay[key]}',
                    child: InkWell(
                      borderRadius: BorderRadius.circular(6),
                      onTap: color == null ? null : () => onDayTap(date),
                      child: Container(
                        height: _cellHeight,
                        decoration: BoxDecoration(
                          color: color ?? emptyColor,
                          borderRadius: BorderRadius.circular(6),
                          border: isToday
                              ? Border.all(
                                  color: theme.colorScheme.primary, width: 2)
                              : null,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ],
    );
  }

  static String _keyOf(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  static bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}
/// Legend showing icon + label + colour for each option.
class GridLegend extends StatelessWidget {
  const GridLegend({super.key, required this.items});

  final List<LookupItem> items;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Wrap(
      spacing: 12,
      runSpacing: 6,
      children: items.map((item) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: colorFromHex(item.colorHex),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: theme.colorScheme.outlineVariant),
              ),
            ),
            const SizedBox(width: 5),
            Text('${item.icon} ${item.label}',
                style: theme.textTheme.labelSmall),
          ],
        );
      }).toList(),
    );
  }
}