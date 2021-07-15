import 'dart:convert';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_confluence/core/constants.dart';
import 'package:flutter_confluence/features/certifications/presentation/pages/error_page.dart';
import 'package:flutter_confluence/features/certifications/data/models/cloud_certification_model.dart';
import 'package:flutter_confluence/features/certifications/domain/entities/cloud_certification_type.dart';
import 'package:flutter_confluence/features/certifications/presentation/bloc/cloud_certification_bloc.dart';
import 'package:flutter_confluence/features/certifications/presentation/pages/home_page.dart';
import 'package:flutter_confluence/features/certifications/presentation/widgets/certifications_view.dart';
import 'package:flutter_confluence/features/certifications/presentation/widgets/empty_search.dart';
import 'package:flutter_confluence/features/certifications/presentation/widgets/searchbox.dart';
import 'package:flutter_confluence/features/certifications/presentation/widgets/toggle-switch.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart' as Mockito;
import 'package:mocktail/mocktail.dart' as Mocktail;

import '../../../../fixtures/FixtureReader.dart';
import 'home_page_test.mocks.dart';

class UnknownState extends CloudCertificationState {}

class MockCertBloc
    extends MockBloc<CloudCertificationEvent, CloudCertificationState>
    implements CloudCertificationBloc {}

@GenerateMocks([CloudCertificationBloc])
void main() {
  late CloudCertificationBloc mockBloc;

  setUp(() {
    mockBloc = MockCloudCertificationBloc();
  });

  tearDown(() {});

  setMockBlockState(CloudCertificationState state) {
    Mockito.when(mockBloc.state).thenAnswer((_) => state);
    Mockito.when(mockBloc.stream).thenAnswer((_) => Stream.value(state));
  }

  testWidgets('Home Page shows Certifications List Page when bloc emits Loaded',
      (WidgetTester tester) async {
    // arrange
    final mockList = getMockCompletedCertifications();
    setMockBlockState(Loaded(
        items: mockList,
        cloudCertificationType: CloudCertificationType.completed));

    // act
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<CloudCertificationBloc>(
          create: (_) => mockBloc,
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
    final listFinder = find.byWidgetPredicate((widget) => widget is ListView);
    final listView = tester.widget(listFinder) as ListView;

    // assert
    expect(searchBoxFinder, findsOneWidget);
    expect(toggleFinder, findsOneWidget);
    expect(certificationsFinder, findsOneWidget);
    expect(listFinder, findsOneWidget);
    expect(listView.childrenDelegate.estimatedChildCount, mockList.length);
  });

  testWidgets('Home Page shows Loading Widget when bloc emits Loading',
      (WidgetTester tester) async {
    // arrange
    setMockBlockState(Loading());

    // act
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<CloudCertificationBloc>(
          create: (_) => mockBloc,
          child: HomePage(),
        ),
      ),
    );

    final searchBoxFinder =
        find.byWidgetPredicate((widget) => widget is SearchBox);
    final toggleFinder =
        find.byWidgetPredicate((widget) => widget is ToggleButton);
    final circleProgressFinder =
        find.byWidgetPredicate((widget) => widget is CircularProgressIndicator);

    // assert
    expect(searchBoxFinder, findsOneWidget);
    expect(toggleFinder, findsOneWidget);
    expect(circleProgressFinder, findsOneWidget);
  });

  testWidgets('Home Page shows No Results Text when bloc emits Empty',
      (WidgetTester tester) async {
    // arrange
    setMockBlockState(Empty());

    // act
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<CloudCertificationBloc>(
          create: (_) => mockBloc,
          child: HomePage(),
        ),
      ),
    );

    final searchBoxFinder =
        find.byWidgetPredicate((widget) => widget is SearchBox);
    final toggleFinder =
        find.byWidgetPredicate((widget) => widget is ToggleButton);
    final txtFinder = find.text(Constants.NO_RESULTS);

    // assert
    expect(searchBoxFinder, findsOneWidget);
    expect(toggleFinder, findsOneWidget);
    expect(txtFinder, findsOneWidget);
  });

  testWidgets(
      'Home Page shows Unknown Error Text when bloc emits Unknown State',
      (WidgetTester tester) async {
    // arrange
    setMockBlockState(UnknownState());

    // act
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<CloudCertificationBloc>(
          create: (_) => mockBloc,
          child: HomePage(),
        ),
      ),
    );

    final searchBoxFinder =
        find.byWidgetPredicate((widget) => widget is SearchBox);
    final toggleFinder =
        find.byWidgetPredicate((widget) => widget is ToggleButton);
    final errorMsgFinder = find.text(Constants.UNKNOWN_ERROR);

    // assert
    expect(searchBoxFinder, findsOneWidget);
    expect(toggleFinder, findsOneWidget);
    expect(errorMsgFinder, findsOneWidget);
  });

  testWidgets('Home Page shows EmptySearch when bloc emits EmptySearchResult',
      (WidgetTester tester) async {
    // arrange
    final CloudCertificationState state = EmptySearchResult(
        cloudCertificationType: CloudCertificationType.completed);
    setMockBlockState(state);

    // act
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<CloudCertificationBloc>(
          create: (_) => mockBloc,
          child: HomePage(),
        ),
      ),
    );

    final searchBoxFinder =
        find.byWidgetPredicate((widget) => widget is SearchBox);
    final toggleFinder =
        find.byWidgetPredicate((widget) => widget is ToggleButton);
    final emptySearchFinder =
        find.byWidgetPredicate((widget) => widget is EmptySearch);

    // assert
    expect(searchBoxFinder, findsOneWidget);
    expect(toggleFinder, findsOneWidget);
    expect(emptySearchFinder, findsOneWidget);
  });

  testWidgets(
      'Home Page shows Error Page when bloc emits Error. When click Try Again'
      ' bloc emits Loaded and Certifications ListView appears',
      (WidgetTester tester) async {
    // arrange
    final mockList = getMockCompletedCertifications();
    CloudCertificationState loaded = Loaded(
        items: mockList,
        cloudCertificationType: CloudCertificationType.completed);

    final errorMsg = Constants.SERVER_FAILURE_MSG;
    final CloudCertificationState error = Error(
        message: errorMsg, certificationType: CloudCertificationType.completed);

    Mocktail.registerFallbackValue<CloudCertificationState>(error);
    Mocktail.registerFallbackValue<CloudCertificationEvent>(
        GetCompletedCertificationsEvent());

    CloudCertificationBloc bl = MockCertBloc();

    whenListen(bl, Stream.fromIterable([error, loaded]), initialState: error);

    // act
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<CloudCertificationBloc>(
          create: (_) => bl,
          child: HomePage(),
        ),
      ),
    );

    final searchBoxFinder =
        find.byWidgetPredicate((widget) => widget is SearchBox);
    final toggleFinder =
        find.byWidgetPredicate((widget) => widget is ToggleButton);
    final errorPageFinder =
        find.byWidgetPredicate((widget) => widget is ErrorPage);
    final errorMsgFinder = find.text(errorMsg);
    final tryAgainBtnFinder =
        find.byWidgetPredicate((widget) => widget is ElevatedButton);

    // assert
    expect(searchBoxFinder, findsOneWidget);
    expect(toggleFinder, findsOneWidget);
    expect(errorPageFinder, findsOneWidget);
    expect(errorMsgFinder, findsOneWidget);
    expect(tryAgainBtnFinder, findsOneWidget);

    // act
    // Tap on Try Again Btn to check if triggers expected BlocEvent
    await tester.tap(tryAgainBtnFinder);

    await tester.pump(Duration(seconds: 1));

    final certificationsFinder =
        find.byWidgetPredicate((widget) => widget is CertificationsView);
    final listFinder = find.byWidgetPredicate((widget) => widget is ListView);
    final listView = tester.widget(listFinder) as ListView;

    // assert
    Mocktail.verify(() => bl.add(GetCompletedCertificationsEvent())).called(1);
    Mocktail.verifyNever(() => bl.add(GetInProgressCertificationsEvent()));

    expect(searchBoxFinder, findsOneWidget);
    expect(toggleFinder, findsOneWidget);
    expect(certificationsFinder, findsOneWidget);
    expect(listFinder, findsOneWidget);
    expect(listView.childrenDelegate.estimatedChildCount, mockList.length);
  });
}
