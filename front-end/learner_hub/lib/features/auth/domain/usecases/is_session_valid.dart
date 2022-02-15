import 'package:dartz/dartz.dart';

import '/core/error/failures.dart';
import '/core/usecases/usecase.dart';
import '/features/auth/domain/repositories/auth_repository.dart';

class IsSessionValidUseCase implements UseCase<bool, NoParams> {
  IsSessionValidUseCase(this.repository);

  final AuthRepository repository;

  @override
  Future<Either<Failure, bool>> call(NoParams noParams) async {
    return repository.isValidSession();
  }
}
