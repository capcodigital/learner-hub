import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '/core/error/auth_failures.dart';
import '/core/error/failures.dart';
import '/features/user_registration/domain/entities/user_registration.dart';
import '/features/user_registration/domain/usecases/register_user.dart';

part 'user_registration_event.dart';

part 'user_registration_state.dart';

class UserRegistrationBloc extends Bloc<UserRegistrationEvent, UserRegistrationState> {
  UserRegistrationBloc({required this.registerUserUseCase}) : super(UserRegistrationInitial());

  final RegisterUserUseCase registerUserUseCase;

  @override
  Stream<UserRegistrationState> mapEventToState(
    UserRegistrationEvent event,
  ) async* {
    if (event is RegisterUserEvent) {
      yield UserRegistrationLoading();
      final result = await registerUserUseCase(event.parameters);
      yield result.fold(
              (failure) => UserRegistrationError(errorMessage: _mapFailureToMessage(failure)),
          (user) => UserRegistrationSuccess());
    }
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is AuthFailure) {
      return failure.reason;
    } else {
      return 'Constants.UNKNOWN_ERROR_MSG';
    }
  }
}
