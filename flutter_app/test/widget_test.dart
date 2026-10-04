import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:memoir_app/src/ui/theme.dart';
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
}
