import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:memoir_app/src/core/autosave.dart';
import 'package:memoir_app/src/ui/theme.dart';
import 'package:memoir_app/src/ui/home/home_scale.dart';
import 'package:memoir_app/src/ui/home/picker_card.dart';
import 'package:memoir_app/src/ui/month/day_details.dart';
import 'package:memoir_app/src/ui/month/month_card.dart';
import 'package:memoir_app/src/ui/route/route_planner_panel.dart';
import 'package:memoir_app/src/ui/screens/calendar_screen.dart';
import 'package:memoir_app/src/ui/screens/entry_editor.dart';
import 'package:memoir_app/src/ui/tokens.dart';
import 'package:memoir_app/src/ui/widgets/app_header.dart';
import 'package:memoir_app/src/ui/widgets/month_heatmap.dart';
import 'package:memoir_app/src/ui/widgets/weather_card.dart';
import 'package:memoir_app/src/data/models.dart';
import 'package:memoir_app/src/data/providers.dart';

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

  testWidgets('MonthHeatmap draws a Sunday-first month of numbered days',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: MonthHeatmap(
          month: DateTime(2026, 4),
          style: const MonthHeatmapStyle(),
          colorOf: (date) => date.day == 1 ? const Color(0xFFFFD93D) : null,
          numberOf: (date) => '${date.day}',
          tooltipOf: (date) => '${date.day}.${date.month}',
        ),
      ),
    ));

    // The design's grid runs Sunday first, so the weekday column opens on CN.
    expect(find.text('CN'), findsOneWidget);
    expect(find.text('T7'), findsOneWidget);
    // April 2026 opens on a Wednesday, so the first column is 1–4.
    expect(find.text('1–4'), findsOneWidget);
    // One cell per day, each carrying its number, and the range header is drawn
    // once per column.
    expect(find.text('30'), findsOneWidget);
    expect(find.byType(Tooltip), findsNWidgets(30));
    expect(tester.takeException(), isNull);
  });

  testWidgets('MonthHeatmap taps only the days that carry a value',
      (tester) async {
    DateTime? tapped;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: MonthHeatmap(
          month: DateTime(2026, 4),
          style: const MonthHeatmapStyle(),
          colorOf: (date) => date.day == 1 ? const Color(0xFFFFD93D) : null,
          numberOf: (date) => '${date.day}',
          tooltipOf: (date) => '${date.day}.4',
          onDayTap: (date) => tapped = date,
        ),
      ),
    ));

    await tester.tap(find.byTooltip('1.4'));
    expect(tapped, DateTime(2026, 4, 1));

    // A day with nothing stored has nothing to point at.
    await tester.tap(find.byTooltip('2.4'));
    expect(tapped, DateTime(2026, 4, 1));
  });

  testWidgets('MonthHeatmap hands every in-month day a slot when asked',
      (tester) async {
    DateTime? tapped;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: MonthHeatmap(
          month: DateTime(2026, 4),
          style: const MonthHeatmapStyle(),
          tooltipOf: (date) => '${date.day}.4',
          clickableWhenEmpty: true,
          onDayTap: (date) => tapped = date,
        ),
      ),
    ));

    await tester.tap(find.byTooltip('2.4'));
    expect(tapped, DateTime(2026, 4, 2));
  });

  testWidgets('CategoryLegend names every mood or weather', (tester) async {
    final items = [
      const LookupItem(
        id: 1,
        code: 'happy',
        label: 'Vui',
        colorHex: '#FFD93D',
        icon: '😀',
      ),
      const LookupItem(
        id: 2,
        code: 'sad',
        label: 'Buồn',
        colorHex: '#9BB8D3',
        icon: '😔',
      ),
    ];

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(body: CategoryLegend(items: items)),
    ));

    expect(find.text('Vui'), findsOneWidget);
    expect(find.text('Buồn'), findsOneWidget);
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

  group('Journal editor quick picks', () {
    // The editor's side column carries the same cards the home dashboard
    // shows, so this covers both shapes it can take: the 300 px column (the
    // cards stack) and a window wide enough for them to sit in one row.
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

    Widget cards({int? moodId}) => WeatherMoodRow(
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
            selectedId: moodId,
            onSelected: (_) {},
          ),
        );

    testWidgets('fit the 300 px side column with no overflow', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: buildTheme(Brightness.light),
          home: Scaffold(body: SizedBox(width: 300, child: cards())),
        ),
      );
      await tester.pumpAndSettle();

      // Overflow stripes would show up here: the tiles are at their narrowest
      // and the test font wraps every label onto two lines.
      expect(tester.takeException(), isNull);
      expect(find.byType(ChoiceTile), findsNWidgets(10));
      // 300 px is under the row's breakpoint, so the two cards stack.
      expect(
        tester.getTopLeft(find.text('Cảm xúc hôm nay')).dy,
        greaterThan(tester.getTopLeft(find.text('Thời tiết hôm nay')).dy),
      );
    });

    testWidgets('name the choice the day already stored', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: buildTheme(Brightness.light),
          home: Scaffold(body: SizedBox(width: 342, child: cards(moodId: 3))),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(ChoiceTile), findsNWidgets(10));
      // Both picker cards carry tiles with the same labels, so the meaningful
      // assertion is the card's status line naming the stored choice — that is
      // what keeps a mood picked on the home dashboard visible here.
      final primary = buildTheme(Brightness.light).colorScheme.primary;
      final namingStatusLines = tester
          .widgetList<Text>(find.text('Lựa chọn 2'))
          .where((t) => t.style?.color == primary);
      expect(namingStatusLines.length, 1);
    });

    testWidgets('sit in one row when the window has room', (tester) async {
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MaterialApp(
          theme: buildTheme(Brightness.light),
          home: Scaffold(body: cards()),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(
        tester.getTopLeft(find.text('Cảm xúc hôm nay')).dy,
        tester.getTopLeft(find.text('Thời tiết hôm nay')).dy,
      );
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
      expect(DiaryEntry.contentFieldCount, 8);
    });

    test('reports 0 for a day with no content at all', () {
      final empty = DiaryEntry(id: 'e2', entryDate: DateTime(2026, 4, 2));
      expect(empty.filledFields, 0);
    });
  });

  group('ActivityDay', () {
    test('maps how full a day is onto the five shades', () {
      int level(int filled) => ActivityDay(filled: filled, total: 8).level;

      expect(level(0), 0, reason: 'nothing written is not a shade');
      expect(level(1), 1);
      expect(level(2), 1, reason: 'mood + weather alone is still "ít"');
      expect(level(3), 2);
      expect(level(5), 3);
      expect(level(7), 4);
      expect(level(8), 5, reason: 'a full page reaches the darkest shade');
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

  group('homeTextScaleFor', () {
    test('follows the layout factor while it is still small', () {
      expect(homeTextScaleFor(390), 1);
      expect(homeTextScaleFor(kHomeDesignWidth), 1);
      expect(homeTextScaleFor(kHomeDesignWidth * 1.05), closeTo(1.05, 0.001));
    });

    test('stops at the text cap on a desktop window', () {
      expect(homeTextScaleFor(1536), kHomeTextMaxScale);
      expect(homeTextScaleFor(2560), kHomeTextMaxScale);
    });

    test('lags the boxes once the layout starts zooming', () {
      // 13 px body must not become 17.8 px just because the window is wide.
      expect(homeTextScaleFor(1536), lessThan(homeScaleFor(1536)));
      expect(13 * homeTextScaleFor(1536), lessThan(15));
    });

    test('survives a width that cannot be laid out', () {
      expect(homeTextScaleFor(0), 1);
      expect(homeTextScaleFor(-100), 1);
      expect(homeTextScaleFor(double.infinity), 1);
    });
  });

  testWidgets('HomeScale answers 1 when no ancestor provides a factor',
      (tester) async {
    late double factor;
    late double textFactor;
    await tester.pumpWidget(MaterialApp(
      home: Builder(
        builder: (context) {
          factor = HomeScale.of(context);
          textFactor = HomeScale.textOf(context);
          return const SizedBox();
        },
      ),
    ));

    expect(factor, 1);
    expect(textFactor, 1);
  });

  testWidgets('HomeScale publishes both factors to descendants',
      (tester) async {
    late double factor;
    late double textFactor;
    await tester.pumpWidget(MaterialApp(
      home: HomeScale(
        factor: 1.4,
        textFactor: 1.1,
        child: Builder(
          builder: (context) {
            factor = HomeScale.of(context);
            textFactor = HomeScale.textOf(context);
            return const SizedBox();
          },
        ),
      ),
    ));

    expect(factor, 1.4);
    expect(textFactor, 1.1);
  });

  group('AppHeader', () {
    Future<void> pumpHeader(
      WidgetTester tester,
      Size size, {
      String? name = 'Minh An',
      bool showUtilities = true,
      AppDestination destination = AppDestination.home,
      ValueChanged<AppDestination>? onNavigate,
    }) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(MaterialApp(
        home: HomeScale(
          factor: 1.4,
          textFactor: 1.1,
          child: Scaffold(
            body: AppHeader(
              date: DateTime(2026, 10, 11),
              initials: 'MA',
              name: name,
              destination: destination,
              onNavigate: onNavigate,
              showUtilities: showUtilities,
              onLogout: () {},
            ),
          ),
        ),
      ));
      await tester.pumpAndSettle();
    }

    testWidgets('folds the utilities in without zooming the bar itself',
        (tester) async {
      await pumpHeader(tester, const Size(1400, 800));

      expect(find.text('Xem thời tiết'), findsOneWidget);
      expect(find.text('Minh An'), findsOneWidget);
      expect(find.text('Đăng xuất'), findsOneWidget);
      // Chrome: the 1.4 layout zoom must not stretch the 84 px bar.
      expect(tester.getSize(find.byType(AppHeader)).height, kAppHeaderHeight);
      expect(tester.takeException(), isNull);
    });

    testWidgets('marks the current destination and opens the others',
        (tester) async {
      final tapped = <AppDestination>[];
      await pumpHeader(
        tester,
        const Size(1400, 800),
        destination: AppDestination.monthGrid,
        onNavigate: tapped.add,
      );

      expect(find.text('Trang chủ'), findsOneWidget);
      // The screen the user is already on is not a link.
      await tester.tap(find.text('Lưới tháng'));
      expect(tapped, isEmpty);

      await tester.tap(find.text('Trang chủ'));
      expect(tapped, [AppDestination.home]);
    });

    testWidgets('makes every destination reachable', (tester) async {
      final tapped = <AppDestination>[];
      await pumpHeader(tester, const Size(1400, 800), onNavigate: tapped.add);

      await tester.tap(find.text('Lịch sử kiện'));
      expect(tapped, [AppDestination.eventHistory]);
    });

    testWidgets('hides the navigation when the header is narrow',
        (tester) async {
      await pumpHeader(tester, const Size(640, 844));

      expect(find.text('Trang chủ'), findsNothing);
      expect(find.text('Lưới tháng'), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('keeps everything the Figma frame shows at the design width',
        (tester) async {
      await pumpHeader(tester, const Size(1120, 800));

      expect(find.text('Xem thời tiết'), findsOneWidget);
      expect(find.text('Minh An'), findsOneWidget);
      expect(find.text('Đăng xuất'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('hides the utilities when the page carries them instead',
        (tester) async {
      await pumpHeader(tester, const Size(900, 800), showUtilities: false);

      expect(find.text('Xem thời tiết'), findsNothing);
      expect(find.text('Đăng xuất'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('drops the display name before the row can overflow',
        (tester) async {
      await pumpHeader(tester, const Size(900, 800));

      expect(find.text('Minh An'), findsNothing);
      expect(find.text('Xem thời tiết'), findsOneWidget);
    });

    testWidgets('holds a narrow window with no name and no utilities',
        (tester) async {
      // 640 rather than a 390 px phone: the widget-test font gives every glyph
      // the width of its own size, so the 34 px wordmark alone measures 204 px
      // here where the real font needs about half of that.
      await pumpHeader(tester, const Size(640, 844));

      expect(find.text('Memoir'), findsOneWidget);
      expect(find.text('Xem thời tiết'), findsNothing);
      expect(find.text('Minh An'), findsNothing);
      expect(find.text('Đăng xuất'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group('Lưới tháng scale', () {
    test('scales from its own frame width, not the home one', () {
      expect(
        homeScaleFor(kMonthDesignWidth, designWidth: kMonthDesignWidth),
        1,
      );
      // 1536 / 1280 = 1.2, a wider layout factor than the home's 1536/1120.
      expect(
        homeScaleFor(1536, designWidth: kMonthDesignWidth),
        closeTo(1.2, 0.001),
      );
      // The type still stops at the same cap.
      expect(
        homeTextScaleFor(1920, designWidth: kMonthDesignWidth),
        kHomeTextMaxScale,
      );
    });
  });

  group('AutosaveDebouncer', () {
    // The editor has no `Lưu nhật ký` button: it saves itself once the writing
    // pauses, so the wait has to restart on every keystroke.
    testWidgets('saves only once the writing pauses', (tester) async {
      await tester.pumpWidget(const SizedBox.shrink());
      var saves = 0;
      final debouncer = AutosaveDebouncer(
        delay: kEntryAutoSaveDelay,
        onElapsed: () => saves++,
      );
      addTearDown(debouncer.cancel);

      debouncer.schedule();
      await tester.pump(kEntryAutoSaveDelay - const Duration(seconds: 1));
      expect(saves, 0, reason: 'still inside the quiet period');

      await tester.pump(const Duration(seconds: 1));
      expect(saves, 1);
    });

    testWidgets('collapses a burst of typing into one save', (tester) async {
      await tester.pumpWidget(const SizedBox.shrink());
      var saves = 0;
      final debouncer = AutosaveDebouncer(
        delay: kEntryAutoSaveDelay,
        onElapsed: () => saves++,
      );
      addTearDown(debouncer.cancel);

      for (var keystroke = 0; keystroke < 5; keystroke++) {
        debouncer.schedule();
        expect(debouncer.pending, isTrue);
        await tester.pump(const Duration(seconds: 1));
      }
      expect(saves, 0, reason: 'every keystroke restarts the wait');

      await tester.pump(kEntryAutoSaveDelay);
      expect(saves, 1);
    });

    testWidgets('cancel drops a waiting save', (tester) async {
      await tester.pumpWidget(const SizedBox.shrink());
      var saves = 0;
      final debouncer = AutosaveDebouncer(
        delay: kEntryAutoSaveDelay,
        onElapsed: () => saves++,
      );
      addTearDown(debouncer.cancel);

      debouncer.schedule();
      debouncer.cancel();
      expect(debouncer.pending, isFalse);

      await tester.pump(kEntryAutoSaveDelay * 2);
      expect(saves, 0);
    });
  });

  group('SelectedDayDetails', () {
    const mood = LookupItem(
      id: 1,
      code: 'happy',
      label: 'Vui',
      colorHex: '#FFD93D',
      icon: '😀',
    );
    const weather = LookupItem(
      id: 2,
      code: 'sunny',
      label: 'Nắng',
      colorHex: '#F7E6B3',
      icon: '☀️',
    );

    testWidgets('names the day, what it stored and the way into the editor',
        (tester) async {
      var opened = false;
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SelectedDayDetails(
            date: DateTime(2026, 10, 11),
            isToday: true,
            mood: mood,
            weather: weather,
            entry: DiaryEntry(id: 'e1', entryDate: DateTime(2026, 10, 11)),
            onWrite: () => opened = true,
          ),
        ),
      ));

      expect(find.text('NGÀY ĐANG CHỌN · HÔM NAY'), findsOneWidget);
      expect(find.text('Chủ nhật, 11.10'), findsOneWidget);
      expect(find.text('Cảm xúc và thời tiết đã được lưu.'), findsOneWidget);
      expect(find.text('Vui'), findsOneWidget);
      expect(find.text('Nắng'), findsOneWidget);

      await tester.tap(find.text('Viết nhật ký hôm nay'));
      expect(opened, isTrue);
      expect(tester.takeException(), isNull);
    });

    testWidgets('leaves a day with nothing stored empty', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SelectedDayDetails(
            date: DateTime(2026, 10, 12),
            isToday: false,
            mood: null,
            weather: null,
            entry: null,
            onWrite: () {},
          ),
        ),
      ));

      expect(find.text('NGÀY ĐANG CHỌN'), findsOneWidget);
      expect(
        find.text('Chưa lưu cảm xúc hay thời tiết cho ngày này.'),
        findsOneWidget,
      );
      expect(find.text('Viết nhật ký ngày này'), findsOneWidget);
    });
  });

  group('FilledButton minimum size', () {
    // The theme used to say `minimumSize: const Size.fromHeight(48)`, which is
    // `Size(double.infinity, 48)` — an infinite *minimum width*. A `Row` lays
    // its non-flex children out with unbounded width, so a `FilledButton` in
    // one gets an impossible constraint: `performLayout` throws "BoxConstraints
    // forces an infinite width" and, on web, the whole page goes blank. The
    // entry editor's save bar is exactly that shape.
    testWidgets('the theme never asks a button for an infinite width',
        (tester) async {
      Size minimumOf(ThemeData theme) =>
          theme.filledButtonTheme.style!.minimumSize!
              .resolve(const <WidgetState>{})!;

      final minimum = minimumOf(buildTheme(Brightness.light));
      expect(minimum.width.isFinite, isTrue);
      // The 48 px height is the part the design pins.
      expect(minimum.height, 48);

      expect(minimumOf(buildTheme(Brightness.dark)).width.isFinite, isTrue);
    });

    testWidgets('a filled button survives a Row beside an Expanded',
        (tester) async {
      await tester.pumpWidget(MaterialApp(
        theme: buildTheme(Brightness.light),
        home: Scaffold(
          body: Row(
            children: [
              const Expanded(child: Text('Đã lưu lúc 10:20')),
              TextButton(onPressed: () {}, child: const Text('Huỷ')),
              const SizedBox(width: 8),
              FilledButton(
                onPressed: () {},
                child: const Text('Lưu nhật ký'),
              ),
            ],
          ),
        ),
      ));

      expect(tester.takeException(), isNull);
      expect(find.text('Lưu nhật ký'), findsOneWidget);
    });

    // The buttons that must span their column ask for it themselves now that
    // the theme only pins the height.
    testWidgets('a button can still be made to fill its column',
        (tester) async {
      await tester.pumpWidget(MaterialApp(
        theme: buildTheme(Brightness.light),
        home: Scaffold(
          body: SizedBox(
            width: 300,
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {},
                    child: const Text('Lưu nhật ký'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ));

      expect(
        tester.getSize(find.byType(FilledButton)),
        const Size(300, 48),
      );
    });

    testWidgets('the day-details CTA still spans its card', (tester) async {
      await tester.pumpWidget(MaterialApp(
        theme: buildTheme(Brightness.light),
        home: Scaffold(
          body: SizedBox(
            width: 400,
            child: SelectedDayDetails(
              date: DateTime(2026, 10, 11),
              isToday: true,
              mood: null,
              weather: null,
              entry: null,
              onWrite: () {},
            ),
          ),
        ),
      ));

      expect(
        tester.getSize(find.byType(FilledButton)).width,
        400 - 2 * MemoirSpace.s6,
      );
    });
  });

  group('weatherIconFor', () {
    test('maps conditions to the Figma weather icons', () {
      expect(weatherIconFor('Nắng'), 'sun');
      expect(weatherIconFor('Mưa to'), 'cloud-rain');
      expect(weatherIconFor('Có gió'), 'wind');
      expect(weatherIconFor('Giông bão'), 'storm');
      expect(weatherIconFor('Sương mù'), 'weather');
      expect(weatherIconFor('Không biết'), 'cloud');
    });
  });

  group('Calendar helpers', () {
    List<Map<String, dynamic>> rows() => [
          {
            'id': 'a',
            'title': 'Họp gia đình',
            'start_at': '2026-10-13T09:00:00',
            'end_at': '2026-10-13T10:00:00',
            'location': 'Nhà',
            'description': null,
          },
          {
            'id': 'b',
            'title': 'Tập thể dục',
            'start_at': '2026-10-14T07:00:00',
          },
        ];

    test('parses the /events rows without the optional columns', () {
      final events = eventsFromRows(rows());
      expect(events, hasLength(2));
      expect(events.first.title, 'Họp gia đình');
      expect(events.first.location, 'Nhà');
      expect(events.first.endAt!.hour, 10);
      expect(events.last.endAt, isNull);
    });

    test('calendarCells frames the month Monday to Sunday', () {
      final cells = calendarCells(DateTime(2026, 10));
      expect(cells, hasLength(42));
      final days = cells.whereType<DateTime>().toList();
      expect(days, hasLength(31));
      expect(days.first, DateTime(2026, 10, 1));
      expect(days.last, DateTime(2026, 10, 31));
      // The blank cells before the first of the month push the grid so its
      // first row starts on a Monday (`DateTime.weekday` 1 = Monday).
      expect(
        cells.takeWhile((d) => d == null).length,
        DateTime(2026, 10, 1).weekday - 1,
      );
    });

    test('eventsOn matches a whole local day', () {
      final events = eventsFromRows(rows());
      final onDay = eventsOn(events, DateTime(2026, 10, 13));
      expect(onDay.map((e) => e.title), ['Họp gia đình']);
      expect(eventsOn(events, DateTime(2026, 10, 15)), isEmpty);
    });

    test('upcomingAfter drops older events and sorts', () {
      final events = eventsFromRows([
        {'id': 'late', 'title': 'Muộn', 'start_at': '2026-10-14T07:00:00'},
        {'id': 'early', 'title': 'Sớm', 'start_at': '2026-10-14T06:00:00'},
      ]);
      final from = DateTime(2026, 10, 14, 6, 30);
      expect(
        upcomingAfter(events, from).map((e) => e.title),
        ['Muộn'],
      );
      expect(
        upcomingAfter(events, DateTime(2026, 10, 13)).map((e) => e.title),
        ['Sớm', 'Muộn'],
      );
    });
  });

  group('RoutePlannerPanel', () {
    /// Every stop list the panel reported, with the flag it used.
    late List<({List<RouteStop> stops, bool immediate})> reported;

    setUp(() => reported = []);

    /// Pumps the panel inside a stand-in for the screen.
    ///
    /// The stand-in owns the stop list and feeds it back, which is what the real
    /// screen does — without that the field would be reset by the panel's own
    /// rebuild and a test could pass for the wrong reason.
    Future<void> pumpPanel(WidgetTester tester,
        {List<String>? searched}) async {
      var stops = const [
        RouteStop(name: 'Hà Nội', lat: 21.0285, lon: 105.8542, kind: 'origin'),
        RouteStop(name: '', lat: 0, lon: 0, kind: 'destination'),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            // There is no backend in a widget test. An empty answer is enough to
            // show that a search actually ran, and [searched] records the terms.
            placeSearchProvider.overrideWith((ref, query) async {
              searched?.add(query);
              return const <PlaceCandidate>[];
            }),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: StatefulBuilder(
                builder: (context, setLocalState) => SingleChildScrollView(
                  child: RoutePlannerPanel(
                    stops: stops,
                    vehicle: 'car',
                    departureAt: DateTime(2026, 10, 14, 18),
                    plan: null,
                    selectedAlternative: null,
                    pickTarget: null,
                    scale: 1,
                    onStopsChanged: (next, {bool immediate = true}) {
                      reported.add((stops: next, immediate: immediate));
                      setLocalState(() => stops = next);
                    },
                    onVehicleChanged: (_) {},
                    onDepartureChanged: (_) {},
                    onPickTarget: (_) {},
                    onSelectAlternative: (_) {},
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    // docs/12-route-weather.md §11: the stop field is also the address field,
    // so typing must be reported as "not immediate" for the screen to hold the
    // route request back instead of asking OSRM once per letter.
    testWidgets('a typed name is reported as debounceable', (tester) async {
      await pumpPanel(tester);
      await tester.enterText(find.byType(TextField).first, 'Đà Lạt');
      await tester.pump();

      expect(reported, isNotEmpty);
      expect(
        reported.every((call) => !call.immediate),
        isTrue,
        reason: 'typing must never ask for a route straight away',
      );

      // Typing also arms the two-second search pause; let it and the 2.5 s
      // counter after it run out, so no timer outlives the test.
      await tester.pump(const Duration(seconds: 5));
    });

    // The point of the whole screen: you type an address and the list appears
    // once you stop — no button press, no Enter. But only once the text has
    // settled, so a half-typed address never reaches the geocoder.
    testWidgets('typing searches two seconds after the last keystroke',
        (tester) async {
      final searched = <String>[];
      await pumpPanel(tester, searched: searched);

      await tester.enterText(find.byType(TextField).first, 'Đà Lạt');
      await tester.pump();
      expect(searched, isEmpty);
      expect(
        find.text('Không có địa điểm phù hợp.'),
        findsNothing,
        reason: 'the lookup waits for the typing to stop',
      );

      // One millisecond short of the pause: still nothing may have been sent.
      await tester.pump(const Duration(milliseconds: 1999));
      expect(searched, isEmpty);

      await tester.pump(const Duration(milliseconds: 1));
      await tester.pump();
      await tester.pump();
      expect(searched, ['Đà Lạt']);
      expect(find.text('Không có địa điểm phù hợp.'), findsOneWidget);

      // Let the 2.5 s search counter run out, so no timer outlives the test.
      await tester.pump(const Duration(seconds: 3));
    });

    // Every keystroke restarts the pause, so the search always carries the
    // text the user actually stopped on — never a prefix of it.
    testWidgets('a keystroke inside the pause restarts it', (tester) async {
      final searched = <String>[];
      await pumpPanel(tester, searched: searched);

      await tester.enterText(find.byType(TextField).first, 'Đà');
      await tester.pump(const Duration(milliseconds: 600));
      await tester.enterText(find.byType(TextField).first, 'Đà Lạt');
      await tester.pump(const Duration(milliseconds: 600));
      expect(
        searched,
        isEmpty,
        reason: 'only 600 ms have passed since the last keystroke',
      );

      await tester.pump(const Duration(milliseconds: 1400));
      await tester.pump();
      await tester.pump();
      expect(searched, ['Đà Lạt']);

      await tester.pump(const Duration(seconds: 2));
    });

    // Enter stays the impatient shortcut: it looks the text up straight away
    // instead of waiting out the pause.
    testWidgets('Enter searches without waiting for the pause', (tester) async {
      final searched = <String>[];
      await pumpPanel(tester, searched: searched);

      await tester.enterText(find.byType(TextField).first, 'Đà Lạt');
      await tester.pump();
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pump();
      await tester.pump();
      expect(searched, ['Đà Lạt']);
      expect(find.text('Không có địa điểm phù hợp.'), findsOneWidget);

      await tester.pump(const Duration(seconds: 2));
    });

    testWidgets('a discrete edit is reported as immediate', (tester) async {
      await pumpPanel(tester);
      await tester.tap(find.text('Thêm điểm dừng'));
      await tester.pump();

      expect(reported, isNotEmpty);
      expect(
        reported.every((call) => call.immediate),
        isTrue,
        reason: 'adding a stop should not wait for a typing pause',
      );
    });
  });
}
