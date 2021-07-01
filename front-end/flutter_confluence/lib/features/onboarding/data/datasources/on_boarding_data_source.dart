import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class OnBoardingDataSource {
  Future<bool> authenticate();
  Future<void> saveAuthTimeStamp();
  Future<bool> checkAuthTimeStamp();
  Future<void> clearAuthTimeStamp();
}

const PREF_LAST_BIOMETRIC_AUTH_TIME = "last_biometric_auth_time";

class OnBoardingDataSourceImpl extends OnBoardingDataSource {
  final LocalAuthentication auth;
  final SharedPreferences prefs;

  OnBoardingDataSourceImpl({required this.auth, required this.prefs});

  @override
  Future<bool> authenticate() async {
    return await auth.authenticate(
        localizedReason: 'Please authenticate to proceed', biometricOnly: true);
  }

  @override
  Future<void> saveAuthTimeStamp() {
    return prefs.setInt(
        PREF_LAST_BIOMETRIC_AUTH_TIME, DateTime.now().millisecond);
  }

  @override
  Future<bool> checkAuthTimeStamp() {
    bool isAuthenticated = false;
    int? lastAuthTime = prefs.getInt(PREF_LAST_BIOMETRIC_AUTH_TIME);
    if (lastAuthTime != null) {
      isAuthenticated = DateTime.now().hour -
              DateTime.fromMillisecondsSinceEpoch(lastAuthTime).hour < 24;
    }
    return Future.value(isAuthenticated);
  }

  @override
  Future<void> clearAuthTimeStamp() {
    return prefs.remove(PREF_LAST_BIOMETRIC_AUTH_TIME);
  }
}
