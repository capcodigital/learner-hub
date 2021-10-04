import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '/core/error/auth_failures.dart';
import '/core/error/failures.dart';
import '/core/usecases/usecase.dart';
import '/features/auth/domain/usecases/is_session_valid.dart';
import '/features/auth/domain/usecases/login.dart';
import '/features/auth/domain/usecases/logout.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(
      {required this.isSessionValidUseCase,
      required this.loginUseCase,
      required this.logoutUseCase})
      : super(AuthInitial());

  final IsSessionValidUseCase isSessionValidUseCase;
  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    print('Event received: ${event.runtimeType}');

    // Add user check for initial preloader
    if (event is CheckAuthEvent) {
      final result = await isSessionValidUseCase(NoParams());
      yield* getStateFromCheckAuthResult(result);
    }

    // Login Event
    if (event is LoginEvent) {
      yield LoginLoading();
      final params = LoginParams(email: event.email, password: event.password);
      final result = await loginUseCase(params);
      yield result.fold(
              (failure) => AuthError(message: _mapFailureToMessage(failure)),
              (user) => LoginSuccess());
    }

    // Logout
    if (event is LogoutEvent) {
      final result = await logoutUseCase(NoParams());
      yield result.fold(
              (failure) => AuthError(message: _mapFailureToMessage(failure)),
              (success) => AuthLogout());
    }
  }

  Stream<AuthState> getStateFromCheckAuthResult(Either<Failure, bool> arg) async* {
    yield arg.fold(
      (failure) => InvalidUser(), // If there is an error with auth, treat it as if there is no user
      (success) => success ? ValidUser() : InvalidUser(),
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
