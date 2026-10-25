import 'package:flutter_test/flutter_test.dart';

import 'package:memoir_app/src/data/models.dart';
import 'package:memoir_app/src/ui/health/health_metrics.dart';

/// The cards the "Biến động cân nặng" section draws for the chosen window.
HealthLog _log(DateTime date, double? kg) =>
    HealthLog(id: 'x', logDate: date, weightKg: kg);

void main() {
  // 4 tuần = 28 ngày ending today, split into four 7-day segments.
  final until = DateTime(2026, 10, 25);

  group('weightCardsOf', () {
    test('builds three week averages plus today', () {
      final cards = weightCardsOf(
        [
          _log(DateTime(2026, 9, 28), 59.0), // Tuần 1
          _log(DateTime(2026, 10, 4), 58.8), // Tuần 1
          _log(DateTime(2026, 10, 6), 58.6), // Tuần 2
          _log(DateTime(2026, 10, 13), 58.4), // Tuần 3
          _log(DateTime(2026, 10, 24), 58.3), // Hôm nay
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
      expect(cards[1].kg, closeTo(58.6, 1e-9));
      expect(cards[1].caption, '-0.3 kg');
      expect(cards[2].kg, closeTo(58.4, 1e-9));
      expect(cards[2].caption, '-0.2 kg');
      expect(cards[3].kg, closeTo(58.3, 1e-9));
      expect(cards[3].caption, '-0.1 kg');
      expect(cards[3].isToday, isTrue);
    });

    test('ignores weigh-ins after the window ends', () {
      final cards = weightCardsOf(
        [
          _log(DateTime(2026, 10, 24), 58.3),
          _log(DateTime(2026, 10, 28), 40.0), // future row, must not win
        ],
        WeightRange.fourWeeks,
        until: until,
      );

      expect(cards.last.kg, closeTo(58.3, 1e-9));
    });

    test('leaves missing segments empty', () {
      final cards = weightCardsOf(
        [_log(DateTime(2026, 10, 24), 58.3)],
        WeightRange.fourWeeks,
        until: until,
      );

      expect(cards[0].kg, isNull);
      expect(cards[0].caption, '28/09');
      expect(cards[1].kg, isNull);
      expect(cards[1].caption, '--');
      expect(cards[2].caption, '--');
      expect(cards[3].kg, closeTo(58.3, 1e-9));
      expect(cards[3].caption, '--');
    });

    test('a longer window reaches further back and titles months', () {
      final logs = [_log(DateTime(2026, 8, 1), 61.0)];

      expect(
        weightCardsOf(logs, WeightRange.fourWeeks, until: until).first.kg,
        isNull,
      );
      final months = weightCardsOf(logs, WeightRange.threeMonths, until: until);
      expect(months.first.title, 'Tháng 1');
      expect(months.first.kg, closeTo(61.0, 1e-9));
      expect(months.first.caption, '28/07');
      expect(months.last.title, 'Hôm nay');
    });
  });
}
