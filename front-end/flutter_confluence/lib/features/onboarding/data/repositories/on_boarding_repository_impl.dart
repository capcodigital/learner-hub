import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';
import 'package:flutter_confluence/core/error/custom_exceptions.dart';

import '../../../../core/error/failures.dart';
import '../datasources/on_boarding_local_data_source.dart';
import '../../domain/repositories/on_boarding_repository.dart';

class OnBoardingRepositoryImpl extends OnBoardingRepository {
  final OnBoardingLocalDataSource onBoardingDataSource;

  OnBoardingRepositoryImpl({required this.onBoardingDataSource});

  @override
  Future<Either<Failure, bool>> authenticate() async {
    try {
      final authSuccess = await onBoardingDataSource.authenticate();
      if (authSuccess) {
        onBoardingDataSource.saveAuthTimeStamp();
        return Right(true);
      }
    } on PlatformException catch (e) {
      print("repo: " + e.code);
      return Left(AuthFailure(e.code));
    } on AuthNotSupportedPlatform {
      return Right(true);
    }
    return Left(AuthFailure(AuthFailure.CODE_GENERIC_FAILURE));
  }

  @override
  Future<Either<Failure, bool>> checkCachedAuth() async {
    final result = await onBoardingDataSource.checkCachedAuth();
    return result ? Right(true) : Left(AuthExpirationFailure());
  }
}
