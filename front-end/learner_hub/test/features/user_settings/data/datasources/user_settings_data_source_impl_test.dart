import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:learner_hub/core/error/custom_exceptions.dart';
import 'package:learner_hub/features/user_settings/data/datasources/user_settings_data_source.dart';
import 'package:learner_hub/features/user_settings/data/model/user_model.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockClient extends Mock implements http.Client {}

// Both UserCredentials and Firebase User have private constructors.
// So let's use mocks to be able to create instances of those classes for testing
class MockFirebaseCredentials extends Mock implements UserCredential {}
class MockFirebaseAuth extends Mock implements FirebaseAuth {}
class FakeAuthCredentials extends Fake implements AuthCredential {}
class MockFirebaseUser extends Mock implements User {}

void main() {
  late UserSettingsDataSourceImpl dataSource;
  late MockFirebaseAuth mockAuth;
  late MockClient mockHttpClient;

  void setUpMockHttpClient(String fixtureName, {int statusCode = HttpStatus.ok}) {
    when(() => mockHttpClient.get(any(), headers: any(named: 'headers')))
        .thenAnswer((_) async => http.Response(fixture(fixtureName), statusCode));
  }

  setUpAll(() {
    // Required for HTTP Client mock
    registerFallbackValue(Uri());
    registerFallbackValue(FakeAuthCredentials());
  });

  setUp(() {
    mockAuth = MockFirebaseAuth();
    mockHttpClient = MockClient();
    dataSource = UserSettingsDataSourceImpl(auth: mockAuth, client: mockHttpClient);
  });

  User _createFirebaseUser(String uid, String displayName, String email, String photoUrl) {
    final firebaseUser = MockFirebaseUser();
    when(() => firebaseUser.uid).thenReturn(uid);
    when(() => firebaseUser.displayName).thenReturn(displayName);
    when(() => firebaseUser.email).thenReturn(email);
    when(() => firebaseUser.photoURL).thenReturn(photoUrl);

    return firebaseUser;
  }

  UserCredential _createUserCredentials(String uid, String displayName, String email, String photoUrl) {
    final firebaseUser = _createFirebaseUser(uid, displayName, email, photoUrl);
    final firebaseCredentials = MockFirebaseCredentials();
    when(() => firebaseCredentials.user).thenReturn(firebaseUser);
    return firebaseCredentials;
  }

  group('update user settings', () {
    // Firebase mock data
    const String uid = 'Mk1x5qCzmlTye7vpVRV';
    const String displayName = 'Luke Skywalker';
    const String email = 'luke@jedi.com';
    const String photoUrl = 'https://photoUrl';

    const sampleUser = UserModel(
      name: 'Luke',
      lastName: 'Skywalker',
      jobTitle: 'Jedi',
      bio: 'Master Jedi',
      email: 'luke@jedi.com',
      secondarySkills: [''],
      primarySkills: [''],
    );

    setUp(() {
      // Mock the required info to get the user token
      final mockUser = _createFirebaseUser(uid, displayName, email, photoUrl);
      when(() => mockUser.getIdToken(any())).thenAnswer((_) => Future.value('token'));
      when(() => mockAuth.currentUser).thenReturn(mockUser);
    });

    test('should make a put request to the backend', () async {
      // arrange
      when(() => mockHttpClient.put(any(), headers: any(named: 'headers'), body: any(named: 'body')))
          .thenAnswer((_) async => http.Response('', HttpStatus.ok));

      // act
      await dataSource.updateUserSettings(sampleUser);

      // assert
      verify(() => mockHttpClient.put(any(), headers: any(named: 'headers'), body: any(named: 'body')));
    });

    test("should throw an exception if the server doesn't respond with a HTTP Status Code 200", () async {
      // arrange
      when(() => mockHttpClient.put(any(), headers: any(named: 'headers'), body: any(named: 'body')))
          .thenAnswer((_) async => http.Response('', HttpStatus.internalServerError));

      // act / assert
      expect(() async => dataSource.updateUserSettings(sampleUser), throwsA(predicate((e) => e is ServerException)));
    });
  });

  group('update password', () {
    // Firebase mock data
    const String uid = 'Mk1x5qCzmlTye7vpVRV';
    const String displayName = 'Luke Skywalker';
    const String email = 'luke@jedi.com';
    const String photoUrl = 'https://photoUrl';

    test('should update the user password', () async {
      // arrange
      const oldPassword = 'oldPassword';
      const newPassword = 'newPassword';
      final mockUser = _createFirebaseUser(uid, displayName, email, photoUrl);
      final mockUserCredential = _createUserCredentials(uid, displayName, email, photoUrl);
      when(() => mockUser.updatePassword(any())).thenAnswer((_) => Future.value());
      when(() => mockAuth.currentUser).thenReturn(mockUser);
      when(() => mockUser.reauthenticateWithCredential(any()))
          .thenAnswer((invocation) => Future.value(mockUserCredential));

      // act
      await dataSource.updatePassword(oldPassword, newPassword);

      // assert
      verify(() => mockUser.updatePassword(newPassword));
    });

    test('should throw an exception if the user is not logged', () async {
      // arrange
      const oldPassword = 'oldPassword';
      const newPassword = 'newPassword';
      when(() => mockAuth.currentUser).thenReturn(null);

      // act/assert
      expect(() async => dataSource.updatePassword(oldPassword, newPassword),
          throwsA(predicate((e) => e is ServerException)));
    });
  });

  group('load user info', () {
    // Firebase mock data
    const String uid = 'Mk1x5qCzmlTye7vpVRV';
    const String displayName = 'Luke Skywalker';
    const String email = 'luke@jedi.com';
    const String photoUrl = 'https://photoUrl';

    setUp(() {
      // Mock the required info to get the user token
      final mockUser = _createFirebaseUser(uid, displayName, email, photoUrl);
      when(() => mockUser.getIdToken(any())).thenAnswer((_) => Future.value('token'));
      when(() => mockAuth.currentUser).thenReturn(mockUser);
    });

    test('should load the data from the backend', () async {
      // arrange
      setUpMockHttpClient('user_profile.json');

      // act
      final userInfo = await dataSource.loadUserInfo();

      // assert
      expect(userInfo.name, equals('Luke'));
      expect(userInfo.lastName, equals('Skywalker'));
      expect(userInfo.jobTitle, equals('Master Jedi'));
    });

    test("should throw an exception if the server doesn't respond with a HTTP Status Code 200", () async {
      // arrange
      setUpMockHttpClient('user_profile.json', statusCode: HttpStatus.internalServerError);
      // act / assert
      expect(() async => dataSource.loadUserInfo(), throwsA(predicate((e) => e is ServerException)));
    });

    test('should throw an exception if the server response type is not success', () async {
      // arrange
      setUpMockHttpClient('server_response_error.json');
      // act / assert
      expect(() async => dataSource.loadUserInfo(), throwsA(predicate((e) => e is ServerException)));
    });
  });
}
