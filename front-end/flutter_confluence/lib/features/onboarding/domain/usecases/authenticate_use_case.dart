import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/on_boarding_repository.dart';

class AuthenticateUseCase //implements UseCase<bool, NoParams>
{
  final OnBoardingRepository repository;

  AuthenticateUseCase(this.repository);

  Future<Either<Failure, void>> call(NoParams noParams) async {
    return await repository.authenticate();
  }

}
