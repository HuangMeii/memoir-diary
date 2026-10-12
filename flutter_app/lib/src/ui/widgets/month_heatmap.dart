import 'package:flutter/material.dart';

import '../home/home_scale.dart';
import '../theme.dart';
import '../tokens.dart';

/// A day scored for the heatmap: how many of its content slots are filled.
///
/// [MonthHeatmap] itself only takes colours; this is the score the variants put
/// on top of it, so the home's "Nhịp viết" card and the `Lưới tháng` journal
/// card shade a day the same way.
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

/// Geometry and colours of one day cell in a [MonthHeatmap].
///
/// All the sizes are design pixels: the widget multiplies them by
/// [HomeScale.of] like the rest of the app. When [cellWidth] and [cellHeight]
/// are smaller than the slot the cell floats in the middle of it, which is how
/// the home draws a 24 px number inside a 30 px slot; making them equal fills
/// the slot, which is how `Lưới tháng` draws one mood or weather tile per day.
class MonthHeatmapStyle {
  const MonthHeatmapStyle({
    this.slotWidth = 30,
    this.slotHeight = 30,
    this.cellWidth = 24,
    this.cellHeight = 24,
    this.labelWidth = 26,
    this.radius = 6,
    this.borderColor,
    this.borderWidth = 1,
    this.borderEmpty = false,
    this.emptyColor,
    this.futureColor,
    this.todayFillColor,
    this.todayBorderColor,
    this.todayBorderWidth = 2,
  });

  /// Slot reserved for one day, gap included.
  final double slotWidth;
  final double slotHeight;

  /// Drawn size of the day itself, inside the slot.
  final double cellWidth;
  final double cellHeight;

  /// Width of the weekday column on the left.
  final double labelWidth;

  final double radius;

  /// Stroke around every day that carries a value.
  final Color? borderColor;
  final double borderWidth;

  /// Draws [borderColor] on days with no value too, which is how the mood and
  /// weather tiles read as a calendar of empty boxes.
  final bool borderEmpty;

  /// Fill for a day inside the month that has no value yet, and for a day still
  /// to come. Null leaves the slot empty.
  final Color? emptyColor;
  final Color? futureColor;

  /// Fill and stroke that replace the metric colours on today.
  final Color? todayFillColor;
  final Color? todayBorderColor;
  final double todayBorderWidth;
}

/// One month drawn as calendar weeks (Sunday first) with a weekday column and
/// the design's week-range header ("Tuần · 1–3 · 4–10 …").
///
/// This is the design's `Synchronized contribution grid`. The home's "Nhịp
/// viết" card draws one copy with a number in every cell; `Lưới tháng` draws
/// three side by side — the journal (numbered cells shaded by how complete the
/// day is), the moods and the weather (one filled tile per logged day).
///
/// It only knows about days and colours, never about moods or entries: the
/// caller answers [colorOf], [numberOf] and [tooltipOf] per day.
class MonthHeatmap extends StatelessWidget {
  const MonthHeatmap({
    super.key,
    required this.month,
    required this.style,
    required this.tooltipOf,
    this.colorOf,
    this.numberOf,
    this.numberColorOf,
    this.onDayTap,
    this.clickableWhenEmpty = false,
    this.weekRanges = true,
    this.axisLabel = 'Tuần',
  });

  /// Any day inside the month to render.
  final DateTime month;

  final MonthHeatmapStyle style;

  /// Tooltip for one day; shown on every cell the grid draws.
  final String Function(DateTime date) tooltipOf;

  /// Fill for a day; null means the caller has no value for that day.
  final Color? Function(DateTime date)? colorOf;

  /// Text drawn inside the cell. Null draws no day number at all.
  final String? Function(DateTime date)? numberOf;

  /// Colour of the day number; the theme's body colour by default.
  final Color Function(DateTime date)? numberColorOf;

  /// Fires for days the grid can point at; with [clickableWhenEmpty] that
  /// includes days with no value.
  final ValueChanged<DateTime>? onDayTap;
  final bool clickableWhenEmpty;

  /// Draws the "1–3 / 4–10 / …" ranges above the columns.
  final bool weekRanges;

  /// Caption above the weekday column; the design labels it "Tuần".
  final String axisLabel;

  /// Weekday names starting on Sunday, matching `DateTime.weekday % 7`.
  static const List<String> _weekdays = ['CN', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scale = HomeScale.of(context);
    final caption = theme.textTheme.labelSmall?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );

    final first = DateTime(month.year, month.month, 1);
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    // Weeks run Sunday -> Saturday, so Sunday is row 0.
    final leading = first.weekday % 7;
    final weekCount = ((leading + daysInMonth) / 7).ceil();
    final gridStart = first.subtract(Duration(days: leading));

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
              width: style.labelWidth * scale,
              child: Text(axisLabel, style: caption),
            ),
            for (var week = 0; week < weekCount; week++)
              SizedBox(
                width: style.slotWidth * scale,
                child: weekRanges
                    ? FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(weekRange(week), style: caption),
                      )
                    : null,
              ),
          ],
        ),
        SizedBox(height: MemoirSpace.custom6 * scale),
        for (var row = 0; row < 7; row++)
          Row(
            children: [
              SizedBox(
                width: style.labelWidth * scale,
                child: Text(_weekdays[row], style: caption),
              ),
              for (var week = 0; week < weekCount; week++)
                _cellFor(
                  context: context,
                  date: gridStart.add(Duration(days: week * 7 + row)),
                  first: first,
                  scale: scale,
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
    required double scale,
  }) {
    final slot = SizedBox(
      width: style.slotWidth * scale,
      height: style.slotHeight * scale,
    );
    // Days belonging to the neighbouring months keep their slot so the rows
    // stay level, but draw nothing.
    if (date.month != first.month || date.year != first.year) return slot;

    final theme = Theme.of(context);
    final palette = MemoirPalette.of(context);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final isToday = date == today;
    final isFuture = date.isAfter(today);

    final value = colorOf?.call(date);
    final fill = (isToday ? style.todayFillColor : null) ??
        value ??
        (isFuture ? style.futureColor : style.emptyColor);
    final borderColor = isToday
        ? style.todayBorderColor
        : value != null || style.borderEmpty
            ? style.borderColor
            : null;
    final borderWidth = isToday ? style.todayBorderWidth : style.borderWidth;
    final label = numberOf?.call(date);

    final cell = Container(
      width: style.cellWidth * scale,
      height: style.cellHeight * scale,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: fill,
        borderRadius: BorderRadius.circular(style.radius * scale),
        border: borderColor == null
            ? null
            : Border.all(color: borderColor, width: borderWidth * scale),
      ),
      child: label == null
          ? null
          : Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: numberColorOf?.call(date) ??
                    (fill == null
                        ? palette.textDisabled
                        : theme.colorScheme.onSurface),
              ),
            ),
    );

    final tappable = onDayTap != null && (clickableWhenEmpty || value != null);

    return SizedBox(
      width: style.slotWidth * scale,
      height: style.slotHeight * scale,
      child: Tooltip(
        message: tooltipOf(date),
        child: tappable
            ? InkWell(
                borderRadius: BorderRadius.circular(style.radius * scale),
                onTap: () => onDayTap!(date),
                child: cell,
              )
            : Center(child: cell),
      ),
    );
  }

}
