import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:memoir_app/src/data/models.dart';
import 'package:memoir_app/src/ui/weather/weather_charts.dart';
import 'package:memoir_app/src/ui/weather/weather_illustrative.dart';
import 'package:memoir_app/src/ui/weather/weather_tabs.dart';

WeatherDay dayOf(String condition, {double? min, double? max, int day = 11}) =>
    WeatherDay(
      date: DateTime(2026, 10, day),
      weatherCode: 0,
      condition: condition,
      icon: '',
      tempMin: min ?? 25,
      tempMax: max ?? 31,
    );

void main() {
  group('hourlySeries', () {
    test('covers the 24 hours of the day in order', () {
      final hours = hourlySeries(dayOf('Mưa rào'));
      expect(hours, hasLength(24));
      expect(hours.map((h) => h.hour), List.generate(24, (i) => i));
      expect(hours.first.label, '00:00');
      expect(hours.last.label, '23:00');
      expect(hours[15].rangeLabel, '15:00–16:00');
    });

    test('keeps the temperature between the day low and high', () {
      final hours = hourlySeries(dayOf('Nắng nhẹ', min: 24, max: 33));
      for (final hour in hours) {
        expect(hour.temperature, greaterThanOrEqualTo(24 - 1e-9));
        expect(hour.temperature, lessThanOrEqualTo(33 + 1e-9));
      }
      // The curve peaks in the afternoon and bottoms out before dawn.
      expect(hours[14].temperature, greaterThan(hours[2].temperature));
    });

    test('spreads the day rain over the hours it belongs to', () {
      final day = dayOf('Mưa nhiều');
      final hours = hourlySeries(day);
      final sum = hours.fold<double>(0, (total, h) => total + h.rainMm);
      expect(sum, closeTo(rainTotalMm(day), 1));
      // Dry hours carry no rain at all.
      expect(hours.where((h) => h.rainMm == 0), isNotEmpty);
    });

    test('is stable across calls', () {
      final first = hourlySeries(dayOf('Mưa rào'));
      final second = hourlySeries(dayOf('Mưa rào'));
      expect(
        first.map((h) => h.temperature).toList(),
        second.map((h) => h.temperature).toList(),
      );
      expect(
        first.map((h) => h.rainMm).toList(),
        second.map((h) => h.rainMm).toList(),
      );
    });

    test('a dry day rains nowhere', () {
      final day = dayOf('Nắng nhẹ', min: 26, max: 34);
      expect(rainTotalMm(day), 0);
      expect(hourlySeries(day).every((h) => h.rainMm == 0), isTrue);
    });
  });

  group('illustrative metrics', () {
    test('stay inside their natural ranges', () {
      for (final condition in const [
        'Nắng',
        'Mây',
        'Mưa rào',
        'Mưa nhiều',
        'Giông bão',
      ]) {
        final day = dayOf(condition);
        expect(rainChance(day), inInclusiveRange(0, 100));
        expect(humidityPercent(day), inInclusiveRange(40, 96));
        expect(windKmh(day), greaterThan(0));
        expect(rainTotalMm(day), greaterThanOrEqualTo(0));
        expect(windDirection(day), isNotEmpty);
      }
    });

    test('a storm is wetter and windier than a sunny day', () {
      final storm = dayOf('Giông bão');
      final sunny = dayOf('Nắng nhẹ');
      expect(rainChance(storm), greaterThan(rainChance(sunny)));
      expect(windKmh(storm), greaterThan(windKmh(sunny)));
    });

    test('the week total adds the days up', () {
      final days = [
        dayOf('Mưa rào', day: 11),
        dayOf('Nắng nhẹ', day: 12),
        dayOf('Mưa nhiều', day: 13),
      ];
      final expected =
          days.fold<double>(0, (sum, day) => sum + rainTotalMm(day));
      expect(rainTotalWeekMm(days), closeTo(expected, 1e-9));
    });
  });

  group('axis helpers', () {
    test('axisTop rounds up to the next step', () {
      expect(axisTop(const [12, 42]), 50);
      expect(axisTop(const [0, 1]), 20);
      expect(axisTop(const [3], step: 1, minimum: 2), 3);
    });

    test('axisTicks run from 0 to the top', () {
      expect(axisTicks(50), [0, 10, 20, 30, 40, 50]);
      expect(axisTicks(2, segments: 2), [0, 1, 2]);
    });

    test('rainAxisTicks step by the unit the design labels', () {
      expect(rainAxisTicks(50), [0, 10, 20, 30, 40, 50]);
      expect(rainAxisTicks(20), [0, 10, 20]);
      expect(rainAxisTicks(2, step: 1), [0, 1, 2]);
    });

    test('rainAxisTop reads the scale from the largest tick', () {
      // axisTicks opens on 0; taking the first tick as the scale flattens the
      // chart and pushes every bar past the canvas.
      expect(rainAxisTicks(20).first, 0);
      expect(rainAxisTop(rainAxisTicks(20)), 20);
      expect(rainAxisTop(rainAxisTicks(2, step: 1)), 2);
      expect(rainAxisTop(const <double>[]), 1);
      expect(rainAxisTop(const [0]), 1);
    });
  });

  group('weather labels', () {
    test('mmLabel drops the trailing zero', () {
      expect(mmLabel(0), '0');
      expect(mmLabel(12), '12');
      expect(mmLabel(2.5), '2.5');
    });

    test('weekRangeLabel names the window', () {
      expect(
        weekRangeLabel([dayOf('Nắng', day: 11), dayOf('Nắng', day: 17)]),
        '11–17 tháng 10, 2026',
      );
      expect(weekRangeLabel(const []), '');
    });

    test('metricRowsFor describes the day with four rows', () {
      final rows = metricRowsFor(dayOf('Mưa rào'));
      expect(rows, hasLength(4));
      expect(rows.first.$1, 'Lượng mưa trong ngày');
      expect(rows[1].$2, endsWith('%'));
      expect(rows.last.$1, 'Độ ẩm');
    });
  });

  testWidgets('RainChart paints without an exception', (tester) async {
    await tester.pumpWidget(MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: RainChart(
            values: const [12, 28, 42, 8, 2, 0, 6],
            labels: const ['11', '12', '13', '14', '15', '16', '17'],
            ticks: axisTicks(50),
            selectedIndex: 2,
          ),
        ),
      ),
    ));
    expect(tester.takeException(), isNull);
  });
}
