import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '/core/auth/auth_failures.dart';
import '/core/error/failures.dart';
import '/features/login/domain/usecases/login_use_case.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({required this.loginUseCase}) : super(LoginInitial());

  final LoginUseCase loginUseCase;

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is LoginRequestEvent) {
      yield LoginLoading();
      final params = LoginParams(email: event.email, password: event.password);
      final result = await loginUseCase.call(params);
      yield result.fold(
              (failure) => LoginError(errorMessage: _mapFailureToMessage(failure)),
              (user) => LoginSuccess());
    }
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is AuthFailure) {
      return failure.reason;
    }
    else {
      return 'Constants.UNKNOWN_ERROR_MSG';
    }

    // switch (failure.runtimeType) {
    //   case WeakPasswordFailure:
    //     return "(failure as ServerFailure).message";
    //   case InvalidEmailFailure:
    //     return "Constants.CACHE_FAILURE_MSG";
    //   case InvalidPasswordFailure:
    //     return "";
    //   default:
    //     return "Constants.UNKNOWN_ERROR_MSG";
    // }
  }
}
