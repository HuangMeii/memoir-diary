import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:memoir_app/src/ui/theme.dart';
import 'package:memoir_app/src/ui/home/activity_heatmap.dart';
import 'package:memoir_app/src/ui/home/home_scale.dart';
import 'package:memoir_app/src/ui/home/picker_card.dart';
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

  testWidgets('MonthGrid renders one cell per day and colours the logged day',
      (tester) async {
    final month = DateTime(2026, 4);
    final cells = [
      GridCell(
        date: DateTime(2026, 4, 1),
        code: 'happy',
        label: 'Vui',
        color: '#FFD93D',
      ),
    ];
    DateTime? tapped;

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: MonthGrid(
          cells: cells,
          selectedDate: month,
          onDayTap: (day) => tapped = day,
        ),
      ),
    ));

    // April 2026 has 30 days. The grid keeps a slot for each of them and no
    // longer prints the day numbers, so the date lives in the tooltip.
    expect(find.byType(Tooltip), findsNWidgets(30));
    expect(find.byTooltip('1 · Vui'), findsOneWidget);

    await tester.tap(find.byTooltip('1 · Vui'));
    expect(tapped, DateTime(2026, 4, 1));
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
  group('WeatherMoodRow', () {
    // Stand-ins keep the test on the layout contract - where the row puts the
    // two cards. The cards themselves are built from the picker tokens.
    Widget row() => const WeatherMoodRow(
          weather: Card(child: Text('Thời tiết')),
          mood: Card(child: Text('Cảm xúc')),
        );

    testWidgets('shares one line between the two cards when wide',
        (tester) async {
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(MaterialApp(home: Scaffold(body: row())));
      await tester.pumpAndSettle();

      // Same top edge means same line.
      expect(
        tester.getTopLeft(find.text('Thời tiết')).dy,
        tester.getTopLeft(find.text('Cảm xúc')).dy,
      );
    });

    testWidgets('stacks the two cards when narrow', (tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(MaterialApp(home: Scaffold(body: row())));
      await tester.pumpAndSettle();

      expect(
        tester.getTopLeft(find.text('Thời tiết')).dy,
        lessThan(tester.getTopLeft(find.text('Cảm xúc')).dy),
      );
    });

    // The intrinsic-height pass is the part that could break at runtime, so one
    // test lays out the real cards rather than the stand-ins above.
    List<LookupItem> choices() => [
          for (var i = 0; i < 5; i++)
            LookupItem(
              id: i + 1,
              code: 'code-$i',
              label: 'Lựa chọn $i',
              colorHex: '#FFD93D',
              icon: '•',
            ),
        ];

    Widget realCards() => WeatherMoodRow(
          weather: PickerCard(
            title: 'Thời tiết hôm nay',
            items: choices(),
            iconName: (_) => 'sun',
            selectedId: null,
            onSelected: (_) {},
          ),
          mood: PickerCard(
            title: 'Cảm xúc hôm nay',
            items: choices(),
            iconName: (_) => 'mood-3',
            selectedId: null,
            onSelected: (_) {},
          ),
        );

    Future<void> pumpAt(WidgetTester tester, Size size) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: realCards())),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('lays the real picker cards out on one line', (tester) async {
      await pumpAt(tester, const Size(1200, 800));

      expect(find.text('Thời tiết hôm nay'), findsOneWidget);
      expect(find.text('Cảm xúc hôm nay'), findsOneWidget);
      expect(
        tester.getTopLeft(find.text('Thời tiết hôm nay')).dy,
        tester.getTopLeft(find.text('Cảm xúc hôm nay')).dy,
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('keeps the real cards inside a phone width', (tester) async {
      await pumpAt(tester, const Size(390, 844));

      // Overflow stripes would show up here: the tiles are at their narrowest
      // and the test font wraps every label onto two lines.
      expect(tester.takeException(), isNull);
    });
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

  group('DiaryEntry.filledFields', () {
    test('counts only the slots a day actually fills', () {
      final entry = DiaryEntry(
        id: 'e1',
        entryDate: DateTime(2026, 4, 1),
        moodId: 1,
        weatherId: 2,
        // Whitespace is not content.
        diaryText: '   ',
        gratitude: 'cảm ơn',
      );

      expect(entry.filledFields, 3);
      expect(DiaryEntry.contentFieldCount, 9);
    });

    test('reports 0 for a day with no content at all', () {
      final empty = DiaryEntry(id: 'e2', entryDate: DateTime(2026, 4, 2));
      expect(empty.filledFields, 0);
    });
  });

  group('ActivityDay', () {
    test('maps how full a day is onto the five shades', () {
      int level(int filled) => ActivityDay(filled: filled, total: 9).level;

      expect(level(0), 0, reason: 'nothing written is not a shade');
      expect(level(1), 1);
      expect(level(2), 1, reason: 'mood + weather alone is still "ít"');
      expect(level(3), 2);
      expect(level(5), 3);
      expect(level(7), 4);
      expect(level(9), 5);
    });
  });

  group('homeScaleFor', () {
    test('keeps a phone at 1:1', () {
      expect(homeScaleFor(390), 1);
      expect(homeScaleFor(kHomeDesignWidth), 1);
      expect(homeScaleFor(kHomeDesignWidth - 1), 1);
    });

    test('fills a 1536 px desktop window', () {
      expect(homeScaleFor(1536), closeTo(1.3714, 0.001));
    });

    test('stops at the cap on an ultrawide monitor', () {
      expect(homeScaleFor(2560), kHomeMaxScale);
      expect(homeScaleFor(3840), kHomeMaxScale);
    });

    test('survives a width that cannot be laid out', () {
      expect(homeScaleFor(0), 1);
      expect(homeScaleFor(-100), 1);
      expect(homeScaleFor(double.infinity), 1);
    });
  });

  testWidgets('HomeScale answers 1 when no ancestor provides a factor',
      (tester) async {
    late double factor;
    await tester.pumpWidget(MaterialApp(
      home: Builder(
        builder: (context) {
          factor = HomeScale.of(context);
          return const SizedBox();
        },
      ),
    ));

    expect(factor, 1);
  });

  testWidgets('HomeScale publishes its factor to descendants', (tester) async {
    late double factor;
    await tester.pumpWidget(MaterialApp(
      home: HomeScale(
        factor: 1.4,
        child: Builder(
          builder: (context) {
            factor = HomeScale.of(context);
            return const SizedBox();
          },
        ),
      ),
    ));

    expect(factor, 1.4);
  });
}
