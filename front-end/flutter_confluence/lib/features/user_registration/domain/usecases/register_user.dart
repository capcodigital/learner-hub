import 'package:dartz/dartz.dart';

import '/core/error/auth_failures.dart';
import '/core/error/failures.dart';
import '/features/user_registration/domain/entities/user_registration.dart';
import '/features/user_registration/domain/repositories/user_registration_repository.dart';

class RegisterUser {
  RegisterUser({required this.registrationRepository});

  final UserRegistrationRepository registrationRepository;

  Future<Either<Failure, bool>> execute(UserRegistration user) async {
    if (user.email == null || user.password == null) {
      return Left(AuthFailure('Email and password cannot be null'));
    }
    final registerFirebaseUserResult = await registrationRepository
        .registerFirebaseUser(user.email!, user.password!);
    return registerFirebaseUserResult.fold((failure) => Left(failure),
        (success) async {
      final createUserResult = await registrationRepository.createUser(user);
      return createUserResult.fold((failure) async {
        await _handleCreateUserFailure(failure);
        return Left(CreateUserError());
      }, (success) => Right(success));
    });
  }

  Future<void> _handleCreateUserFailure(Failure failure) async {
    // If creating the user in our custom backend fails,
    // then we need to clear all local firebase auth details in our app
    // so there are no conflicts
    await registrationRepository.cleanUpFirebaseUser();
  }
}
