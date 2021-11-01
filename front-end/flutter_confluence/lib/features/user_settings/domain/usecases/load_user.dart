import 'package:dartz/dartz.dart';

import '/core/error/failures.dart';
import '/core/usecases/usecase.dart';
import '/features/user_settings/domain/entities/user.dart';
import '/features/user_settings/domain/repositories/user_settings_repository.dart';

class LoadUser implements UseCase<User, NoParams> {
  LoadUser({required this.userSettingsRepository});

  final UserSettingsRepository userSettingsRepository;

  @override
  Future<Either<Failure, User>> call(NoParams params) async {
    return userSettingsRepository.getCurrentUser();
  }
}
