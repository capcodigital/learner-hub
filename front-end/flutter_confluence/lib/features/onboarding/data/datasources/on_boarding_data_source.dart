import 'package:dartz/dartz.dart';
import 'package:flutter_confluence/core/error/failures.dart';
import 'package:local_auth/local_auth.dart';

abstract class OnBoardingDataSource {
  Future<bool> authenticate();
}

class OnBoardingDataSourceImpl extends OnBoardingDataSource {
  final LocalAuthentication auth;

  OnBoardingDataSourceImpl({required this.auth});

  @override
  Future<bool> authenticate() async {
    return await auth.authenticate(
        localizedReason: 'Please authenticate to show account balance',
        biometricOnly: true);
  }
}
