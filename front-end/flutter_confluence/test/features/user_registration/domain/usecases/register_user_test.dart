import 'package:dartz/dartz.dart';
import 'package:flutter_confluence/core/error/auth_failures.dart';
import 'package:flutter_confluence/features/auth/domain/entities/user.dart';
import 'package:flutter_confluence/features/user_registration/domain/entities/user_registration.dart';
import 'package:flutter_confluence/features/user_registration/domain/repositories/user_registration_repository.dart';
import 'package:flutter_confluence/features/user_registration/domain/usecases/register_user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRegisterUserRepository extends Mock implements UserRegistrationRepository {}

void main() {
  late RegisterUserUseCase useCase;
  late MockRegisterUserRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(UserRegistration(
        lastName: '',
        jobTitle: '',
        bio: '',
        secondarySkills: [],
        primarySkills: [],
        password: '',
        name: '',
        email: ''));
  });

  setUp(() {
    mockRepository = MockRegisterUserRepository();
    useCase = RegisterUserUseCase(registrationRepository: mockRepository);
  });

  const testUser = User(uid: '123');

  const useCaseParams = RegisterParams(
    name: 'testName',
    lastName: 'testLastName',
    jobTitle: 'testJobTitle',
    bio: 'testBio',
    primarySkills: [],
    secondarySkills: [],
    email: 'test@capco.com',
    password: '123456',
  );

  test(
    'should create a user if the firebase registration succeeds',
    () async {
      // arrange
      when(() => mockRepository.registerFirebaseUser(any())).thenAnswer((_) => Future.value(const Right(testUser)));
      when(() => mockRepository.createUser(any())).thenAnswer((_) => Future.value(const Right(true)));

      // Act
      final result = await useCase(useCaseParams);

      // assert
      verify(() => mockRepository.createUser(any()));
      expect(result, const Right(true));
    },
  );

  test(
    "should don't create a user if the firebase registration fails",
    () async {
      // arrange
      when(() => mockRepository.registerFirebaseUser(any()))
          .thenAnswer((_) => Future.value(Left(WeakPasswordFailure())));
      when(() => mockRepository.createUser(any())).thenAnswer((_) => Future.value(const Right(false)));

      // Act
      final result = await useCase(useCaseParams);

      // assert
      expect(result, Left(WeakPasswordFailure()));
      verifyNever(() => mockRepository.createUser(any()));
    },
  );
}
