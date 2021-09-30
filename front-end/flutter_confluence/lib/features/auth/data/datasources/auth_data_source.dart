import 'package:firebase_auth/firebase_auth.dart' as firebase;

import '/core/auth/auth_failures.dart';
import '/features/auth/domain/entities/user.dart';

abstract class AuthDataSource {
  Future<bool> checkLocalUserLogged();
  Future<User> signInWithEmailAndPassword(String email, String password);
  Future<void> logout();
}

class FirebaseAuthDataSourceImpl implements AuthDataSource {
  FirebaseAuthDataSourceImpl({required this.auth});

  final firebase.FirebaseAuth auth;

  @override
  Future<bool> checkLocalUserLogged() async {
    // Note: FlutterFire will handle automatically the persistence between app sessions,
    // so we only need to check if there is any current user
    // More info: https://firebase.flutter.dev/docs/auth/usage#persisting-authentication-state
    final isUserLogged = auth.currentUser != null;
    return Future.value(isUserLogged);
  }

  @override
  Future<User> signInWithEmailAndPassword(String email, String password) async {
    try {
      final credentials = await auth.signInWithEmailAndPassword(email: email, password: password);
      final firebaseUser = credentials.user;
      if (firebaseUser != null) {
        return User(
            uid: firebaseUser.uid,
            email: firebaseUser.email,
            displayName: firebaseUser.displayName,
            photoUrl: firebaseUser.photoURL);
      } else {
        throw AuthFailure('Is not possible to get the firebase user');
      }
    } on firebase.FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw InvalidEmailFailure();
      } else if (e.code == 'wrong-password') {
        throw InvalidPasswordFailure();
      } else {
        throw AuthFailure(e.code);
      }
    } catch (e) {
      throw AuthFailure('Unknown error: ${e.toString()}');
    }
  }

  @override
  Future<void> logout() async {
    await auth.signOut();
  }
}
