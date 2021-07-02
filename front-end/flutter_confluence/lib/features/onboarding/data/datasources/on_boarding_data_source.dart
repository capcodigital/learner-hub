import 'dart:math';

import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class OnBoardingDataSource {
  Future<bool> authenticate();
  Future<void> saveAuthTimeStamp();
  Future<bool> checkCachedAuth();
  Future<void> clearCachedAuth();
}

const prefLastBiometricAuthTimeMillis = "last_biometric_auth_time_millis";
const oneDayMillis = 24 * 60 * 60 * 1000;
const authReason = 'Please authenticate to proceed';
const biometricAuthOnly = true;

class OnBoardingDataSourceImpl extends OnBoardingDataSource {
  final LocalAuthentication auth;
  final SharedPreferences prefs;

  OnBoardingDataSourceImpl({required this.auth, required this.prefs});

  @override
  Future<bool> authenticate() async {
    return await auth.authenticate(
          localizedReason: authReason,
          biometricOnly: biometricAuthOnly);
  }

  @override
  Future<void> saveAuthTimeStamp() {
    return prefs.setInt(
        prefLastBiometricAuthTimeMillis, DateTime.now().millisecond);
  }

  @override
  Future<bool> checkCachedAuth() {
    bool isAuth = false;
    int? lastAuthTime = prefs.getInt(prefLastBiometricAuthTimeMillis);
    if (lastAuthTime != null) {
      isAuth = DateTime.now().millisecond - lastAuthTime < oneDayMillis;
    }
    return Future.value(isAuth);
  }

  @override
  Future<void> clearCachedAuth() {
    return prefs.remove(prefLastBiometricAuthTimeMillis);
  }
}
