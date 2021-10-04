import 'package:dartz/dartz.dart';
import 'package:flutter_confluence/core/usecases/usecase.dart';
import 'package:flutter_confluence/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_confluence/features/auth/domain/usecases/is_session_valid.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late IsSessionValisUseCase subject;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    subject = IsSessionValisUseCase(mockRepository);
  });

  test(
    'should call checkCachedAuth and return true',
    () async {
      // arrange
      when(() => mockRepository.isValidSession()).thenAnswer((_) async => const Right(true));
      // act
      final result = await subject(NoParams());
      // assert
      verify(() => mockRepository.isValidSession());
      expect(result, const Right(true));
      verifyNoMoreInteractions(mockRepository);
    },
  );

  test(
    'should call checkCachedAuth and return false',
    () async {
      // arrange
      when(() => mockRepository.isValidSession()).thenAnswer((_) async => const Right(false));
      // act
      final result = await subject(NoParams());
      // assert
      verify(() => mockRepository.isValidSession());
      expect(result, const Right(false));
      verifyNoMoreInteractions(mockRepository);
    },
  );
}
