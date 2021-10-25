import 'package:dartz/dartz.dart';

import '/core/error/auth_failures.dart';
import '/features/user_registration/data/datasources/register_user_data_source.dart';
import '/features/user_registration/data/models/skills_model.dart';
import '/features/user_registration/data/models/user_registration_model.dart';
import '/features/user_registration/domain/entities/user_registration.dart';
import '/features/user_registration/domain/repositories/user_registration_repository.dart';

class UserRegistrationRepositoryIml implements UserRegistrationRepository {
  UserRegistrationRepositoryIml({required this.dataSource});

  final RegisterUserDataSource dataSource;

  @override
  Future<Either<AuthFailure, bool>> registerFirebaseUser(String email, String password) async {
    try {
      await dataSource.registerFirebaseUser(email, password);
      return const Right(true);
    } on AuthFailure catch (failure) {
      return Left(failure);
    } on Exception catch (ex) {
      return Left(AuthFailure('$ex'));
    }
  }

  @override
  Future<Either<AuthFailure, bool>> createUser(UserRegistration user) async {
    try {
      final userRequest = UserRegistrationModel(
          name: user.name,
          lastName: user.lastName,
          jobTitle: user.jobTitle,
          skills: user.skills?.toModel() ?? SkillsModel(primarySkills: [], secondarySkills: []),
          bio: user.bio,
          email: user.email,
          password: user.password);

      final isUserCreated = await dataSource.createUser(userRequest);
      if (isUserCreated) {
        return const Right(true);
      } else {
        return Left(CreateUserError());
      }
    } catch (ex) {
      return Left(CreateUserError());
    }
  }

  @override
  Future<Either<AuthFailure, bool>> cleanUpFirebaseUser() async {
    try {
      await dataSource.cleanUpFailedUser();
      return const Right(true);
    } catch (ex) {
      return Left(AuthFailure("It's not possible to clean up the user"));
    }
  }
}
