import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_confluence/core/error/failures.dart';
import 'package:flutter_confluence/core/usecases/usecase.dart';
import 'package:flutter_confluence/features/user_settings/domain/entities/user.dart';
import 'package:flutter_confluence/features/user_settings/domain/usecases/load_user.dart';
import 'package:flutter_confluence/features/user_settings/domain/usecases/update_password.dart';
import 'package:flutter_confluence/features/user_settings/domain/usecases/update_user_settings.dart';
import 'package:flutter_confluence/features/user_settings/presentation/bloc/user_settings_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockUpdateUserSettings extends Mock implements UpdateUserSettings {}
class MockUpdatePassword extends Mock implements UpdatePassword {}
class MockLoadUser extends Mock implements LoadUser {}

void main() {
  late MockUpdateUserSettings mockUpdateUserSettings;
  late MockUpdatePassword mockUpdatePassword;
  late MockLoadUser mockLoadUser;
  late UserSettingsBloc bloc;

  const testUser = User(
      name: 'Luke',
      lastName: 'Skywalker',
      jobTitle: 'Master Jedi',
      primarySkills: ['Use the Force'],
      secondarySkills: ['Jedi tricks'],
      bio: 'bio',
      email: 'luke.skywalker@capco.com');

  setUpAll(() {
    registerFallbackValue(NoParams());
    registerFallbackValue(const UpdatePasswordParams(oldPassword: 'old', newPassword: 'new'));
    registerFallbackValue(const UpdateUserSettingsParams(user: testUser));
  });

  setUp(() {
    mockUpdateUserSettings = MockUpdateUserSettings();
    mockUpdatePassword = MockUpdatePassword();
    mockLoadUser = MockLoadUser();
    bloc = UserSettingsBloc(
      updateUserSettings: mockUpdateUserSettings,
      updatePassword: mockUpdatePassword,
      loadUser: mockLoadUser,
    );
  });

  test('initial bloc state should be UserSettingsInitial', () {
    expect(bloc.state, equals(UserSettingsInitial()));
  });

  group('Enable editing', () {
    blocTest<UserSettingsBloc, UserSettingsState>(
      'emits edit mode when data can be edited',
      seed: () => const UserLoadedState(user: testUser, isEditing: false, canCancel: false, canSave: false),
      build: () => bloc,
      act: (UserSettingsBloc bloc) => bloc.add(EnableEditEvent()),
      expect: () => [const UserLoadedState(user: testUser, isEditing: true, canSave: true, canCancel: true)],
    );

    blocTest<UserSettingsBloc, UserSettingsState>(
      'emits cancel edit mode when data is no longer editable',
      seed: () => const UserLoadedState(user: testUser, isEditing: true, canCancel: true, canSave: true),
      build: () => bloc,
      act: (UserSettingsBloc bloc) => bloc.add(CancelEditingEvent()),
      expect: () => [const UserLoadedState(user: testUser, isEditing: false, canSave: false, canCancel: false)],
    );
  });

  group('LoadUser', () {
    blocTest<UserSettingsBloc, UserSettingsState>(
      'emits [Loading, UserLoadedState] when LoadUserEvent is added',
      build: () {
        when(() => mockLoadUser(any())).thenAnswer((_) => Future.value(const Right(testUser)));
        return bloc;
      },
      act: (UserSettingsBloc bloc) => bloc.add(LoadUserEvent()),
      expect: () => [
        Loading(user: User.emptyUser()),
        const UserLoadedState(
          user: testUser,
          canSave: false,
          canCancel: false,
          isEditing: false,
        ),
      ],
    );

    blocTest<UserSettingsBloc, UserSettingsState>(
      'emits [Loading, UserLoadErrorState] when LoadUserEvent is added and there is an error loading the user',
      build: () {
        when(() => mockLoadUser(any())).thenAnswer((_) => Future.value(const Left(ServerFailure(message: ''))));
        return bloc;
      },
      act: (UserSettingsBloc bloc) => bloc.add(LoadUserEvent()),
      expect: () => [
        Loading(user: User.emptyUser()),
        UserLoadErrorState(errorMessage: "It's not possible to load the user data. "),
      ],
    );
  });

  group('UpdatePassword', () {
    blocTest<UserSettingsBloc, UserSettingsState>(
      'emits [Loading, PasswordUpdateSuccess] when password is changed',
      seed: () => const UserLoadedState(user: testUser, isEditing: false, canCancel: false, canSave: false),
      build: () {
        when(() => mockUpdatePassword(any())).thenAnswer((_) => Future.value(const Right(true)));
        return bloc;
      },
      act: (UserSettingsBloc bloc) =>
          bloc.add(const UpdatePasswordEvent(oldPassword: 'oldPassword', newPassword: 'new password')),
      expect: () => [
        const Loading(user: testUser),
        const PasswordUpdateSuccess(
          user: testUser,
        ),
      ],
    );

    blocTest<UserSettingsBloc, UserSettingsState>(
      'emits [Loading, PasswordUpdateError] when there is an error updating the password',
      seed: () => const UserLoadedState(user: testUser, isEditing: false, canCancel: false, canSave: false),
      build: () {
        when(() => mockUpdatePassword(any())).thenAnswer((_) => Future.value(const Left(ServerFailure(message: ''))));
        return bloc;
      },
      act: (UserSettingsBloc bloc) =>
          bloc.add(const UpdatePasswordEvent(oldPassword: 'oldPassword', newPassword: 'new password')),
      expect: () => [
        const Loading(user: testUser),
        const PasswordUpdateError(errorMessage: '', user: testUser),
      ],
    );
  });

  group('UpdateUserSettings', () {
    blocTest<UserSettingsBloc, UserSettingsState>(
      'emits [Loading, UserUpdateSuccess] when user data has been updated',
      seed: () => const UserLoadedState(user: testUser, isEditing: true, canCancel: true, canSave: true),
      build: () {
        when(() => mockUpdateUserSettings(any())).thenAnswer((_) => Future.value(const Right(true)));
        return bloc;
      },
      act: (UserSettingsBloc bloc) => bloc.add(const SaveChangesEvent(user: testUser)),
      expect: () => [
        const Loading(user: testUser),
        const UserUpdateSuccess(
          user: testUser,
        ),
      ],
    );

    blocTest<UserSettingsBloc, UserSettingsState>(
      'emits [Loading, UserUpdateError] when there is an error updating the user data',
      seed: () => const UserLoadedState(user: testUser, isEditing: true, canCancel: true, canSave: true),
      build: () {
        when(() => mockUpdateUserSettings(any()))
            .thenAnswer((_) => Future.value(const Left(ServerFailure(message: ''))));
        return bloc;
      },
      act: (UserSettingsBloc bloc) => bloc.add(const SaveChangesEvent(user: testUser)),
      expect: () => [
        const Loading(user: testUser),
        const UserUpdateError(errorMessage: '', user: testUser, canCancel: true, canSave: true, isEditing: true),
      ],
    );
  });
}
