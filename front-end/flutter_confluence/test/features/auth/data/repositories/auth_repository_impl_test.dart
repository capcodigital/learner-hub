import 'package:dartz/dartz.dart';
import 'package:flutter_confluence/core/error/auth_failures.dart';
import 'package:flutter_confluence/features/auth/data/datasources/auth_data_source.dart';
import 'package:flutter_confluence/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_confluence/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthDataSource extends Mock implements AuthDataSource {}

void main() {
  late AuthRepository repository;
  late MockAuthDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockAuthDataSource();
    repository = AuthRepositoryImpl(authDataSource: mockDataSource);
  });

  group('checkCachedAuth', () {
    test('Should call checkCachedAuth and return true if there is a logged user', () async {
      // arrange
      when(() => mockDataSource.checkLocalUserLogged()).thenAnswer((_) => Future.value(true));

      // act
      final result = await repository.isValidSession();

      // assert
      verify(() => mockDataSource.checkLocalUserLogged()).called(1);
      expect(result, equals(const Right(true)));
    });

    test('Should call checkCachedAuth and return auth error when there is no user', () async {
      // arrange
      when(() => mockDataSource.checkLocalUserLogged()).thenAnswer((_) => Future.value(false));

      // act
      final result = await repository.isValidSession();

      // assert
      verify(() => mockDataSource.checkLocalUserLogged()).called(1);
      expect(result, equals(Left(NoCurrentUserLogged())));
    });
  });

  group('loginUser', () {
    test('Should return a user when the email and password are correct', () async {
      // arrange
      when(() => mockDataSource.signInWithEmailAndPassword(any(), any()))
          .thenAnswer((_) => Future.value(true));

      // act
      final result = await repository.loginUser('email', 'password');

      // assert
      verify(() => mockDataSource.signInWithEmailAndPassword(any(), any())).called(1);
      result.fold((l) => throwsAssertionError, (result) {
        expect(result, true);
      });
    });

    test('Should call checkCachedAuth and return auth expiration failure', () async {
      // arrange
      when(() => mockDataSource.signInWithEmailAndPassword(any(), any()))
          .thenThrow(AuthFailure('forced for unit test'));

      // act
      final result = await repository.loginUser('email', 'password');

      // assert
      expect(result, equals(Left(AuthFailure('forced for unit test'))));
    });
  });
}
