import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/on_boarding_repository.dart';

class CheckCachedAuthUseCase implements UseCase<bool, NoParams> {
  final OnBoardingRepository repository;

  CheckCachedAuthUseCase(this.repository);

  Future<Either<Failure, bool>> call(NoParams noParams) async {
    return await repository.checkCachedAuth();
  }

}
