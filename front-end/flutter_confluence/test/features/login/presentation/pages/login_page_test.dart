import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_confluence/core/shared_ui/primary_button.dart';
import 'package:flutter_confluence/core/themes.dart';
import 'package:flutter_confluence/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_confluence/features/onboarding/presentation/pages/login_page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart' as mocktail;

class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

class TestEvent extends AuthEvent {}

void main() {
  setUp(() {
    // Tests fails if not call registerFallbackValue for State and Event.
    // This requires Mocktail
    mocktail.registerFallbackValue(AuthInitial());
    mocktail.registerFallbackValue(TestEvent());
  });

  testWidgets('Login Page should show expected widgets', (tester) async {
    // arrange
    final AuthBloc mockBloc = MockAuthBloc();
    whenListen(mockBloc, Stream.fromIterable([AuthInitial()]),
        initialState: AuthInitial());

    // act
    await tester.pumpWidget(MaterialApp(
        theme: Themes.appTheme,
        home: BlocProvider<AuthBloc>(
            create: (_) => mockBloc, child: const LoginPage())));

    final formFields =
        find.byWidgetPredicate((widget) => widget is TextFormField);
    final loginButton =
        find.byWidgetPredicate((widget) => widget is PrimaryButton);

    // assert
    expect(formFields, findsNWidgets(2));
    expect(loginButton, findsOneWidget);
  });
}
