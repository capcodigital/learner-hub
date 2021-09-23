import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';
import 'package:flutter_confluence/core/auth/auth_failures.dart';
import 'package:flutter_confluence/core/error/custom_exceptions.dart';

import '../../../../core/error/failures.dart';
import '../../domain/repositories/on_boarding_repository.dart';
import '../datasources/on_boarding_local_data_source.dart';

class OnBoardingRepositoryImpl implements OnBoardingRepository {
  OnBoardingRepositoryImpl({required this.onBoardingDataSource});

  final OnBoardingLocalDataSource onBoardingDataSource;

  @override
  Future<Either<Failure, bool>> authenticate() async {
    try {
      final authSuccess = await onBoardingDataSource.authenticate();
      if (authSuccess) {
        onBoardingDataSource.saveAuthTimeStamp();
        return const Right(true);
      }
    } on PlatformException catch (e) {
      return Left(AuthFailure(e.code));
    } on AuthNotSupportedPlatform {
      return const Right(true);
    }
    return Left(AuthFailure(AuthFailure.CODE_GENERIC_FAILURE));
  }

  @override
  Future<Either<Failure, bool>> checkCachedAuth() async {
    final result = await onBoardingDataSource.checkCachedAuth();
    return result ? const Right(true) : Left(AuthExpirationFailure());
  }
}
