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
      : super(AuthInitial()){
    on<CheckAuthEvent>(onCheckAuth);
    on<LoginEvent>(onLogin);
    on<LogoutEvent>(onLogout);
  }

  final IsSessionValidUseCase isSessionValidUseCase;
  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;

  AuthState getStateFromCheckAuthResult(Either<Failure, bool> arg)  {
    return arg.fold(
      (failure) => InvalidUser(), // If there is an error with auth, treat it as if there is no user
      (success) => success ? ValidUser() : InvalidUser(),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is AuthFailure) {
      return failure.message;
    } else {
      return 'Constants.UNKNOWN_ERROR_MSG';
    }
  }

  FutureOr<void> onCheckAuth(CheckAuthEvent event, Emitter<AuthState> emit) async {
    final result = await isSessionValidUseCase(NoParams());
    emit(getStateFromCheckAuthResult(result));
  }

  FutureOr<void> onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(LoginLoading());
    final params = LoginParams(email: event.email, password: event.password);
    final result = await loginUseCase(params);
    emit(result.fold(
            (failure) => AuthError(message: _mapFailureToMessage(failure)),
            (user) => LoginSuccess()));
  }

  FutureOr<void> onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    final result = await logoutUseCase(NoParams());
    emit(result.fold(
            (failure) => AuthError(message: _mapFailureToMessage(failure)),
            (success) => AuthLogout()));
  }
}
