import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_confluence/features/user_settings/domain/entities/user.dart';

part 'user_settings_event.dart';
part 'user_settings_state.dart';

class UserSettingsBloc extends Bloc<UserSettingsEvent, UserSettingsState> {
  UserSettingsBloc() : super(UserSettingsInitial()) {}

  @override
  Stream<UserSettingsState> mapEventToState(UserSettingsEvent event) async* {
    print('Event received: ${event.runtimeType}');
    yield UserSettingsInitial();
  }
}
