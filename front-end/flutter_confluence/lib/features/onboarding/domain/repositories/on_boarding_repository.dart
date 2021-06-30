import 'package:dartz/dartz.dart';
import 'package:flutter_confluence/core/error/failures.dart';

abstract class OnBoardingRepository {

  Future<Either<Failure, void>> authenticate();
}
