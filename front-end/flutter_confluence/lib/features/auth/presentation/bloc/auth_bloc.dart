import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '/core/auth/auth_failures.dart';
import '/core/error/failures.dart';
import '/core/usecases/usecase.dart';
import '/features/auth/domain/usecases/check_auth_use_case.dart';
import '/features/auth/domain/usecases/login_use_case.dart';
import '/features/auth/domain/usecases/logout_use_case.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({required this.checkAuthUseCase, required this.loginUseCase, required this.logoutUseCase})
      : super(AuthInitial());

  final CheckAuthUseCase checkAuthUseCase;
  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    print('Event received: ${event.runtimeType}');

    // Add user check for initial preloader
    if (event is CheckAuthEvent) {
      final result = await checkAuthUseCase(NoParams());
      yield* getStateFromCheckAuthResult(result);
    }

    // Login Event
    if (event is LoginEvent) {
      yield LoginLoading();
      final params = LoginParams(email: event.email, password: event.password);
      final result = await loginUseCase.call(params);
      yield result.fold((failure) => AuthError(message: _mapFailureToMessage(failure)), (user) => LoginSuccess());
    }

    // Logout
    if (event is LogoutEvent) {
      final result = await logoutUseCase.call(NoParams());
      yield result.fold((failure) => AuthError(message: _mapFailureToMessage(failure)), (r) => AuthLogout());
    }
  }

  Stream<AuthState> getStateFromCheckAuthResult(Either<Failure, bool> arg) async* {
    yield arg.fold(
      (failure) => InvalidUser(), // If there is an error with auth, treat it as if there is no user
      (result) => result ? ValidUser() : InvalidUser(),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is AuthFailure) {
      return failure.reason;
    } else {
      return 'Constants.UNKNOWN_ERROR_MSG';
    }
  }
}
