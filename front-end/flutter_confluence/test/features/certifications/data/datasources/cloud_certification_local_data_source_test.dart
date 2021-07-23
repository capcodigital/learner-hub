import 'dart:convert';
import 'package:flutter_confluence/features/certifications/data/datasources/certification_local_dao.dart';
import 'package:flutter_confluence/features/certifications/data/datasources/cloud_certification_local_data_source.dart';
import 'package:flutter_confluence/features/certifications/data/models/cloud_certification_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/FixtureReader.dart';

class MockCertificationsDao extends Mock implements CertificationLocalDao {}

void main() {
  late CloudCertificationLocalDataSourceImpl dataSource;
  late MockCertificationsDao mockDao;

  setUp(() {
    mockDao = MockCertificationsDao();
    dataSource = CloudCertificationLocalDataSourceImpl(dao: mockDao);
  });

  group('completedCertificationsCache', () {
    final expectedResult =
        (json.decode(fixture('cached_certifications.json')) as List)
            .map((e) => CloudCertificationModel.fromJson(e))
            .toList();

    test(
        'should return a list of completed certifications from '
            'LocalCertificationDao when there is one in te cache',
        () async {
      // arrange
      when(() => mockDao.getCompleted())
          .thenReturn(expectedResult);
      // act
      final result = await dataSource.getCompletedCertifications();
      // assert
      verify(() => mockDao.getCompleted()).called(1);
      expect(result, equals(expectedResult));
    });

    // TODO: Fix following Test
/*
    test(
      'should throw a CacheException when there is not a cached value',
      () {
        when(() => mockDao.getCompleted())
            .thenReturn(null);
        expect(() async => await dataSource.getCompletedCertifications(),
            throwsA(TypeMatcher<CacheException>()));
      },
    ); */

    test(
      'should call LocalCertificationDao to cache completed certifications',
      () async {
        // arrange
        when(() => mockDao.cacheCompleted(any()))
            .thenAnswer((_) => Future.value(true));
        // act
        dataSource.saveCompletedCertifications(expectedResult);
        // assert
        verify(() => mockDao.cacheCompleted(expectedResult)).called(1);
      },
    );
  });

  group('inProgressCertificationsCache', () {
    final expectedResult =
        (json.decode(fixture('cached_completed_certifications.json')) as List)
            .map((e) => CloudCertificationModel.fromJson(e))
            .toList();

    test(
        'should return a list of in progress certifications from '
            'LocalCertificationDao when there is one in the cache',
        () async {
      // arrange
      when(() => mockDao.getInProgress())
          .thenReturn(expectedResult);
      // act
      final result = await dataSource.getInProgressCertifications();
      // assert
      verify(() => mockDao.getInProgress()).called(1);
      expect(result, equals(expectedResult));
    });
  });
}
