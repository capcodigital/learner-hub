import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_confluence/core/components/custom_appbar.dart';
import 'package:flutter_confluence/core/constants.dart';
import 'package:flutter_confluence/features/certifications/domain/entities/cloud_certification_type.dart';
import 'package:flutter_confluence/features/certifications/presentation/bloc/cloud_certification_bloc.dart';
import 'package:flutter_confluence/features/certifications/presentation/pages/error_page.dart';
import 'package:flutter_confluence/features/certifications/presentation/pages/home_page.dart';
import 'package:flutter_confluence/features/certifications/presentation/widgets/certifications_view.dart';
import 'package:flutter_confluence/features/certifications/presentation/widgets/empty_search.dart';
import 'package:flutter_confluence/features/certifications/presentation/widgets/searchbox.dart';
import 'package:flutter_confluence/features/certifications/presentation/widgets/toggle-switch.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart' as mocktail;

import '../../../../fixtures/fixture_reader.dart';

class UnknownState extends CloudCertificationState {}

class MockCertificationBloc
    extends MockBloc<CloudCertificationEvent, CloudCertificationState>
    implements CloudCertificationBloc {}

void main() {
  setUp(() {
    // Tests fails if not call registerFallbackValue for State and Event.
    // This requires Mocktail
    mocktail.registerFallbackValue<CloudCertificationState>(Empty());
    mocktail.registerFallbackValue<CloudCertificationEvent>(
        GetInProgressCertificationsEvent());
  });

  testWidgets('Home Page shows Certifications ListView when bloc emits Loaded',
      (WidgetTester tester) async {
    // arrange
    final Loaded loaded = Loaded(
        items: getMockCompletedCertifications(),
        cloudCertificationType: CloudCertificationType.completed);
    final CloudCertificationBloc mockBloc = MockCertificationBloc();
    whenListen(mockBloc, Stream.fromIterable([Empty()]), initialState: loaded);

    // act
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<CloudCertificationBloc>(
          create: (_) => mockBloc,
          child: const HomePage(
            appBar: CustomAppBar(
              icon: Icons.menu,
              text: 'Cloud Certification',
              color: Constants.JIRA_COLOR,
            ),
          ),
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
    expect(listView.childrenDelegate.estimatedChildCount, loaded.items.length);
  });

  testWidgets('Home Page shows Loading Widget when bloc emits Loading',
      (WidgetTester tester) async {
    // arrange
    final CloudCertificationBloc mockBloc = MockCertificationBloc();
    whenListen(mockBloc, Stream.fromIterable([Empty()]),
        initialState: Loading());

    // act
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<CloudCertificationBloc>(
          create: (_) => mockBloc,
          child: const HomePage(
            appBar: CustomAppBar(
              icon: Icons.menu,
              text: 'Cloud Certification',
              color: Constants.JIRA_COLOR,
            ),
          ),
        ),
      ),
    );

    final searchBoxFinder =
        find.byWidgetPredicate((widget) => widget is SearchBox);
    final toggleFinder =
        find.byWidgetPredicate((widget) => widget is ToggleButton);
    final circleProgressFinder = find.byWidgetPredicate(
        (widget) => widget is PlatformCircularProgressIndicator);

    // assert
    expect(searchBoxFinder, findsOneWidget);
    expect(toggleFinder, findsOneWidget);
    expect(circleProgressFinder, findsOneWidget);
  });

  testWidgets('Home Page shows No Results Text when bloc emits Empty',
      (WidgetTester tester) async {
    // arrange
    final CloudCertificationBloc mockBloc = MockCertificationBloc();
    whenListen(mockBloc, Stream.fromIterable([Empty()]), initialState: Empty());

    // act
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<CloudCertificationBloc>(
          create: (_) => mockBloc,
          child: const HomePage(
            appBar: CustomAppBar(
                icon: Icons.menu,
                text: 'Cloud Certification',
                color: Constants.JIRA_COLOR),
          ),
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
    final CloudCertificationBloc mockBloc = MockCertificationBloc();
    whenListen(mockBloc, Stream.fromIterable([Empty()]),
        initialState: UnknownState());

    // act
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<CloudCertificationBloc>(
          create: (_) => mockBloc,
          child: const HomePage(
            appBar: CustomAppBar(
                icon: Icons.menu,
                text: 'Cloud Certification',
                color: Constants.JIRA_COLOR),
          ),
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
    final CloudCertificationBloc mockBloc = MockCertificationBloc();
    whenListen(mockBloc, Stream.fromIterable([Empty()]),
        initialState: const EmptySearchResult(
            cloudCertificationType: CloudCertificationType.completed));

    // act
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<CloudCertificationBloc>(
          create: (_) => mockBloc,
          child: const HomePage(
            appBar: CustomAppBar(
                icon: Icons.menu,
                text: 'Cloud Certification',
                color: Constants.JIRA_COLOR),
          ),
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
      ' bloc emits Loaded and Home Page shows Certifications ListView',
      (WidgetTester tester) async {
    // arrange
    const Error error = Error(
        message: Constants.SERVER_FAILURE_MSG,
        cloudCertificationType: CloudCertificationType.completed);
    final Loaded loaded = Loaded(
        items: getMockCompletedCertifications(),
        cloudCertificationType: CloudCertificationType.completed);
    final CloudCertificationBloc mockBloc = MockCertificationBloc();
    whenListen(mockBloc, Stream.fromIterable([loaded]), initialState: error);

    // act
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<CloudCertificationBloc>(
          create: (_) => mockBloc,
          child: const HomePage(
            appBar: CustomAppBar(
                icon: Icons.menu,
                text: 'Cloud Certification',
                color: Constants.JIRA_COLOR),
          ),
        ),
      ),
    );

    final searchBoxFinder =
        find.byWidgetPredicate((widget) => widget is SearchBox);
    final toggleFinder =
        find.byWidgetPredicate((widget) => widget is ToggleButton);
    final errorPageFinder =
        find.byWidgetPredicate((widget) => widget is ErrorPage);
    final errorMsgFinder = find.text(error.message);
    final tryAgainBtnFinder =
        find.byWidgetPredicate((widget) => widget is ElevatedButton);

    // assert
    expect(searchBoxFinder, findsOneWidget);
    expect(toggleFinder, findsOneWidget);
    expect(errorPageFinder, findsOneWidget);
    expect(errorMsgFinder, findsOneWidget);
    expect(tryAgainBtnFinder, findsOneWidget);

    // act
    await tester.tap(tryAgainBtnFinder);
    await tester.pump(const Duration(seconds: 1));

    final certificationsFinder =
        find.byWidgetPredicate((widget) => widget is CertificationsView);
    final listFinder = find.byWidgetPredicate((widget) => widget is ListView);
    final listView = tester.widget(listFinder) as ListView;

    // assert
    mocktail
        .verify(() => mockBloc.add(GetCompletedCertificationsEvent()))
        .called(1);
    mocktail
        .verifyNever(() => mockBloc.add(GetInProgressCertificationsEvent()));

    expect(searchBoxFinder, findsOneWidget);
    expect(toggleFinder, findsOneWidget);
    expect(certificationsFinder, findsOneWidget);
    expect(listFinder, findsOneWidget);
    expect(listView.childrenDelegate.estimatedChildCount, loaded.items.length);
  });
  testWidgets('Tapping Toggle in Home Page triggers expected Event',
      (WidgetTester tester) async {
    // arrange
    final Loaded loadedInProgress = Loaded(
        items: getMockInProgressCertifications(),
        cloudCertificationType: CloudCertificationType.in_progress);

    final Loaded loadedCompleted = Loaded(
        items: getMockCompletedCertifications(),
        cloudCertificationType: CloudCertificationType.completed);

    final CloudCertificationBloc mockBloc = MockCertificationBloc();
    whenListen(mockBloc, Stream.fromIterable([loadedCompleted]),
        initialState: loadedInProgress);

    // act
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<CloudCertificationBloc>(
          create: (_) => mockBloc,
          child: const HomePage(
            appBar: CustomAppBar(
                icon: Icons.menu,
                text: 'Cloud Certification',
                color: Constants.JIRA_COLOR),
          ),
        ),
      ),
    );

    final searchBoxFinder =
        find.byWidgetPredicate((widget) => widget is SearchBox);
    final toggleFinder =
        find.byWidgetPredicate((widget) => widget is ToggleButton);
    final toggleCompletedFinder = find.text(ToggleButton.TXT_COMPLETED);
    final toggleInProgressFinder = find.text(ToggleButton.TXT_IN_PROGRESS);
    final certificationsFinder =
        find.byWidgetPredicate((widget) => widget is CertificationsView);
    final listFinder = find.byWidgetPredicate((widget) => widget is ListView);
    final listView = tester.widget(listFinder) as ListView;

    // assert
    expect(searchBoxFinder, findsOneWidget);
    expect(toggleFinder, findsOneWidget);
    expect(toggleCompletedFinder, findsOneWidget);
    expect(certificationsFinder, findsOneWidget);
    expect(listFinder, findsOneWidget);
    expect(listView.childrenDelegate.estimatedChildCount,
        loadedInProgress.items.length);

    // act
    await tester.tap(toggleCompletedFinder);
    // assert
    mocktail
        .verify(() => mockBloc.add(GetCompletedCertificationsEvent()))
        .called(1);

    // act
    await tester.tap(toggleInProgressFinder);
    // assert
    mocktail
        .verify(() => mockBloc.add(GetInProgressCertificationsEvent()))
        .called(1);

    // act
    await tester.tap(toggleCompletedFinder);
    // assert
    mocktail
        .verify(() => mockBloc.add(GetCompletedCertificationsEvent()))
        .called(1);
  });
}
