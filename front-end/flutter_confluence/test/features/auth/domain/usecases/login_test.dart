import 'package:dartz/dartz.dart';
import 'package:flutter_confluence/core/error/auth_failures.dart';
import 'package:flutter_confluence/features/auth/domain/entities/user.dart';
import 'package:flutter_confluence/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_confluence/features/auth/domain/usecases/login.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late LoginUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = LoginUseCase(authRepository: mockRepository);
  });

  const testUser = User(uid: '123');

  test(
    'should return a user when credentials are valid',
    () async {
      // arrange
      when(() => mockRepository.loginUser(any(), any())).thenAnswer((_) => Future.value(const Right(testUser)));

      // Act
      final result = await useCase(const LoginParams(email: 'test@capco.com', password: '123456'));

      // assert
      expect(result, const Right(testUser));
    },
  );

  test(
    'should return a failure when credentials are not valid',
    () async {
      // arrange
      when(() => mockRepository.loginUser(any(), any())).thenAnswer((_) => Future.value(Left(InvalidEmailFailure())));

      // act
      final result = await useCase(const LoginParams(email: 'test@capco.com', password: '123456'));

      // assert
      expect(result, Left(InvalidEmailFailure()));
    },
  );
}
