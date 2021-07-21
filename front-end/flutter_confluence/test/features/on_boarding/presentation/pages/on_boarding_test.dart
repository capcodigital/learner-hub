import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart' as Mocktail;

import 'package:flutter_confluence/features/onboarding/presentation/bloc/on_boarding_bloc.dart';
import 'package:flutter_confluence/features/onboarding/presentation/pages/on_boarding.dart';

class UnknownState extends OnBoardingState {}

class MockOnBoardingBloc extends MockBloc<OnBoardingEvent, OnBoardingState>
    implements OnBoardingBloc {}

void main() {
  const NUM_OF_CARDS = 2;
  const NUM_OF_CIRCLE_AVATARS = 5;
  const NUM_OF_IMAGES = 4;

  setUp(() {
    // Tests fails if not call registerFallbackValue for State and Event.
    // This requires Mocktail
    Mocktail.registerFallbackValue<OnBoardingState>(Empty());
    Mocktail.registerFallbackValue<OnBoardingEvent>(AuthEvent());
  });

  testWidgets('OnBoarding Page should show expected widgets',
      (WidgetTester tester) async {
    // arrange
    OnBoardingBloc mockBloc = MockOnBoardingBloc();
    whenListen(mockBloc, Stream.fromIterable([Empty()]), initialState: Empty());

    // act
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<OnBoardingBloc>(
            create: (_) => mockBloc, child: OnBoardingPage()),
      ),
    );

    final cardFinder = find.byWidgetPredicate((widget) => widget is Card);
    final circleAvatarFinder =
        find.byWidgetPredicate((widget) => widget is CircleAvatar);
    final imgFinder = find.byWidgetPredicate((widget) => widget is Image);
    final btnFinder =
        find.byWidgetPredicate((widget) => widget is ElevatedButton);

    // assert
    expect(cardFinder, findsNWidgets(NUM_OF_CARDS));
    expect(circleAvatarFinder, findsNWidgets(NUM_OF_CIRCLE_AVATARS));
    expect(imgFinder, findsNWidgets(NUM_OF_IMAGES));
    expect(btnFinder, findsOneWidget);
  });
}
