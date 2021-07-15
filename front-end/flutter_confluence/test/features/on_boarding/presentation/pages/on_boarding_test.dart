import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:flutter_confluence/features/onboarding/presentation/bloc/on_boarding_bloc.dart';
import 'package:flutter_confluence/features/onboarding/presentation/pages/on_boarding.dart';

import 'on_boarding_test.mocks.dart';

class UnknownState extends OnBoardingState {}

@GenerateMocks([OnBoardingBloc])
void main() {
  const NUM_OF_CARDS = 2;
  const NUM_OF_CIRCLE_AVATARS = 6;
  const NUM_OF_IMAGES = 4;

  MockOnBoardingBloc mockBloc = MockOnBoardingBloc();

  setMockBlockState(OnBoardingState state) {
    when(mockBloc.state).thenAnswer((_) => state);
    when(mockBloc.stream).thenAnswer((_) => Stream.value(state));
  }

  testWidgets('OnBoarding Page should show expected widgets',
      (WidgetTester tester) async {
    // arrange
    setMockBlockState(Empty());

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
