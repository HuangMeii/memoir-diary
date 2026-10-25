import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:memoir_app/src/core/session.dart';
import 'package:memoir_app/src/data/models.dart';
import 'package:memoir_app/src/data/providers.dart';
import 'package:memoir_app/src/ui/health/health_modal.dart';
import 'package:memoir_app/src/ui/screens/health_screen.dart';

/// A session with nothing stored.
///
/// `AuthNotifier` restores the session in its constructor, so a real store would
/// ask the platform keystore and then the backend for a user. Answering `null`
/// keeps the screen offline: it shows the logged-out header and never asks the
/// API for a day, which is all the layout needs.
class _EmptySessionStore extends SessionStore {
  _EmptySessionStore() : super(const FlutterSecureStorage());

  @override
  Future<String?> readAccess() async => null;

  @override
  Future<String?> readRefresh() async => null;
}

void main() {
  /// The breadcrumb + page header title, drawn twice by the chrome.
  const pageTitle = 'Sức khoẻ & Thể chất';

  final overview = HealthDayOverview(
    date: DateTime(2026, 10, 11),
    water: const <HealthWaterEntry>[],
    activities: const <HealthActivity>[],
  );

  Future<void> pumpScreen(
    WidgetTester tester,
    Size size, {
    List<HealthLog> logs = const <HealthLog>[],
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sessionStoreProvider.overrideWithValue(_EmptySessionStore()),
          // Answer every day/profile/trend request locally so the dashboard
          // renders without touching the backend.
          healthDayProvider.overrideWith((ref, date) async => overview),
          healthProfileProvider
              .overrideWith((ref) async => const HealthProfile()),
          healthLogsProvider.overrideWith(
            (ref, range) async => logs,
          ),
          healthTrendsProvider.overrideWith(
            (ref, range) async => const <HealthTrendPoint>[],
          ),
        ],
        child: const MaterialApp(home: HealthScreen()),
      ),
    );
    // auth resolves, then the day/profile/trend futures settle.
    await tester.pump();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
  }

  // The dashboard scrolls with a `SingleChildScrollView` + `Center` +
  // `ConstrainedBox(maxWidth: 1200)` and switches the two content columns at
  // 1000 px. A stray `Expanded`/`stretch` inside the unbounded scroll axis used
  // to blank the page, so both widths are guarded here.
  testWidgets('lays the dashboard out on a phone window', (tester) async {
    await pumpScreen(tester, const Size(390, 844));

    expect(tester.takeException(), isNull);
    expect(find.text(pageTitle), findsWidgets);
    expect(find.text('Thời gian luyện tập'), findsOneWidget);
    // The inline "Nhập nhanh chỉ số hôm nay" card is gone; the header button
    // is now the only way into the body-metrics drawer. The dead "Xuất báo
    // cáo" placeholder went with it.
    expect(find.text('NHẬP NHANH CHỈ SỐ HÔM NAY'), findsNothing);
    expect(find.text('Xuất báo cáo'), findsNothing);
    expect(find.widgetWithText(OutlinedButton, 'Thông số'), findsOneWidget);
  });

  testWidgets('lays the dashboard out on a wide window', (tester) async {
    await pumpScreen(tester, const Size(1904, 1024));

    expect(tester.takeException(), isNull);
    expect(find.text(pageTitle), findsWidgets);
    // The three hero cards read the day it was given, so a non-blank page is
    // proof the provider data reached the dashboard.
    expect(find.text('Thời gian luyện tập'), findsOneWidget);
    expect(find.text('Nước uống'), findsWidgets);
    expect(find.text('Giấc ngủ'), findsWidgets);
    expect(find.text('NHẬP NHANH CHỈ SỐ HÔM NAY'), findsNothing);
    expect(find.text('Xuất báo cáo'), findsNothing);
    expect(find.widgetWithText(OutlinedButton, 'Thông số'), findsOneWidget);
  });

  // Both secondary forms used to be bottom sheets at every width, so on a
  // desktop window they hugged the lower edge instead of sitting in the middle.
  testWidgets('centres the small forms on a wide window', (tester) async {
    await pumpScreen(tester, const Size(1904, 1024));

    await tester.tap(find.widgetWithText(OutlinedButton, 'Thông số'));
    await tester.pumpAndSettle();
    expect(find.byType(Dialog), findsOneWidget);
    expect(find.byType(BottomSheet), findsNothing);
    final bodyPanel = tester.getRect(find.byKey(healthModalPanelKey));
    expect(bodyPanel.center.dx, closeTo(1904 / 2, 1));
    expect(bodyPanel.center.dy, closeTo(1024 / 2, 1));
    expect(bodyPanel.width, lessThanOrEqualTo(560));
    expect(bodyPanel.bottom, lessThan(1024));

    await tester.tap(find.byTooltip('Đóng'));
    await tester.pumpAndSettle();
    expect(find.byType(Dialog), findsNothing);

    await tester.tap(find.widgetWithText(FilledButton, '+ Ghi nhận nhanh'));
    await tester.pumpAndSettle();
    expect(find.byType(Dialog), findsOneWidget);
    final logPanel = tester.getRect(find.byKey(healthModalPanelKey));
    expect(logPanel.center.dx, closeTo(1904 / 2, 1));
    expect(logPanel.center.dy, closeTo(1024 / 2, 1));
    expect(logPanel.bottom, lessThan(1024));
  });

  testWidgets('keeps the small forms as bottom sheets on a phone',
      (tester) async {
    await pumpScreen(tester, const Size(390, 844));

    await tester.tap(find.widgetWithText(OutlinedButton, 'Thông số'));
    await tester.pumpAndSettle();
    expect(find.byType(BottomSheet), findsOneWidget);
    expect(find.byType(Dialog), findsNothing);
  });

  // "Biến động cân nặng" follows the design: three window pills and four cards
  // (three past segments plus today), with no manual weigh-in row.
  testWidgets('shows the designed weight fluctuation cards', (tester) async {
    await pumpScreen(tester, const Size(1904, 1024));

    await tester.tap(find.widgetWithText(OutlinedButton, 'Thông số'));
    await tester.pumpAndSettle();

    expect(find.text('Biến động cân nặng'), findsOneWidget);
    final sheet = find.byType(Dialog);
    for (final label in ['4 tuần', '3 tháng', '6 tháng']) {
      expect(
        find.descendant(of: sheet, matching: find.text(label)),
        findsOneWidget,
      );
    }
    for (final title in ['Tuần 1', 'Tuần 2', 'Tuần 3', 'Hôm nay']) {
      expect(
        find.descendant(of: sheet, matching: find.text(title)),
        findsOneWidget,
      );
    }
    expect(
      find.text('Chưa đủ dữ liệu trong 4 tuần qua để thấy biến động'),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey<String>('weight-entry-field')),
      findsNothing,
    );
    expect(find.text('Thời gian'), findsNothing);
  });

  testWidgets('fills the weight cards from the logs', (tester) async {
    final now = DateTime.now();
    await pumpScreen(
      tester,
      const Size(1904, 1024),
      logs: [
        HealthLog(
          id: 'a',
          logDate: now.subtract(const Duration(days: 12)),
          weightKg: 58.9,
        ),
        HealthLog(
          id: 'b',
          logDate: now.subtract(const Duration(days: 5)),
          weightKg: 58.6,
        ),
        HealthLog(id: 'c', logDate: now, weightKg: 58.3),
      ],
    );

    await tester.tap(find.widgetWithText(OutlinedButton, 'Thông số'));
    await tester.pumpAndSettle();

    expect(
      find.text('Giảm 0.6 kg trong 4 tuần qua một cách lành mạnh'),
      findsOneWidget,
    );
  });
}
