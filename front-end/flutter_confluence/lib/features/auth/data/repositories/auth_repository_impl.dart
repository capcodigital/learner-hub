import 'package:dartz/dartz.dart';

import '/core/auth/auth_failures.dart';
import '/features/auth/data/datasources/auth_data_source.dart';
import '/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({required this.authDataSource});

  final AuthDataSource authDataSource;

  @override
  Future<void> logout() async {
    await authDataSource.logout();
  }

  @override
  Future<Either<AuthFailure, bool>> checkCachedAuth() async {
    final result = await authDataSource.checkLocalUserLogged();
    return result ? const Right(true) : Left(NoCurrentUserLogged());
  }
}
