import 'package:dartz/dartz.dart';
import 'package:flutter_confluence/core/auth/auth_failures.dart';
import 'package:flutter_confluence/features/onboarding/data/datasources/on_boarding_local_data_source.dart';
import 'package:flutter_confluence/features/onboarding/data/repositories/on_boarding_repository_impl.dart';
import 'package:flutter_confluence/features/onboarding/domain/repositories/on_boarding_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockOnBoardingLocalDataSource extends Mock implements OnBoardingLocalDataSource {}

void main() {
  late OnBoardingRepository repository;
  late MockOnBoardingLocalDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockOnBoardingLocalDataSource();
    repository = OnBoardingRepositoryImpl(onBoardingDataSource: mockDataSource);
  });

  group('checkCachedAuth', () {
    test('Should call checkCachedAuth and return true', () async {
      // arrange
      when(() => mockDataSource.checkLocalUserLogged()).thenAnswer((_) => Future.value(true));

      // act
      final result = await repository.checkCachedAuth();

      // assert
      verify(() => mockDataSource.checkLocalUserLogged()).called(1);
      expect(result, equals(const Right(true)));
    });

    test('Should call checkCachedAuth and return auth expiration failure', () async {
      // arrange
      when(() => mockDataSource.checkLocalUserLogged()).thenAnswer((_) => Future.value(false));

      // act
      final result = await repository.checkCachedAuth();

      // assert
      verify(() => mockDataSource.checkLocalUserLogged()).called(1);
      expect(result, equals(Left(NoCurrentUserLogged())));
    });
  });
}
