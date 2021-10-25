part of 'user_settings_bloc.dart';

abstract class UserSettingsState extends Equatable {
  const UserSettingsState({
    required this.user,
    required this.isEditing,
    required this.canCancel,
    required this.canSave,
  });

  final User? user;
  final bool? isEditing;
  final bool? canCancel;
  final bool? canSave;

  @override
  List<Object> get props => [user ?? '', isEditing ?? '', canCancel ?? '', canSave ?? ''];
}

class UserSettingsInitial extends UserSettingsState {
  const UserSettingsInitial() : super(user: null, isEditing: false, canCancel: false, canSave: false);
}

class Loading extends UserSettingsState {
  const Loading({required user}) : super(user: user, isEditing: false, canCancel: false, canSave: false);
}

class UserLoadedState extends UserSettingsState {
  const UserLoadedState({
    required user,
    required isEditing,
    required canCancel,
    required canSave,
  }) : super(user: user, isEditing: isEditing, canCancel: canCancel, canSave: canSave);
}

class UserUpdateSuccess extends UserSettingsState {
  const UserUpdateSuccess({
    required user,
  }) : super(user: user, isEditing: false, canCancel: false, canSave: false);
}

class UserUpdateError extends UserSettingsState {
  const UserUpdateError({
    required this.errorMessage,
    required user,
    required isEditing,
    required canCancel,
    required canSave,
  }) : super(user: user, isEditing: isEditing, canCancel: canCancel, canSave: canSave);

  final String errorMessage;

  @override
  List<Object> get props => [errorMessage];
}

class PasswordUpdateSuccess extends UserSettingsState {
  const PasswordUpdateSuccess({
    required user,
  }) : super(user: user, isEditing: false, canCancel: false, canSave: false);
}

class PasswordUpdateError extends UserSettingsState {
  const PasswordUpdateError({
    required this.errorMessage,
    required user,
  }) : super(user: user, isEditing: false, canCancel: false, canSave: false);

  final String errorMessage;

  @override
  List<Object> get props => [errorMessage, user ?? '', isEditing ?? '', canCancel ?? '', canSave ?? ''];
}
