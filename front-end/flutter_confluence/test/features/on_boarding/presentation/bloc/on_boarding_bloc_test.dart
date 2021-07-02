import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_confluence/core/usecases/usecase.dart';
import 'package:flutter_confluence/features/onboarding/domain/usecases/auth_use_case.dart';
import 'package:flutter_confluence/features/onboarding/domain/usecases/check_auth_use_case.dart';
import 'package:flutter_confluence/features/onboarding/presentation/bloc/on_boarding_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'on_boarding_bloc_test.mocks.dart';

@GenerateMocks([AuthUseCase, CheckAuthUseCase])
void main() {
  late MockAuthUseCase mockAuthCase;
  late MockCheckAuthUseCase mockCheckAuthCase;
  late OnBoardingBloc bloc;

  final orderCompleted = [
    Loading(),
    Completed(),
  ];

  final orderFailure = [
    Loading(),
    Error(message: 'error'),
  ];

  setUp(() {
    mockAuthCase = MockAuthUseCase();
    mockCheckAuthCase = MockCheckAuthUseCase();
    bloc = OnBoardingBloc(
        authUseCase: mockAuthCase,
        checkAuthUseCase: mockCheckAuthCase);
  });

  test('initial bloc state should be Empty', () {
    expect(bloc.state, equals(Empty()));
  });

  group('AuthenticationEvent', () {

    void stabMockAuthenticateCase(bool result) {
      when(mockAuthCase(any)).thenAnswer((_) async => Right(result));
    }

    test(
      'Should call the Authentication use case',
      () async {
        // arrange
        stabMockAuthenticateCase(true);
        // act
        bloc.add((AuthEvent()));
        await untilCalled(mockAuthCase(any));
        // assert
        verify(mockAuthCase(NoParams()));
      },
    );

    blocTest(
      'should emit Loading, Completed',
      build: () {
        stabMockAuthenticateCase(true);
        return bloc;
      },
      act: (OnBoardingBloc bloc) =>
      {bloc.add(AuthEvent())},
      expect: () => orderCompleted,
    );

    blocTest(
      'should emit Loading, Error',
      build: () {
        stabMockAuthenticateCase(false);
        return bloc;
      },
      act: (OnBoardingBloc bloc) =>
      {bloc.add(AuthEvent())},
      expect: () => orderFailure,
    );

  });

  group('CheckCachedAuthEvent', () {

    void stabMockCheckCachedAuthCase(bool result) {
      when(mockCheckAuthCase(any)).thenAnswer((_) async => Right(result));
    }

    test(
      'Should call the CheckCachedAuth use case',
      () async {
        // arrange
        stabMockCheckCachedAuthCase(true);
        // act
        bloc.add((CheckAuthEvent()));
        await untilCalled(mockCheckAuthCase(any));
        // assert
        verify(mockCheckAuthCase(NoParams()));
      },
    );

    blocTest(
      'should emit Loading, Completed',
      build: () {
        stabMockCheckCachedAuthCase(true);
        return bloc;
      },
      act: (OnBoardingBloc bloc) =>
      {bloc.add(CheckAuthEvent())},
      expect: () => orderCompleted,
    );

    blocTest(
      'should emit Loading, Error',
      build: () {
        stabMockCheckCachedAuthCase(false);
        return bloc;
      },
      act: (OnBoardingBloc bloc) =>
      {bloc.add(CheckAuthEvent())},
      expect: () => orderFailure,
    );

  });
}
