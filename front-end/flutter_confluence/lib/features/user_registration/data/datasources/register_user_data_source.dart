import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

import '/core/auth/auth_failures.dart';
import '/core/error/failures.dart';
import '/features/user_registration/data/models/user_registration_model.dart';

abstract class RegisterUserDataSource {
  Future<Either<Failure, User>> registerFirebaseUser(String email, String password);

  Future<bool> createUser(UserRegistrationModel userRequest);
}

class RegisterUserDataSourceImpl implements RegisterUserDataSource {
  RegisterUserDataSourceImpl({required this.auth, required this.client});

  final FirebaseAuth auth;
  final http.Client client;

  @override
  Future<Either<Failure, User>> registerFirebaseUser(String email, String password) async {
    try {
      final userCredential = await auth.createUserWithEmailAndPassword(email: email, password: password);
      if (userCredential.user == null) {
        return Left(AuthFailure('Is not possible to get the firebase user'));
      } else {
        final appUser = userCredential.user;
        if (appUser == null) {
          return Left(AuthFailure("It's not possible to get the user"));
        } else {
          return Right(appUser);
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return Left(WeakPasswordFailure());
      } else if (e.code == 'email-already-in-use') {
        return Left(AlreadyRegisteredFailure());
      } else {
        return Left(AuthFailure('Error registering the user: ${e.code}'));
      }
    } catch (e) {
      return Left(AuthFailure('Unknown error: ${e.toString()}'));
    }
  }

  @override
  Future<bool> createUser(UserRegistrationModel userRequest) async {
    try {
      // TODO(cgal-capco): Move this base url to a constant
      const baseUrl = 'http://localhost:5001/io-capco-flutter-dev/europe-west2/app';
      const url = '$baseUrl/user';

      final token = await auth.currentUser?.getIdToken();

      final response = await client.post(Uri.parse(url), headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token'
      }, body: {
        'email': userRequest.email,
        'name': userRequest.name,
        'lastName': userRequest.lastName,
        'jobTitle': userRequest.jobTitle,
        'bio': userRequest.bio,
      });

      if (response.statusCode == HttpStatus.created) {
        return true;
      } else {
        // TODO(cgal-capco): Handle other status codes better
        return false;
      }
    } on Exception catch (exception) {
      print(exception.toString());
      // throw ServerException(message: Constants.SERVER_FAILURE_MSG);
      rethrow;
    }
  }
}
