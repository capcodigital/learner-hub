import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_confluence/features/user_registration/data/datasources/register_user_data_source.dart';
import 'package:flutter_confluence/features/user_registration/data/models/user_registration_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockClient extends Mock implements http.Client {}

// Both UserCredentials and Firebase User have private constructors.
// So let's use mocks to be able to create instances of those classes for testing
class MockFirebaseCredentials extends Mock implements UserCredential {}

class MockFirebaseUser extends Mock implements User {}

void main() {
  late RegisterUserDataSourceImpl dataSource;
  late MockFirebaseAuth mockAuth;
  late MockClient mockHttpClient;

  setUpAll(() {
    // Required for HTTP Client mock
    registerFallbackValue(Uri());
  });

  setUp(() {
    mockAuth = MockFirebaseAuth();
    mockHttpClient = MockClient();
    dataSource = RegisterUserDataSourceImpl(auth: mockAuth, client: mockHttpClient);
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

  group('register user in firebase', () {
    const String uid = 'Mk1x5qCzmlTye7vpVRV';
    const String displayName = 'Luke Skywalker';
    const String email = 'luke@jedi.com';
    const String photoUrl = 'https://photoUrl';

    test('should return the user when email and password are valid', () async {
      // arrange
      final mockCredential = _createUserCredentials(uid, displayName, email, photoUrl);
      when(() => mockAuth.createUserWithEmailAndPassword(email: any(named: 'email'), password: any(named: 'password')))
          .thenAnswer((_) => Future.value(mockCredential));

      // act
      final result = await dataSource.registerFirebaseUser('email', 'password');

      // assert
      expect(result, mockCredential.user);
    });

    test('should return the user when email and password are valid', () async {
      // arrange
      final mockCredential = _createUserCredentials(uid, displayName, email, photoUrl);
      when(() => mockAuth.createUserWithEmailAndPassword(email: any(named: 'email'), password: any(named: 'password')))
          .thenAnswer((_) => Future.value(mockCredential));

      // act
      final result = await dataSource.registerFirebaseUser('email', 'password');

      // assert
      expect(result, mockCredential.user);
    });
  });

  group('create user in custom backend', () {
    const String uid = 'Mk1x5qCzmlTye7vpVRV';
    const String displayName = 'Luke Skywalker';
    const String email = 'luke@jedi.com';
    const String photoUrl = 'https://photoUrl';

    const String name = 'Luke';
    const String lastName = 'Skywalker';
    const String jobTitle = 'Master Jedi';
    const List<String> primarySkills = [];
    const List<String> secondarySkills = [];
    const String bio = 'Master Jedi';
    const String password = '123456';

    test(
        'should return a failure when creating a user '
        'and email does not exist', () async {
      // Arrange
      final mockUser = _createFirebaseUser(uid, displayName, email, photoUrl);
      when(() => mockUser.getIdToken(any())).thenAnswer((_) => Future.value('token'));
      when(() => mockAuth.currentUser).thenReturn(mockUser);

      when(() => mockHttpClient
          .post(any(),
                headers: any(named: 'headers'),
                body: any(named: 'body')))
          .thenAnswer((_) async => http.Response('true', HttpStatus.created));

      // Act
      final result = await dataSource.createUser(UserRegistrationModel(
          name: name,
          lastName: lastName,
          jobTitle: jobTitle,
          primarySkills: primarySkills,
          secondarySkills: secondarySkills,
          bio: bio,
          email: email,
          password: password));

      // Assert
      expect(result, true);
    });
  });
}
