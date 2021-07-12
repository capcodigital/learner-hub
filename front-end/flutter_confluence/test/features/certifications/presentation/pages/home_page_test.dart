import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_confluence/core/constants.dart';
import 'package:flutter_confluence/core/error/error_page.dart';
import 'package:flutter_confluence/features/certifications/data/models/cloud_certification_model.dart';
import 'package:flutter_confluence/features/certifications/domain/entities/cloud_certification.dart';
import 'package:flutter_confluence/features/certifications/domain/entities/cloud_certification_type.dart';
import 'package:flutter_confluence/features/certifications/presentation/bloc/cloud_certification_bloc.dart';
import 'package:flutter_confluence/features/certifications/presentation/pages/home_page.dart';
import 'package:flutter_confluence/features/certifications/presentation/widgets/certifications_view.dart';
import 'package:flutter_confluence/features/certifications/presentation/widgets/searchbox.dart';
import 'package:flutter_confluence/features/certifications/presentation/widgets/toggle-switch.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/FixtureReader.dart';
import 'home_page_test.mocks.dart';

class UnknownState extends CloudCertificationState {}

@GenerateMocks([CloudCertificationBloc])
void main() {
  MockCloudCertificationBloc mockBloc = MockCloudCertificationBloc();

  setMockBlockState(CloudCertificationState state) {
    when(mockBloc.state).thenAnswer((_) => state);
    when(mockBloc.stream).thenAnswer((_) => Stream.value(state));
  }

  testWidgets('Home Page shows Certifications List Page when bloc emits Loaded',
      (WidgetTester tester) async {
    // arrange
    final mockList =
        (json.decode(fixture('completed.json')) as List)
            .map((e) => CloudCertificationModel.fromJson(e))
            .toList();
    setMockBlockState(Loaded(
        items: mockList,
        cloudCertificationType: CloudCertificationType.completed));

    // act
    await tester.pumpWidget(
      // Test fails without Material App
      MaterialApp(
        home: BlocProvider<CloudCertificationBloc>(
          create: (_) => mockBloc..add(GetCompletedCertificationsEvent()),
          child: HomePage(),
        ),
      ),
    );

    final searchBoxFinder =
        find.byWidgetPredicate((widget) => widget is SearchBox);
    final toggleFinder =
        find.byWidgetPredicate((widget) => widget is ToggleButton);
    final certificationsFinder =
        find.byWidgetPredicate((widget) => widget is CertificationsView);

    // assert
    expect(searchBoxFinder, findsOneWidget);
    expect(toggleFinder, findsOneWidget);
    expect(certificationsFinder, findsOneWidget);
  });

  testWidgets('Home Page shows Error Page when bloc emits Error',
      (WidgetTester tester) async {
    // arrange
    final expectedMessage = Constants.SERVER_FAILURE_MSG;
    final Error error = Error(
        message: expectedMessage,
        certificationType: CloudCertificationType.completed);

    setMockBlockState(error);

    // act
    await tester.pumpWidget(
      // Test fails without Material App
      MaterialApp(
        home: BlocProvider<CloudCertificationBloc>(
          create: (_) => mockBloc..add(GetCompletedCertificationsEvent()),
          child: HomePage(),
        ),
      ),
    );

    // TODO: Check how to verify that user cannot interact with Search & Toggle
    final searchBoxFinder =
        find.byWidgetPredicate((widget) => widget is SearchBox);
    final toggleFinder =
        find.byWidgetPredicate((widget) => widget is ToggleButton);
    final errorPageFinder =
        find.byWidgetPredicate((widget) => widget is ErrorPage);
    // this is the error msg text inside error page
    final errorMsgFinder = find.text(expectedMessage);

    // assert
    expect(searchBoxFinder, findsOneWidget);
    expect(toggleFinder, findsOneWidget);
    expect(errorPageFinder, findsOneWidget);
    expect(errorMsgFinder, findsOneWidget);
  });

  testWidgets('Home Page shows Loading Widget when bloc emits Loading',
      (WidgetTester tester) async {
    // arrange
    setMockBlockState(Loading());

    // act
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<CloudCertificationBloc>(
          create: (_) => mockBloc..add(GetCompletedCertificationsEvent()),
          child: HomePage(),
        ),
      ),
    );

    final circleProgressFinder =
        find.byWidgetPredicate((widget) => widget is CircularProgressIndicator);

    // assert
    expect(circleProgressFinder, findsOneWidget);
  });

  testWidgets('Home Page shows no results text when bloc emits empty',
      (WidgetTester tester) async {
    // arrange
    setMockBlockState(Empty());

    // act
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<CloudCertificationBloc>(
          create: (_) => mockBloc..emit(Empty()),
          child: HomePage(),
        ),
      ),
    );

    final errorMsgFinder = find.text(Constants.NO_RESULTS);

    // assert
    expect(errorMsgFinder, findsOneWidget);
  });

  testWidgets(
      'Home Page shows unknown error text when bloc emits unknown state',
      (WidgetTester tester) async {
    // arrange

    setMockBlockState(UnknownState());

    // act
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<CloudCertificationBloc>(
          create: (_) => mockBloc..emit(UnknownState()),
          child: HomePage(),
        ),
      ),
    );

    final errorMsgFinder = find.text(Constants.UNKNOWN_ERROR);

    // assert
    expect(errorMsgFinder, findsOneWidget);
  });
}
