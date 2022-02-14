import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '/core/error/failures.dart';
import '/core/usecases/usecase.dart';
import '/features/user_settings/domain/entities/user.dart';
import '/features/user_settings/domain/repositories/user_settings_repository.dart';

class UpdateUserSettingsParams extends Equatable {
  const UpdateUserSettingsParams({required this.user});

  final User user;

  @override
  List<Object> get props => [user];
}

class UpdateUserSettings implements UseCase<bool, UpdateUserSettingsParams> {
  UpdateUserSettings({required this.userSettingsRepository});

  final UserSettingsRepository userSettingsRepository;

  @override
  Future<Either<Failure, bool>> call(UpdateUserSettingsParams params) async {
    return userSettingsRepository.updateUserDetails(params.user);
  }
}
