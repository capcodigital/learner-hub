import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';
import 'package:flutter_confluence/core/constants.dart';
import 'package:flutter_confluence/core/error/custom_exceptions.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:local_auth/error_codes.dart' as auth_error;

import 'package:flutter_confluence/core/error/failures.dart';
import 'package:flutter_confluence/features/onboarding/data/datasources/on_boarding_local_data_source.dart';
import 'package:flutter_confluence/features/onboarding/data/repositories/on_boarding_repository_impl.dart';
import 'package:flutter_confluence/features/onboarding/domain/repositories/on_boarding_repository.dart';

import 'on_boarding_repository_impl_test.mocks.dart';

@GenerateMocks([OnBoardingLocalDataSource])
void main() {
  late OnBoardingRepository repository;
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

    test('Should return success for AuthNotSupportedPlatform', () async {
      // arrange
      when(mockDataSource.authenticate()).thenThrow(AuthNotSupportedPlatform());

      // act
      final result = await repository.authenticate();

      // assert
      expect(result, equals(Right(true)));
    });

    test('Should return AuthFailure for Default Auth Error', () async {
      // arrange
      when(mockDataSource.authenticate())
          .thenAnswer((_) => Future.value(false));

      // act
      final result = await repository.authenticate();

      // assert
      expect(result,
          equals(Left(AuthFailure(Constants.BIO_AUTH_DEFAULT_AUTH_FAILED))));
    });

    testPlatformException(String errorCode) async {
      // arrange
      when(mockDataSource.authenticate())
          .thenThrow(PlatformException(code: errorCode));

      // act
      final result = await repository.authenticate();

      // assert
      verify(mockDataSource.authenticate()).called(1);
      verifyNever(mockDataSource.saveAuthTimeStamp());
      expect(result, equals(Left(AuthFailure(errorCode))));
    }

    test('Should return AuthFailure for NotEnrolled', () async {
      testPlatformException(auth_error.notEnrolled);
    });

    test('Should return AuthFailure for NotAvailable', () async {
      testPlatformException(auth_error.notAvailable);
    });

    test('Should return AuthFailure for LockedOut', () async {
      testPlatformException(auth_error.lockedOut);
    });

    test('Should return AuthFailure for OtherOperatingSystem', () async {
      testPlatformException(auth_error.otherOperatingSystem);
    });

    test('Should return AuthFailure for PasscodeNotSet', () async {
      testPlatformException(auth_error.passcodeNotSet);
    });

    test('Should return AuthFailure for PermanentlyLockedOut', () async {
      testPlatformException(auth_error.permanentlyLockedOut);
    });
  });

  group('checkCachedAuth', () {
    test('Should call checkCachedAuth and return true', () async {
      // arrange
      when(mockDataSource.checkCachedAuth())
          .thenAnswer((_) => Future.value(true));

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
