import 'package:dartz/dartz.dart';

import '/core/error/failures.dart';
import '/features/user_settings/domain/entities/user.dart';

abstract class UserSettingsRepository {
  Future<Either<Failure, bool>> updateUserDetails(User user);
  Future<Either<Failure, bool>> updatePassword(String newPassword);
  Future<Either<Failure, User>> getCurrentUser();
}
