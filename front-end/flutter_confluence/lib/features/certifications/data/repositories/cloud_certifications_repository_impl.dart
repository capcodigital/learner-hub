import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flutter_confluence/core/constants.dart';
import 'package:flutter_confluence/core/error/custom_exceptions.dart';
import 'package:flutter_confluence/core/error/failures.dart';
import 'package:flutter_confluence/core/network/network_info.dart';
import 'package:flutter_confluence/core/utils/extensions/extensions.dart';
import 'package:flutter_confluence/features/certifications/data/datasources/cloud_certification_local_data_source.dart';
import 'package:flutter_confluence/features/certifications/data/datasources/cloud_certification_remote_data_source.dart';
import 'package:flutter_confluence/features/certifications/data/models/cloud_certification_model.dart';
import 'package:flutter_confluence/features/certifications/domain/entities/cloud_certification.dart';
import 'package:flutter_confluence/features/certifications/domain/entities/cloud_certification_type.dart';
import 'package:flutter_confluence/features/certifications/domain/repositories/cloud_certification_repository.dart';

class CloudCertificationsRepositoryImpl
    implements CloudCertificationRepository {
  CloudCertificationsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });
  static const TAG = 'CloudCertificationsRepositoryImpl:';
  final CloudCertificationRemoteDataSource remoteDataSource;
  final CloudCertificationLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  @override
  Future<Either<Failure, List<CloudCertification>>> getCompletedCertifications() async {
    return _getData(
        remoteDataSource.getCompletedCertifications,
        localDataSource.getCompletedCertifications,
        localDataSource.saveCompletedCertifications);
  }

  @override
  Future<Either<Failure, List<CloudCertification>>>
      getInProgressCertifications() async {
    return _getData(
        remoteDataSource.getInProgressCertifications,
        localDataSource.getInProgressCertifications,
        localDataSource.saveInProgressCertifications);
  }

  Future<Either<Failure, List<CloudCertification>>> _getData(
    Future<List<CloudCertificationModel>> Function() getRemoteData,
    Future<List<CloudCertificationModel>> Function() getLocalData,
    Future<void> Function(List<CloudCertificationModel> certifications)
        saveDataIntoCache,
  ) async {
    try {
      if (await networkInfo.isConnected) {
        try {
          final certifications = await getRemoteData();
          saveDataIntoCache(certifications);
          return Right(certifications);
        } on ServerException catch (e) {
          log(TAG + e.message);
          try {
            final localCertifications = await getLocalData();
            return Right(localCertifications);
          } on CacheException {
            log('${TAG}CacheException');
            return Left(ServerFailure(message: e.message));
          }
        }
      } else {
        try {
          final localCertifications = await getLocalData();
          return Right(localCertifications);
        } on CacheException {
          return Left(CacheFailure());
        }
      }
    } on Exception {
      return const Left(ServerFailure(message: Constants.UNKNOWN_ERROR_MSG));
    }
  }

  @override
  Future<Either<Failure, List<CloudCertification>>> searchCertifications(
      String searchQuery, CloudCertificationType dataType) async {
    try {
      var certifications = <CloudCertification>[];
      switch (dataType) {
        case CloudCertificationType.completed:
          certifications = await localDataSource.getCompletedCertifications();
          break;
        case CloudCertificationType.in_progress:
          certifications = await localDataSource.getInProgressCertifications();
          break;
      }
      final searchTerm = searchQuery.trim();
      if (searchTerm.isNotEmpty) {
        final filtered = certifications
            .where((element) =>
                element.name.containsIgnoreCase(searchTerm) ||
                element.certificationType.containsIgnoreCase(searchTerm) ||
                element.platform.containsIgnoreCase(searchTerm))
            .toList();
        return Right(filtered);
      } else {
        return Right(certifications);
      }
    } on Exception {
      return Left(CacheFailure());
    }
  }
}
