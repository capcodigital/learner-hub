import 'dart:async';

import 'package:bloc/bloc.dart';

part 'user_registration_event.dart';
part 'user_registration_state.dart';

class UserRegistrationBloc extends Bloc<UserRegistrationEvent, UserRegistrationState> {
  UserRegistrationBloc() : super(UserRegistrationInitial());

  @override
  Stream<UserRegistrationState> mapEventToState(
    UserRegistrationEvent event,
  ) async* {
    // TODO(cgal-capco): implement mapEventToState
  }
}
