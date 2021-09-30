import 'package:dartz/dartz.dart';

import '/core/error/auth_failures.dart';
import '/core/error/failures.dart';
import '/core/usecases/usecase.dart';
import '/features/auth/domain/repositories/auth_repository.dart';

class LogoutUseCase implements UseCase<bool, NoParams> {
  LogoutUseCase({required this.logoutRepository});

  final AuthRepository logoutRepository;

  @override
  Future<Either<Failure, bool>> call(NoParams parameters) async {
    try {
      await logoutRepository.logout();
      return const Right(true);
    } catch (ex) {
      return Left(AuthFailure('Is not possible to logout the user: $ex'));
    }
  }
}
