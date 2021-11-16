import 'package:dartz/dartz.dart';
import 'package:flutter_confluence/features/user_settings/domain/repositories/user_settings_repository.dart';
import 'package:flutter_confluence/features/user_settings/domain/usecases/update_password.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockUserSettingsRepository extends Mock implements UserSettingsRepository {}

void main() {
  late UpdatePassword useCase;
  late MockUserSettingsRepository mockRepository;

  setUp(() {
    mockRepository = MockUserSettingsRepository();
    useCase = UpdatePassword(userSettingsRepository: mockRepository);
  });

  test(
    'should return true if the password have been updated',
    () async {
      // arrange
      when(() => mockRepository.updatePassword(any(), any())).thenAnswer((_) => Future.value(const Right(true)));

      // Act
      final result = await useCase(const UpdatePasswordParams(oldPassword: 'oldPassword', newPassword: 'newPassword'));

      // assert
      verify(() => mockRepository.updatePassword(any(), any()));
      expect(result, const Right(true));
    },
  );
}
