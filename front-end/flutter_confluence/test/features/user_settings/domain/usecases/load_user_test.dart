import 'package:dartz/dartz.dart';
import 'package:flutter_confluence/core/usecases/usecase.dart';
import 'package:flutter_confluence/features/user_settings/domain/entities/user.dart';
import 'package:flutter_confluence/features/user_settings/domain/repositories/user_settings_repository.dart';
import 'package:flutter_confluence/features/user_settings/domain/usecases/load_user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockUserSettingsRepository extends Mock implements UserSettingsRepository {}

void main() {
  late LoadUser useCase;
  late MockUserSettingsRepository mockRepository;

  setUp(() {
    mockRepository = MockUserSettingsRepository();
    useCase = LoadUser(userSettingsRepository: mockRepository);
  });

  test(
    'should return a user if the request is valid',
    () async {
      // arrange
      const testUser = User(
          name: 'name',
          lastName: 'lastName',
          jobTitle: 'jobTitle',
          primarySkills: [],
          secondarySkills: [],
          bio: 'bio',
          email: 'email');
      when(() => mockRepository.getCurrentUser()).thenAnswer((_) => Future.value(const Right(testUser)));

      // Act
      final result = await useCase(NoParams());

      // assert
      verify(() => mockRepository.getCurrentUser());
      expect(result, const Right(testUser));
    },
  );
}
