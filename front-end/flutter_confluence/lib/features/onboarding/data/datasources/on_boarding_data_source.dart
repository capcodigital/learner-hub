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

const PREF_LAST_BIOMETRIC_AUTH_TIME_MILLIS = "last_biometric_auth_time_millis";
const ONE_DAY_IN_MILLIS = 24 * 60 * 60 * 1000;

class OnBoardingDataSourceImpl extends OnBoardingDataSource {
  final LocalAuthentication auth;
  final SharedPreferences prefs;

  OnBoardingDataSourceImpl({required this.auth, required this.prefs});

  @override
  Future<bool> authenticate() async {
    try {
      return await auth.authenticate(
          localizedReason: 'Please authenticate to proceed',
          biometricOnly: true);
    } on PlatformException catch (e) {
      throw e;
    }
  }

  @override
  Future<void> saveAuthTimeStamp() {
    return prefs.setInt(
        PREF_LAST_BIOMETRIC_AUTH_TIME_MILLIS, DateTime.now().millisecond);
  }

  @override
  Future<bool> checkCachedAuth() {
    bool isAuth = false;
    int? lastAuthTime = prefs.getInt(PREF_LAST_BIOMETRIC_AUTH_TIME_MILLIS);
    if (lastAuthTime != null) {
      isAuth = DateTime.now().millisecond - lastAuthTime < ONE_DAY_IN_MILLIS;
    }
    return Future.value(isAuth);
  }

  @override
  Future<void> clearCachedAuth() {
    return prefs.remove(PREF_LAST_BIOMETRIC_AUTH_TIME_MILLIS);
  }
}
