import 'package:dartz/dartz.dart';
import 'package:flutter_confluence/core/error/auth_failures.dart';

import '/core/error/failures.dart';
import '/core/usecases/usecase.dart';
import '/features/user_registration/domain/entities/user_registration.dart';
import '/features/user_registration/domain/repositories/user_registration_repository.dart';

class RegisterUserUseCase implements UseCase<bool, UserRegistration> {
  RegisterUserUseCase({required this.registrationRepository});

  final UserRegistrationRepository registrationRepository;

  @override
  Future<Either<Failure, bool>> call(UserRegistration user) async {
    if (user.email == null || user.password == null) {
      return Left(AuthFailure('Email and password cannot be null'));
    }
    final registerFirebaseUserResult = await registrationRepository.registerFirebaseUser(user.email!, user.password!);
    return registerFirebaseUserResult.fold(
        (failure) => Left(failure), (success) => registrationRepository.createUser(user));
  }
}
