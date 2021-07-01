import 'package:dartz/dartz.dart';
import 'package:flutter_confluence/core/error/custom_exceptions.dart';
import 'package:flutter_confluence/core/error/failures.dart';
import 'package:flutter_confluence/core/network/network_info.dart';
import 'package:flutter_confluence/core/utils/extensions.dart';
import 'package:flutter_confluence/data/datasources/cloud_certification_local_data_source.dart';
import 'package:flutter_confluence/data/datasources/cloud_certification_remote_data_source.dart';
import 'package:flutter_confluence/data/models/cloud_certification_model.dart';
import 'package:flutter_confluence/domain/entities/cloud_certification.dart';
import 'package:flutter_confluence/domain/repositories/cloud_certification_repository.dart';
import 'package:flutter_confluence/presentation/bloc/cloud_certification_bloc.dart';

class CloudCertificationsRepositoryImpl extends CloudCertificationRepository {
  final CloudCertificationRemoteDataSource remoteDataSource;
  final CloudCertificationLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  CloudCertificationsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<CloudCertification>>> getCompletedCertifications() async {
    return await _getData(
        remoteDataSource.getCompletedCertifications,
        localDataSource.getCompletedCertifications,
        localDataSource.saveCompletedCertifications);
  }

  @override
  Future<Either<Failure, List<CloudCertification>>> getInProgressCertifications() async {
    return await _getData(
        remoteDataSource.getInProgressCertifications,
        localDataSource.getInProgressCertifications,
        localDataSource.saveInProgressCertifications);
  }

  Future<Either<Failure, List<CloudCertification>>> _getData(
    Future<List<CloudCertificationModel>> Function() getRemoteData,
    Future<List<CloudCertificationModel>> Function() getLocalData,
    Future<void> Function(List<CloudCertificationModel> certifications) saveDataIntoCache,
  ) async {
    try {
      if (await networkInfo.isConnected) {
        try {
          final certifications = await getRemoteData();
          saveDataIntoCache(certifications);
          return Right(certifications);
        } on ServerException {
          return Left(ServerFailure());
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
      return Left(ServerFailure());
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
      var searchTerm = searchQuery.trim();
      if (searchTerm.isNotEmpty) {
        var filtered = certifications
            .where((element) =>
        element.name.containsIgnoreCase(searchTerm) ||
            element.certificationType.containsIgnoreCase(searchTerm) ||
            element.platform.containsIgnoreCase(searchTerm))
            .toList();
        return Right(filtered);
      }
      else {
        return Right(certifications);
      }
    } on Exception {
      return Left(CacheFailure());
    }
  }
}
