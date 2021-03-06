part of 'user_settings_bloc.dart';

abstract class UserSettingsEvent extends Equatable {
  const UserSettingsEvent();

  @override
  List<Object?> get props => [];
}

class LoadUserEvent extends UserSettingsEvent {}

class EnableEditEvent extends UserSettingsEvent {}

class SaveChangesEvent extends UserSettingsEvent {
  const SaveChangesEvent({required this.user}) : super();
  final User user;
}

class CancelEditingEvent extends UserSettingsEvent {}

class UpdatePasswordEvent extends UserSettingsEvent {
  const UpdatePasswordEvent({required this.oldPassword, required this.newPassword}) : super();

  final String oldPassword;
  final String newPassword;
}
