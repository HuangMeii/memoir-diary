import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:memoir_app/src/data/models.dart';
import 'package:memoir_app/src/ui/calendar/calendar_views.dart';
import 'package:memoir_app/src/ui/screens/calendar_screen.dart';
import 'package:memoir_app/src/ui/theme.dart';

void main() {
  group('PlannerSchedule', () {
    test('parses the snake_case row the backend returns', () {
      final item = PlannerSchedule.fromJson({
        'id': 'abc',
        'title': 'Học Test',
        'start_at': '2026-10-13T11:00:00.000',
        'end_at': '2026-10-13T12:00:00.000',
        'recurrence_rule': 'FREQ=WEEKLY;BYDAY=TU',
        'reminder_minutes': 30,
      });

      expect(item.id, 'abc');
      expect(item.title, 'Học Test');
      expect(item.startAt, DateTime(2026, 10, 13, 11));
      expect(item.endAt, DateTime(2026, 10, 13, 12));
      expect(item.reminderMinutes, 30);
      expect(item.recurrenceLabel, 'Hằng tuần');
    });

    test('tolerates a null end and keeps an unknown rule readable', () {
      final item = PlannerSchedule.fromJson({
        'id': 'abc',
        'title': 'Đọc sách',
        'start_at': '2026-10-13T07:00:00.000',
        'recurrence_rule': 'FREQ=YEARLY',
      });

      expect(item.endAt, isNull);
      expect(item.recurrenceLabel, 'FREQ=YEARLY');
    });

    test('schedulesFromRows maps every row, in order', () {
      final rows = [
        {'id': 'a', 'title': 'A', 'start_at': '2026-10-13T09:00:00.000'},
        {'id': 'b', 'title': 'B', 'start_at': '2026-10-13T08:00:00.000'},
      ];

      expect(schedulesFromRows(rows).map((s) => s.id), ['a', 'b']);
    });
  });

  group('CalendarSource', () {
    CalendarEntry entry(String id, CalendarSource source) => CalendarEntry(
          id: id,
          title: id,
          start: DateTime(2026, 10, 13, 9),
          end: DateTime(2026, 10, 13, 10),
          source: source,
        );

    test('visibleEntries keeps only the ticked calendars', () {
      final entries = [
        entry('e', CalendarSource.events),
        entry('s', CalendarSource.schedules),
        entry('d', CalendarSource.diary),
      ];

      expect(
        visibleEntries(entries, {CalendarSource.events}).map((e) => e.id),
        ['e'],
      );
      expect(
        visibleEntries(
          entries,
          {CalendarSource.schedules, CalendarSource.diary},
        ).map((e) => e.id),
        ['s', 'd'],
      );
      expect(visibleEntries(entries, const <CalendarSource>{}), isEmpty);
    });

    test('a plain CalendarEntry defaults to the events calendar', () {
      final plain = CalendarEntry(
        id: 'x',
        title: 'x',
        start: DateTime(2026, 10, 13),
        end: DateTime(2026, 10, 13),
      );

      expect(plain.source, CalendarSource.events);
      expect(plain.isAllDay, isFalse);
    });
  });

  testWidgets('the all-day lane paints diary pages without a time', (
    tester,
  ) async {
    await tester.pumpWidget(MaterialApp(
      theme: buildTheme(Brightness.light),
      home: Scaffold(
        body: SizedBox(
          width: 900,
          child: SingleChildScrollView(
            child: CalendarDaySchedule(
              date: DateTime(2026, 10, 11),
              entries: const [],
              allDayEntries: [
                CalendarEntry(
                  id: 'd',
                  title: 'Nhật ký',
                  start: DateTime(2026, 10, 11),
                  end: DateTime(2026, 10, 11),
                  source: CalendarSource.diary,
                  isAllDay: true,
                ),
              ],
              scale: 1,
            ),
          ),
        ),
      ),
    ));

    expect(find.text('Nhật ký'), findsOneWidget);
    expect(find.text('Không có sự kiện cả ngày'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  test('DiaryEntry.contentFieldCount stays the scale the tile prints', () {
    expect(DiaryEntry.contentFieldCount, 8);
  });
}
