import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/on_boarding_repository.dart';

class CheckAuthUseCase implements UseCase<bool, NoParams> {
  final OnBoardingRepository repository;

  CheckAuthUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(NoParams noParams) async {
    return await repository.checkCachedAuth();
  }

}
