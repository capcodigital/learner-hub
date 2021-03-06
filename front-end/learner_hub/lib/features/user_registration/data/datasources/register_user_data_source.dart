import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

import '/core/constants.dart';
import '/core/error/auth_failures.dart';
import '/core/error/custom_exceptions.dart';
import '/features/user_registration/data/models/user_registration_model.dart';

abstract class RegisterUserDataSource {
  Future<User> registerFirebaseUser(String email, String password);
  Future<bool> createUser(UserRegistrationModel userRequest);
  Future<void> cleanUpFailedUser();
}

class RegisterUserDataSourceImpl implements RegisterUserDataSource {
  RegisterUserDataSourceImpl({required this.auth, required this.client});

  final FirebaseAuth auth;
  final http.Client client;

  @override
  Future<User> registerFirebaseUser(String email, String password) async {
    if (email == null || password == null) {
      throw const AuthFailure('Email and password cannot be null');
    }
    try {
      final userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (userCredential.user == null) {
        throw const AuthFailure('Is not possible to get the firebase user');
      } else {
        final appUser = userCredential.user;
        if (appUser == null) {
          throw const AuthFailure("It's not possible to get the user");
        } else {
          return appUser;
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw const WeakPasswordFailure();
      } else if (e.code == 'email-already-in-use') {
        throw const AlreadyRegisteredFailure();
      } else {
        throw AuthFailure('Error registering the user: ${e.code}');
      }
    } catch (e) {
      throw AuthFailure('Unknown error: ${e.toString()}');
    }
  }

  @override
  Future<bool> createUser(UserRegistrationModel userRequest) async {
    try {
      const url = '${Constants.BASE_API_URL}/user';

      final token = await auth.currentUser?.getIdToken();

      final body = jsonEncode(userRequest);

      final response = await client.post(Uri.parse(url),
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $token',
            HttpHeaders.contentTypeHeader: 'application/json'
          },
          body: body);

      if (response.statusCode == HttpStatus.created) {
        return true;
      } else {
        throw AuthFailure('Status code: ${response.statusCode}');
      }
    } catch (exception) {
      print(exception.toString());
      throw ServerException(message: Constants.SERVER_FAILURE_MSG);
    }
  }

  @override
  Future<void> cleanUpFailedUser() async {
    // Delete the user from Firebase, so the user can register again later
    // Otherwise, the user will get an "EmailAlreadyRegistered" error
    await auth.currentUser?.delete();
    await auth.signOut();
  }
}
