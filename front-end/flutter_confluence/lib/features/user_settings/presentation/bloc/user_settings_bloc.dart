import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_confluence/features/user_settings/domain/entities/user.dart';
import 'package:flutter_confluence/features/user_settings/domain/usecases/update_password.dart';
import 'package:flutter_confluence/features/user_settings/domain/usecases/update_user_settings.dart';

part 'user_settings_event.dart';

part 'user_settings_state.dart';

class UserSettingsBloc extends Bloc<UserSettingsEvent, UserSettingsState> {
  UserSettingsBloc({required this.updateUserSettings, required this.updatePassword})
      : super(const UserSettingsInitial()) {
    on<UpdatePasswordEvent>(onUpdatePassword);
  }

  final UpdateUserSettings updateUserSettings;
  final UpdatePassword updatePassword;

  @override
  Stream<UserSettingsState> mapEventToState(UserSettingsEvent event) async* {
    print('Event received: ${event.runtimeType}');
  }

  void onUpdatePassword(UpdatePasswordEvent event, Emitter<UserSettingsState> emit) {
    print('Updating password');
    emit(PasswordUpdateSuccess());
  }
}
