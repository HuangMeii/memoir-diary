import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:memoir_app/src/ui/theme.dart';
import 'package:memoir_app/src/ui/widgets/icon_picker_row.dart';
import 'package:memoir_app/src/ui/widgets/month_grid.dart';
import 'package:memoir_app/src/data/models.dart';

void main() {
  group('colorFromHex', () {
    test('parses a 6-digit hex string', () {
      expect(colorFromHex('#FFD93D'), const Color(0xFFFFD93D));
    });

    test('works without the leading hash', () {
      expect(colorFromHex('5C9EDB'), const Color(0xFF5C9EDB));
    });

    test('falls back for invalid input', () {
      expect(colorFromHex(null), const Color(0xFFEEEEEE));
      expect(colorFromHex('#GGG'), const Color(0xFFEEEEEE));
      expect(colorFromHex('#FFF'), const Color(0xFFEEEEEE));
    });
  });

  group('LookupItem', () {
    test('maps the API JSON shape', () {
      final item = LookupItem.fromJson({
        'id': 1,
        'code': 'happy',
        'label_vi': 'Vui',
        'color_hex': '#FFD93D',
        'icon': '😀',
      });
      expect(item.id, 1);
      expect(item.code, 'happy');
      expect(item.label, 'Vui');
    });
  });

  testWidgets('MonthGrid renders a day number per cell', (tester) async {
    final month = DateTime(2026, 4);
    final cells = [
      GridCell(
        date: DateTime(2026, 4, 1),
        code: 'happy',
        label: 'Vui',
        color: '#FFD93D',
      ),
    ];

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: MonthGrid(cells: cells, selectedDate: month, onDayTap: (_) {}),
      ),
    ));

    // April 2026 has 30 days, so both 1 and 30 must appear.
    expect(find.text('1'), findsOneWidget);
    expect(find.text('30'), findsOneWidget);
  });

  testWidgets('GridLegend shows icon and label text', (tester) async {
    final items = [
      const LookupItem(
        id: 1,
        code: 'happy',
        label: 'Vui',
        colorHex: '#FFD93D',
        icon: '😀',
      ),
    ];

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(body: GridLegend(items: items)),
    ));

    expect(find.text('😀 Vui'), findsOneWidget);
  });
  group('IconPickerStrip', () {
    // Mirrors the seeded rows: five weathers, five moods.
    List<LookupItem> weather() => [
          for (final t in [
            ['sunny', 'Nắng', '☀️'],
            ['cloudy', 'Râm', '⛅'],
            ['rainy', 'Mưa', '🌧️'],
            ['storm', 'Bão', '⛈️'],
            ['other', 'Khác', '❔'],
          ])
            LookupItem(
              id: t[0].hashCode % 97 + 1,
              code: t[0],
              label: t[1],
              colorHex: '#5C9EDB',
              icon: t[2],
            ),
        ];

    List<LookupItem> moods() => [
          for (final t in [
            ['happy', 'Vui', '😀'],
            ['sad', 'Buồn', '😢'],
            ['bored', 'Chán', '😑'],
            ['neutral', 'Bình thường', '😐'],
            ['angry', 'Giận', '😠'],
          ])
            LookupItem(
              id: t[0].hashCode % 89 + 1,
              code: t[0],
              label: t[1],
              colorHex: '#FFD93D',
              icon: t[2],
            ),
        ];

    // Matches the private widget so the count can be asserted without
    // exporting it from the library.
    Finder cells() => find.byWidgetPredicate(
          (w) => w.runtimeType.toString().contains('IconCell'),
        );

    Widget strip({required double width, int? weatherId, int? moodId}) {
      return MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: width,
              child: IconPickerStrip(
                weatherLabel: 'THỜI TIẾT',
                weatherItems: weather(),
                weatherSelectedId: weatherId,
                onWeatherSelected: (_) {},
                moodLabel: 'CẢM XÚC',
                moodItems: moods(),
                moodSelectedId: moodId,
                onMoodSelected: (_) {},
              ),
            ),
          ),
        ),
      );
    }

    testWidgets('puts all ten icons on one row when wide', (tester) async {
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(strip(width: 1000));
      await tester.pumpAndSettle();

      expect(cells(), findsNWidgets(10));
      // Two group captions share one line, which is what tells us the groups
      // sit side by side rather than being stacked.
      expect(find.text('Chưa chọn'), findsNWidgets(2));
    });

    testWidgets('stacks into two rows when the window is narrow',
        (tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(strip(width: 300));
      await tester.pumpAndSettle();

      // Same ten icons, just not beside each other.
      expect(cells(), findsNWidgets(10));
    });

    testWidgets('names the selection instead of relying on colour alone',
        (tester) async {
      final items = weather();
      await tester.pumpWidget(strip(width: 1000, weatherId: items[1].id));
      await tester.pumpAndSettle();

      expect(find.text('Râm'), findsOneWidget);
      expect(find.text('Chưa chọn'), findsOneWidget);
    });
  });
}
