import 'package:dartz/dartz.dart';

import '/core/error/auth_failures.dart';
import '/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  // Rename checkCachedAuth -> isValidSessionToken()?
  Future<Either<AuthFailure, bool>> checkCachedAuth();
  Future<Either<AuthFailure, User>> loginUser(String email, String password);
  Future<void> logout();
}
