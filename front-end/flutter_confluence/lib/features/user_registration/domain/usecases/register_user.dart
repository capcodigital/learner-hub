import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '/core/error/failures.dart';
import '/core/usecases/usecase.dart';
import '/features/user_registration/domain/entities/user_registration.dart';
import '/features/user_registration/domain/repositories/user_registration_repository.dart';

class RegisterParams extends Equatable {
  const RegisterParams({
    required this.name,
    required this.lastName,
    required this.jobTitle,
    required this.primarySkills,
    required this.secondarySkills,
    required this.bio,
    required this.email,
    required this.password,
  });

  final String name;
  final String lastName;
  final String jobTitle;
  final List<String> primarySkills;
  final List<String> secondarySkills;
  final String bio;
  final String email;
  final String password;

  @override
  List<Object> get props => [
        name,
        lastName,
        jobTitle,
        primarySkills,
        secondarySkills,
        bio,
        email,
        password
      ];
}

class RegisterUser implements UseCase<bool, RegisterParams> {
  RegisterUser({required this.registrationRepository});

  final UserRegistrationRepository registrationRepository;

  @override
  Future<Either<Failure, bool>> call(RegisterParams parameters) async {
    final newUser = UserRegistration(
        name: parameters.name,
        lastName: parameters.lastName,
        jobTitle: parameters.jobTitle,
        primarySkills: parameters.primarySkills,
        secondarySkills: parameters.secondarySkills,
        bio: parameters.bio,
        email: parameters.email,
        password: parameters.password);

    final registerFirebaseUserResult =
        await registrationRepository.registerFirebaseUser(newUser);
    return registerFirebaseUserResult.fold((failure) => Left(failure),
        (success) => registrationRepository.createUser(newUser));
  }
}
