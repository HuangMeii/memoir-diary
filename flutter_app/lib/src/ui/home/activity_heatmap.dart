import 'package:flutter/material.dart';

import '../theme.dart';
import '../tokens.dart';
import 'home_scale.dart';

/// One day of the journal heatmap: how many content slots it fills.
class ActivityDay {
  const ActivityDay({required this.filled, required this.total});

  final int filled;
  final int total;

  /// 1..5, or 0 when the day has no entry at all.
  ///
  /// Only tapping the mood and the weather lands on level 1 ("Ít"); a page with
  /// every question answered lands on level 5.
  int get level {
    if (filled <= 0) return 0;
    return (((filled - 1) ~/ 2) + 1).clamp(1, 5);
  }
}

/// Month grid shaded by how complete each day's entry is.
///
/// Columns are calendar weeks (Sunday first), rows are the weekdays, and each
/// cell carries the day number — the layout of the design's `Contribution
/// heatmap`. Days outside the month stay blank, days still to come are washed
/// out, and today is outlined.
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

  /// Weekday names starting on Sunday, matching `DateTime.weekday % 7`.
  static const List<String> _weekdays = ['CN', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = MemoirPalette.of(context);
    final shades = journalHeatmapScale(context);
    final scale = HomeScale.of(context);
    final caption = theme.textTheme.labelSmall?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
      fontSize: MemoirType.overlineEditorial,
    );

    final first = DateTime(month.year, month.month, 1);
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    // Weeks run Sunday -> Saturday, so Sunday is row 0.
    final leading = first.weekday % 7;
    final weekCount = ((leading + daysInMonth) / 7).ceil();
    final gridStart = first.subtract(Duration(days: leading));

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    String weekRange(int week) {
      final start = gridStart.add(Duration(days: week * 7));
      final end = start.add(const Duration(days: 6));
      final from = start.isBefore(first) ? 1 : start.day;
      final to = end.month == first.month && end.year == first.year
          ? end.day
          : daysInMonth;
      return '$from–$to';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SizedBox(
              width: _labelWidth * scale,
              child: Text(monthLabel ?? '', style: caption),
            ),
            for (var week = 0; week < weekCount; week++)
              SizedBox(
                width: (_cell + _gap) * scale,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(weekRange(week), style: caption),
                ),
              ),
          ],
        ),
        SizedBox(height: MemoirSpace.custom6 * scale),
        for (var row = 0; row < 7; row++)
          Row(
            children: [
              SizedBox(
                width: _labelWidth * scale,
                child: Text(_weekdays[row], style: caption),
              ),
              for (var week = 0; week < weekCount; week++)
                _cellFor(
                  context: context,
                  date: gridStart.add(Duration(days: week * 7 + row)),
                  first: first,
                  daysInMonth: daysInMonth,
                  today: today,
                  palette: palette,
                  shades: shades,
                ),
            ],
          ),
      ],
    );
  }
  Widget _cellFor({
    required BuildContext context,
    required DateTime date,
    required DateTime first,
    required int daysInMonth,
    required DateTime today,
    required MemoirPalette palette,
    required List<Color> shades,
  }) {
    final theme = Theme.of(context);
    final scale = HomeScale.of(context);

    // Days belonging to the neighbouring months keep their slot so the rows
    // stay level, but draw nothing.
    if (date.month != first.month || date.year != first.year) {
      return SizedBox(
        width: (_cell + _gap) * scale,
        height: (_cell + _gap) * scale,
      );
    }

    final day = days[_dayKey(date)];
    final isToday = date == today;
    final isFuture = date.isAfter(today);
    final level = day?.level ?? 0;

    final Color background;
    final Color foreground;
    if (level > 0) {
      background = shades[level - 1];
      foreground = level >= 4
          ? theme.colorScheme.onPrimary
          : theme.colorScheme.onSurface;
    } else if (isFuture) {
      background = palette.surfaceBrandSubtle.withValues(alpha: 0.25);
      foreground = palette.textDisabled;
    } else {
      background = palette.surfaceBrandSubtle.withValues(alpha: 0.55);
      foreground = theme.colorScheme.onSurfaceVariant;
    }

    return Padding(
      padding: EdgeInsets.all(_gap / 2 * scale),
      child: Tooltip(
        message: day == null
            ? '${date.day}.${date.month} · chưa ghi'
            : '${date.day}.${date.month} · ${day.filled}/${day.total} mục',
        child: Container(
          width: _cell * scale,
          height: _cell * scale,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: background,
            borderRadius:
                BorderRadius.circular(MemoirRadius.weather6 * scale),
            border: isToday
                ? Border.all(
                    color: theme.colorScheme.primary,
                    width: 2 * scale,
                  )
                : null,
          ),
          child: Text(
            '${date.day}',
            style: theme.textTheme.labelSmall?.copyWith(
              color: foreground,
              fontSize: MemoirType.overlineEditorial,
            ),
          ),
        ),
      ),
    );
  }

  static String _dayKey(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}

