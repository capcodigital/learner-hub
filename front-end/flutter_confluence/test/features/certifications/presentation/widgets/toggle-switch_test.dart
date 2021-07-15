import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart' as Mocktail;

import 'package:flutter_confluence/features/certifications/presentation/widgets/toggle-switch.dart';
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

  testWidgets('ToggleButton shows expected widgets',
      (WidgetTester tester) async {
    // act
    await tester.pumpWidget(Directionality(
      textDirection: TextDirection.ltr,
      child: MediaQuery(
        data: MediaQueryData(),
        child: ToggleButton(),
      ),
    ));

    final gesturesFinder =
        find.byWidgetPredicate((widget) => widget is GestureDetector);
    final txtCompletedFinder = find.text(ToggleButton.TXT_COMPLETED);
    final txtInProgressFinder = find.text(ToggleButton.TXT_IN_PROGRESS);

    // assert
    expect(gesturesFinder, findsNWidgets(2));
    expect(txtCompletedFinder, findsOneWidget);
    expect(txtInProgressFinder, findsOneWidget);
  });

  testWidgets('ToggleButton triggers expected events when tapped',
      (WidgetTester tester) async {
    CloudCertificationBloc mockBloc = MockCertificationBloc();
    whenListen(mockBloc, Stream.fromIterable([Empty()]), initialState: Empty());

    // act
    await tester.pumpWidget(Directionality(
      textDirection: TextDirection.ltr,
      child: MediaQuery(
        data: MediaQueryData(),
        child: BlocProvider<CloudCertificationBloc>(
          create: (_) => mockBloc,
          child: ToggleButton(),
        ),
      ),
    ));

    final txtCompletedFinder = find.text(ToggleButton.TXT_COMPLETED);
    final txtInProgressFinder = find.text(ToggleButton.TXT_IN_PROGRESS);

    // assert
    expect(txtCompletedFinder, findsOneWidget);
    expect(txtInProgressFinder, findsOneWidget);

    await tester.tap(txtCompletedFinder);
    Mocktail.verify(() => mockBloc.add(GetCompletedCertificationsEvent()))
        .called(1);

    await tester.tap(txtInProgressFinder);
    Mocktail.verify(() => mockBloc.add(GetInProgressCertificationsEvent()))
        .called(1);

    await tester.tap(txtCompletedFinder);
    Mocktail.verify(() => mockBloc.add(GetCompletedCertificationsEvent()))
        .called(1);

    await tester.tap(txtInProgressFinder);
    await tester.tap(txtInProgressFinder);
    Mocktail.verify(() => mockBloc.add(GetInProgressCertificationsEvent()))
        .called(2);
  });
}
