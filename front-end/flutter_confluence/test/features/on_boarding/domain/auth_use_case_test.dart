import 'package:dartz/dartz.dart';
import 'package:flutter_confluence/core/usecases/usecase.dart';
import 'package:flutter_confluence/features/onboarding/domain/repositories/on_boarding_repository.dart';
import 'package:flutter_confluence/features/onboarding/domain/usecases/auth_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockOnBoardingRepository extends Mock implements OnBoardingRepository {}

void main() {
  late AuthUseCase subject;
  late MockOnBoardingRepository mockRepository;

  setUp(() {
    mockRepository = MockOnBoardingRepository();
    subject = AuthUseCase(mockRepository);
  });

  test(
    'should call authenticate and return true',
    () async {
      // arrange
      when(() => mockRepository.authenticate())
          .thenAnswer((_) async => const Right(true));
      // act
      final result = await subject(NoParams());
      // assert
      verify(() => mockRepository.authenticate());
      expect(result, const Right(true));
      verifyNoMoreInteractions(mockRepository);
    },
  );

  test(
    'should call authenticate and return false',
    () async {
      // arrange
      when(() => mockRepository.authenticate())
          .thenAnswer((_) async => const Right(false));
      // act
      final result = await subject(NoParams());
      // assert
      verify(() => mockRepository.authenticate());
      expect(result, const Right(false));
      verifyNoMoreInteractions(mockRepository);
    },
  );
}
