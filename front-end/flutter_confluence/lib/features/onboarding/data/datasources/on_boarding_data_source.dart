import 'package:local_auth/local_auth.dart';

abstract class OnBoardingDataSource {
  void authenticate();
}

class OnBoardingDataSourceImpl extends OnBoardingDataSource {
  final LocalAuthentication auth;

  OnBoardingDataSourceImpl({required this.auth});

  @override
  void authenticate() async {
    var localAuth = LocalAuthentication();
    bool didAuthenticate =
        await localAuth.authenticate(
        localizedReason: 'Please authenticate to show account balance',
        biometricOnly: true);
  }

}