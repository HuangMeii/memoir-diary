import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:memoir_app/src/ui/health/health_quote_card.dart';
import 'package:memoir_app/src/ui/theme.dart';

void main() {
  Widget host(Widget child) => MaterialApp(
        theme: buildTheme(Brightness.light),
        home: Scaffold(body: child),
      );

  testWidgets('journal bridge calls the supplied callback', (tester) async {
    var opened = false;
    await tester.pumpWidget(
      host(HealthJournalBridgeCard(onOpenJournal: () => opened = true)),
    );

    await tester.tap(find.text('Mở nhật ký hôm nay'));

    expect(opened, isTrue);
  });

  testWidgets('gentle reminder shows the default editorial copy',
      (tester) async {
    await tester.pumpWidget(host(const HealthGentleReminderCard()));

    expect(
      find.textContaining(
          'Cơ thể bạn là ngôi đền duy nhất bạn có suốt cuộc đời.'),
      findsOneWidget,
    );
    expect(find.text('Trích Memoir Mindful Journal'), findsOneWidget);
  });

  testWidgets('gentle reminder accepts dynamic text and source',
      (tester) async {
    await tester.pumpWidget(
      host(
        const HealthGentleReminderCard(
          text: 'Hôm nay hãy đi chậm lại.',
          source: 'Từ nhật ký của bạn',
        ),
      ),
    );

    expect(find.text('“Hôm nay hãy đi chậm lại.”'), findsOneWidget);
    expect(find.text('Từ nhật ký của bạn'), findsOneWidget);
    expect(find.text('Trích Memoir Mindful Journal'), findsNothing);
  });
}
