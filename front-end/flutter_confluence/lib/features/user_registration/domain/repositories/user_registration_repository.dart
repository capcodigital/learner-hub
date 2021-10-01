import 'package:dartz/dartz.dart';
import 'package:flutter_confluence/core/error/auth_failures.dart';

import '/features/auth/domain/entities/user.dart';
import '/features/user_registration/domain/entities/user_registration.dart';

abstract class UserRegistrationRepository {
  Future<Either<AuthFailure, User>> registerFirebaseUser(UserRegistration user);
  Future<Either<AuthFailure, bool>> createUser(UserRegistration user);
}
