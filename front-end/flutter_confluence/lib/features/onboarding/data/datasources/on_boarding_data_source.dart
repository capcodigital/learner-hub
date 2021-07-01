import 'package:local_auth/local_auth.dart';

abstract class OnBoardingDataSource {
  Future<bool> authenticate();
  Future<void> saveAuthTimeStamp();
  Future<bool> checkAuthTimeStamp();
}

class OnBoardingDataSourceImpl extends OnBoardingDataSource {
  final LocalAuthentication auth;

  OnBoardingDataSourceImpl({required this.auth});

  @override
  Future<bool> authenticate() async {
    return await auth.authenticate(
        localizedReason: 'Please authenticate to proceed',
        biometricOnly: true);
  }

  @override
  Future<bool> checkAuthTimeStamp() {
    // TODO: implement checkAuthTimeStamp
    throw UnimplementedError();
  }

  @override
  Future<void> saveAuthTimeStamp() {
    // TODO: implement saveAuthTimeStamp
    throw UnimplementedError();
  }
}
