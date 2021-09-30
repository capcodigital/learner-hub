import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '/core/error/auth_failures.dart';
import '/core/error/failures.dart';
import '/features/user_registration/domain/entities/user_registration_navigation_parameters.dart';
import '/features/user_registration/domain/usecases/register_user_use_case.dart';

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
      final parameters = event.parameters;
      final params = RegisterParams(
          name: parameters.name!,
          lastName: parameters.lastName!,
          jobTitle: parameters.jobTitle!,
          primarySkills: parameters.primarySkills!,
          secondarySkills: parameters.secondarySkills!,
          bio: parameters.bio!,
          email: parameters.email!,
          password: parameters.password!);
      final result = await registerUserUseCase.call(params);
      yield result.fold((failure) => UserRegistrationError(errorMessage: _mapFailureToMessage(failure)),
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
