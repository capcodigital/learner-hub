import 'package:dartz/dartz.dart';
import 'package:flutter_confluence/core/error/failures.dart';
import 'package:flutter_confluence/core/network/network_info.dart';
import 'package:flutter_confluence/features/user_settings/data/datasources/user_settings_data_source.dart';
import 'package:flutter_confluence/features/user_settings/data/model/user_model.dart';
import 'package:flutter_confluence/features/user_settings/data/repositories/user_settings_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockUserSettingsDataSource extends Mock implements UserSettingsDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late UserSettingsRepositoryImpl repository;
  late MockUserSettingsDataSource mockDataSource;
  late MockNetworkInfo mockNetworkInfo;

  const sampleUser = UserModel(
      name: 'name',
      lastName: 'lastName',
      jobTitle: 'jobTitle',
      primarySkills: [''],
      secondarySkills: [''],
      bio: 'bio',
      email: 'email');

  setUpAll(() {
    registerFallbackValue(sampleUser);
  });

  setUp(() {
    mockDataSource = MockUserSettingsDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = UserSettingsRepositoryImpl(dataSource: mockDataSource, networkInfo: mockNetworkInfo);
  });

  group('getCurrentUser', () {
    setUp(() {
      when(() => mockDataSource.loadUserInfo()).thenAnswer((_) async => sampleUser);
    });

    test('should return the user info when is connected to the internet', () async {
      // arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);

      // act
      final result = await repository.getCurrentUser();

      // assert
      verify(() => mockDataSource.loadUserInfo());
      expect(result, const Right(sampleUser));
    });

    test('should returns a NoInternetFailure when there is not internet connection', () async {
      // arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      // act
      final result = await repository.getCurrentUser();

      //  assert
      verifyNever(() => mockDataSource.loadUserInfo());
      expect(result, Left(NoInternetFailure()));
    });
  });

  group('updatePassword', () {
    setUp(() {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockDataSource.updatePassword(any(), any())).thenAnswer((_) async => {});
    });

    test('should return true when the user password has been updated', () async {
      // arrange
      const oldPassword = 'oldPassword';
      const newPassword = 'newPassword';

      // act
      final result = await repository.updatePassword(oldPassword, newPassword);

      // assert
      verify(() => mockDataSource.updatePassword(oldPassword, newPassword));
      expect(result, const Right(true));
    });

    test('should returns a NoInternetFailure when there is not internet connection', () async {
      // arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      // act
      final result = await repository.updatePassword('old password', 'new password');

      //  assert
      verifyNever(() => mockDataSource.updatePassword(any(), any()));
      expect(result, Left(NoInternetFailure()));
    });
  });

  group('updateUserDetails', () {
    setUp(() {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockDataSource.updateUserSettings(any())).thenAnswer((_) async => {});
    });

    test('should return true when the user password has been updated', () async {
      // arrange

      // act
      final result = await repository.updateUserDetails(sampleUser);

      // assert
      verify(() => mockDataSource.updateUserSettings(sampleUser));
      expect(result, const Right(true));
    });

    test('should returns a NoInternetFailure when there is not internet connection', () async {
      // arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      // act
      final result = await repository.updateUserDetails(sampleUser);

      //  assert
      verifyNever(() => mockDataSource.updatePassword(any(), any()));
      expect(result, Left(NoInternetFailure()));
    });
  });
}
