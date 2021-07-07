import 'package:flutter_confluence/core/utils/date_extensions.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class OnBoardingLocalDataSource {
  Future<bool> authenticate();
  Future<void> saveAuthTimeStamp();
  Future<bool> checkCachedAuth();
}

const PREF_LAST_BIOMETRIC_AUTH_TIME_MILLIS = "last_biometric_auth_time_millis";
const AUTH_REASON = 'Please authenticate to proceed';
const BIOMETRIC_AUTH_ONLY = true;
const STICKY_AUTH = true;
const USE_ERROR_DIALOGS = false;

class OnBoardingLocalDataSourceImpl extends OnBoardingLocalDataSource {
  final LocalAuthentication auth;
  final SharedPreferences prefs;

  OnBoardingLocalDataSourceImpl({required this.auth, required this.prefs});

  @override
  Future<bool> authenticate() async {
    return await auth.authenticate(
        localizedReason: AUTH_REASON,
        biometricOnly: BIOMETRIC_AUTH_ONLY,
        stickyAuth: STICKY_AUTH,
        useErrorDialogs: USE_ERROR_DIALOGS);
  }

  @override
  Future<void> saveAuthTimeStamp() {
    return prefs.setInt(PREF_LAST_BIOMETRIC_AUTH_TIME_MILLIS,
        CustomizableDateTime.current.millisecondsSinceEpoch);
  }

  @override
  Future<bool> checkCachedAuth() {
    int? lastAuthTime = prefs.getInt(PREF_LAST_BIOMETRIC_AUTH_TIME_MILLIS);
    if (lastAuthTime != null) {
      final now = CustomizableDateTime.current;
      final lastAuthDate = DateTime.fromMillisecondsSinceEpoch(lastAuthTime);
      final int daysDiff = now.difference(lastAuthDate).inDays;
      return Future.value(daysDiff <= 1);
    }
    return Future.value(false);
  }
}