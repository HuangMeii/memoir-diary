import 'package:flutter_test/flutter_test.dart';

import 'package:memoir_app/src/data/models.dart';
import 'package:memoir_app/src/ui/health/health_metrics.dart';

/// The cards the "Biến động cân nặng" section draws for the chosen window.
HealthLog _log(DateTime date, double? kg) =>
    HealthLog(id: 'x', logDate: date, weightKg: kg);

void main() {
  final until = DateTime(2026, 10, 25);

  group('weightCardsOf · 4 tuần', () {
    test('one card per 7-day week, the last one being the current week', () {
      final cards = weightCardsOf(
        [
          _log(DateTime(2026, 9, 28), 59.0), // Tuần 1 (28/09 - 04/10)
          _log(DateTime(2026, 10, 4), 58.8),
          _log(DateTime(2026, 10, 6), 58.6), // Tuần 2
          _log(DateTime(2026, 10, 13), 58.4), // Tuần 3
          _log(DateTime(2026, 10, 20), 58.5), // Hôm nay (tuần hiện tại)
          _log(DateTime(2026, 10, 24), 58.3),
        ],
        WeightRange.fourWeeks,
        until: until,
      );

      expect(
        cards.map((card) => card.title),
        ['Tuần 1', 'Tuần 2', 'Tuần 3', 'Hôm nay'],
      );
      expect(cards[0].kg, closeTo(58.9, 1e-9));
      expect(cards[0].caption, '28/09');
      expect(cards[0].estimated, isFalse);
      expect(cards[1].kg, closeTo(58.6, 1e-9));
      expect(cards[1].caption, '-0.3 kg');
      expect(cards[2].kg, closeTo(58.4, 1e-9));
      expect(cards[3].kg, closeTo(58.4, 1e-9)); // (58.5 + 58.3) / 2
      expect(cards[3].isToday, isTrue);
      expect(cards[3].caption, '0.0 kg');
    });

    test('ignores weigh-ins dated after today', () {
      final cards = weightCardsOf(
        [
          _log(DateTime(2026, 10, 24), 58.3),
          _log(DateTime(2026, 10, 28), 40.0), // future row
        ],
        WeightRange.fourWeeks,
        until: until,
      );

      expect(cards.last.kg, closeTo(58.3, 1e-9));
    });

    test('carries the nearest weight into empty periods', () {
      final cards = weightCardsOf(
        [_log(DateTime(2026, 10, 24), 58.3)],
        WeightRange.fourWeeks,
        until: until,
      );

      // Every card has a number because the single weigh-in is carried over,
      // but only the current week is real.
      expect(cards.map((card) => card.kg), everyElement(closeTo(58.3, 1e-9)));
      expect(cards[0].estimated, isTrue);
      expect(cards[1].caption, '0.0 kg');
      expect(cards.last.estimated, isFalse);
    });

    test('has no numbers at all when nothing was ever weighed', () {
      final cards = weightCardsOf(
        [_log(DateTime(2026, 10, 24), null)],
        WeightRange.fourWeeks,
        until: until,
      );

      expect(cards.map((card) => card.kg), everyElement(isNull));
      expect(cards.first.caption, '28/09');
      expect(cards[1].caption, '--');
    });
  });

  group('weightCardsOf · months', () {
    test('3 tháng uses calendar months ending with the current one', () {
      final cards = weightCardsOf(
        [
          _log(DateTime(2026, 8, 1), 61.0), // Tháng 1 = August
          _log(DateTime(2026, 9, 15), 59.2), // Tháng 2 = September
          _log(DateTime(2026, 10, 20), 58.4), // Hôm nay = October
        ],
        WeightRange.threeMonths,
        until: until,
      );

      expect(
        cards.map((card) => card.title),
        ['Tháng 1', 'Tháng 2', 'Hôm nay'],
      );
      expect(cards[0].caption, '01/08');
      expect(cards[0].kg, closeTo(61.0, 1e-9));
      expect(cards[1].kg, closeTo(59.2, 1e-9));
      expect(cards.last.kg, closeTo(58.4, 1e-9));
      expect(cards.last.caption, '-0.8 kg');
    });

    test('6 tháng yields six month cards, last one current', () {
      final cards = weightCardsOf(
        [_log(DateTime(2026, 5, 10), 63.0)],
        WeightRange.sixMonths,
        until: until,
      );

      expect(cards, hasLength(6));
      expect(cards.first.title, 'Tháng 1');
      expect(cards.first.caption, '01/05');
      expect(cards.last.title, 'Hôm nay');
      // May is real, the following empty months are carried forward.
      expect(cards.first.estimated, isFalse);
      expect(cards[1].estimated, isTrue);
      expect(cards.last.kg, closeTo(63.0, 1e-9));
    });
  });
}
