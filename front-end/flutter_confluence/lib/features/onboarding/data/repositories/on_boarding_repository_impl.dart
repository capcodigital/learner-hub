import 'package:dartz/dartz.dart';
import 'package:flutter_confluence/core/error/failures.dart';

import '../datasources/on_boarding_data_source.dart';
import '../../domain/repositories/on_boarding_repository.dart';

class OnBoardingRepositoryImpl extends OnBoardingRepository {
  final OnBoardingDataSource onBoardingDataSource;

  OnBoardingRepositoryImpl({required this.onBoardingDataSource});

  @override
  Future<Either<Failure, void>> authenticate() async {
    final result = await onBoardingDataSource.authenticate();
    if (result) return Right(null);
    else return Left(AuthFailure());
  }
}
