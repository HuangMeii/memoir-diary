import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:memoir_app/src/data/models.dart';
import 'package:memoir_app/src/data/providers.dart';
import 'package:memoir_app/src/ui/health/quick_log_sheet.dart';
import 'package:memoir_app/src/ui/health/quick_sleep_tab.dart';

/// H4-S4: the `Giờ ngủ` tab must prefill from the day's log, recompute the
/// total as the user types and refuse impossible numbers before touching the
/// API.
void main() {
  final date = DateTime(2026, 10, 25);

  HealthDayOverview dayWith(HealthLog? log, {HealthProfile? profile}) =>
      HealthDayOverview(
        date: date,
        log: log,
        water: const <HealthWaterEntry>[],
        activities: const <HealthActivity>[],
        profile: profile,
      );

  Future<GlobalKey<QuickSleepTabState>> pumpTab(
    WidgetTester tester, {
    HealthLog? log,
    HealthProfile? profile,
    List<HealthLog> logs = const <HealthLog>[],
  }) async {
    final key = GlobalKey<QuickSleepTabState>();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          healthLogsProvider.overrideWith((ref, range) async => logs),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: QuickSleepTab(
                key: key,
                date: date,
                day: dayWith(log, profile: profile),
                profile: profile,
                onDirtyChanged: (_) {},
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    return key;
  }

  testWidgets('prefills the night from the saved log', (tester) async {
    await pumpTab(
      tester,
      log: HealthLog(
        id: 'log-1',
        logDate: date.subtract(const Duration(days: 1)),
        sleepHours: 7.5,
        sleepBedtime: '23:00',
        sleepWake: '06:30',
        sleepDeepMinutes: 105,
        sleepQuality: 'ngonSau',
        sleepNote: 'Thức dậy tỉnh táo.',
      ),
      logs: [
        HealthLog(
          id: 'log-0',
          logDate: date.subtract(const Duration(days: 1)),
          sleepHours: 7,
        ),
      ],
    );

    // Hero: 7h 30m inside the 7h–8h recommended band, plus the minute total.
    expect(find.text('7h 30m'), findsOneWidget);
    expect(find.text('Đạt chuẩn'), findsOneWidget);
    expect(find.text('(450 phút)'), findsOneWidget);
    expect(
      find.textContaining('Mục tiêu đề xuất: 7h 00m — 8h 00m'),
      findsOneWidget,
    );
    // Clock tiles use the design's 12-hour labels.
    expect(find.text('11:00 PM'), findsOneWidget);
    expect(find.text('06:30 AM'), findsOneWidget);
    // Deep sleep share of the cycle: 105 / 450 = 23%.
    expect(find.text('Chiếm 23% chu kỳ ngủ'), findsOneWidget);
  });

  testWidgets('recomputes the total while the user types', (tester) async {
    await pumpTab(tester);

    // Hero + both clock tiles start empty.
    expect(find.text('--'), findsNWidgets(3));

    await tester.enterText(find.byType(TextField).at(0), '6');
    await tester.enterText(find.byType(TextField).at(1), '45');
    await tester.pump();

    expect(find.text('6h 45m'), findsOneWidget);
    expect(find.text('(405 phút)'), findsOneWidget);
    expect(find.text('Thiếu 15m'), findsOneWidget);
  });

  testWidgets('blocks a minute value of 60 or more', (tester) async {
    final key = await pumpTab(tester);

    await tester.enterText(find.byType(TextField).at(0), '6');
    await tester.enterText(find.byType(TextField).at(1), '75');
    await tester.pump();

    await expectLater(
      key.currentState!.save(),
      throwsA(isA<FormatException>()),
    );
    await tester.pump();
    expect(find.text('Phút phải nhỏ hơn 60'), findsOneWidget);
  });

  testWidgets('blocks deep sleep longer than the whole night', (tester) async {
    final key = await pumpTab(tester);

    await tester.enterText(find.byType(TextField).at(0), '6');
    await tester.enterText(find.byType(TextField).at(1), '0');
    await tester.enterText(find.byType(TextField).at(2), '400');
    await tester.pump();

    await expectLater(
      key.currentState!.save(),
      throwsA(isA<FormatException>()),
    );
    await tester.pump();
    expect(
      find.text('Ngủ sâu không được lớn hơn tổng thời lượng ngủ'),
      findsOneWidget,
    );
  });

  testWidgets('the sheet opens the real sleep form on a 390px phone',
      (tester) async {
    tester.view.physicalSize = const Size(390, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          healthDayProvider.overrideWith((ref, day) async => dayWith(null)),
          healthLogsProvider.overrideWith(
            (ref, range) async => [
              HealthLog(
                id: 'prev',
                logDate: date.subtract(const Duration(days: 1)),
                sleepHours: 7,
              ),
            ],
          ),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: Consumer(
              builder: (context, ref, _) => TextButton(
                onPressed: () => showQuickLogSheet(
                  context,
                  ref,
                  date: date,
                  initialTab: QuickLogTab.sleep,
                ),
                child: const Text('mở'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('mở'));
    await tester.pumpAndSettle();

    expect(find.text('Ghi nhận sức khoẻ'), findsOneWidget);
    // The tab draws the real form, not the "sẽ được bổ sung" placeholder.
    expect(find.text('TỔNG THỜI GIAN NGỦ ĐÊM QUA'), findsOneWidget);
    expect(find.text('Bắt đầu đi ngủ'), findsOneWidget);
    expect(find.text('Chất lượng giấc ngủ'), findsOneWidget);
    expect(find.textContaining('sẽ được bổ sung'), findsNothing);
    // Design-sync: icon badge in the header, the stepper inside the hero and
    // the previous night's record line in the footer.
    expect(find.byIcon(Icons.self_improvement), findsOneWidget);
    expect(find.text('giờ'), findsOneWidget);
    expect(find.text('phút'), findsWidgets);
    expect(find.widgetWithText(OutlinedButton, 'Huỷ / Để sau'), findsOneWidget);
    expect(find.text('Lần ghi nhận gần nhất: Hôm qua'), findsOneWidget);
  });

  testWidgets('lays the sleep tab out inside the 560 px dialog',
      (tester) async {
    tester.view.physicalSize = const Size(900, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          healthDayProvider.overrideWith((ref, day) async => dayWith(null)),
          healthLogsProvider
              .overrideWith((ref, range) async => const <HealthLog>[]),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: Consumer(
              builder: (context, ref, _) => TextButton(
                onPressed: () => showQuickLogSheet(
                  context,
                  ref,
                  date: date,
                  initialTab: QuickLogTab.sleep,
                ),
                child: const Text('mở'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('mở'));
    await tester.pumpAndSettle();

    // The design's three columns (bedtime / wake / deep sleep) and the stepper
    // must fit the 560 px panel without a RenderFlex overflow.
    expect(tester.takeException(), isNull);
    expect(find.text('Bắt đầu đi ngủ'), findsOneWidget);
    expect(find.text('Giờ thức dậy'), findsOneWidget);
    expect(find.text('Ngủ sâu (ước tính)'), findsOneWidget);
    expect(find.text('giờ'), findsOneWidget);
  });
}
