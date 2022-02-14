import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_confluence/core/shared_ui/primary_button.dart';
import 'package:flutter_confluence/core/themes.dart';
import 'package:flutter_confluence/features/user_settings/presentation/bloc/user_settings_bloc.dart';
import 'package:flutter_confluence/features/user_settings/presentation/pages/change_password_page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockUserSettingsBloc extends MockBloc<UserSettingsEvent, UserSettingsState> implements UserSettingsBloc {}

class TestEvent extends UserSettingsEvent {}

void main() {
  setUpAll(() {
    registerFallbackValue(UserSettingsInitial());
    registerFallbackValue(TestEvent());
  });

  testWidgets('Change password page should show expected widgets', (tester) async {
    // arrange
    final UserSettingsBloc mockBloc = MockUserSettingsBloc();
    whenListen(mockBloc, Stream.fromIterable([UserSettingsInitial()]), initialState: UserSettingsInitial());

    // act
    await tester.pumpWidget(MaterialApp(
      theme: Themes.appTheme,
      home: BlocProvider<UserSettingsBloc>(
        create: (_) => mockBloc,
        child: const ChangePasswordPage(),
      ),
    ));

    final textFormFieldWidgets = find.byWidgetPredicate((widget) => widget is TextFormField);
    final ctaButtonWidget = find.byWidgetPredicate((widget) => widget is PrimaryButton);

    // assert
    expect(textFormFieldWidgets, findsNWidgets(3));
    expect(ctaButtonWidget, findsOneWidget);
  });
}
