import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/on_boarding_repository.dart';

class AuthUseCase implements UseCase<bool, NoParams> {
  AuthUseCase(this.repository);
  final OnBoardingRepository repository;

  @override
  Future<Either<Failure, bool>> call(NoParams noParams) async {
    return repository.authenticate();
  }
}
