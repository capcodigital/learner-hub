import 'package:flutter/material.dart';
import 'package:flutter_confluence/core/constants.dart';
import 'package:flutter_confluence/core/shared_ui/primary_button.dart';
import 'package:flutter_confluence/core/themes.dart';
import 'package:flutter_confluence/features/user_registration/domain/entities/user_registration.dart';
import 'package:flutter_confluence/features/user_registration/presentation/pages/skills_page.dart';
import 'package:flutter_confluence/features/user_registration/presentation/widgets/skill_chip.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Primary Skills Page should show expected widgets', (tester) async {
    // arrange
    final navParameters = UserRegistration();

    // act
    await tester.pumpWidget(MaterialApp(theme: Themes.appTheme, home: SkillsPage(navParameters: navParameters)));

    final wrapContainerWidget = find.byWidgetPredicate((widget) => widget is Wrap);
    final richTextWidgets = find.byKey(const Key('subtitleText'));
    final chipWidgets = find.byWidgetPredicate((widget) => widget is SkillChip);
    final ctaButtonWidget = find.byWidgetPredicate((widget) => widget is PrimaryButton);

    // assert
    expect(wrapContainerWidget, findsOneWidget);
    expect(richTextWidgets, findsOneWidget);
    expect(chipWidgets, findsNWidgets(Constants.SKILLS.length));
    expect(ctaButtonWidget, findsOneWidget);
  });
}
