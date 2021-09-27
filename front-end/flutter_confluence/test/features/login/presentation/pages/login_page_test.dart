import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_confluence/core/themes.dart';
import 'package:flutter_confluence/core/widgets/primary_button.dart';
import 'package:flutter_confluence/features/login/presentation/bloc/login_bloc.dart';
import 'package:flutter_confluence/features/login/presentation/pages/login_page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart' as mocktail;

class MockLoginBloc extends MockBloc<LoginEvent, LoginState> implements LoginBloc {}

class TestEvent extends LoginEvent {}

void main() {
  setUp(() {
    // Tests fails if not call registerFallbackValue for State and Event.
    // This requires Mocktail
    mocktail.registerFallbackValue<LoginState>(LoginInitial());
    mocktail.registerFallbackValue<LoginEvent>(TestEvent());
  });

  testWidgets('Login Page should show expected widgets', (tester) async {
    // arrange
    final LoginBloc mockBloc = MockLoginBloc();
    whenListen(mockBloc, Stream.fromIterable([LoginInitial()]), initialState: LoginInitial());

    // act
    await tester.pumpWidget(MaterialApp(
        theme: Themes.appTheme, home: BlocProvider<LoginBloc>(create: (_) => mockBloc, child: const LoginPage())));

    final formFields = find.byWidgetPredicate((widget) => widget is TextFormField);
    final loginButton = find.byWidgetPredicate((widget) => widget is PrimaryButton);

    // assert
    expect(formFields, findsNWidgets(2));
    expect(loginButton, findsOneWidget);
  });
}
