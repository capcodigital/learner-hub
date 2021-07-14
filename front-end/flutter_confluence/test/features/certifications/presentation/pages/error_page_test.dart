import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_confluence/core/constants.dart';
import 'package:flutter_confluence/features/certifications/presentation/pages/error_page.dart';
import 'package:flutter_confluence/features/certifications/domain/entities/cloud_certification_type.dart';
import 'package:flutter_confluence/features/certifications/presentation/bloc/cloud_certification_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('ErrorPage shows expected error message',
      (WidgetTester tester) async {
    // arrange
    final expectedMessage = Constants.SERVER_FAILURE_MSG;
    final Error error = Error(
        message: expectedMessage,
        certificationType: CloudCertificationType.completed);

    // act
    // Without Directionality UI Test fails
    await tester.pumpWidget(Directionality(
      textDirection: TextDirection.ltr,
      child: MediaQuery(
          data: MediaQueryData(),
          child: ErrorPage(error: error),
          ),
    ));

    final errorImageFinder = find.byWidgetPredicate((widget) => widget is Image);
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
}
