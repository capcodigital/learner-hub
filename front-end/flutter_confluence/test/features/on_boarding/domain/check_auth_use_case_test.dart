import 'package:dartz/dartz.dart';
import 'package:flutter_confluence/core/usecases/usecase.dart';
import 'package:flutter_confluence/features/onboarding/domain/repositories/on_boarding_repository.dart';
import 'package:flutter_confluence/features/onboarding/domain/usecases/check_auth_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockOnBoardingRepository extends Mock implements OnBoardingRepository {}

void main() {
  late CheckAuthUseCase subject;
  late MockOnBoardingRepository mockRepository;

  setUp(() {
    mockRepository = MockOnBoardingRepository();
    subject = CheckAuthUseCase(mockRepository);
  });

  test(
    'should call checkCachedAuth and return true',
    () async {
      // arrange
      when(() => mockRepository.checkCachedAuth())
          .thenAnswer((_) async => Right(true));
      // act
      final result = await subject(NoParams());
      // assert
      verify(() => mockRepository.checkCachedAuth());
      expect(result, Right(true));
      verifyNoMoreInteractions(mockRepository);
    },
  );

  test(
    'should call checkCachedAuth and return false',
    () async {
      // arrange
      when(() => mockRepository.checkCachedAuth())
          .thenAnswer((_) async => Right(false));
      // act
      final result = await subject(NoParams());
      // assert
      verify(() => mockRepository.checkCachedAuth());
      expect(result, Right(false));
      verifyNoMoreInteractions(mockRepository);
    },
  );
}
