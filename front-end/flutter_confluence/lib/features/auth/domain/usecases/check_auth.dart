import 'package:dartz/dartz.dart';

import '/core/error/failures.dart';
import '/core/usecases/usecase.dart';
import '/features/auth/domain/repositories/auth_repository.dart';

class CheckAuthUseCase implements UseCase<bool, NoParams> {
  CheckAuthUseCase(this.repository);

  final AuthRepository repository;

  @override
  Future<Either<Failure, bool>> call(NoParams noParams) async {
    return repository.checkCachedAuth();
  }
}
