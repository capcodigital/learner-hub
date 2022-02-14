import 'package:dartz/dartz.dart';
import 'package:flutter_confluence/core/error/auth_failures.dart';
import 'package:flutter_confluence/core/usecases/usecase.dart';
import 'package:flutter_confluence/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_confluence/features/auth/domain/usecases/logout.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late LogoutUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = LogoutUseCase(logoutRepository: mockRepository);
  });

  test(
    'should call logout and return true',
    () async {
      // arrange
      when(() => mockRepository.logout()).thenAnswer((_) => Future.value());

      // Act
      final result = await useCase(NoParams());

      // assert
      verify(() => mockRepository.logout());
      expect(result, const Right(true));
      verifyNoMoreInteractions(mockRepository);
    },
  );

  test(
    'should return a failure if something goes wrong n logging out the user',
    () async {
      // arrange
      when(() => mockRepository.logout()).thenThrow(const AuthFailure(''));
      // act
      final result = await useCase(NoParams());

      // assert
      verify(() => mockRepository.logout());
      expect(result, const Left(AuthFailure('Is not possible to logout the user')));
    },
  );
}
