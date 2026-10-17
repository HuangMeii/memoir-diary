/// The `Ngày` and `Tuần` bodies of the event calendar.
///
/// Built from the `Lịch ngày · Web` (`42:25691`) and `Lịch tuần · Web`
/// (`42:26242`) frames: a 06:00–23:00 canvas, the day's all-day lane, and the
/// events laid out by their start time and duration.
///
/// The widgets here work on [CalendarEntry] rather than the screen's
/// `PlannerEvent`, so the geometry helpers stay pure and unit-testable.
library;

import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme.dart';
import '../tokens.dart';

/// The three views the design's `View control` switches between.
enum CalendarView {
  day('Ngày'),
  week('Tuần'),
  month('Tháng');

  const CalendarView(this.label);

  final String label;
}

/// One of the calendars listed under `Lịch của tôi`.
///
/// Events and schedule items carry a time, so they paint on the timeline;
/// diary pages only know their day and ride in the all-day lane.
enum CalendarSource {
  events('Sự kiện'),
  schedules('Lịch biểu'),
  diary('Nhật ký');

  const CalendarSource(this.label);

  final String label;
}

/// Height of one hour row of the canvas (design: 48).
const double kCalendarHourHeight = 48;

/// The first and last hour the timeline covers.
const int kCalendarFirstHour = 6;
const int kCalendarLastHour = 22;

/// Number of hour rows on the canvas.
const int kCalendarHourCount = kCalendarLastHour - kCalendarFirstHour + 1;

/// Width of the hour gutter on the left of the canvas (design: 52).
const double kCalendarGutterWidth = 52;

/// Smallest height an event block can take, so a half-hour event still fits
/// its title and its time line.
const double kCalendarMinEventHeight = 32;

/// Height of a block in the `Cả ngày` lane; also the height of the lane's
/// placeholder, so the lane keeps one rhythm whether or not it has entries.
const double kCalendarAllDayBlockHeight = 34;

/// One event as the calendar views need it.
class CalendarEntry {
  const CalendarEntry({
    required this.id,
    required this.title,
    required this.start,
    required this.end,
    this.source = CalendarSource.events,
    this.isAllDay = false,
  });

  final String id;
  final String title;
  final DateTime start;

  /// Never before [start]; the screen falls back to one hour when the stored
  /// row has no end.
  final DateTime end;

  /// Which calendar produced this entry. The tint and the `Lịch của tôi`
  /// toggles key off it.
  final CalendarSource source;

  /// True for entries without a time of day (diary pages).
  final bool isAllDay;

  /// `07:00`.
  String get startLabel =>
      '${start.hour.toString().padLeft(2, '0')}:'
      '${start.minute.toString().padLeft(2, '0')}';

  String get endLabel =>
      '${end.hour.toString().padLeft(2, '0')}:'
      '${end.minute.toString().padLeft(2, '0')}';

  /// `07:00–07:30`.
  String get timeLabel => '$startLabel–$endLabel';
}

/// Monday of [day]'s week.
DateTime mondayOf(DateTime day) =>
    DateTime(day.year, day.month, day.day - (day.weekday - 1));

/// Whether [day] falls on the same local date as [other].
bool sameDay(DateTime day, DateTime other) =>
    day.year == other.year && day.month == other.month && day.day == other.day;

/// The entries of one local day, oldest first.
List<CalendarEntry> entriesOn(List<CalendarEntry> entries, DateTime day) {
  final list = entries.where((e) => sameDay(e.start, day)).toList()
    ..sort((a, b) => a.start.compareTo(b.start));
  return list;
}

/// The entries whose day falls inside the `[from, to]` dates, oldest first.
///
/// The bounds are compared by day, so passing midnight (a plain date) still
/// keeps that day's events.
List<CalendarEntry> entriesBetween(
  List<CalendarEntry> entries,
  DateTime from,
  DateTime to,
) {
  final first = DateTime(from.year, from.month, from.day);
  final last = DateTime(to.year, to.month, to.day).add(const Duration(days: 1));
  final list = entries
      .where((e) => !e.start.isBefore(first) && e.start.isBefore(last))
      .toList()
    ..sort((a, b) => a.start.compareTo(b.start));
  return list;
}

/// The entries of the calendars ticked in `Lịch của tôi`.
List<CalendarEntry> visibleEntries(
  List<CalendarEntry> entries,
  Set<CalendarSource> visible,
) =>
    entries.where((entry) => visible.contains(entry.source)).toList();

