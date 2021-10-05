import 'package:dartz/dartz.dart';

import '/core/error/auth_failures.dart';
import '/features/user_registration/domain/entities/user_registration.dart';

abstract class UserRegistrationRepository {
  Future<Either<AuthFailure, bool>> registerFirebaseUser(String email, String password);
  Future<Either<AuthFailure, bool>> createUser(UserRegistration user);

  Future<Either<AuthFailure, bool>> cleanUpFirebaseUser();
}
