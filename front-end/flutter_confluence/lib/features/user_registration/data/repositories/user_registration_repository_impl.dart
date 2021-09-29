import 'package:dartz/dartz.dart';

import '/core/error/failures.dart';
import '/features/login/data/models/user_model.dart';
import '/features/login/domain/entities/user.dart';
import '/features/user_registration/data/datasources/register_user_data_source.dart';
import '/features/user_registration/domain/entities/user_registration.dart';
import '/features/user_registration/domain/repositories/user_registration_repository.dart';

class UserRegistrationRepositoryIml implements UserRegistrationRepository {
  UserRegistrationRepositoryIml({required this.dataSource});

  final RegisterUserDataSource dataSource;

  @override
  Future<Either<Failure, User>> registerUser(UserRegistration user) async {
    final result = await dataSource.registerUser(user.email, user.password);
    return result.fold(
        (failure) => Left(failure),
        (firebaseUser) => Right(UserModel(
            uid: firebaseUser.uid,
            displayName: firebaseUser.displayName,
            email: firebaseUser.email,
            photoUrl: firebaseUser.photoURL)));
  }
}
