import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';

abstract class OnBoardingRepository {

  Future<Either<Failure, bool>> authenticate();
}
