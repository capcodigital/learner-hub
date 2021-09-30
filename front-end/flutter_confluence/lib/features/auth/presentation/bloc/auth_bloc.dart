import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '/core/error/failures.dart';
import '/core/usecases/usecase.dart';
import '/features/auth/domain/usecases/check_auth_use_case.dart';
import '/features/auth/domain/usecases/logout_use_case.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({required this.checkAuthUseCase, required this.logoutUseCase}) : super(AuthInitial());

  final CheckAuthUseCase checkAuthUseCase;
  final LogoutUseCase logoutUseCase;

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    print('Event received: ${event.runtimeType}');

    // Add login

    // Add user check for initial preloader
    if (event is CheckAuthEvent) {
      final result = await checkAuthUseCase(NoParams());
      yield* getStateFromCheckAuthResult(result);
    }

    // Logout
    if (event is LogoutEvent) {
      final result = await logoutUseCase.call(NoParams());
      yield result.fold((l) => const AuthError(message: "It's not possible to logout the user"), (r) => AuthLogout());
    }
  }

  Stream<AuthState> getStateFromCheckAuthResult(Either<Failure, bool> arg) async* {
    print('hello');
    yield arg.fold(
      (failure) => InvalidUser(), // If there is an error with auth, treat it as if there is no user
      (result) => result ? ValidUser() : InvalidUser(),
    );
  }
}
