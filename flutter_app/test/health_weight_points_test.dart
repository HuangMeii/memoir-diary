import 'package:flutter_test/flutter_test.dart';

import 'package:memoir_app/src/data/models.dart';
import 'package:memoir_app/src/ui/health/health_metrics.dart';

/// The weigh-ins the "Biến động cân nặng" section buckets by day/week/month.
HealthLog _log(DateTime date, double? kg) =>
    HealthLog(id: 'x', logDate: date, weightKg: kg);

void main() {
  final until = DateTime(2026, 10, 25);

  group('weightPointsOf', () {
    test('keeps every weigh-in for the day bucket, oldest first', () {
      final points = weightPointsOf(
        [
          _log(DateTime(2026, 10, 20), 41.4),
          _log(DateTime(2026, 10, 18), 41.0),
          _log(DateTime(2026, 10, 22), 40.6),
        ],
        WeightBucket.day,
        until: until,
      );

      expect(points.map((point) => point.label), ['18/10', '20/10', '22/10']);
      expect(points.map((point) => point.kg), [41.0, 41.4, 40.6]);
    });

    test('averages a week bucket starting on Monday', () {
      final points = weightPointsOf(
        [
          // 19/10/2026 is a Monday.
          _log(DateTime(2026, 10, 19), 40.0),
          _log(DateTime(2026, 10, 21), 41.0),
          _log(DateTime(2026, 10, 25), 42.0),
          _log(DateTime(2026, 10, 12), 43.0),
        ],
        WeightBucket.week,
        until: until,
      );

      expect(points, hasLength(2));
      expect(points.first.label, 'Tuần 12/10');
      expect(points.first.kg, 43.0);
      expect(points.last.label, 'Tuần 19/10');
      expect(points.last.kg, closeTo(41.0, 1e-9));
    });

    test('averages a month bucket by calendar month', () {
      final points = weightPointsOf(
        [
          _log(DateTime(2026, 8, 2), 44.0),
          _log(DateTime(2026, 8, 30), 43.0),
          _log(DateTime(2026, 10, 1), 41.0),
        ],
        WeightBucket.month,
        until: until,
      );

      expect(points.map((point) => point.label), ['Th 08/2026', 'Th 10/2026']);
      expect(points.first.kg, closeTo(43.5, 1e-9));
      expect(points.last.kg, 41.0);
    });

    test('drops weigh-ins outside the 180 day window and null weights', () {
      final points = weightPointsOf(
        [
          _log(DateTime(2026, 10, 25), 40.0),
          _log(DateTime(2025, 10, 1), 50.0),
          _log(DateTime(2026, 10, 20), null),
        ],
        WeightBucket.day,
        until: until,
      );

      expect(points, hasLength(1));
      expect(points.single.kg, 40.0);
    });

    test('returns nothing when every weigh-in is missing', () {
      expect(
        weightPointsOf(
          [_log(DateTime(2026, 10, 25), null)],
          WeightBucket.week,
          until: until,
        ),
        isEmpty,
      );
    });

    test('startOfWeek snaps to the Monday of that week', () {
      expect(startOfWeek(DateTime(2026, 10, 25)), DateTime(2026, 10, 19));
      expect(startOfWeek(DateTime(2026, 10, 19)), DateTime(2026, 10, 19));
    });
  });

  group('weightWindowDays', () {
    test('converts the typed length by unit', () {
      expect(weightWindowDays(5, WeightWindow.day), 5);
      expect(weightWindowDays(2, WeightWindow.week), 14);
      expect(weightWindowDays(6, WeightWindow.month), 180);
    });

    test('clamps to 1–730 days so a stray value cannot blank the series', () {
      expect(weightWindowDays(0, WeightWindow.day), 1);
      expect(weightWindowDays(-3, WeightWindow.week), 1);
      expect(weightWindowDays(999, WeightWindow.month), 730);
    });

    test('labels the window the way the summary reads it', () {
      expect(weightWindowLabel(5, WeightWindow.day), '5 ngày');
      expect(weightWindowLabel(2, WeightWindow.week), '2 tuần');
      expect(weightWindowLabel(0, WeightWindow.month), '1 tháng');
    });
  });

  group('weightPointsOf with a typed window', () {
    test('respects the days it is given', () {
      final logs = [
        _log(DateTime(2026, 10, 24), 40.0),
        _log(DateTime(2026, 10, 15), 41.0),
      ];

      expect(
        weightPointsOf(logs, WeightBucket.day, until: until, days: 5),
        hasLength(1),
      );
      expect(
        weightPointsOf(logs, WeightBucket.day, until: until, days: 30),
        hasLength(2),
      );
    });
  });
}
