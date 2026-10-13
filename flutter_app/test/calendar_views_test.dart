import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:memoir_app/src/ui/calendar/calendar_views.dart';
import 'package:memoir_app/src/ui/theme.dart';

CalendarEntry entry(String id, DateTime start, DateTime end) =>
    CalendarEntry(id: id, title: 'Sự kiện $id', start: start, end: end);

void main() {
  group('week helpers', () {
    test('mondayOf lands on the Monday of that week', () {
      // 2026-10-11 is a Sunday, so its week opens on Monday the 5th.
      expect(mondayOf(DateTime(2026, 10, 11)), DateTime(2026, 10, 5));
      expect(mondayOf(DateTime(2026, 10, 5)), DateTime(2026, 10, 5));
      expect(mondayOf(DateTime(2026, 10, 10)), DateTime(2026, 10, 5));
    });

    test('the weekday labels follow DateTime.weekday', () {
      final sunday = DateTime(2026, 10, 11);
      expect(weekdayName(sunday), 'Chủ nhật');
      expect(upperWeekday(sunday), 'CHỦ NHẬT');
      expect(shortWeekday(sunday), 'CN');
      expect(weekdayName(DateTime(2026, 10, 5)), 'Thứ hai');
    });
  });

  group('entriesOn', () {
    test('keeps one local day, oldest first', () {
      final entries = [
        entry('b', DateTime(2026, 10, 11, 9), DateTime(2026, 10, 11, 10)),
        entry('a', DateTime(2026, 10, 11, 7), DateTime(2026, 10, 11, 8)),
        entry('c', DateTime(2026, 10, 12, 7), DateTime(2026, 10, 12, 8)),
      ];
      expect(
        entriesOn(entries, DateTime(2026, 10, 11)).map((e) => e.id),
        ['a', 'b'],
      );
      expect(entriesOn(entries, DateTime(2026, 10, 13)), isEmpty);
    });

    test('entriesBetween keeps the range inclusive', () {
      final entries = [
        entry('a', DateTime(2026, 10, 5, 7), DateTime(2026, 10, 5, 8)),
        entry('b', DateTime(2026, 10, 11, 7), DateTime(2026, 10, 11, 8)),
        entry('c', DateTime(2026, 10, 12, 7), DateTime(2026, 10, 12, 8)),
      ];
      expect(
        entriesBetween(entries, DateTime(2026, 10, 5), DateTime(2026, 10, 11))
            .map((e) => e.id),
        ['a', 'b'],
      );
    });
  });

  group('timelineSlot', () {
    test('places an event by its start and duration', () {
      final slot = timelineSlot(
        entry('a', DateTime(2026, 10, 11, 7), DateTime(2026, 10, 11, 7, 30)),
      )!;
      expect(slot.top, kCalendarHourHeight);
      expect(slot.height, kCalendarMinEventHeight);

      final hour = timelineSlot(
        entry('b', DateTime(2026, 10, 11, 9), DateTime(2026, 10, 11, 10)),
      )!;
      expect(hour.top, 3 * kCalendarHourHeight);
      expect(hour.height, kCalendarHourHeight);
    });

    test('clips an event that runs past the window', () {
      final slot = timelineSlot(
        entry('a', DateTime(2026, 10, 11, 5), DateTime(2026, 10, 11, 7)),
      )!;
      expect(slot.top, 0);
      expect(slot.height, kCalendarHourHeight);
    });

    test('drops an event that falls outside the window', () {
      expect(
        timelineSlot(
          entry('a', DateTime(2026, 10, 11, 4), DateTime(2026, 10, 11, 5, 30)),
        ),
        isNull,
      );
      expect(
        timelineSlot(
          entry('b', DateTime(2026, 10, 11, 23), DateTime(2026, 10, 12)),
        ),
        isNull,
      );
    });
  });

  group('dayLanes', () {
    test('keeps events that do not overlap in one lane', () {
      final slots = dayLanes([
        entry('a', DateTime(2026, 10, 11, 7), DateTime(2026, 10, 11, 8)),
        entry('b', DateTime(2026, 10, 11, 9), DateTime(2026, 10, 11, 10)),
      ]);
      expect(slots.map((s) => s.lanes), [1, 1]);
    });

    test('splits overlapping events into separate lanes', () {
      final slots = dayLanes([
        entry('a', DateTime(2026, 10, 11, 9), DateTime(2026, 10, 11, 10)),
        entry('b', DateTime(2026, 10, 11, 9, 30), DateTime(2026, 10, 11, 10, 30)),
      ]);
      expect(slots, hasLength(2));
      expect(slots.map((s) => s.lanes), [2, 2]);
      expect(slots.map((s) => s.lane), [0, 1]);
    });

    test('reuses a lane once the event that held it has ended', () {
      final slots = dayLanes([
        entry('a', DateTime(2026, 10, 11, 9), DateTime(2026, 10, 11, 12)),
        entry('b', DateTime(2026, 10, 11, 9, 30), DateTime(2026, 10, 11, 10)),
        entry('c', DateTime(2026, 10, 11, 10, 30), DateTime(2026, 10, 11, 11)),
      ]);
      expect(slots.map((s) => s.lane), [0, 1, 1]);
      expect(slots.map((s) => s.lanes), [2, 2, 2]);
    });
  });

  testWidgets('the day timeline paints without an exception', (tester) async {
    await tester.pumpWidget(MaterialApp(
      theme: buildTheme(Brightness.light),
      home: Scaffold(
        body: SizedBox(
          width: 900,
          child: SingleChildScrollView(
            child: CalendarDaySchedule(
              date: DateTime(2026, 10, 11),
              entries: [
                entry(
                  'a',
                  DateTime(2026, 10, 11, 7),
                  DateTime(2026, 10, 11, 7, 30),
                ),
                entry('b', DateTime(2026, 10, 11, 9), DateTime(2026, 10, 11, 10)),
              ],
              scale: 1,
            ),
          ),
        ),
      ),
    ));

    expect(find.text('CHỦ NHẬT'), findsOneWidget);
    expect(find.text('Cả ngày'), findsOneWidget);
    expect(find.text('06:00'), findsOneWidget);
    expect(find.text('22:00'), findsOneWidget);
    expect(find.text('Sự kiện a'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('the week grid paints seven columns', (tester) async {
    await tester.pumpWidget(MaterialApp(
      theme: buildTheme(Brightness.light),
      home: Scaffold(
        body: SizedBox(
          width: 900,
          child: SingleChildScrollView(
            child: CalendarWeekGrid(
              anchor: DateTime(2026, 10, 11),
              entries: [
                entry('b', DateTime(2026, 10, 6, 9), DateTime(2026, 10, 6, 10)),
              ],
              scale: 1,
            ),
          ),
        ),
      ),
    ));

    expect(find.text('T2'), findsOneWidget);
    expect(find.text('CN'), findsOneWidget);
    expect(find.text('Sự kiện b'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
