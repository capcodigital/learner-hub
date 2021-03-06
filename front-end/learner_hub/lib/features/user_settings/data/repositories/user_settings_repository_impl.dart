import 'package:dartz/dartz.dart';

import '/core/error/auth_failures.dart';
import '/core/error/failures.dart';
import '/core/network/network_info.dart';
import '/features/user_settings/data/datasources/user_settings_data_source.dart';
import '/features/user_settings/data/model/user_model.dart';
import '/features/user_settings/domain/entities/user.dart';
import '/features/user_settings/domain/repositories/user_settings_repository.dart';

class UserSettingsRepositoryImpl implements UserSettingsRepository {
  UserSettingsRepositoryImpl({required this.dataSource, required this.networkInfo});

  final UserSettingsDataSource dataSource;
  final NetworkInfo networkInfo;

  @override
  Future<Either<Failure, bool>> updateUserDetails(User user) async {
    if (await networkInfo.isConnected) {
      try {
        final userModel = user.toModel();
        await dataSource.updateUserSettings(userModel);
        return const Right(true);
      } on Exception catch (ex) {
        return Left(ServerFailure(message: '$ex'));
      }
    } else {
      return Left(NoInternetFailure());
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    if (await networkInfo.isConnected) {
      try {
        final user = await dataSource.loadUserInfo();
        return Right(user);
      } on Exception {
        return const Left(AuthFailure("It's not possible to load the user"));
      }
    } else {
      return Left(NoInternetFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> updatePassword(String oldPassword, String newPassword) async {
    if (await networkInfo.isConnected) {
      try {
        await dataSource.updatePassword(oldPassword, newPassword);
        return const Right(true);
      } on AuthFailure catch (e) {
        var reason = '';
        if (e.message == 'user-mismatch') {
          reason = 'User mismatch';
        } else if (e.message == 'invalid-credential') {
          reason = 'The credentials have expired. Please login again';
        } else if (e.message == 'invalid-email') {
          reason = 'Invalid email';
        } else if (e.message == 'wrong-password') {
          reason = 'The password entered is incorrect';
        } else {
          reason = e.message;
        }

        return Left(AuthFailure(reason));
      } on Exception catch (ex) {
        return Left(ServerFailure(message: '$ex'));
      }
    } else {
      return Left(NoInternetFailure());
    }
  }
}
