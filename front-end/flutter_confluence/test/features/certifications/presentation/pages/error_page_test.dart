import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart' as Mocktail;

import 'package:flutter_confluence/core/constants.dart';
import 'package:flutter_confluence/features/certifications/presentation/pages/error_page.dart';
import 'package:flutter_confluence/features/certifications/domain/entities/cloud_certification_type.dart';
import 'package:flutter_confluence/features/certifications/presentation/bloc/cloud_certification_bloc.dart';

class MockCertificationBloc
    extends MockBloc<CloudCertificationEvent, CloudCertificationState>
    implements CloudCertificationBloc {}

void main() {

  setUp(() {
    // Tests fails if not call registerFallbackValue for State and Event.
    // This requires Mocktail
    Mocktail.registerFallbackValue<CloudCertificationState>(Empty());
    Mocktail.registerFallbackValue<CloudCertificationEvent>(
        GetCompletedCertificationsEvent());
  });

  testWidgets('ErrorPage shows expected widgets', (WidgetTester tester) async {
    // arrange
    final Error error = Error(
        message: Constants.SERVER_FAILURE_MSG,
        cloudCertificationType: CloudCertificationType.completed);

    // act
    await tester.pumpWidget(Directionality(
      textDirection: TextDirection.ltr,
      child: MediaQuery(
        data: MediaQueryData(),
        child: ErrorPage(error: error),
      ),
    ));

    final errorImageFinder =
        find.byWidgetPredicate((widget) => widget is Image);
    final titleMsgFinder = find.text(ErrorPage.msgTitle);
    final errorMsgFinder = find.text(error.message);
    final btnTryAgainFinder =
        find.byWidgetPredicate((widget) => widget is ElevatedButton);
    final txtTryAgainFinder = find.text(ErrorPage.msgTryAgain);

    // assert
    expect(errorImageFinder, findsOneWidget);
    expect(titleMsgFinder, findsOneWidget);
    expect(errorMsgFinder, findsOneWidget);
    expect(btnTryAgainFinder, findsOneWidget);
    expect(txtTryAgainFinder, findsOneWidget);
  });

  testWidgets(
      'When tap on Try Again Btn to get Completed Certifications,'
      'then Bloc emits GetCompletedCertificationsEvent',
      (WidgetTester tester) async {
    // arrange
    final Error error = Error(
        message: Constants.SERVER_FAILURE_MSG,
        cloudCertificationType: CloudCertificationType.completed);
    CloudCertificationBloc mockBloc = MockCertificationBloc();
    whenListen(mockBloc, Stream.fromIterable([Empty()]),
        initialState: error);

    // act
    await tester.pumpWidget(Directionality(
      textDirection: TextDirection.ltr,
      child: MediaQuery(
          data: MediaQueryData(),
          child: BlocProvider<CloudCertificationBloc>(
            create: (_) => mockBloc,
            child: ErrorPage(error: error),
          )),
    ));

    final tryAgainFinder =
        find.byWidgetPredicate((widget) => widget is ElevatedButton);

    // assert
    // tap on try again button to check if it triggers expected event
    await tester.tap(tryAgainFinder);

    Mocktail.verify(() => mockBloc..add(GetCompletedCertificationsEvent())).called(1);
    Mocktail.verifyNever(() => mockBloc..add(GetInProgressCertificationsEvent()));
  });

  testWidgets(
      'When tap on Try Again Btn to get In Progress Certifications,'
      'then Bloc emits GetInProgressCertificationsEvent',
      (WidgetTester tester) async {
    // arrange
    final Error error = Error(
        message: Constants.SERVER_FAILURE_MSG,
        cloudCertificationType: CloudCertificationType.in_progress);
    CloudCertificationBloc mockBloc = MockCertificationBloc();
    whenListen(mockBloc, Stream.fromIterable([Empty()]),
        initialState: error);

    // act
    await tester.pumpWidget(Directionality(
      textDirection: TextDirection.ltr,
      child: MediaQuery(
          data: MediaQueryData(),
          child: BlocProvider<CloudCertificationBloc>(
            create: (_) => mockBloc,
            child: ErrorPage(error: error),
          )),
    ));

    final tryAgainFinder =
        find.byWidgetPredicate((widget) => widget is ElevatedButton);

    // assert
    // tap on try again button to check if it triggers expected event
    await tester.tap(tryAgainFinder);

    Mocktail.verify(() => mockBloc..add(GetInProgressCertificationsEvent())).called(1);
    Mocktail.verifyNever(() => mockBloc..add(GetCompletedCertificationsEvent()));
  });
}
