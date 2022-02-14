import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learner_hub/core/shared_ui/primary_button.dart';
import 'package:learner_hub/core/themes.dart';
import 'package:learner_hub/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:learner_hub/features/onboarding/presentation/pages/login_page.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

class TestAuthEvent extends AuthEvent {}

void main() {
  setUpAll(() {
    registerFallbackValue(AuthInitial());
    registerFallbackValue(TestAuthEvent());
  });

  testWidgets('Login Page should show expected widgets', (tester) async {
    // arrange
    final AuthBloc mockBloc = MockAuthBloc();
    whenListen(mockBloc, Stream.fromIterable([AuthInitial()]), initialState: AuthInitial());

    // act
    await tester.pumpWidget(
      MaterialApp(
        theme: Themes.appTheme,
        home: BlocProvider<AuthBloc>(
          create: (_) => mockBloc,
          child: const LoginPage(),
        ),
      ),
    );

    final formWidget = find.byWidgetPredicate((widget) => widget is Form);
    final inputFieldsWidgets = find.byWidgetPredicate((widget) => widget is TextFormField);
    final loginButtonWidget = find.byWidgetPredicate((widget) => widget is PrimaryButton);

    // assert
    expect(formWidget, findsOneWidget);
    expect(inputFieldsWidgets, findsNWidgets(2));
    expect(loginButtonWidget, findsOneWidget);
  });
}
