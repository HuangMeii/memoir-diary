import 'package:flutter/material.dart';

import '../theme.dart';
import '../tokens.dart';
import '../widgets/month_heatmap.dart';

/// Month grid shaded by how complete each day's entry is (`Nhịp viết của bạn`).
///
/// A thin variant of [MonthHeatmap] for the home: 24 px cells that carry the
/// day number, shaded by [ActivityDay.level], today outlined. Days outside the
/// month stay blank and days still to come are washed out.
class ActivityHeatmap extends StatelessWidget {
  const ActivityHeatmap({
    super.key,
    required this.month,
    required this.days,
    this.monthLabel,
  });

  /// Any day inside the month to render.
  final DateTime month;

  /// Day key (`YYYY-MM-DD`) to score, for days that have an entry.
  final Map<String, ActivityDay> days;

  /// Caption shown above the week columns; the design labels it "Tuần".
  final String? monthLabel;

  static const double _cell = 24;

  /// Gap around every cell. The design's `Contribution heatmap` is 176 wide:
  /// a 26 px weekday column plus five `24 + 6` columns, and 223 tall: a 13 px
  /// header plus seven `24 + 6` rows.
  static const double _gap = 6;

  static const double _labelWidth = 26;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = MemoirPalette.of(context);
    final shades = journalHeatmapScale(context);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    int levelOf(DateTime date) => days[_dayKey(date)]?.level ?? 0;

    return MonthHeatmap(
      month: month,
      axisLabel: monthLabel ?? '',
      style: MonthHeatmapStyle(
        slotWidth: _cell + _gap,
        slotHeight: _cell + _gap,
        cellWidth: _cell,
        cellHeight: _cell,
        labelWidth: _labelWidth,
        radius: MemoirRadius.weather6,
        emptyColor: palette.surfaceBrandSubtle.withValues(alpha: 0.55),
        futureColor: palette.surfaceBrandSubtle.withValues(alpha: 0.25),
        todayBorderColor: theme.colorScheme.primary,
      ),
      colorOf: (date) {
        final level = levelOf(date);
        return level > 0 ? shades[level - 1] : null;
      },
      numberOf: (date) => '${date.day}',
      numberColorOf: (date) {
        final level = levelOf(date);
        if (level >= 4) return theme.colorScheme.onPrimary;
        if (level > 0) return theme.colorScheme.onSurface;
        return date.isAfter(today)
            ? palette.textDisabled
            : theme.colorScheme.onSurfaceVariant;
      },
      tooltipOf: (date) {
        final day = days[_dayKey(date)];
        return day == null
            ? '${date.day}.${date.month} · chưa ghi'
            : '${date.day}.${date.month} · ${day.filled}/${day.total} mục';
      },
    );
  }

  static String _dayKey(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}
