import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_confluence/core/widgets/primary_button.dart';
import 'package:flutter_confluence/features/onboarding/presentation/widgets/onboarding_carousel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart' as Mocktail;

import 'package:flutter_confluence/features/onboarding/presentation/bloc/on_boarding_bloc.dart';
import 'package:flutter_confluence/features/onboarding/presentation/pages/on_boarding.dart';

class UnknownState extends OnBoardingState {}

class MockOnBoardingBloc extends MockBloc<OnBoardingEvent, OnBoardingState>
    implements OnBoardingBloc {}

void main() {
  setUp(() {
    // Tests fails if not call registerFallbackValue for State and Event.
    // This requires Mocktail
    Mocktail.registerFallbackValue<OnBoardingState>(Empty());
    Mocktail.registerFallbackValue<OnBoardingEvent>(AuthEvent());
  });

  testWidgets('OnBoarding Page should show expected widgets',
      (WidgetTester tester) async {
    // arrange
    MockOnBoardingBloc mockBloc = MockOnBoardingBloc();
    whenListen(mockBloc, Stream.fromIterable([Empty()]), initialState: Empty());

    // act
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<OnBoardingBloc>(
            create: (_) => mockBloc, child: OnBoardingPage()),
      ),
    );

    final logoFinder = find.byWidgetPredicate((widget) => widget is Image);
    final carouselFinder = find.byWidgetPredicate((widget) => widget is OnBoardingCarousel);
    final loginButtonFinder = find.byWidgetPredicate((widget) => widget is PrimaryButton);

    // assert
    expect(logoFinder, findsNWidgets(1));
    expect(carouselFinder, findsNWidgets(1));
    expect(loginButtonFinder, findsNWidgets(1));
  });
}
