import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '/core/auth/auth_failures.dart';
import '/core/error/failures.dart';

abstract class RegisterUserDataSource {
  Future<Either<Failure, User>> registerUser(String email, String password);
}

class RegisterUserDataSourceImpl implements RegisterUserDataSource {
  RegisterUserDataSourceImpl({required this.auth});

  final FirebaseAuth auth;

  @override
  Future<Either<Failure, User>> registerUser(String email, String password) async {
    try {
      final userCredential = await auth.createUserWithEmailAndPassword(email: email, password: password);
      if (userCredential.user == null) {
        return Left(AuthFailure('Is not possible to get the firebase user'));
      } else {
        final appUser = userCredential.user;
        if (appUser == null) {
          return Left(AuthFailure("It's not possible to get the user"));
        } else {
          return Right(appUser);
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return Left(WeakPasswordFailure());
      } else if (e.code == 'email-already-in-use') {
        return Left(AlreadyRegisteredFailure());
      } else {
        return Left(AuthFailure('Error registering the user: ${e.code}'));
      }
    } catch (e) {
      return Left(AuthFailure('Unknown error: ${e.toString()}'));
    }
  }
}
