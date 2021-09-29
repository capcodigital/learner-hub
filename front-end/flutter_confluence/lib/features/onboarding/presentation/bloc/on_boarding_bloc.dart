import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:local_auth/error_codes.dart' as auth_error;

import '/core/auth/auth_failures.dart';
import '/core/constants.dart';
import '/core/error/failures.dart';
import '/core/usecases/usecase.dart';
import '/features/onboarding/domain/usecases/check_auth_use_case.dart';

part 'on_boarding_event.dart';
part 'on_boarding_state.dart';

class OnBoardingBloc extends Bloc<OnBoardingEvent, OnBoardingState> {
  OnBoardingBloc({required this.checkAuthUseCase}) : super(Empty());

  final CheckAuthUseCase checkAuthUseCase;

  @override
  Stream<OnBoardingState> mapEventToState(
    OnBoardingEvent event,
  ) async* {
    if (event is CheckAuthEvent) {
      yield Loading();
      final result = await checkAuthUseCase(NoParams());
      yield* getState(result);
    }
  }

  Stream<OnBoardingState> getState(Either<Failure, bool> arg) async* {
    yield arg.fold(
      (failure) => failure is NoCurrentUserLogged
          ? Expired()
          : AuthError(message: _mapFailureToMessage(failure as AuthFailure)),
      (result) => result ? Completed() : const AuthError(message: Constants.BIO_AUTH_DEFAULT_AUTH_FAILED),
    );
  }

  String _mapFailureToMessage(AuthFailure failure) {
    switch (failure.reason) {
      case auth_error.notEnrolled:
        return Constants.BIO_AUTH_NOT_ENROLLED;
      case auth_error.notAvailable:
        return Constants.BIO_AUTH_NOT_AVAILABLE;
      case auth_error.passcodeNotSet:
        return Constants.BIO_AUTH_PASSCODE_NOT_SET;
      case auth_error.otherOperatingSystem:
        return Constants.BIO_AUTH_OTHER_OPERATING_SYSTEM;
      case auth_error.lockedOut:
        return Constants.BIO_AUTH_LOCKED_OUT;
      case auth_error.permanentlyLockedOut:
        return Constants.BIO_AUTH_PERMANENTLY_LOCKED_OUT;
      default:
        return Constants.BIO_AUTH_DEFAULT_AUTH_FAILED;
    }
  }
}
