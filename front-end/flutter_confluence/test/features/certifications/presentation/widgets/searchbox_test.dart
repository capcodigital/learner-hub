import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_confluence/features/certifications/presentation/widgets/searchbox.dart';

void main() {
  final String hint = "Search";
  final TextEditingController controller = TextEditingController();

  testWidgets('SearchBox shows expected widgets and can type in it',
      (WidgetTester tester) async {
    // act
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SearchBox(
            hintText: hint,
            controller: controller,
          ),
        ),
      ),
    );

    final txtFieldFinder =
        find.byWidgetPredicate((widget) => widget is TextField);

    // assert
    expect(txtFieldFinder, findsOneWidget);

    final firstInput = "Jonathan";
    await tester.enterText(txtFieldFinder, firstInput);
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();

    TextField textField = tester.widget(txtFieldFinder) as TextField;
    expect(textField.controller?.value.text, firstInput);

    final secondInput = "Hello";
    await tester.enterText(txtFieldFinder, secondInput);
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();

    expect(textField.controller?.value.text, secondInput);
  });
}
