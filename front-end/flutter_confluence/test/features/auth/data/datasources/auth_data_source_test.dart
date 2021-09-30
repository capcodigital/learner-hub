import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_confluence/core/error/auth_failures.dart';
import 'package:flutter_confluence/features/auth/data/datasources/auth_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

// Both UserCredentials and Firebase User have private constructors.
// So let's use mocks to be able to create instances of those classes for testing
class MockFirebaseCredentials extends Mock implements UserCredential {}

class MockFirebaseUser extends Mock implements User {}

void main() {
  late AuthDataSource dataSource;
  late MockFirebaseAuth mockAuth;

  setUp(() {
    mockAuth = MockFirebaseAuth();
    dataSource = FirebaseAuthDataSourceImpl(auth: mockAuth);
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

  group('check user logged persistence', () {
    const String uid = 'Mk1x5qCzmlTye7vpVRV';
    const String displayName = 'Luke Skywalker';
    const String email = 'luke@jedi.com';
    const String photoUrl = 'https://photoUrl';

    test('should return true when there is a current logged user', () async {
      // arrange
      final mockUser = _createFirebaseUser(uid, displayName, email, photoUrl);
      when(() => mockAuth.currentUser).thenReturn(mockUser);

      // act
      final result = await dataSource.checkLocalUserLogged();

      // assert
      expect(result, true);
    });

    test('should return false when there is not a current logged user', () async {
      // arrange
      when(() => mockAuth.currentUser).thenReturn(null);

      // act
      final result = await dataSource.checkLocalUserLogged();

      // assert
      expect(result, false);
    });
  });

  group('login', () {
    const String uid = 'Mk1x5qCzmlTye7vpVRV';
    const String displayName = 'Luke Skywalker';
    const String email = 'luke@jedi.com';
    const String photoUrl = 'https://photoUrl';

    final firebaseCredentials = _createUserCredentials(uid, displayName, email, photoUrl);

    test(
        'should return a failure when login a user '
        'and email does not exist', () async {
      when(() => mockAuth.signInWithEmailAndPassword(email: any(named: 'email'), password: any(named: 'password')))
          .thenThrow(FirebaseAuthException(code: 'user-not-found'));
      expect(dataSource.signInWithEmailAndPassword('email', 'password'),
          throwsA(const TypeMatcher<InvalidEmailFailure>()));
    });

    test(
        'should return a failure when login a user '
        'and password is wrong', () async {
      when(() => mockAuth.signInWithEmailAndPassword(email: any(named: 'email'), password: any(named: 'password')))
          .thenThrow(FirebaseAuthException(code: 'wrong-password'));

      expect(dataSource.signInWithEmailAndPassword('email', 'password'),
          throwsA(const TypeMatcher<InvalidPasswordFailure>()));
    });

    test('should return an user when signIn with valid credentials', () async {
      // arrange
      when(() => mockAuth.signInWithEmailAndPassword(email: any(named: 'email'), password: any(named: 'password')))
          .thenAnswer((_) => Future.value(firebaseCredentials));
      // act
      final user = await dataSource.signInWithEmailAndPassword('email', 'password');
      // assert
      expect(user.uid, uid);
    });
  });
}
