import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_confluence/core/error/custom_exceptions.dart';
import 'package:flutter_confluence/core/error/failures.dart';
import 'package:http/http.dart' as http;

import '/core/constants.dart';
import '/features/user_settings/data/model/user_model.dart';

abstract class UserSettingsDataSource {
  Future updateUserSettings(UserModel user);
  Future updatePassword(String password);
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
          body: user.toJson());

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
  Future updatePassword(String password) async {
    final currentUser = auth.currentUser;
    if (currentUser == null) {
      throw Exception('There is no current logged in user');
    } else {
      await currentUser.updatePassword(password);
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
        return UserModel.fromJson(jsonDecode(response.body));
      } else {
        throw ServerFailure(message: 'Status code: ${response.statusCode}');
      }
    } catch (exception) {
      print(exception.toString());
      throw ServerException(message: Constants.SERVER_FAILURE_MSG);
    }
  }
}
