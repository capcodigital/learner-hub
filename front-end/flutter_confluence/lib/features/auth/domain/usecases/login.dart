import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '/core/error/failures.dart';
import '/core/usecases/usecase.dart';
import '/features/auth/domain/entities/user.dart';
import '/features/auth/domain/repositories/auth_repository.dart';

class LoginParams extends Equatable {
  const LoginParams({required this.email, required this.password});

  final String email;
  final String password;

  @override
  List<Object> get props => [email, password];
}

class LoginUseCase implements UseCase<User, LoginParams> {
  LoginUseCase({required this.authRepository});

  final AuthRepository authRepository;

  @override
  Future<Either<Failure, User>> call(LoginParams parameters) async {
    return authRepository.loginUser(parameters.email, parameters.password);
  }
}
