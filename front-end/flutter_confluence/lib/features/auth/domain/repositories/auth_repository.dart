import 'package:dartz/dartz.dart';

import '/core/auth/auth_failures.dart';

abstract class AuthRepository {
  Future<Either<AuthFailure, bool>> checkCachedAuth();
  Future<void> logout();
}
