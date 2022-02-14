import 'package:flutter/material.dart';
import 'package:flutter_confluence/core/shared_ui/primary_button.dart';
import 'package:flutter_confluence/core/themes.dart';
import 'package:flutter_confluence/features/user_registration/presentation/pages/user_details_page.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('User Details Page should show expected widgets', (tester) async {
    // arrange

    // act
    await tester.pumpWidget(MaterialApp(theme: Themes.appTheme, home: const UserDetailsPage()));

    final formWidget = find.byWidgetPredicate((widget) => widget is Form);
    final inputFieldsWidgets = find.byWidgetPredicate((widget) => widget is TextFormField);
    final ctaButtonWidget = find.byWidgetPredicate((widget) => widget is PrimaryButton);

    // assert
    expect(formWidget, findsOneWidget);
    expect(inputFieldsWidgets, findsNWidgets(3));
    expect(ctaButtonWidget, findsOneWidget);
  });
}
