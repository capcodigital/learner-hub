import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart' as FlutterFire;
import 'package:flutter_confluence/core/auth/auth_manager.dart';
import 'package:flutter_confluence/core/auth/user.dart';
import 'package:flutter_confluence/core/error/failures.dart';

import 'auth_failures.dart';

class FirebaseAuthManager implements AuthManager {
  final FlutterFire.FirebaseAuth auth;

  FlutterFire.User? get _user {
    return this.auth.currentUser;
  }

  FirebaseAuthManager({required this.auth});

  @override
  Either<Failure, User> currentUser() {
    if (this._user == null) {
      return Left(AuthFailure("User is not logged in"));
    } else {
      return Right(this._user!.toAppUser());
    }
  }

  @override
  bool isUserLogged() {
    return this._user != null && !this._user!.isAnonymous;
  }

  @override
  Future<Either<Failure, User>> registerUser(String email, String password) async {
    try {
      var userCredential =
      await this.auth.createUserWithEmailAndPassword(email: email, password: password);
      if (userCredential.user == null) {
        return Left(AuthFailure("Is not possible to get the firebase user"));
      } else {
        var appUser = userCredential.user!.toAppUser();
        return Right(appUser);
      }
    } on FlutterFire.FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return Left(WeakPasswordFailure());
      } else if (e.code == 'email-already-in-use') {
        return Left(AlreadyRegisteredFailure());
      } else {
        return Left(AuthFailure("Error registering the user: ${e.code}"));
      }
    } catch (e) {
      return Left(AuthFailure("Unknown error: ${e.toString()}"));
    }
  }

  @override
  Future<Either<Failure, User>> loginUser(String email, String password) async {
    try {
      var userCredential =
      await this.auth.signInWithEmailAndPassword(email: email, password: password);

      if (userCredential.user != null) {
        return Right(userCredential.user!.toAppUser());
      } else {
        return Left(AuthFailure("Is not possible to get the firebase user"));
      }
    } on FlutterFire.FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return Left(InvalidEmailFailure());
      } else if (e.code == 'wrong-password') {
        return Left(InvalidPasswordFailure());
      } else {
        return Left(AuthFailure("Error registering the user: ${e.code}"));
      }
    } catch (e) {
      return Left(AuthFailure("Unknown error: ${e.toString()}"));
    }
  }

  @override
  Future<Either<Failure, String>> getUserAccessToken() async {
    try {
      if (this._user != null) {
        var token = await this._user!.getIdToken();
        return Right(token);
      } else {
        return Left(AuthFailure("User is not logged in"));
      }
    } catch (e) {
      return Left(AuthFailure("It's not possible to get the user token: ${e.toString()}"));
    }
  }

  @override
  Future<void> signOut() async {
    await this.auth.signOut();
  }
}