import 'package:connectivity_plus/connectivity_plus.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  NetworkInfoImpl(this.connectionChecker);
  final Connectivity connectionChecker;

  @override
  Future<bool> get isConnected async {
    final result = await connectionChecker.checkConnectivity();
    switch (result) {
      case ConnectivityResult.wifi:
        return true;
      case ConnectivityResult.mobile:
        return true;
      case ConnectivityResult.ethernet:
        return true;
      case ConnectivityResult.bluetooth:
        return true;
      case ConnectivityResult.none:
        return false;
    }
  }
}
