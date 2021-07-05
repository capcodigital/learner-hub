import 'package:flutter_confluence/core/time/time_info.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class OnBoardingLocalDataSource {
  Future<bool> authenticate();
  Future<void> saveAuthTimeStamp();
  Future<bool> checkCachedAuth();
  Future<void> clearCachedAuth();
}

const PREF_LAST_BIOMETRIC_AUTH_TIME_MILLIS = "last_biometric_auth_time_millis";
const ONE_DAY_MILLIS = 24 * 60 * 60 * 1000;
const AUTH_REASON = 'Please authenticate to proceed';
const BIOMETRIC_AUTH_ONLY = true;

class OnBoardingLocalDataSourceImpl extends OnBoardingLocalDataSource {
  final LocalAuthentication auth;
  final SharedPreferences prefs;
  final TimeInfo timeInfo;

  OnBoardingLocalDataSourceImpl({
    required this.auth,
    required this.prefs,
    required this.timeInfo});

  @override
  Future<bool> authenticate() async {
    return await auth.authenticate(
          localizedReason: AUTH_REASON,
          biometricOnly: BIOMETRIC_AUTH_ONLY);
  }

  @override
  Future<void> saveAuthTimeStamp() {
    return prefs.setInt(
        PREF_LAST_BIOMETRIC_AUTH_TIME_MILLIS, timeInfo.currentTimeMillis);
  }

  @override
  Future<bool> checkCachedAuth() {
    bool isAuth = false;
    int? lastAuthTime = prefs.getInt(PREF_LAST_BIOMETRIC_AUTH_TIME_MILLIS);
    if (lastAuthTime != null) {
      isAuth = timeInfo.currentTimeMillis - lastAuthTime <= ONE_DAY_MILLIS;
    }
    return Future.value(isAuth);
  }

  @override
  Future<void> clearCachedAuth() {
    return prefs.remove(PREF_LAST_BIOMETRIC_AUTH_TIME_MILLIS);
  }
}
