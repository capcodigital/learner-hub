import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_confluence/core/constants.dart';
import 'package:flutter_confluence/core/shared_ui/custom_appbar.dart';
import 'package:flutter_confluence/core/themes.dart';
import 'package:flutter_confluence/features/certifications/presentation/bloc/cloud_certification_bloc.dart';
import 'package:flutter_confluence/features/certifications/presentation/pages/home_page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart' as mocktail;

class UnknownState extends CloudCertificationState {}

class MockCertificationBloc extends MockBloc<CloudCertificationEvent, CloudCertificationState>
    implements CloudCertificationBloc {}

void main() {
  setUp(() {
    // Tests fails if not call registerFallbackValue for State and Event.
    // This requires Mocktail
    mocktail.registerFallbackValue<CloudCertificationState>(Empty());
    mocktail.registerFallbackValue<CloudCertificationEvent>(GetInProgressCertificationsEvent());
  });

  testWidgets('Home Page shows Loading Widget when bloc emits Loading', (WidgetTester tester) async {
    // arrange
    final CloudCertificationBloc mockBloc = MockCertificationBloc();
    whenListen(mockBloc, Stream.fromIterable([Empty()]), initialState: Loading());

    // act
    await tester.pumpWidget(
      MaterialApp(
        theme: Themes.appTheme,
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

    final textWidget = find.byKey(const Key('sampleText'));

    // assert
    expect(textWidget, findsOneWidget);
  });
}
