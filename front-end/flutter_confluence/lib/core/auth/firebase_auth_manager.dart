// import 'package:dartz/dartz.dart';
// import 'package:firebase_auth/firebase_auth.dart' as flutterfire;
// import 'package:flutter_confluence/core/auth/auth_manager.dart';
// import 'package:flutter_confluence/core/auth/user.dart';
// import 'package:flutter_confluence/core/error/failures.dart';
//
// import 'auth_failures.dart';
//
// class FirebaseAuthManager implements AuthManager {
//   FirebaseAuthManager({required this.auth});
//
//   final flutterfire.FirebaseAuth auth;
//
//   flutterfire.User? get _user {
//     return auth.currentUser;
//   }
//
//   @override
//   Either<Failure, User> currentUser() {
//     if (_user == null) {
//       return Left(AuthFailure('User is not logged in'));
//     } else {
//       return Right(_user!.toAppUser());
//     }
//   }
//
//   @override
//   bool isUserLogged() {
//     return _user != null && !_user!.isAnonymous;
//   }
//
//   @override
//   Future<Either<Failure, User>> registerUser(String email, String password) async {
//     try {
//       final userCredential = await auth.createUserWithEmailAndPassword(email: email, password: password);
//       if (userCredential.user == null) {
//         return Left(AuthFailure('Is not possible to get the firebase user'));
//       } else {
//         final appUser = userCredential.user!.toAppUser();
//         return Right(appUser);
//       }
//     } on flutterfire.FirebaseAuthException catch (e) {
//       if (e.code == 'weak-password') {
//         return Left(WeakPasswordFailure());
//       } else if (e.code == 'email-already-in-use') {
//         return Left(AlreadyRegisteredFailure());
//       } else {
//         return Left(AuthFailure('Error registering the user: ${e.code}'));
//       }
//     } catch (e) {
//       return Left(AuthFailure('Unknown error: ${e.toString()}'));
//     }
//   }
//
//   @override
//   Future<Either<Failure, User>> loginUser(String email, String password) async {
//     try {
//       final userCredential = await auth.signInWithEmailAndPassword(email: email, password: password);
//
//       if (userCredential.user != null) {
//         return Right(userCredential.user!.toAppUser());
//       } else {
//         return Left(AuthFailure('Is not possible to get the firebase user'));
//       }
//     } on flutterfire.FirebaseAuthException catch (e) {
//       if (e.code == 'user-not-found') {
//         return Left(InvalidEmailFailure());
//       } else if (e.code == 'wrong-password') {
//         return Left(InvalidPasswordFailure());
//       } else {
//         return Left(AuthFailure('Error registering the user: ${e.code}'));
//       }
//     } catch (e) {
//       return Left(AuthFailure('Unknown error: ${e.toString()}'));
//     }
//   }
//
//   @override
//   Future<Either<Failure, String>> getUserAccessToken() async {
//     try {
//       if (_user != null) {
//         final token = await _user!.getIdToken();
//         return Right(token);
//       } else {
//         return Left(AuthFailure('User is not logged in'));
//       }
//     } catch (e) {
//       return Left(AuthFailure("It's not possible to get the user token: ${e.toString()}"));
//     }
//   }
//
//   @override
//   Future<void> signOut() async {
//     await auth.signOut();
//   }
// }
