import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/on_boarding_repository.dart';

class AuthUseCase implements UseCase<bool, NoParams> {
  final OnBoardingRepository repository;

  AuthUseCase(this.repository);

  Future<Either<Failure, bool>> call(NoParams noParams) async {
    return await repository.authenticate();
  }

}
