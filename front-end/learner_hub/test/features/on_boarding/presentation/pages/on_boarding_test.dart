import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learner_hub/core/shared_ui/primary_button.dart';
import 'package:learner_hub/core/themes.dart';
import 'package:learner_hub/features/onboarding/presentation/pages/on_boarding.dart';
import 'package:learner_hub/features/onboarding/presentation/widgets/onboarding_carousel.dart';

void main() {
  testWidgets('OnBoarding Page should show expected widgets', (tester) async {
    // arrange
    // act
    await tester.pumpWidget(
        MaterialApp(theme: Themes.appTheme, home: OnBoardingPage()));

    final logoFinder = find.byWidgetPredicate((widget) => widget is Image);
    final carouselFinder =
        find.byWidgetPredicate((widget) => widget is OnBoardingCarousel);
    final loginButtonFinder =
        find.byWidgetPredicate((widget) => widget is PrimaryButton);

    // assert
    // 2 images: the logo and the carousel icon
    expect(logoFinder, findsNWidgets(2));
    expect(carouselFinder, findsOneWidget);
    expect(loginButtonFinder, findsOneWidget);
  });
}
