part of 'user_settings_bloc.dart';

abstract class UserSettingsState extends Equatable {
  const UserSettingsState({
    this.user,
    this.canCancel,
    this.canSave,
  });

  final User? user;
  final bool? canCancel;
  final bool? canSave;

  @override
  List<Object> get props => [];
}

class UserSettingsInitial extends UserSettingsState {
  const UserSettingsInitial() : super();
}


class TodosLoadInProgress extends UserSettingsState {}


class PasswordUpdateSuccess extends UserSettingsState {}
class PasswordUpdateError extends UserSettingsState {
  const PasswordUpdateError({required this.errorMessage});

  final String errorMessage;

  @override
  List<Object> get props => [errorMessage];
}

