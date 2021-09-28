import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '/core/auth/auth_failures.dart';
import '/core/error/failures.dart';

abstract class LoginDataSource {
  Future<Either<Failure, User>> signInWithEmailAndPassword(String email, String password);
}

class LoginDataSourceImpl implements LoginDataSource {
  LoginDataSourceImpl({required this.auth});

  final FirebaseAuth auth;

  @override
  Future<Either<Failure, User>> signInWithEmailAndPassword(String email, String password) async {
    try {
      final credentials = await auth.signInWithEmailAndPassword(email: email, password: password);
      if (credentials.user != null) {
        return Right(credentials.user!);
      } else {
        return Left(AuthFailure('Is not possible to get the firebase user'));
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return Left(InvalidEmailFailure());
      } else if (e.code == 'wrong-password') {
        return Left(InvalidPasswordFailure());
      } else {
        return Left(AuthFailure('Error registering the user: ${e.code}'));
      }
    } catch (e) {
      return Left(AuthFailure('Unknown error: ${e.toString()}'));
    }
  }
}
