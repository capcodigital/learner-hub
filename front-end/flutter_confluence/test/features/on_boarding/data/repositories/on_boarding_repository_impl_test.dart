import 'package:dartz/dartz.dart';
import 'package:flutter_confluence/core/error/failures.dart';
import 'package:flutter_confluence/features/onboarding/data/datasources/on_boarding_local_data_source.dart';
import 'package:flutter_confluence/features/onboarding/data/repositories/on_boarding_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'on_boarding_repository_impl_test.mocks.dart';

@GenerateMocks([OnBoardingLocalDataSource])
void main() {
  late OnBoardingRepositoryImpl repository;
  late MockOnBoardingLocalDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockOnBoardingLocalDataSource();
    repository = OnBoardingRepositoryImpl(onBoardingDataSource: mockDataSource);
  });

  group('authenticate', () {
    test('Should save timeStamp and return true on auth success', () async {
      // arrange
      when(mockDataSource.authenticate()).thenAnswer((_) => Future.value(true));
      // act
      final result = await repository.authenticate();
      // assert
      verify(mockDataSource.saveAuthTimeStamp()).called(1);
      expect(result, equals(Right(true)));
    });

    test('Should delete cached timeStamp and return false on auth failure',
        () async {
      // arrange
      when(mockDataSource.authenticate())
          .thenAnswer((_) => Future.value(false));
      // act
      final result = await repository.authenticate();
      // assert
      verify(mockDataSource.clearCachedAuth()).called(1);
      expect(result, equals(Left(AuthFailure())));
    });
  });

  group('checkCachedAuth', () {
    test('Should call checkCachedAuth and return true', () async {
      // arrange
      when(mockDataSource.checkCachedAuth()).thenAnswer((_) => Future.value(true));
      // act
      final result = await repository.checkCachedAuth();
      // assert
      verify(mockDataSource.checkCachedAuth()).called(1);
      expect(result, equals(Right(true)));
    });

    test('Should call checkCachedAuth and return auth expiration failure',
            () async {
          // arrange
          when(mockDataSource.checkCachedAuth())
              .thenAnswer((_) => Future.value(false));
          // act
          final result = await repository.checkCachedAuth();
          // assert
          verify(mockDataSource.checkCachedAuth()).called(1);
          expect(result, equals(Left(AuthExpirationFailure())));
        });
  });
}
