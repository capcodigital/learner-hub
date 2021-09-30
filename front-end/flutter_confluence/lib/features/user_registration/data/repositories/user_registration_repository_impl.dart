import 'package:dartz/dartz.dart';

import '/core/error/auth_failures.dart';
import '/core/error/failures.dart';
import '/features/auth/data/models/user_model.dart';
import '/features/auth/domain/entities/user.dart';
import '/features/user_registration/data/datasources/register_user_data_source.dart';
import '/features/user_registration/data/models/user_registration_model.dart';
import '/features/user_registration/domain/entities/user_registration.dart';
import '/features/user_registration/domain/repositories/user_registration_repository.dart';

class UserRegistrationRepositoryIml implements UserRegistrationRepository {
  UserRegistrationRepositoryIml({required this.dataSource});

  final RegisterUserDataSource dataSource;

  @override
  Future<Either<Failure, User>> registerFirebaseUser(UserRegistration user) async {
    try {
      final firebaseUser = await dataSource.registerFirebaseUser(user.email, user.password);
      return Right(UserModel(
          uid: firebaseUser.uid,
          displayName: firebaseUser.displayName,
          email: firebaseUser.email,
          photoUrl: firebaseUser.photoURL));
    } on AuthFailure catch (failure) {
      return Left(failure);
    } on Exception catch (ex) {
      return Left(AuthFailure('$ex'));
    }
  }

  @override
  Future<Either<Failure, User>> createUser(UserRegistration user) async {
    final userRequest = UserRegistrationModel(
        name: user.name,
        lastName: user.lastName,
        jobTitle: user.jobTitle,
        primarySkills: user.primarySkills,
        secondarySkills: user.secondarySkills,
        bio: user.bio,
        email: user.email,
        password: user.password);

    final isUserCreated = await dataSource.createUser(userRequest);
    if (isUserCreated) {
      return const Right(User(uid: '1234'));
    } else {
      return Left(AuthFailure("It's not possible to create the user"));
    }
  }
}
