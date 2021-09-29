import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flutter/foundation.dart' as foundation;

import '/core/auth/auth_failures.dart';
import '/core/error/failures.dart';
import '/core/usecases/usecase.dart';
import '/features/login/domain/entities/user.dart';
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
  List<Object> get props => [name, lastName, jobTitle, primarySkills, secondarySkills, bio, email, password];
}

class RegisterUserUseCase implements UseCase<User, RegisterParams> {
  RegisterUserUseCase({required this.registrationRepository});

  final UserRegistrationRepository registrationRepository;

  @override
  Future<Either<Failure, User>> call(RegisterParams parameters) async {
    final newUser = UserRegistration(
        name: parameters.name,
        lastName: parameters.lastName,
        jobTitle: parameters.jobTitle,
        primarySkills: parameters.primarySkills,
        secondarySkills: parameters.secondarySkills,
        bio: parameters.bio,
        email: parameters.email,
        password: parameters.password);
    final firebaseUser = await registrationRepository.registerUser(newUser);


    if (foundation.kDebugMode) {
      // TODO(cgal-capco): Remember to delete this code before mergin into development
      // Only useful during registration flow
      final firebaseToken = await getUserAccessToken();
      print('FIREBASE TOKEN: $firebaseToken');
    }

    return firebaseUser;
  }

  Future<String> getUserAccessToken() async {
    try {
      final user = firebase.FirebaseAuth.instance.currentUser;
      if (user != null) {
        final token = await user.getIdToken();
        return token;
      } else {
        throw AuthFailure('User is not logged in');
      }
    } catch (e) {
      throw AuthFailure("It's not possible to get the user token: ${e.toString()}");
    }
  }
}
