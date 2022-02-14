import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learner_hub/features/user_settings/domain/entities/user.dart';
import 'package:learner_hub/features/user_settings/domain/repositories/user_settings_repository.dart';
import 'package:learner_hub/features/user_settings/domain/usecases/update_user_settings.dart';
import 'package:mocktail/mocktail.dart';

class MockUserSettingsRepository extends Mock implements UserSettingsRepository {}

void main() {
  late UpdateUserSettings useCase;
  late MockUserSettingsRepository mockRepository;

  const testUser = User(
      name: 'name',
      lastName: 'lastName',
      jobTitle: 'jobTitle',
      primarySkills: [],
      secondarySkills: [],
      bio: 'bio',
      email: 'email');

  setUpAll(() {
    registerFallbackValue(testUser);
  });

  setUp(() {
    mockRepository = MockUserSettingsRepository();
    useCase = UpdateUserSettings(userSettingsRepository: mockRepository);
  });

  test(
    'should return true if the user details have been updated',
    () async {
      // arrange

      when(() => mockRepository.updateUserDetails(any())).thenAnswer((_) => Future.value(const Right(true)));

      // Act
      final result = await useCase(const UpdateUserSettingsParams(user: testUser));

      // assert
      verify(() => mockRepository.updateUserDetails(any()));
      expect(result, const Right(true));
    },
  );
}
