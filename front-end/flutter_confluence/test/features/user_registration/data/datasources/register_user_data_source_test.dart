import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_confluence/features/user_registration/data/datasources/register_user_data_source.dart';
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

  // group('create user in custom backend', () {
  //   const String uid = 'Mk1x5qCzmlTye7vpVRV';
  //   const String displayName = 'Luke Skywalker';
  //   const String email = 'luke@jedi.com';
  //   const String photoUrl = 'https://photoUrl';
  //
  //   final firebaseCredentials = _createUserCredentials(uid, displayName, email, photoUrl);
  //
  //   test(
  //       'should return a failure when login a user '
  //       'and email does not exist', () async {
  //     when(() => mockAuth.signInWithEmailAndPassword(email: any(named: 'email'), password: any(named: 'password')))
  //         .thenThrow(FirebaseAuthException(code: 'user-not-found'));
  //     expect(dataSource.signInWithEmailAndPassword('email', 'password'),
  //         throwsA(const TypeMatcher<InvalidEmailFailure>()));
  //   });
  //
  //   test(
  //       'should return a failure when login a user '
  //       'and password is wrong', () async {
  //     when(() => mockAuth.signInWithEmailAndPassword(email: any(named: 'email'), password: any(named: 'password')))
  //         .thenThrow(FirebaseAuthException(code: 'wrong-password'));
  //
  //     expect(dataSource.signInWithEmailAndPassword('email', 'password'),
  //         throwsA(const TypeMatcher<InvalidPasswordFailure>()));
  //   });
  //
  //   test('should return an user when signIn with valid credentials', () async {
  //     // arrange
  //     when(() => mockAuth.signInWithEmailAndPassword(email: any(named: 'email'), password: any(named: 'password')))
  //         .thenAnswer((_) => Future.value(firebaseCredentials));
  //     // act
  //     final user = await dataSource.signInWithEmailAndPassword('email', 'password');
  //     // assert
  //     expect(user.uid, uid);
  //   });
  // });
}
