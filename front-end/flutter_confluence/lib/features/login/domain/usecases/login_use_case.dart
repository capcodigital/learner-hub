import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_confluence/core/auth/auth_manager.dart';
import 'package:flutter_confluence/core/auth/user.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';

class LoginParams extends Equatable {
  const LoginParams({required this.email, required this.password});

  final String email;
  final String password;

  @override
  List<Object> get props => [email, password];
}

class LoginUseCase implements UseCase<User, LoginParams> {
  LoginUseCase({required this.authManager});

  final AuthManager authManager;

  @override
  Future<Either<Failure, User>> call(LoginParams parameters) async {
    return authManager.loginUser(parameters.email, parameters.password);
  }
}
