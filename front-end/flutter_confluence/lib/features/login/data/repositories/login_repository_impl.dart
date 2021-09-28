import 'package:dartz/dartz.dart';

import '/core/error/failures.dart';
import '/features/login/data/datasource/login_data_source.dart';
import '/features/login/data/models/user_model.dart';
import '/features/login/domain/entities/user.dart';
import '/features/login/domain/repositories/login_repository.dart';

class LoginRepositoryImpl implements LoginRepository {
  LoginRepositoryImpl({required this.dataSource});

  // We don't have a local/remote sources, as they are both handled by the
  // firebase auth library
  final LoginDataSource dataSource;

  @override
  Future<Either<Failure, User>> loginUser(String email, String password) async {
    final result = await dataSource.signInWithEmailAndPassword(email, password);
    return result.fold(
        (failure) => Left(failure),
        (firebaseUser) => Right(UserModel(
            uid: firebaseUser.uid,
            displayName: firebaseUser.displayName,
            email: firebaseUser.email,
            photoUrl: firebaseUser.photoURL)));
  }
}
