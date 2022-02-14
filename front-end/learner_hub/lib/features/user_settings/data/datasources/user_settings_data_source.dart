import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

import '/core/constants.dart';
import '/core/error/auth_failures.dart';
import '/core/error/custom_exceptions.dart';
import '/core/error/failures.dart';
import '/features/user_settings/data/model/user_model.dart';

abstract class UserSettingsDataSource {
  Future updateUserSettings(UserModel user);

  Future updatePassword(String oldPassword, String newPassword);

  Future<UserModel> loadUserInfo();
}

class UserSettingsDataSourceImpl implements UserSettingsDataSource {
  UserSettingsDataSourceImpl({required this.auth, required this.client});

  final FirebaseAuth auth;
  final http.Client client;

  @override
  Future updateUserSettings(UserModel user) async {
    try {
      const url = '${Constants.BASE_API_URL}/user';

      final token = await auth.currentUser?.getIdToken();

      final response = await client.put(Uri.parse(url),
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $token',
            HttpHeaders.contentTypeHeader: 'application/json'
          },
          body: jsonEncode(user));

      if (response.statusCode == HttpStatus.ok) {
        return true;
      } else {
        throw ServerFailure(message: 'Status code: ${response.statusCode}');
      }
    } catch (exception) {
      print(exception.toString());
      throw ServerException(message: Constants.SERVER_FAILURE_MSG);
    }
  }

  @override
  Future updatePassword(String oldPassword, String newPassword) async {
    final currentUser = auth.currentUser;
    if (currentUser == null) {
      throw ServerException(message: 'There is no current logged in user');
    } else {
      final email = currentUser.email;
      if (email == null || email.isEmpty) {
        throw Exception('Invalid email');
      }

      try {
        final credentials = EmailAuthProvider.credential(email: email, password: oldPassword);
        await currentUser.reauthenticateWithCredential(credentials);
        await currentUser.updatePassword(newPassword);
      } on FirebaseAuthException catch (e) {
        throw AuthFailure(e.code);
      } catch (exception) {
        print(exception.toString());
        throw ServerException(message: Constants.SERVER_FAILURE_MSG);
      }
    }
  }

  @override
  Future<UserModel> loadUserInfo() async {
    try {
      const url = '${Constants.BASE_API_URL}/user';

      final token = await auth.currentUser?.getIdToken();

      final response = await client.get(
        Uri.parse(url),
        headers: {HttpHeaders.authorizationHeader: 'Bearer $token', HttpHeaders.contentTypeHeader: 'application/json'},
      );

      if (response.statusCode == HttpStatus.ok) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        final responseStatus = json['status'];
        if (responseStatus == 'success') {
          final Map<String, dynamic> data = json['data'];
          return UserModel.fromJson(data);
        } else {
          throw ServerException(message: 'Response status: $responseStatus');
        }
      } else {
        throw ServerException(message: 'Status code: ${response.statusCode}');
      }
    } catch (exception) {
      print(exception.toString());
      throw ServerException(message: Constants.SERVER_FAILURE_MSG);
    }
  }
}
