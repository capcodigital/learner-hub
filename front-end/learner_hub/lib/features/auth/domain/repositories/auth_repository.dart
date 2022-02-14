import 'package:dartz/dartz.dart';

import '/core/error/auth_failures.dart';

abstract class AuthRepository {
  Future<Either<AuthFailure, bool>> isValidSession();
  Future<Either<AuthFailure, bool>> loginUser(String email, String password);
  Future<void> logout();
}
