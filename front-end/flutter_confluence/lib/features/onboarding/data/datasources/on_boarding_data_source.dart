import 'package:local_auth/local_auth.dart';

abstract class OnBoardingDataSource {
  Future authenticate();
}

class OnBoardingDataSourceImpl extends OnBoardingDataSource {
  final LocalAuthentication auth;

  OnBoardingDataSourceImpl({required this.auth});

  @override
  Future authenticate() {
    return Future.value();
  }
}