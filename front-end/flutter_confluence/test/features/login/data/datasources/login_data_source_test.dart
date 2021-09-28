import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_confluence/core/auth/auth_failures.dart';
import 'package:flutter_confluence/features/login/data/datasource/login_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

// Both UserCredentials and Firebase User have private constructors.
// So let's use mocks to be able to create instances of those classes for testing
class MockFirebaseCredentials extends Mock implements UserCredential {}

class MockFirebaseUser extends Mock implements User {}

void main() {
  late LoginDataSourceImpl dataSource;
  late MockFirebaseAuth mockFirebaseAuth;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    dataSource = LoginDataSourceImpl(auth: mockFirebaseAuth);
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

  // group('register', () {
  //   const String uid = 'Mk1x5qCzmlTye7vpVRV';
  //   const String displayName = 'Luke Skywalker';
  //   const String email = 'luke@jedi.com';
  //   const String photoUrl = 'https://photoUrl';
  //
  //   final firebaseCredentials = _createUserCredentials(uid, displayName, email, photoUrl);
  //   const expectedUser = User(uid: uid, displayName: displayName, email: email, photoUrl: photoUrl);
  //
  //   test(
  //       'should return a failure when registering a new user '
  //       'and email is already registered', () async {
  //     // arrange
  //     when(() => mockFirebaseAuth.createUserWithEmailAndPassword(
  //         email: any(named: 'email'),
  //         password: any(named: 'password'))).thenThrow(firebase.FirebaseAuthException(code: 'email-already-in-use'));
  //     // act
  //     final result = await data.registerUser('email', 'password');
  //     // assert
  //     expect(result, equals(Left(AlreadyRegisteredFailure())));
  //   });
  //
  //   test(
  //       'should return a failure when registering a new user '
  //       'and password is too weak', () async {
  //     // arrange
  //     when(() => mockFirebaseAuth.createUserWithEmailAndPassword(
  //         email: any(named: 'email'),
  //         password: any(named: 'password'))).thenThrow(firebase.FirebaseAuthException(code: 'weak-password'));
  //     // act
  //     final result = await authManager.registerUser('email', 'password');
  //     // assert
  //     expect(result, equals(Left(WeakPasswordFailure())));
  //   });
  //
  //   test(
  //       'should return an user when registering a new user '
  //       'and the user is not already registered '
  //       'and password is strong enough', () async {
  //     // arrange
  //     when(() => mockFirebaseAuth.createUserWithEmailAndPassword(
  //         email: any(named: 'email'),
  //         password: any(named: 'password'))).thenAnswer((_) => Future.value(firebaseCredentials));
  //     // act
  //     final result = await authManager.registerUser('email', 'password');
  //     // assert
  //     expect(result.isRight(), true);
  //     result.fold((l) => throwsAssertionError, (r) => expect(r, expectedUser));
  //   });
  // });

  group('login', () {
    const String uid = 'Mk1x5qCzmlTye7vpVRV';
    const String displayName = 'Luke Skywalker';
    const String email = 'luke@jedi.com';
    const String photoUrl = 'https://photoUrl';

    final firebaseCredentials = _createUserCredentials(uid, displayName, email, photoUrl);

    test(
        'should return a failure when login a user '
        'and email does not exist', () async {
      // arrange
      when(() =>
              mockFirebaseAuth.signInWithEmailAndPassword(email: any(named: 'email'), password: any(named: 'password')))
          .thenThrow(FirebaseAuthException(code: 'user-not-found'));
      // act
      final result = await dataSource.signInWithEmailAndPassword('email', 'password');
      // assert
      expect(result, equals(Left(InvalidEmailFailure())));
    });

    test(
        'should return a failure when login a user '
        'and password is wrong', () async {
      // arrange
      when(() =>
              mockFirebaseAuth.signInWithEmailAndPassword(email: any(named: 'email'), password: any(named: 'password')))
          .thenThrow(FirebaseAuthException(code: 'wrong-password'));
      // act
      final result = await dataSource.signInWithEmailAndPassword('email', 'password');
      // assert
      expect(result, equals(Left(InvalidPasswordFailure())));
    });

    test('should return an user when signIn with valid credentials', () async {
      // arrange
      when(() =>
              mockFirebaseAuth.signInWithEmailAndPassword(email: any(named: 'email'), password: any(named: 'password')))
          .thenAnswer((_) => Future.value(firebaseCredentials));
      // act
      final result = await dataSource.signInWithEmailAndPassword('email', 'password');
      // assert
      expect(result.isRight(), true);
      result.fold((l) => throwsAssertionError, (r) {
        expect(r.uid, uid);
      });
    });
  });
}
