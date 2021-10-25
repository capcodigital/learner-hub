import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '/core/error/auth_failures.dart';
import '/core/error/failures.dart';
import '/core/usecases/usecase.dart';
import '/features/user_settings/domain/repositories/user_settings_repository.dart';

class UpdatePasswordParams extends Equatable {
  const UpdatePasswordParams({required this.password});

  final String password;

  @override
  List<Object> get props => [password];
}

class UpdatePassword implements UseCase<bool, UpdatePasswordParams> {
  UpdatePassword({required this.userSettingsRepository});

  final UserSettingsRepository userSettingsRepository;

  @override
  Future<Either<Failure, bool>> call(UpdatePasswordParams passwordParams) async {
    final password = passwordParams.password;
    if (password == null || password.isEmpty) {
      return Left(AuthFailure('New password cannot be null'));
    }

    return userSettingsRepository.updatePassword(passwordParams.password);
  }
}