/// Where [entry] sits inside the 06:00–23:00 canvas, or null when it falls
/// completely outside that window.
({double top, double height})? timelineSlot(
  CalendarEntry entry, {
  double hourHeight = kCalendarHourHeight,
}) {
  final day = DateTime(entry.start.year, entry.start.month, entry.start.day);
  final windowStart = day.add(const Duration(hours: kCalendarFirstHour));
  final windowEnd = day.add(const Duration(hours: kCalendarLastHour + 1));
  final end = entry.end.isAfter(entry.start)
      ? entry.end
      : entry.start.add(const Duration(hours: 1));

  if (!end.isAfter(windowStart) || !entry.start.isBefore(windowEnd)) return null;

  final start = entry.start.isBefore(windowStart) ? windowStart : entry.start;
  final stop = end.isAfter(windowEnd) ? windowEnd : end;
  final minutes = stop.difference(start).inMinutes.toDouble();

  return (
    top: start.difference(windowStart).inMinutes / 60 * hourHeight,
    height: math.max(kCalendarMinEventHeight, minutes / 60 * hourHeight),
  );
}

/// `06:00` for the row starting at [hour].
String calendarHourLabel(int hour) => '${hour.toString().padLeft(2, '0')}:00';

/// The tint the frames give the calendars in `Lịch của tôi`.
///
/// Each of the three calendars owns one tone — brand for events, amber for the
/// timetable, teal for the diary — so a block read against the sidebar tells
/// you which calendar it came from.
class CalendarEventTint {
  const CalendarEventTint({required this.background, required this.accent});

  final Color background;
  final Color accent;
}

CalendarEventTint calendarEventTint(BuildContext context, CalendarEntry entry) {
  final palette = MemoirPalette.of(context);
  final theme = Theme.of(context);
  switch (entry.source) {
    case CalendarSource.events:
      return CalendarEventTint(
        background: palette.surfaceBrandSubtle,
        accent: theme.colorScheme.primary,
      );
    case CalendarSource.schedules:
      return CalendarEventTint(
        background: palette.warningSurface,
        accent: palette.warningText,
      );
    case CalendarSource.diary:
      return CalendarEventTint(
        background: palette.rainChart.withValues(alpha: 0.18),
        accent: palette.rainChart,
      );
  }
}

/// The colour the sidebar uses for a calendar's checkbox and dots.
Color calendarSourceAccent(BuildContext context, CalendarSource source) =>
    calendarEventTint(
      context,
      CalendarEntry(
        id: source.name,
        title: source.label,
        start: DateTime(2000),
        end: DateTime(2000),
        source: source,
      ),
    ).accent;

/// One event block: a tinted rectangle with a coloured left edge, its title and
/// its time range.
class CalendarEventBlock extends StatelessWidget {
  const CalendarEventBlock({
    super.key,
    required this.entry,
    required this.scale,
    this.showTime = true,
  });

  final CalendarEntry entry;
  final double scale;

  /// Draws the `07:00–07:30` line under the title.
  final bool showTime;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tint = calendarEventTint(context, entry);

