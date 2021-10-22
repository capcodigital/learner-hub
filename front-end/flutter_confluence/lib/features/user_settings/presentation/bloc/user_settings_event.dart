part of 'user_settings_bloc.dart';

abstract class UserSettingsEvent extends Equatable {
  const UserSettingsEvent();

  @override
  List<Object?> get props => [];
}

class LoadUserEvent extends UserSettingsEvent {}

class EditPhotoEvent extends UserSettingsEvent {}

class EnableEditEvent extends UserSettingsEvent {}

class SaveChangesEvent extends UserSettingsEvent {}

class CancelEditingEvent extends UserSettingsEvent {}

class ChangePasswordEvent extends UserSettingsEvent {}

class UpdatePasswordEvent extends UserSettingsEvent {
  const UpdatePasswordEvent({required this.newPassword}) : super();

  final String newPassword;
}
