import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '/core/usecases/usecase.dart';
import '/features/user_settings/domain/entities/user.dart';
import '/features/user_settings/domain/usecases/load_user.dart';
import '/features/user_settings/domain/usecases/update_password.dart';
import '/features/user_settings/domain/usecases/update_user_settings.dart';

part 'user_settings_event.dart';

part 'user_settings_state.dart';

class UserSettingsBloc extends Bloc<UserSettingsEvent, UserSettingsState> {
  UserSettingsBloc({required this.updateUserSettings, required this.updatePassword, required this.loadUser})
      : super(UserSettingsInitial()) {
    on<LoadUserEvent>(onLoadUser);
    on<UpdatePasswordEvent>(onUpdatePassword);
    on<EnableEditEvent>(onEnableEditEvent);
    on<CancelEditingEvent>(onCancelEditingEvent);
    on<SaveChangesEvent>(onSaveChangesEvent);
  }

  final UpdateUserSettings updateUserSettings;
  final UpdatePassword updatePassword;
  final LoadUser loadUser;

  FutureOr<void> onLoadUser(LoadUserEvent event, Emitter<UserSettingsState> emit) async {
    print('Loading user');
    final currentUser = state.user;
    emit(Loading(user: currentUser));
    final result = await loadUser(NoParams());
    result.fold(
            (failure) => emit(UserLoadErrorState(errorMessage: "It's not possible to load the user data. ${failure.message}")),
            (user) => emit(UserLoadedState(user: user, canCancel: false, canSave: false, isEditing: false))
    );
  }

  Future onUpdatePassword(UpdatePasswordEvent event, Emitter<UserSettingsState> emit) async {
    print('Updating password');
    final currentUser = state.user;
    emit(Loading(user: currentUser));
    final result = await updatePassword(UpdatePasswordParams(oldPassword: event.oldPassword, newPassword: event.newPassword));
    result.fold(
            (failure) => emit(PasswordUpdateError(errorMessage: failure.message, user: currentUser)),
            (success) => emit(PasswordUpdateSuccess(user: currentUser))
    );
  }

  FutureOr<void> onEnableEditEvent(EnableEditEvent event, Emitter<UserSettingsState> emit) {
    print('Enter edit mode');
    emit(UserLoadedState(user: state.user, isEditing: true, canSave: true, canCancel: true));
  }

  FutureOr<void> onCancelEditingEvent(CancelEditingEvent event, Emitter<UserSettingsState> emit) {
    print('Canceling edit');
    emit(UserLoadedState(user: state.user, isEditing: false, canSave: false, canCancel: false));
  }

  FutureOr<void> onSaveChangesEvent(SaveChangesEvent event, Emitter<UserSettingsState> emit) async {
    print('Saving user profile changes');
    final currentUser = state.user;
    final newUser = event.user;
    emit(Loading(user: state.user));

    final result = await updateUserSettings(UpdateUserSettingsParams(user: newUser));
    result.fold(
        (failure) => emit(UserUpdateError(errorMessage: failure.message, user: currentUser, canCancel: true, canSave: true, isEditing: true)),
        (success) => emit(UserUpdateSuccess(user: newUser))
    );
  }
}