    return ClipRRect(
      borderRadius: BorderRadius.circular(MemoirRadius.weather6 * scale),
      child: ColoredBox(
        color: tint.background,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(width: 3 * scale, color: tint.accent),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MemoirSpace.custom6 * scale,
                  vertical: 2 * scale,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      entry.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: theme.colorScheme.onSurface,
                        fontSize: MemoirType.caption,
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                      ),
                    ),
                    if (showTime)
                      Text(
                        entry.timeLabel,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontSize: MemoirType.caption,
                          height: 1.2,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The 06:00–23:00 grid: the hour labels in the left gutter and one hairline
/// per hour.
class CalendarHourCanvas extends StatelessWidget {
  const CalendarHourCanvas({
    super.key,
    required this.columns,
    required this.scale,
  });

  /// Number of day columns; the day view uses one, the week view seven.
  final int columns;

  final double scale;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final line = BorderSide(color: theme.colorScheme.outlineVariant);
    final labelStyle = theme.textTheme.bodySmall?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
      fontSize: MemoirType.caption,
    );

    return Column(
      children: [
        for (var hour = kCalendarFirstHour;
            hour <= kCalendarLastHour;
            hour++)
          SizedBox(
            height: kCalendarHourHeight * scale,
            child: Row(
              children: [
                SizedBox(
                  width: kCalendarGutterWidth * scale,
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: MemoirSpace.custom6 * scale,
                      top: MemoirSpace.s1 * scale,
                    ),
                    child: Text(
                      calendarHourLabel(hour),
                      textAlign: TextAlign.right,
                      style: labelStyle,
                    ),
                  ),
                ),
                for (var i = 0; i < columns; i++)
                  Expanded(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border(
                          left: columns > 1 ? line : BorderSide.none,
                          bottom: line,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

/// The `Cả ngày` lane above the canvas.
class CalendarAllDayLane extends StatelessWidget {
  const CalendarAllDayLane({
    super.key,
    required this.scale,
    required this.columns,
    this.entries = const <List<CalendarEntry>>[],
    this.tintedColumns = const <int>{},
  });

  final double scale;
  final int columns;

  /// All-day entries per column; empty columns fall back to the design's
  /// placeholder.
  final List<List<CalendarEntry>> entries;

  /// Columns washed with the selected tint (the week's current day).
  final Set<int> tintedColumns;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurfaceVariant;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: theme.colorScheme.outlineVariant),
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: 3 * scale),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: kCalendarGutterWidth * scale,
            child: Padding(
              padding: EdgeInsets.only(
                right: MemoirSpace.custom6 * scale,
                top: 3 * scale,
              ),
              child: Text(
                'Cả ngày',
                textAlign: TextAlign.right,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: muted,
                  fontSize: MemoirType.caption,
                ),
              ),
            ),
          ),
          for (var i = 0; i < columns; i++)
            Expanded(
              child: Container(
                color: tintedColumns.contains(i)
                    ? theme.colorScheme.primaryContainer.withValues(alpha: 0.35)
                    : null,
                padding: EdgeInsets.symmetric(horizontal: 2 * scale),
                child: _cell(
                  context,
                  i < entries.length ? entries[i] : const <CalendarEntry>[],
                  muted,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _cell(BuildContext context, List<CalendarEntry> day, Color muted) {
    if (day.isEmpty) {
      // The day view names the empty state; the week columns use the dash the
      // frame draws.
      return SizedBox(
        height: kCalendarAllDayBlockHeight * scale,
        child: Center(
          child: Text(
            columns == 1 ? 'Không có sự kiện cả ngày' : '—',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: muted,
                  fontSize: MemoirType.caption,
                ),
          ),
        ),
      );
    }
    return Column(
      children: [
        for (final entry in day)
          Padding(
            padding: EdgeInsets.only(bottom: 2 * scale),
            // The lane is as tall as its content, so the block's stretched row
            // needs a height of its own here.
            child: SizedBox(
              height: kCalendarAllDayBlockHeight * scale,
              child: CalendarEventBlock(
                entry: entry,
                scale: scale,
                showTime: false,
              ),
            ),
          ),
      ],
    );
  }
}

const List<String> _upperWeekdays = [
  'THỨ HAI',
  'THỨ BA',
  'THỨ TƯ',
  'THỨ NĂM',
  'THỨ SÁU',
  'THỨ BẢY',
  'CHỦ NHẬT',
];

const List<String> _shortWeekdays = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];

const List<String> _weekdayNames = [
  'Thứ hai',
  'Thứ ba',
  'Thứ tư',
  'Thứ năm',
  'Thứ sáu',
  'Thứ bảy',
  'Chủ nhật',
];

/// `CHỦ NHẬT`, the header over the day column.
String upperWeekday(DateTime date) => _upperWeekdays[date.weekday - 1];

/// `CN`, the header over a week column.
String shortWeekday(DateTime date) => _shortWeekdays[date.weekday - 1];

/// `Chủ nhật`, as the period title spells it.
String weekdayName(DateTime date) => _weekdayNames[date.weekday - 1];

/// One entry placed in the day's lane layout.
class CalendarEntrySlot {
  const CalendarEntrySlot({
    required this.entry,
    required this.lane,
    required this.lanes,
  });

  final CalendarEntry entry;

  /// Column the entry sits in, 0-based.
  final int lane;

  /// How many lanes its overlap cluster needs.
  final int lanes;
}

/// Lays overlapping events out side by side.
///
/// Events are grouped into clusters of transitively overlapping intervals;
/// inside a cluster an event takes the first lane whose previous event has
/// already ended, and the cluster's lane count splits the column width.
List<CalendarEntrySlot> dayLanes(List<CalendarEntry> entries) {
  final sorted = [...entries]..sort((a, b) => a.start.compareTo(b.start));
  final result = <CalendarEntrySlot>[];
  var cluster = <({CalendarEntry entry, int lane})>[];
  var laneEnds = <DateTime>[];
  DateTime? clusterEnd;

  DateTime endOf(CalendarEntry entry) => entry.end.isAfter(entry.start)
      ? entry.end
      : entry.start.add(const Duration(hours: 1));

  void flush() {
    final lanes = laneEnds.isEmpty ? 1 : laneEnds.length;
    for (final item in cluster) {
      result.add(
        CalendarEntrySlot(entry: item.entry, lane: item.lane, lanes: lanes),
      );
    }
    cluster = [];
    laneEnds = [];
    clusterEnd = null;
  }

  for (final entry in sorted) {
    final end = endOf(entry);
    if (clusterEnd != null && entry.start.isBefore(clusterEnd!)) {
      // Still inside the running cluster.
    } else {
      flush();
    }

    var lane = laneEnds.indexWhere((laneEnd) => !entry.start.isBefore(laneEnd));
    if (lane < 0) {
      laneEnds.add(end);
      lane = laneEnds.length - 1;
    } else {
      laneEnds[lane] = end;
    }

    cluster.add((entry: entry, lane: lane));
    if (clusterEnd == null || end.isAfter(clusterEnd!)) clusterEnd = end;
  }
  flush();
  return result;
}

/// The `Ngày` body: the day header, the all-day lane and the 06:00–23:00
/// timeline with the day's events laid over it.
class CalendarDaySchedule extends StatelessWidget {
  const CalendarDaySchedule({
    super.key,
    required this.date,
    required this.entries,
    required this.scale,
    this.allDayEntries = const <CalendarEntry>[],
    this.onTapEntry,
  });

  final DateTime date;
  final List<CalendarEntry> entries;
  final double scale;

  /// Entries without a time of day (diary pages), drawn in the `Cả ngày` lane.
  final List<CalendarEntry> allDayEntries;

  final ValueChanged<CalendarEntry>? onTapEntry;

  @override
  Widget build(BuildContext context) {
    final isToday = sameDay(date, DateTime.now());
    final slots = dayLanes(entriesOn(entries, date));
    final canvasHeight = kCalendarHourCount * kCalendarHourHeight * scale;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _header(context, isToday),
        CalendarAllDayLane(
          scale: scale,
          columns: 1,
          entries: [entriesOn(allDayEntries, date)],
        ),
        SizedBox(
          height: canvasHeight,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final plotLeft = kCalendarGutterWidth * scale;
              final plotWidth = math.max(0.0, constraints.maxWidth - plotLeft);
              final blocks = <Widget>[];

              for (final slot in slots) {
                final place = timelineSlot(slot.entry);
                if (place == null) continue;
                final laneWidth = plotWidth / slot.lanes;
                blocks.add(
                  Positioned(
                    left: plotLeft + laneWidth * slot.lane + 2 * scale,
                    width: math.max(0.0, laneWidth - 4 * scale),
                    top: place.top * scale,
                    height: place.height * scale,
                    child: GestureDetector(
                      onTap: onTapEntry == null
                          ? null
                          : () => onTapEntry!(slot.entry),
                      child: CalendarEventBlock(
                        entry: slot.entry,
                        scale: scale,
                      ),
                    ),
                  ),
                );
              }

              return Stack(
                children: [
                  CalendarHourCanvas(columns: 1, scale: scale),
                  ...blocks,
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _header(BuildContext context, bool isToday) {
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurfaceVariant;
    const badge = 28.0;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: theme.colorScheme.outlineVariant),
        ),
      ),
      padding: EdgeInsets.only(
        top: MemoirSpace.s2 * scale,
        bottom: MemoirSpace.s1 * scale,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: kCalendarGutterWidth * scale,
            child: Padding(
              padding: EdgeInsets.only(
                right: MemoirSpace.custom6 * scale,
                top: MemoirSpace.s1 * scale,
              ),
              child: Text(
                'GMT+7',
                textAlign: TextAlign.right,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: muted,
                  fontSize: MemoirType.caption,
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  upperWeekday(date),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: muted,
                    fontSize: MemoirType.caption,
                    letterSpacing: 1.2,
                  ),
                ),
                SizedBox(height: MemoirSpace.s1 * scale),
                Container(
                  width: badge * scale,
                  height: badge * scale,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isToday
                        ? theme.colorScheme.primary
                        : theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8 * scale),
                  ),
                  child: Text(
                    '${date.day}',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: isToday
                          ? theme.colorScheme.onPrimary
                          : theme.colorScheme.onSurface,
                      fontSize: MemoirType.label,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// The `Tuần` body: seven day columns over the same 06:00–23:00 canvas, with
/// the anchor day's column washed and the week's events in their slots.
class CalendarWeekGrid extends StatelessWidget {
  const CalendarWeekGrid({
    super.key,
    required this.anchor,
    required this.entries,
    required this.scale,
    this.allDayEntries = const <CalendarEntry>[],
    this.onTapEntry,
  });

  final DateTime anchor;
  final List<CalendarEntry> entries;
  final double scale;

  /// Entries without a time of day (diary pages), one list per column.
  final List<CalendarEntry> allDayEntries;

  final ValueChanged<CalendarEntry>? onTapEntry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final monday = mondayOf(anchor);
    final days = [for (var i = 0; i < 7; i++) monday.add(Duration(days: i))];
    final now = DateTime.now();
    final selected = days.indexWhere((day) => sameDay(day, anchor));
    final canvasHeight = kCalendarHourCount * kCalendarHourHeight * scale;
    final wash = theme.colorScheme.primaryContainer.withValues(alpha: 0.35);

    return LayoutBuilder(
      builder: (context, constraints) {
        final plotLeft = kCalendarGutterWidth * scale;
        final plotWidth = math.max(0.0, constraints.maxWidth - plotLeft);
        final columnWidth = plotWidth / 7;
        final blocks = <Widget>[];

        for (var i = 0; i < 7; i++) {
          for (final slot in dayLanes(entriesOn(entries, days[i]))) {
            final place = timelineSlot(slot.entry);
            if (place == null) continue;
            final laneWidth = columnWidth / slot.lanes;
            blocks.add(
              Positioned(
                left: plotLeft +
                    columnWidth * i +
                    laneWidth * slot.lane +
                    2 * scale,
                width: math.max(0.0, laneWidth - 4 * scale),
                top: place.top * scale,
                height: place.height * scale,
                child: GestureDetector(
                  onTap: onTapEntry == null
                      ? null
                      : () => onTapEntry!(slot.entry),
                  child: CalendarEventBlock(entry: slot.entry, scale: scale),
                ),
              ),
            );
          }
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _header(context, days, now, selected),
            CalendarAllDayLane(
              scale: scale,
              columns: 7,
              entries: [for (final day in days) entriesOn(allDayEntries, day)],
              tintedColumns: selected >= 0 ? {selected} : const <int>{},
            ),
            SizedBox(
              height: canvasHeight,
              child: Stack(
                children: [
                  if (selected >= 0)
                    Positioned(
                      left: plotLeft + columnWidth * selected,
                      width: columnWidth,
                      top: 0,
                      bottom: 0,
                      child: ColoredBox(color: wash),
                    ),
                  CalendarHourCanvas(columns: 7, scale: scale),
                  ...blocks,
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _header(
    BuildContext context,
    List<DateTime> days,
    DateTime now,
    int selected,
  ) {
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurfaceVariant;
    final line = BorderSide(color: theme.colorScheme.outlineVariant);

    return Container(
      decoration: BoxDecoration(border: Border(bottom: line)),
      padding: EdgeInsets.only(top: MemoirSpace.s2 * scale),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: kCalendarGutterWidth * scale,
            child: Padding(
              padding: EdgeInsets.only(right: MemoirSpace.custom6 * scale),
              child: Text(
                'GMT+7',
                textAlign: TextAlign.right,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: muted,
                  fontSize: MemoirType.caption,
                ),
              ),
            ),
          ),
          for (var i = 0; i < days.length; i++)
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: i == selected
                      ? theme.colorScheme.primaryContainer.withValues(alpha: 0.35)
                      : null,
                  border: Border(left: line),
                ),
                padding: EdgeInsets.only(bottom: MemoirSpace.s2 * scale),
                child: Column(
                  children: [
                    Text(
                      shortWeekday(days[i]),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: muted,
                        fontSize: MemoirType.caption,
                      ),
                    ),
                    SizedBox(height: MemoirSpace.s1 * scale),
                    Text(
                      '${days[i].day}',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: i == selected
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurface,
                        fontSize: MemoirType.body,
                        fontWeight: (i == selected || sameDay(days[i], now))
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
