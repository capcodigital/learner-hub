import 'package:dartz/dartz.dart';

import '/core/constants.dart';
import '/core/error/auth_failures.dart';
import '/features/auth/data/datasources/auth_data_source.dart';
import '/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({required this.authDataSource});

  final AuthDataSource authDataSource;

  @override
  Future<Either<AuthFailure, bool>> isValidSession() async {
    final result = await authDataSource.checkLocalUserLogged();
    return result ? const Right(true) : Left(NoCurrentUserLogged());
  }

  @override
  Future<Either<AuthFailure, bool>> loginUser(String email, String password) async {
    try {
      final user = await authDataSource.signInWithEmailAndPassword(email, password);
      return Right(user != null);
    } on AuthFailure catch (failure) {
      return Left(failure);
    } catch (ex) {
      return Left(AuthFailure('${Constants.UNKNOWN_ERROR}: $ex'));
    }
  }

  @override
  Future<void> logout() async {
    await authDataSource.logout();
  }
}
