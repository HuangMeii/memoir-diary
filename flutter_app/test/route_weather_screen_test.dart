import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:memoir_app/src/core/session.dart';
import 'package:memoir_app/src/ui/screens/route_weather_screen.dart';

/// A session with nothing stored.
///
/// `AuthNotifier` restores the session in its constructor, so a real store would
/// ask the platform keystore and then the backend for a user. Answering `null`
/// keeps the screen offline: it shows the logged-out header and never asks for a
/// route, which is all the layout needs.
class _EmptySessionStore extends SessionStore {
  _EmptySessionStore() : super(const FlutterSecureStorage());

  @override
  Future<String?> readAccess() async => null;

  @override
  Future<String?> readRefresh() async => null;
}

void main() {
  /// Title the hero always draws, whatever the route state is.
  const heroTitle = 'Thời tiết theo hành trình';

  /// The right column's answer while the form has no destination yet.
  const noRouteYet =
      'Chọn điểm xuất phát và điểm đến để xem thời tiết dọc đường.';

  Future<void> pumpScreen(WidgetTester tester, Size size) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sessionStoreProvider.overrideWithValue(_EmptySessionStore()),
        ],
        child: const MaterialApp(home: RouteWeatherScreen()),
      ),
    );
    await tester.pump();
  }

  // The band above the analysis puts the planner form and the map on one row,
  // and the page under it is a vertical `ListView`: a context with an unbounded
  // height. A `Row` whose `crossAxisAlignment` is `stretch` asks each child for
  // the row's own height before the page has one, so layout fails with
  // `BoxConstraints forces an infinite height` and the whole page stays blank —
  // followed by the paint-time `RenderBox was not laid out` and
  // `child.hasSize` asserts. The two columns keep their own heights instead
  // (docs/UI-design/28-route-weather.md), which is what this guards.
  testWidgets('lays the band out on a wide window', (tester) async {
    await pumpScreen(tester, const Size(1904, 1024));

    expect(tester.takeException(), isNull);
    expect(find.text(heroTitle), findsOneWidget);
    expect(find.text(noRouteYet), findsOneWidget);
  });
}
