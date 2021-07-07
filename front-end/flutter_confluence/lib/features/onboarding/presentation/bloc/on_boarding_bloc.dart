import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_confluence/core/constants.dart';
import 'package:flutter_confluence/features/onboarding/domain/usecases/check_auth_use_case.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/auth_use_case.dart';
import 'package:local_auth/error_codes.dart' as auth_error;

part 'on_boarding_event.dart';
part 'on_boarding_state.dart';

class OnBoardingBloc extends Bloc<OnBoardingEvent, OnBoardingState> {
  final AuthUseCase authUseCase;
  final CheckAuthUseCase checkAuthUseCase;

  OnBoardingBloc({required this.authUseCase, required this.checkAuthUseCase})
      : super(Empty());

  @override
  Stream<OnBoardingState> mapEventToState(
    OnBoardingEvent event,
  ) async* {
    if (event is AuthEvent) {
      yield Loading();
      final result = await authUseCase(NoParams());
      yield* getState(result);
    }
    if (event is CheckAuthEvent) {
      yield Loading();
      final result = await checkAuthUseCase(NoParams());
      yield* getState(result);
    }
  }

  Stream<OnBoardingState> getState(Either<Failure, bool> arg) async* {
    yield arg.fold(
      (failure) => failure is AuthExpirationFailure ? Expired() :
      Error(message: _mapFailureToMessage(failure as AuthFailure)),
      (result) => result ? Completed() : Error(message: Constants.BIO_AUTH_DEFAULT_AUTH_FAILED),
    );
  }

  String _mapFailureToMessage(AuthFailure failure) {
    switch (failure.code) {
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
