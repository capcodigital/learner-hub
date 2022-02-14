import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learner_hub/core/shared_ui/primary_button.dart';
import 'package:learner_hub/core/shared_ui/secondary_button.dart';
import 'package:learner_hub/core/themes.dart';
import 'package:learner_hub/features/user_settings/presentation/bloc/user_settings_bloc.dart';
import 'package:learner_hub/features/user_settings/presentation/pages/user_settings_page.dart';
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
        child: const UserSettingsPage(),
      ),
    ));

    final textFormFieldWidgets = find.byWidgetPredicate((widget) => widget is TextFormField);
    final saveButtonWidget = find.byWidgetPredicate((widget) => widget is PrimaryButton);
    final cancelButtonWidget = find.byWidgetPredicate((widget) => widget is SecondaryButton);

    // assert
    expect(textFormFieldWidgets, findsNWidgets(4));
    expect(saveButtonWidget, findsOneWidget);
    expect(cancelButtonWidget, findsOneWidget);
  });
}
