import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/on_boarding_repository.dart';

class Authenticate implements UseCase<void, NoParams> {
  final OnBoardingRepository repository;

  Authenticate(this.repository);

  Future<Either<Failure, Type>> call(NoParams noParams) {
    //return Future.value(repository.authenticate());
    return Future.value();
  }
}
