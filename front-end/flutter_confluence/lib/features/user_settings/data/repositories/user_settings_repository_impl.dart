import 'package:dartz/dartz.dart';
import 'package:flutter_confluence/core/error/auth_failures.dart';

import '/core/error/failures.dart';
import '/features/user_settings/data/datasources/user_settings_data_source.dart';
import '/features/user_settings/data/model/user_model.dart';
import '/features/user_settings/domain/entities/user.dart';
import '/features/user_settings/domain/repositories/user_settings_repository.dart';

class UserSettingsRepositoryImpl implements UserSettingsRepository {
  UserSettingsRepositoryImpl({required this.dataSource});

  final UserSettingsDataSource dataSource;

  @override
  Future<Either<Failure, bool>> updateUserDetails(User user) async {
    try {
      final userModel = user.toModel();
      await dataSource.updateUserSettings(userModel);
      return const Right(true);
    } on Exception catch (ex) {
      return Left(ServerFailure(message: '$ex'));
    }
  }

  @override
  Future<Either<Failure, bool>> updatePassword(String newPassword) async {
    try {
      await dataSource.updatePassword(newPassword);
      return const Right(true);
    } on Exception catch (ex) {
      return Left(ServerFailure(message: '$ex'));
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      final user = await dataSource.loadUserInfo();
      return Right(user);
    } on Exception catch (ex) {
      print('Error loading the user details: $ex');
      return const Left(AuthFailure("It's not possible to load the user"));
    }
  }
}
