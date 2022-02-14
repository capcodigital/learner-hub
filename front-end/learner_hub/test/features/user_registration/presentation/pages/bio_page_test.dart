import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learner_hub/core/shared_ui/primary_button.dart';
import 'package:learner_hub/core/themes.dart';
import 'package:learner_hub/features/user_registration/domain/entities/user_registration.dart';
import 'package:learner_hub/features/user_registration/presentation/pages/bio_page.dart';

void main() {
  testWidgets('Bio Page should show expected widgets', (tester) async {
    // arrange
    final navParameters = UserRegistration(
        name: null,
        lastName: null,
        jobTitle: null,
        skills: null,
        bio: null,
        email: null,
        password: null
    );

    // act
    await tester.pumpWidget(MaterialApp(
        theme: Themes.appTheme,
        home: UserBioPage(navParameters: navParameters)));

    final textFieldWidget =
        find.byWidgetPredicate((widget) => widget is TextField);
    final ctaButtonWidget =
        find.byWidgetPredicate((widget) => widget is PrimaryButton);

    // assert
    expect(textFieldWidget, findsOneWidget);
    expect(ctaButtonWidget, findsOneWidget);
  });
}
