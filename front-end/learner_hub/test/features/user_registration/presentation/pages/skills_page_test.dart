import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learner_hub/core/constants.dart';
import 'package:learner_hub/core/shared_ui/primary_button.dart';
import 'package:learner_hub/core/shared_ui/skill_chip.dart';
import 'package:learner_hub/core/themes.dart';
import 'package:learner_hub/features/user_registration/domain/entities/user_registration.dart';
import 'package:learner_hub/features/user_registration/presentation/pages/skills_page.dart';

void main() {
  testWidgets('Primary Skills Page should show expected widgets',
      (tester) async {
    // arrange
    final navParameters = UserRegistration(
        name: null,
        lastName: null,
        jobTitle: null,
        skills: null,
        bio: null,
        email: null,
        password: null);

    // act
    await tester.pumpWidget(MaterialApp(
        theme: Themes.appTheme,
        home: SkillsPage(navParameters: navParameters)));

    final wrapContainerWidget =
        find.byWidgetPredicate((widget) => widget is Wrap);
    final richTextWidgets = find.byKey(const Key('subtitleText'));
    final chipWidgets = find.byWidgetPredicate((widget) => widget is SkillChip);
    final ctaButtonWidget =
        find.byWidgetPredicate((widget) => widget is PrimaryButton);

    // assert
    expect(wrapContainerWidget, findsOneWidget);
    expect(richTextWidgets, findsOneWidget);
    expect(chipWidgets, findsNWidgets(Constants.SKILLS.length));
    expect(ctaButtonWidget, findsOneWidget);
  });
}
