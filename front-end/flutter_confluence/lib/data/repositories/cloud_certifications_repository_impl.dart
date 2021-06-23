import 'package:dartz/dartz.dart';
import 'package:flutter_confluence/core/error/custom_exceptions.dart';
import 'package:flutter_confluence/core/errors/failures.dart';
import 'package:flutter_confluence/core/network/network_info.dart';
import 'package:flutter_confluence/data/datasources/cloud_certification_local_data_source.dart';
import 'package:flutter_confluence/data/datasources/cloud_certification_remote_data_source.dart';
import 'package:flutter_confluence/data/models/cloud_certification_model.dart';
import 'package:flutter_confluence/domain/entities/cloud_certification.dart';
import 'package:flutter_confluence/domain/repositories/cloud_certification_repository.dart';

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
    try {
      if (await networkInfo.isConnected) {
        try {
          final certifications = await remoteDataSource.getCompletedCertifications();
          localDataSource.saveCompletedCertifications(certifications);
          return Right(certifications.map((e) => e.toCloudCertification()).toList());
        } on ServerException {
          return Left(ServerFailure());
        }
      } else {
        try {
          final localCertifications = await localDataSource.getCompletedCertifications();
          return Right(localCertifications.map((e) => e.toCloudCertification()).toList());
        } on CacheException {
          return Left(CacheFailure());
        }
      }
    } on Exception {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<CloudCertification>>> getInProgressCertifications() async {
    if (await networkInfo.isConnected) {
      try {
        final certifications = await remoteDataSource.getInProgressCertifications();
        localDataSource.saveInProgressCertifications(certifications);
        return Right(certifications.map((e) => e.toCloudCertification()).toList());
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localCertifications = await localDataSource.getInProgressCertifications();
        return Right(localCertifications.map((e) => e.toCloudCertification()).toList());
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}

extension CloudCertificationMapper on CloudCertificationModel {
  CloudCertification toCloudCertification() {
    return CloudCertification(
        name: this.name,
        platform: this.platform,
        certificationType: this.certificationName,
        certificationDate: this.date);
  }
}
