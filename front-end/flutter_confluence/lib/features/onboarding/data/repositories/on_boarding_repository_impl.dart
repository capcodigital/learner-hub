import 'package:dartz/dartz.dart';

import '/core/auth/auth_failures.dart';
import '/core/error/failures.dart';
import '/features/onboarding/data/datasources/on_boarding_local_data_source.dart';
import '/features/onboarding/domain/repositories/on_boarding_repository.dart';

class OnBoardingRepositoryImpl implements OnBoardingRepository {
  OnBoardingRepositoryImpl({required this.onBoardingDataSource});

  final OnBoardingLocalDataSource onBoardingDataSource;

  @override
  Future<Either<Failure, bool>> checkCachedAuth() async {
    final result = await onBoardingDataSource.checkLocalUserLogged();
    return result ? const Right(true) : Left(NoCurrentUserLogged());
  }
}
