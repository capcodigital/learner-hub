import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';

import 'package:flutter_confluence/core/constants.dart';
import 'package:flutter_confluence/features/certifications/presentation/pages/error_page.dart';
import 'package:flutter_confluence/features/certifications/domain/entities/cloud_certification_type.dart';
import 'package:flutter_confluence/features/certifications/presentation/bloc/cloud_certification_bloc.dart';
import 'package:mockito/mockito.dart';

import 'error_page_test.mocks.dart';

@GenerateMocks([CloudCertificationBloc])
void main() {
  CloudCertificationBloc mockBloc = MockCloudCertificationBloc();

  setMockBlockState(CloudCertificationState state) {
    when(mockBloc.state).thenAnswer((_) => state);
    when(mockBloc.stream).thenAnswer((_) => Stream.value(state));
  }

  testWidgets('ErrorPage shows expected widgets',
          (WidgetTester tester) async {
        // arrange
        final expectedMessage = Constants.SERVER_FAILURE_MSG;
        final Error error = Error(
            message: expectedMessage,
            cloudCertificationType: CloudCertificationType.completed);

        // act
        await tester.pumpWidget(Directionality(
          textDirection: TextDirection.ltr,
          child: MediaQuery(
            data: MediaQueryData(),
            child: ErrorPage(error: error),
          ),
        ));

        final errorImageFinder = find.byWidgetPredicate((
            widget) => widget is Image);
        final titleMsgFinder = find.text(ErrorPage.msgTitle);
        final errorMsgFinder = find.text(expectedMessage);
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

  testWidgets('When tap on Try Again Btn to get Completed Certifications,'
      'then Bloc emits GetCompletedCertificationsEvent',
          (WidgetTester tester) async {
        // arrange
        final expectedMessage = Constants.SERVER_FAILURE_MSG;
        final Error error = Error(
            message: expectedMessage,
            cloudCertificationType: CloudCertificationType.completed);

        setMockBlockState(Empty());

        // act
        await tester.pumpWidget(Directionality(
          textDirection: TextDirection.ltr,
          child: MediaQuery(
              data: MediaQueryData(),
              child: BlocProvider<CloudCertificationBloc>(
                create: (_) => mockBloc,
                child: ErrorPage(error: error),
              )
          ),
        ));

        final tryAgainFinder =
        find.byWidgetPredicate((widget) => widget is ElevatedButton);

        // assert
        // tap on try again button to check if it triggers expected event
        await tester.tap(tryAgainFinder);

        verify(mockBloc..add(GetCompletedCertificationsEvent())).called(1);
        verifyNever(mockBloc..add(GetInProgressCertificationsEvent()));
      });

  testWidgets('When tap on Try Again Btn to get In Progress Certifications,'
      'then Bloc emits GetInProgressCertificationsEvent',
          (WidgetTester tester) async {
        // arrange
        final expectedMessage = Constants.SERVER_FAILURE_MSG;
        final Error error = Error(
            message: expectedMessage,
            cloudCertificationType: CloudCertificationType.in_progress);

        setMockBlockState(Empty());

        // act
        await tester.pumpWidget(Directionality(
          textDirection: TextDirection.ltr,
          child: MediaQuery(
              data: MediaQueryData(),
              child: BlocProvider<CloudCertificationBloc>(
                create: (_) => mockBloc,
                child: ErrorPage(error: error),
              )
          ),
        ));

        final tryAgainFinder =
        find.byWidgetPredicate((widget) => widget is ElevatedButton);

        // assert
        // tap on try again button to check if it triggers expected event
        await tester.tap(tryAgainFinder);

        verify(mockBloc..add(GetInProgressCertificationsEvent())).called(1);
        verifyNever(mockBloc..add(GetCompletedCertificationsEvent()));
      });
}