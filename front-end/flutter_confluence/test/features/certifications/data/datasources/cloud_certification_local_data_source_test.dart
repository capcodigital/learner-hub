import 'dart:convert';
import 'package:flutter_confluence/core/error/custom_exceptions.dart';
import 'package:flutter_confluence/features/certifications/data/datasources/certification_hive_helper.dart';
import 'package:flutter_confluence/features/certifications/data/datasources/cloud_certification_local_data_source.dart';
import 'package:flutter_confluence/features/certifications/data/models/cloud_certification_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/FixtureReader.dart';

class MockCertificationHiveHelper extends Mock implements CertificationHiveHelper {}

void main() {
  late CloudCertificationLocalDataSourceImpl dataSource;
  late MockCertificationHiveHelper mockHiveHelper;

  setUp(() {
    mockHiveHelper = MockCertificationHiveHelper();
    dataSource = CloudCertificationLocalDataSourceImpl(hiveHelper: mockHiveHelper);
  });

  group('completedCertificationsCache', () {
    final expectedResult =
        (json.decode(fixture('cached_certifications.json')) as List)
            .map((e) => CloudCertificationModel.fromJson(e))
            .toList();

    test(
        'should return a list of completed certifications from '
        'cache when there is one in te cache', () async {
      // arrange
      when(() => mockHiveHelper.getCompleted())
          .thenAnswer((_) => Future.value(expectedResult));
      // act
      final result = await dataSource.getCompletedCertifications();
      // assert
      verify(() => mockHiveHelper.getCompleted()).called(1);
      expect(result, equals(expectedResult));
    });

    test(
      'should throw a CacheException when there is not a cached value',
      () {
        when(() => mockHiveHelper.getCompleted())
            .thenAnswer((_) => Future.value(List.empty()));
        expect(() async => await dataSource.getCompletedCertifications(),
            throwsA(TypeMatcher<CacheException>()));
      },
    );

    test(
      'should call hiveHelper to cache completed certifications',
      () async {
        // arrange
        when(() => mockHiveHelper.saveCompleted(any()))
            .thenAnswer((_) => Future.value(true));
        // act
        dataSource.saveCompletedCertifications(expectedResult);
        // assert
        verify(() => mockHiveHelper.saveCompleted(expectedResult)).called(1);
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
        'cache when there is one in the cache', () async {
      // arrange
      when(() => mockHiveHelper.getInProgress())
          .thenAnswer((_) => Future.value(expectedResult));
      // act
      final result = await dataSource.getInProgressCertifications();
      // assert
      verify(() => mockHiveHelper.getInProgress()).called(1);
      expect(result, equals(expectedResult));
    });
  });
}
