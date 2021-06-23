import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_confluence/core/network/network_info.dart';
import 'package:flutter_confluence/data/datasources/cloud_certification_local_data_source.dart';
import 'package:flutter_confluence/data/datasources/cloud_certification_remote_data_source.dart';
import 'package:flutter_confluence/data/models/cloud_certification_model.dart';
import 'package:flutter_confluence/data/repositories/cloud_certifications_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../fixtures/FixtureReader.dart';
import 'cloud_certifications_repository_impl_test.mocks.dart';

@GenerateMocks([CloudCertificationRemoteDataSource, CloudCertificationLocalDataSource, NetworkInfo])
void main() {
  late CloudCertificationsRepositoryImpl repository;
  late MockCloudCertificationRemoteDataSource mockRemoteDataSource;
  late MockCloudCertificationLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

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
    final completedCertifications = (json.decode(fixture('completed.json')) as Map<String, dynamic>)
        .values
        .map((e) => CloudCertificationModel.fromJson(e))
        .toList();

    test('''
        GIVEN the device is connected to the network
        AND the remote source returns a list of certifications
        WHEN the repository.getCompletedCertifications() is called
        THEN the repository gets the data from the remote source
        AND the results are saved in the cache
        ''', () async {
      // GIVEN the device is connected to the network
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

      // AND the remote source returns a list of certifications
      when(mockRemoteDataSource.getCompletedCertifications()).thenAnswer((_) async => completedCertifications);

      // WHEN the repository.getCompletedCertifications() is called
      var certifications = await repository.getCompletedCertifications();

      // THEN the repository gets the data from the remote source
      verify(mockRemoteDataSource.getCompletedCertifications());
      verifyNever(mockLocalDataSource.getCompletedCertifications());

      expect(certifications, Right(completedCertifications));

      // AND the results are saved in the cache
      verify(mockLocalDataSource.saveCompletedCertifications(completedCertifications));
    });
  });
}
