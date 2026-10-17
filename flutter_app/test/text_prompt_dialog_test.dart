import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:memoir_app/src/ui/widgets/text_prompt_dialog.dart';

void main() {
  /// What the dialog answered, in order. Cleared by [pumpHost].
  final answers = <String?>[];

  /// Pumps a page whose only button opens the prompt, then opens it. Mirrors
  /// the note editor's `Thêm dòng checklist` / `Thêm thẻ` call.
  Future<void> pumpHost(WidgetTester tester) async {
    answers.clear();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () async {
                final answer = await showDialog<String>(
                  context: context,
                  builder: (_) => const TextPromptDialog(
                    title: 'Thêm dòng checklist',
                    hintText: 'Việc cần làm...',
                  ),
                );
                answers.add(answer);
              },
              child: const Text('Thêm dòng'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Thêm dòng'));
    await tester.pumpAndSettle();
  }

  testWidgets('answers the trimmed line once the dialog has closed',
      (tester) async {
    await pumpHost(tester);
    expect(find.text('Thêm dòng checklist'), findsOneWidget);

    await tester.enterText(find.byType(TextField), '  Việc A  ');
    await tester.tap(find.widgetWithText(FilledButton, 'Thêm'));
    // The dialog keeps animating out for a few frames after the pop: the whole
    // close has to stay exception free, which is what disposing the controller
    // in the caller broke.
    await tester.pumpAndSettle();

    expect(answers, ['Việc A']);
    expect(find.byType(TextPromptDialog), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('dismissing answers null', (tester) async {
    await pumpHost(tester);

    await tester.tap(find.widgetWithText(TextButton, 'Huỷ'));
    await tester.pumpAndSettle();

    expect(answers, [null]);
    expect(tester.takeException(), isNull);
  });

  testWidgets('submitting from the keyboard answers the line', (tester) async {
    await pumpHost(tester);

    await tester.enterText(find.byType(TextField), 'Việc B');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    expect(answers, ['Việc B']);
    expect(tester.takeException(), isNull);
  });
}
