import 'package:dartz/dartz.dart';

import '/core/auth/user.dart';
import '/core/error/failures.dart';

abstract class LoginRepository {
  Future<Either<Failure, User>> loginUser(String email, String password);
}
