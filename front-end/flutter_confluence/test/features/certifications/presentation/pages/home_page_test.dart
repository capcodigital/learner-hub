import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_confluence/core/constants.dart';
import 'package:flutter_confluence/features/certifications/domain/entities/cloud_certification_type.dart';
import 'package:flutter_confluence/features/certifications/presentation/bloc/cloud_certification_bloc.dart';
import 'package:flutter_confluence/features/certifications/presentation/pages/home_page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'home_page_test.mocks.dart';

@GenerateMocks([CloudCertificationBloc])
void main() {
  MockCloudCertificationBloc mockBloc = MockCloudCertificationBloc();

  testWidgets('Home Page shows Error Page when bloc emits Error',
      (WidgetTester tester) async {
    // arrange
    final expectedMessage = Constants.SERVER_FAILURE_MSG;
    final Error error = Error(
        message: expectedMessage,
        certificationType: CloudCertificationType.completed);

    when(mockBloc.state).thenAnswer((_) => error);
    when(mockBloc.stream).thenAnswer((_) => Stream.value(error));

    // act
    await tester.pumpWidget(
      MaterialApp(
        title: 'Test',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: BlocProvider<CloudCertificationBloc>(
          create: (_) => mockBloc..add(GetCompletedCertificationsEvent()),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: MediaQuery(data: MediaQueryData(), child: HomePage()),
          ),
        ),
      ),
    );
    await tester.pump(Duration(seconds: 3));

    final errorMsgFinder = find.text(expectedMessage);

    // assert
    expect(errorMsgFinder, findsOneWidget);
  });
}
