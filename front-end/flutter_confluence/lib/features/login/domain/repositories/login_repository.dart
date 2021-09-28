import 'package:dartz/dartz.dart';

import '/core/error/failures.dart';
import '/features/login/domain/entities/user.dart';

abstract class LoginRepository {
  Future<Either<Failure, User>> loginUser(String email, String password);
}
