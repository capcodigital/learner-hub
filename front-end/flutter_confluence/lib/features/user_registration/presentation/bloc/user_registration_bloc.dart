import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_confluence/core/constants.dart';

import '/core/error/auth_failures.dart';
import '/core/error/failures.dart';
import '/features/user_registration/domain/entities/user_registration.dart';
import '/features/user_registration/domain/usecases/register_user.dart';

part 'user_registration_event.dart';

part 'user_registration_state.dart';

class UserRegistrationBloc
    extends Bloc<UserRegistrationEvent, UserRegistrationState> {
  UserRegistrationBloc({required this.registerUser})
      : super(UserRegistrationInitial()) {
    on<RegisterUserEvent>(onRegisterUser);
  }

  final RegisterUser registerUser;

  String _mapFailureToMessage(Failure failure) {
    if (failure is AuthFailure) {
      return failure.message;
    } else {
      return Constants.UNKNOWN_ERROR_MSG;
    }
  }

  FutureOr<void> onRegisterUser(RegisterUserEvent event, Emitter<UserRegistrationState> emit) async {
    emit(UserRegistrationLoading());
    final result = await registerUser(event.parameters);
    emit(result.fold(
        (failure) => UserRegistrationError(errorMessage: _mapFailureToMessage(failure)),
        (user) => UserRegistrationSuccess()));
  }
}
