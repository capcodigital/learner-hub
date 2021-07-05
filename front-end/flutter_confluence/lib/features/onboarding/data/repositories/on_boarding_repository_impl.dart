import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';

import '../../../../core/error/failures.dart';
import '../datasources/on_boarding_data_source.dart';
import '../../domain/repositories/on_boarding_repository.dart';

class OnBoardingRepositoryImpl extends OnBoardingRepository {
  final OnBoardingDataSource onBoardingDataSource;

  OnBoardingRepositoryImpl({required this.onBoardingDataSource});

  @override
  Future<Either<Failure, bool>> authenticate() async {
    final authSuccess = await onBoardingDataSource.authenticate();
    if (authSuccess) {
      onBoardingDataSource.saveAuthTimeStamp();
      return Right(true);
    }
    onBoardingDataSource.clearCachedAuth();
    return Left(AuthFailure());
  }

  @override
  Future<Either<Failure, bool>> checkCachedAuth() async {
    final result = await onBoardingDataSource.checkCachedAuth();
    return result ? Right(true) : Left(AuthExpirationFailure());
  }
}
