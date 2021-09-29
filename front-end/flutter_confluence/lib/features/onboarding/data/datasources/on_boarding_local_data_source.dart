import 'package:firebase_auth/firebase_auth.dart';

abstract class OnBoardingLocalDataSource {
  Future<bool> checkLocalUserLogged();
}

class OnBoardingLocalDataSourceImpl implements OnBoardingLocalDataSource {
  OnBoardingLocalDataSourceImpl({required this.auth});

  final FirebaseAuth auth;

  @override
  Future<bool> checkLocalUserLogged() async {
    // Note: FlutterFire will handle automatically the persistence between app sessions,
    // so we only need to check if there is any current user
    // More info: https://firebase.flutter.dev/docs/auth/usage#persisting-authentication-state
    final isUserLogged = auth.currentUser != null;
    return Future.value(isUserLogged);
  }
}
