import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_confluence/core/error/custom_exceptions.dart';
import 'package:flutter_confluence/core/error/failures.dart';
import 'package:flutter_confluence/core/network/network_info.dart';
import 'package:flutter_confluence/data/datasources/cloud_certification_local_data_source.dart';
import 'package:flutter_confluence/data/datasources/cloud_certification_remote_data_source.dart';
import 'package:flutter_confluence/data/models/cloud_certification_model.dart';
import 'package:flutter_confluence/data/repositories/cloud_certifications_repository_impl.dart';
import 'package:flutter_confluence/presentation/bloc/cloud_certification_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../fixtures/FixtureReader.dart';
import 'cloud_certifications_repository_impl_test.mocks.dart';

@GenerateMocks([
  CloudCertificationRemoteDataSource,
  CloudCertificationLocalDataSource,
  NetworkInfo
])
void main() {
  late CloudCertificationsRepositoryImpl repository;
  late MockCloudCertificationRemoteDataSource mockRemoteDataSource;
  late MockCloudCertificationLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  final remoteCertifications =
      (json.decode(fixture('completed.json')) as Map<String, dynamic>)
          .values
          .map((e) => CloudCertificationModel.fromJson(e))
          .toList();

  final localCertifications =
      (json.decode(fixture('cached_completed_certifications.json')) as List)
          .map((e) => CloudCertificationModel.fromJson(e))
          .toList();

  setUp(() {
    mockRemoteDataSource = MockCloudCertificationRemoteDataSource();
    mockLocalDataSource = MockCloudCertificationLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = CloudCertificationsRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  group('completedCertifications', () {
    setUp(() {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    });

    test(
        'should return remote data when the call to remote data source is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.getCompletedCertifications())
          .thenAnswer((_) async => remoteCertifications);
      // act
      final certifications = await repository.getCompletedCertifications();

      // assert
      verify(mockRemoteDataSource.getCompletedCertifications());

      // Note: If you compare
      // expect(certifications, equals(Right(remoteCertifications.map((e) => e.toCloudCertification()))));
      // won't work. Maybe because the mapping of the entities?
      // So I getting just the value of the right side
      expect(certifications.isRight(), true);
      expect(certifications.getOrElse(() => []), equals(remoteCertifications));
    });

    test(
        'certifications are saved in local cache when fetched from remote source',
        () async {
      // arrange
      when(mockRemoteDataSource.getCompletedCertifications())
          .thenAnswer((_) async => remoteCertifications);
      // act
      await repository.getCompletedCertifications();
      // assert
      verify(mockRemoteDataSource.getCompletedCertifications());
      verify(mockLocalDataSource
          .saveCompletedCertifications(remoteCertifications));
    });
  });

  group('inProgressCertifications', () {
    setUp(() {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    });

    test(
        'should return remote data when the call to remote data source is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.getInProgressCertifications())
          .thenAnswer((_) async => remoteCertifications);
      // act
      final certifications = await repository.getInProgressCertifications();

      // assert
      verify(mockRemoteDataSource.getInProgressCertifications());

      // Note: If you compare
      // expect(certifications, equals(Right(remoteCertifications.map((e) => e.toCloudCertification()))));
      // won't work. Maybe because the mapping of the entities?
      // So I getting just the value of the right side
      expect(certifications.isRight(), true);
      expect(certifications.getOrElse(() => []), equals(remoteCertifications));
    });

    test(
        'certifications are saved in local cache when fetched from remote source',
        () async {
      // arrange
      when(mockRemoteDataSource.getInProgressCertifications())
          .thenAnswer((_) async => remoteCertifications);
      // act
      await repository.getInProgressCertifications();
      // assert
      verify(mockRemoteDataSource.getInProgressCertifications());
      verify(mockLocalDataSource
          .saveInProgressCertifications(remoteCertifications));
    });
  });

  group('offlineTests', () {
    setUp(() {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
    });

    test('should return the local completed data when the device is offline',
        () async {
      //arrange
      when(mockLocalDataSource.getCompletedCertifications())
          .thenAnswer((_) async => localCertifications);

      // act
      await repository.getCompletedCertifications();

      // assert
      verifyZeroInteractions(mockRemoteDataSource);
      verify(mockLocalDataSource.getCompletedCertifications());
    });

    test('should return the local in_progress data when the device is offline',
        () async {
      //arrange
      when(mockLocalDataSource.getInProgressCertifications())
          .thenAnswer((_) async => localCertifications);

      // act
      await repository.getInProgressCertifications();

      // assert
      verifyZeroInteractions(mockRemoteDataSource);
      verify(mockLocalDataSource.getInProgressCertifications());
    });
  });

  group('emptyCacheTestsWhenOffline', () {
    setUp(() {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
    });

    test(
        'should return a failure when in_progress is called when the device is offline and cache is empty',
        () async {
      //arrange
      when(mockLocalDataSource.getInProgressCertifications())
          .thenThrow(CacheException());

      // act
      var certifications = await repository.getInProgressCertifications();

      // assert
      verifyZeroInteractions(mockRemoteDataSource);
      verify(mockLocalDataSource.getInProgressCertifications());
      expect(certifications, equals(Left(CacheFailure())));
    });

    test(
        'should return a failure when completed is called when the device is offline and cache is empty',
        () async {
      //arrange
      when(mockLocalDataSource.getCompletedCertifications())
          .thenThrow(CacheException());

      // act
      var certifications = await repository.getCompletedCertifications();

      // assert
      verifyZeroInteractions(mockRemoteDataSource);
      verify(mockLocalDataSource.getCompletedCertifications());
      expect(certifications, equals(Left(CacheFailure())));
    });
  });

  group('searchTests', () {
    test(
        'should return a failure when search is called and cache is empty',
            () async {
          //arrange
          when(mockLocalDataSource.getCompletedCertifications())
              .thenThrow(CacheException());

          // act
          var result = await repository.searchCertifications("search term", CloudCertificationType.completed);

          // assert
          verify(mockLocalDataSource.getCompletedCertifications());
          expect(result, equals(Left(CacheFailure())));
        });

    test(
        'should return all data when cache is not empty and search term is empty',
            () async {
          //arrange
              when(mockLocalDataSource.getCompletedCertifications())
                  .thenAnswer((_) async => localCertifications);

          // act
          var result = await repository.searchCertifications("", CloudCertificationType.completed);

          // assert
          verify(mockLocalDataSource.getCompletedCertifications());
          expect(result, equals(Right(localCertifications)));
        });

    test('should return empty list when cannot find data', () async {
      //arrange
      when(mockLocalDataSource.getCompletedCertifications()).thenAnswer((_) async => localCertifications);

      // act
      var result = await repository.searchCertifications("notfoundstring", CloudCertificationType.completed);

      // assert
      verify(mockLocalDataSource.getCompletedCertifications());
      result.fold((failure) => throwsAssertionError, (certifications) {
        expect(certifications.length, 0);
      });
    });

    test('should return filtered data by certification name', () async {
      //arrange
      when(mockLocalDataSource.getCompletedCertifications()).thenAnswer((_) async => localCertifications);

      // act
      var result = await repository.searchCertifications("Kenobi", CloudCertificationType.completed);

      // assert
      verify(mockLocalDataSource.getCompletedCertifications());
      result.fold((failure) => throwsAssertionError, (certifications) {
        expect(certifications.length, 1);
      });
    });

    test('should return filtered data by certification type', () async {
      //arrange
      when(mockLocalDataSource.getCompletedCertifications())
          .thenAnswer((_) async => localCertifications);

      // act
      var result = await repository.searchCertifications("star", CloudCertificationType.completed);

      // assert
      verify(mockLocalDataSource.getCompletedCertifications());
      result.fold((failure) => throwsAssertionError, (certifications) {
        expect(certifications.length, 1);
      });
    });

    test('should return filtered data by certification platform', () async {
      //arrange
      when(mockLocalDataSource.getCompletedCertifications())
          .thenAnswer((_) async => localCertifications);

      // act
      var result = await repository.searchCertifications("Jedi", CloudCertificationType.completed);

      // assert
      verify(mockLocalDataSource.getCompletedCertifications());
      result.fold((failure) => throwsAssertionError, (certifications) {
        expect(certifications.length, 1);
      });
    });
  });
}
