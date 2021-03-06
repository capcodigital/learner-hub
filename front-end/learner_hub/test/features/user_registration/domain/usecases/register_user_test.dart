import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learner_hub/core/error/auth_failures.dart';
import 'package:learner_hub/features/user_registration/domain/entities/skills.dart';
import 'package:learner_hub/features/user_registration/domain/entities/user_registration.dart';
import 'package:learner_hub/features/user_registration/domain/repositories/user_registration_repository.dart';
import 'package:learner_hub/features/user_registration/domain/usecases/register_user.dart';
import 'package:mocktail/mocktail.dart';

class MockRegisterUserRepository extends Mock
    implements UserRegistrationRepository {}

void main() {
  late RegisterUser useCase;
  late MockRegisterUserRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(UserRegistration(
        lastName: '',
        jobTitle: '',
        bio: '',
        skills: const Skills(primarySkills: [], secondarySkills: []),
        name: '',
        email: '',
        password: ''));
  });

  setUp(() {
    mockRepository = MockRegisterUserRepository();
    useCase = RegisterUser(registrationRepository: mockRepository);
  });

  final useCaseParams = UserRegistration(
      name: 'testName',
      lastName: 'testLastName',
      jobTitle: 'testJobTitle',
      bio: 'testBio',
      skills: const Skills(primarySkills: [], secondarySkills: []),
      email: 'test@capco.com',
      password: 'password');

  test(
    'should create a user if the firebase registration succeeds',
    () async {
      // arrange
      when(() => mockRepository.registerFirebaseUser(any(), any()))
          .thenAnswer((_) => Future.value(const Right(true)));
      when(() => mockRepository.createUser(any()))
          .thenAnswer((_) => Future.value(const Right(true)));

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
      when(() => mockRepository.registerFirebaseUser(any(), any()))
          .thenAnswer((_) => Future.value(const Left(WeakPasswordFailure())));
      when(() => mockRepository.createUser(any()))
          .thenAnswer((_) => Future.value(const Right(false)));

      // Act
      final result = await useCase(useCaseParams);

      // assert
      expect(result, const Left(WeakPasswordFailure()));
      verifyNever(() => mockRepository.createUser(any()));
    },
  );

  test(
    'should clean up the firebase user if cannot create a user',
    () async {
      // arrange
      when(() => mockRepository.registerFirebaseUser(any(), any()))
          .thenAnswer((_) => Future.value(const Right(true)));
      when(() => mockRepository.createUser(any()))
          .thenAnswer((_) => Future.value(const Left(AuthFailure(''))));
      when(() => mockRepository.cleanUpFirebaseUser())
          .thenAnswer((_) => Future.value(const Right(true)));

      // Act
      final result = await useCase(useCaseParams);

      // assert
      expect(result, const Left(CreateUserError()));
      verify(() => mockRepository.createUser(any()));
      verify(() => mockRepository.cleanUpFirebaseUser());
    },
  );
}
