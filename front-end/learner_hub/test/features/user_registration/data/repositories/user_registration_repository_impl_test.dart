import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learner_hub/core/error/auth_failures.dart';
import 'package:learner_hub/features/user_registration/data/datasources/register_user_data_source.dart';
import 'package:learner_hub/features/user_registration/data/models/skills_model.dart';
import 'package:learner_hub/features/user_registration/data/models/user_registration_model.dart';
import 'package:learner_hub/features/user_registration/data/repositories/user_registration_repository_impl.dart';
import 'package:learner_hub/features/user_registration/domain/entities/skills.dart';
import 'package:learner_hub/features/user_registration/domain/entities/user_registration.dart';
import 'package:mocktail/mocktail.dart';

class MockRegisterUserDataSource extends Mock
    implements RegisterUserDataSource {}

class MockFirebaseUser extends Mock implements User {}

void main() {
  late UserRegistrationRepositoryIml repository;
  late MockRegisterUserDataSource mockDataSource;

  setUpAll(() {
    registerFallbackValue(UserRegistrationModel(
      name: 'name',
      lastName: 'lastName',
      jobTitle: 'jobTitle',
      skills: SkillsModel(
          primarySkills: const ['primary'],
          secondarySkills: const ['secondary']),
      bio: 'bio',
      email: 'email',
    ));
  });

  setUp(() {
    mockDataSource = MockRegisterUserDataSource();
    repository = UserRegistrationRepositoryIml(dataSource: mockDataSource);
  });

  group('register Firebase User', () {
    User _createFirebaseUser(String uid) {
      final firebaseUser = MockFirebaseUser();
      when(() => firebaseUser.uid).thenReturn(uid);
      return firebaseUser;
    }

    test(
        'should return true when the the user is registered successfully in firebase',
        () async {
      // arrange
      final mockFirebaseUser = _createFirebaseUser('uid');
      when(() => mockDataSource.registerFirebaseUser(any(), any()))
          .thenAnswer((_) async => Future.value(mockFirebaseUser));

      // act
      final result = await repository.registerFirebaseUser('email', 'password');

      // assert
      expect(result, const Right(true));
      verify(() => mockDataSource.registerFirebaseUser(any(), any()));
    });

    test(
        'should return a failure when there is an error registering the user in firebase',
        () async {
      // arrange
      when(() => mockDataSource.registerFirebaseUser(any(), any()))
          .thenThrow(const WeakPasswordFailure());

      // act
      final result = await repository.registerFirebaseUser('email', 'password');

      // assert
      expect(result, const Left(WeakPasswordFailure()));
    });
  });

  group('create user in remote DB', () {
    final userRegistration = UserRegistration(
        name: 'name',
        lastName: 'lastName',
        jobTitle: 'jobTitle',
        skills: const Skills(
            primarySkills: ['primary'], secondarySkills: ['secondary']),
        bio: 'bio',
        email: 'email',
        password: 'password');

    test('should return true when the the user is created successfully in DB',
        () async {
      // arrange
      when(() => mockDataSource.createUser(any()))
          .thenAnswer((_) async => Future.value(true));

      // act
      final result = await repository.createUser(userRegistration);

      // assert
      expect(result, const Right(true));
      verify(() => mockDataSource.createUser(any()));
    });

    test(
        'should return a failure when there is an error creating the user in the DB',
        () async {
      // arrange
      when(() => mockDataSource.createUser(any()))
          .thenThrow(const AuthFailure('unit test error'));

      // act
      final result = await repository.createUser(userRegistration);

      // assert
      expect(result, const Left(CreateUserError()));
    });
  });
}
