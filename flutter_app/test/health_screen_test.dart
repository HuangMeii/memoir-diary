import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:memoir_app/src/core/session.dart';
import 'package:memoir_app/src/data/models.dart';
import 'package:memoir_app/src/data/providers.dart';
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

  Future<void> pumpScreen(WidgetTester tester, Size size) async {
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
    // is now the only way into the body-metrics drawer.
    expect(find.text('NHẬP NHANH CHỈ SỐ HÔM NAY'), findsNothing);
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
    expect(find.widgetWithText(OutlinedButton, 'Thông số'), findsOneWidget);
  });
}
