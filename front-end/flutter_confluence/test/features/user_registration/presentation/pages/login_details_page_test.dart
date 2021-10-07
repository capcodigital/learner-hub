import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_confluence/core/shared_ui/primary_button.dart';
import 'package:flutter_confluence/core/themes.dart';
import 'package:flutter_confluence/features/user_registration/domain/entities/user_registration.dart';
import 'package:flutter_confluence/features/user_registration/presentation/bloc/user_registration_bloc.dart';
import 'package:flutter_confluence/features/user_registration/presentation/pages/login_details_page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockUserRegistrationBloc extends MockBloc<UserRegistrationEvent, UserRegistrationState>
    implements UserRegistrationBloc {}

class TestAuthEvent extends UserRegistrationEvent {}

void main() {
  setUpAll(() {
    registerFallbackValue<UserRegistrationState>(UserRegistrationInitial());
    registerFallbackValue<UserRegistrationEvent>(TestAuthEvent());
  });

  testWidgets('Login Details Page should show expected widgets', (tester) async {
    // arrange
    final navParameters = UserRegistration();

    final UserRegistrationBloc mockBloc = MockUserRegistrationBloc();
    whenListen(mockBloc, Stream.fromIterable([UserRegistrationInitial()]), initialState: UserRegistrationInitial());

    // act
    await tester.pumpWidget(
      MaterialApp(
        theme: Themes.appTheme,
        home: BlocProvider<UserRegistrationBloc>(
          create: (_) => mockBloc,
          child: LoginDetailsPage(navParameters: navParameters),
        ),
      ),
    );

    final formWidget = find.byWidgetPredicate((widget) => widget is Form);
    final inputFieldsWidgets = find.byWidgetPredicate((widget) => widget is TextFormField);
    final ctaButtonWidget = find.byWidgetPredicate((widget) => widget is PrimaryButton);

    // assert
    expect(formWidget, findsOneWidget);
    expect(inputFieldsWidgets, findsNWidgets(3));
    expect(ctaButtonWidget, findsOneWidget);
  });
}