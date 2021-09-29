import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '/core/usecases/usecase.dart';
import '/features/logout/domain/usecases/logout_use_case.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({required this.logoutUseCase}) : super(AuthInitial());

  final LogoutUseCase logoutUseCase;

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    print('Event received: ${event.runtimeType}');

    if (event is LogoutEvent) {
      final result = await logoutUseCase.call(NoParams());
      yield result.fold((l) => AuthLogoutError(), (r) => AuthLogout());
    }
  }
}
