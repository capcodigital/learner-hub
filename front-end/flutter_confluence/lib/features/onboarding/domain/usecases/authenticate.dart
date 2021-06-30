import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/on_boarding_repository.dart';

class Authenticate //implements UseCase<bool, NoParams>
{
  final OnBoardingRepository repository;

  Authenticate(this.repository);

  Future<Either<Failure, void>> call(NoParams noParams) async {
    return await repository.authenticate();
  }

}
