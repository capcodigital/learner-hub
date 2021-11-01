import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '/core/error/failures.dart';
import '/core/usecases/usecase.dart';
import '/features/user_settings/domain/repositories/user_settings_repository.dart';

class UpdatePasswordParams extends Equatable {
  const UpdatePasswordParams({required this.oldPassword, required this.newPassword});

  final String oldPassword;
  final String newPassword;

  @override
  List<Object> get props => [oldPassword, newPassword];
}

class UpdatePassword implements UseCase<bool, UpdatePasswordParams> {
  UpdatePassword({required this.userSettingsRepository});

  final UserSettingsRepository userSettingsRepository;

  @override
  Future<Either<Failure, bool>> call(UpdatePasswordParams passwordParams) async {
    return userSettingsRepository.updatePassword(passwordParams.oldPassword, passwordParams.newPassword);
  }
}
