import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthDataSource {
  Future<bool> checkLocalUserLogged();
  Future<void> logout();
}

class FirebaseAuthDataSourceImpl implements AuthDataSource {
  FirebaseAuthDataSourceImpl({required this.auth});

  final FirebaseAuth auth;

  @override
  Future<void> logout() async {
    await auth.signOut();
  }

  @override
  Future<bool> checkLocalUserLogged() async {
    // Note: FlutterFire will handle automatically the persistence between app sessions,
    // so we only need to check if there is any current user
    // More info: https://firebase.flutter.dev/docs/auth/usage#persisting-authentication-state
    final isUserLogged = auth.currentUser != null;
    return Future.value(isUserLogged);
  }
}
