import 'dart:convert';

import 'package:flutter_confluence/core/error/custom_exceptions.dart';
import 'package:flutter_confluence/features/certifications/data/datasources/cloud_certification_local_data_source.dart';
import 'package:flutter_confluence/features/certifications/data/models/cloud_certification_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/FixtureReader.dart';
import 'cloud_certification_local_data_source_test.mocks.dart';

@GenerateMocks([SharedPreferences])
void main() {
  late CloudCertificationLocalDataSourceImpl dataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = CloudCertificationLocalDataSourceImpl(sharedPreferences: mockSharedPreferences);
  });

  group('completedCertificationsCache', () {
    final expectedResult = (json.decode(fixture('cached_certifications.json')) as List)
        .map((e) => CloudCertificationModel.fromJson(e))
        .toList();

    test('should return a list of completed certifications from SharedPreferences when there is one in te cache',
        () async {
      // arrange
      when(mockSharedPreferences.getString(COMPLETED_CERTIFICATIONS_KEY))
          .thenReturn(fixture('cached_certifications.json'));
      // act
      final result = await dataSource.getCompletedCertifications();
      // assert
      verify(mockSharedPreferences.getString(COMPLETED_CERTIFICATIONS_KEY)).called(1);
      expect(result, equals(expectedResult));
    });

    test(
      'should throw a CacheException when there is not a cached value',
      () {
        when(mockSharedPreferences.getString(COMPLETED_CERTIFICATIONS_KEY)).thenReturn(null);
        expect(() async => await dataSource.getCompletedCertifications(), throwsA(TypeMatcher<CacheException>()));
      },
    );

    test(
      'should call SharedPreferences to cache the data',
      () async {
        // arrange
        when(mockSharedPreferences.setString(any, any)).thenAnswer((_) => Future.value(true));
        // act
        dataSource.saveCompletedCertifications(expectedResult);
        // assert
        final expectedJsonString = json.encode(expectedResult);
        verify(mockSharedPreferences.setString(
          any,
          expectedJsonString,
        )).called(1);
      },
    );
  });

  group('completedCertificationsCache', () {
    final expectedResult = (json.decode(fixture('cached_completed_certifications.json')) as List)
        .map((e) => CloudCertificationModel.fromJson(e))
        .toList();

    test('should return a list of i progress certifications from SharedPreferences when there is one in te cache',
            () async {
          // arrange
          when(mockSharedPreferences.getString(IN_PROGRESS_CERTIFICATIONS_KEY))
              .thenReturn(fixture('cached_certifications.json'));
          // act
          final result = await dataSource.getInProgressCertifications();
          // assert
          verify(mockSharedPreferences.getString(IN_PROGRESS_CERTIFICATIONS_KEY)).called(1);
          expect(result, equals(expectedResult));
        });
  });
}
