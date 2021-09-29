import 'package:dartz/dartz.dart';

import '/core/error/failures.dart';
import '/features/login/domain/entities/user.dart';
import '/features/user_registration/domain/entities/user_registration.dart';

abstract class UserRegistrationRepository {
  Future<Either<Failure, User>> registerFirebaseUser(UserRegistration user);
  Future<Either<Failure, User>> createUser(UserRegistration user);
}
