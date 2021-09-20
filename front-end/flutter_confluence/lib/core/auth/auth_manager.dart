import 'package:dartz/dartz.dart';
import 'package:flutter_confluence/core/auth/user.dart';
import 'package:flutter_confluence/core/error/failures.dart';

abstract class AuthManager {
  bool isUserLogged();

  Either<Failure, User> currentUser();

  Future<Either<Failure, User>> registerUser(String email, String password);

  Future<Either<Failure, User>> loginUser(String email, String password);

  Future<Either<Failure, String>> getUserAccessToken();

  Future<void> signOut();
}
