import 'package:dartz/dartz.dart';

import '/core/auth/auth_manager.dart';
import '/core/auth/user.dart';
import '/core/error/failures.dart';
import '/features/login/domain/repositories/login_repository.dart';

class LoginRepositoryImpl implements LoginRepository {
  LoginRepositoryImpl({required this.authManager});

  final AuthManager authManager;

  @override
  Future<Either<Failure, User>> loginUser(String email, String password) {
    return authManager.loginUser(email, password);
  }
}
