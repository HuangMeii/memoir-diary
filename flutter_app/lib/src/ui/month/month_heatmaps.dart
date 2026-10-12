import 'package:flutter/material.dart';

import '../../data/models.dart';
import '../../data/providers.dart';
import '../theme.dart';
import '../tokens.dart';
import '../widgets/month_heatmap.dart';

/// Day key (`YYYY-MM-DD`) to entry, as `monthEntriesProvider` returns it.
typedef MonthEntries = Map<String, DiaryEntry>;

/// Tile of the three cards side by side: the design's `Month record card` is
/// 387 wide with a 347 grid, which is a 30 px weekday column plus five 48 px
/// slots and a 42 px row.
const double _labelWidth = 30;
const double _slotWidth = 48;

/// The `Nhật ký` grid: one numbered cell per day, shaded by how much of that
/// day is written.
///
/// The day numbers stay readable on the pale shades, so the darkest days switch
/// the number to the on-primary colour and today is filled with the brand
/// colour outright.
class JournalMonthHeatmap extends StatelessWidget {
  const JournalMonthHeatmap({
    super.key,
    required this.month,
    required this.byDate,
    this.onDayTap,
  });

  /// Any day inside the month to render.
  final DateTime month;

  final MonthEntries byDate;

  final ValueChanged<DateTime>? onDayTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = MemoirPalette.of(context);
    final shades = journalHeatmapScale(context);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    int levelOf(DateTime date) {
      final entry = byDate[dayKey(date)];
      if (entry == null) return 0;
      return ActivityDay(
        filled: entry.filledFields,
        total: DiaryEntry.contentFieldCount,
      ).level;
    }

    return MonthHeatmap(
      month: month,
      style: MonthHeatmapStyle(
        slotWidth: _slotWidth,
        slotHeight: 42,
        cellWidth: 26,
        cellHeight: 26,
        labelWidth: _labelWidth,
        radius: MemoirRadius.weather6,
        todayFillColor: theme.colorScheme.primary,
        todayBorderWidth: 1.5,
      ),
      colorOf: (date) {
        final level = levelOf(date);
        return level > 0 ? shades[level - 1] : null;
      },
      numberOf: (date) => '${date.day}',
      numberColorOf: (date) {
        final level = levelOf(date);
        if (date == today) return theme.colorScheme.onPrimary;
        if (level > 0) return theme.colorScheme.onSurface;
        return date.isAfter(today)
            ? palette.textDisabled
            : theme.colorScheme.onSurfaceVariant;
      },
      tooltipOf: (date) {
        final entry = byDate[dayKey(date)];
        return entry == null
            ? '${date.day}.${date.month} · chưa ghi'
            : '${date.day}.${date.month} · '
                '${entry.filledFields}/${DiaryEntry.contentFieldCount} mục';
      },
      onDayTap: onDayTap,
      clickableWhenEmpty: true,
    );
  }
}

/// The `Cảm xúc` and `Thời tiết` grids: one filled tile per logged day, coloured
/// by whatever value the API stored for that day.
///
/// Days with an entry but no value stay on the page background, and the days
/// still to come are drawn as empty bordered boxes, so all three cards read as
/// the same calendar.
class CategoryMonthHeatmap extends StatelessWidget {
  const CategoryMonthHeatmap({
    super.key,
    required this.month,
    required this.cells,
    this.onDayTap,
  });

  /// Any day inside the month to render.
  final DateTime month;

  /// Grid cells returned by the API (one per logged day).
  final List<GridCell> cells;

  final ValueChanged<DateTime>? onDayTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = MemoirPalette.of(context);
    final byDay = <String, GridCell>{
      for (final cell in cells)
        if (cell.hasData) dayKey(cell.date): cell,
    };

    return MonthHeatmap(
      month: month,
      // The design only labels the week ranges on the journal card; the two
      // category cards sit next to it and keep the columns aligned.
      weekRanges: false,
      style: MonthHeatmapStyle(
        slotWidth: _slotWidth,
        slotHeight: 42,
        cellWidth: _slotWidth,
        cellHeight: 42,
        labelWidth: _labelWidth,
        radius: MemoirRadius.weather6,
        borderColor: palette.borderDefault,
        borderEmpty: true,
        emptyColor: palette.pageBackground,
        todayBorderColor: theme.colorScheme.primary,
        todayBorderWidth: 1.5,
      ),
      colorOf: (date) {
        final cell = byDay[dayKey(date)];
        return cell == null ? null : colorFromHex(cell.color);
      },
      tooltipOf: (date) {
        final cell = byDay[dayKey(date)];
        if (cell == null) return '${date.day}.${date.month} · chưa ghi';
        return '${date.day}.${date.month} · ${cell.label ?? ''}';
      },
      onDayTap: onDayTap,
      clickableWhenEmpty: true,
    );
  }
}
