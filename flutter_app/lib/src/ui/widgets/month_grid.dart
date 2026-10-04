import 'package:flutter/material.dart';

import '../../data/models.dart';
import '../theme.dart';

/// A compact month calendar where each day cell is filled with the mood
/// (or weather) colour. Empty days stay neutral grey.
class MonthGrid extends StatelessWidget {
  const MonthGrid({
    super.key,
    required this.cells,
    required this.onDayTap,
    required this.selectedDate,
  });

  /// Grid cells returned by the API (one per logged day).
  final List<GridCell> cells;

  /// Only fires for days that have data.
  final ValueChanged<DateTime> onDayTap;

  final DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorByDay = {
      for (final cell in cells)
        _keyOf(cell.date): (color: colorFromHex(cell.color), cell: cell),
    };

    final month = selectedDate ?? DateTime.now();
    final firstDay = DateTime(month.year, month.month, 1);
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    // Monday-first offset.
    final leadingBlanks = firstDay.weekday - DateTime.monday;

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
        for (var week = 0; week < 6; week++) ...[
          Row(
            children: List.generate(7, (column) {
              final dayNumber = week * 7 + column - leadingBlanks + 1;
              if (dayNumber < 1 || dayNumber > daysInMonth) {
                return const Expanded(child: SizedBox(height: 40));
              }
              final date = DateTime(month.year, month.month, dayNumber);
              final entry = colorByDay[_keyOf(date)];

              final isToday = _isSameDay(date, DateTime.now());
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: entry == null
                        ? null
                        : () => onDayTap(date),
                    child: Tooltip(
                      message: entry == null
                          ? '$dayNumber'
                          : '${entry.cell.label ?? ''} · $dayNumber',
                      child: Container(
                        height: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: entry?.color ??
                              theme.colorScheme.surfaceContainerHighest
                                  .withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(8),
                          border: isToday
                              ? Border.all(
                                  color: theme.colorScheme.primary, width: 2)
                              : null,
                        ),
                        child: Text(
                          '$dayNumber',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: entry == null
                                ? theme.colorScheme.onSurfaceVariant
                                : _onColor(entry.color),
                            fontWeight:
                                entry == null ? FontWeight.normal : FontWeight.bold,
                          ),
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

  /// Picks readable text for the filled cell background.
  Color _onColor(Color color) =>
      color.computeLuminance() > 0.55 ? Colors.black87 : Colors.white;

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