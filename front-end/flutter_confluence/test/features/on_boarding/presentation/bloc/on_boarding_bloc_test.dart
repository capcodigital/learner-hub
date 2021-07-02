import 'package:dartz/dartz.dart';
import 'package:flutter_confluence/core/usecases/usecase.dart';
import 'package:flutter_confluence/features/onboarding/domain/usecases/authenticate_use_case.dart';
import 'package:flutter_confluence/features/onboarding/domain/usecases/check_cached_auth_use_case.dart';
import 'package:flutter_confluence/features/onboarding/presentation/bloc/on_boarding_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'on_boarding_bloc_test.mocks.dart';

@GenerateMocks([AuthenticateUseCase, CheckCachedAuthUseCase])
void main() {

  late MockAuthenticateUseCase mockAuthenticateCase;
  late MockCheckCachedAuthUseCase mockCheckCachedAuthCase;
  late OnBoardingBloc bloc;

  setUp(() {
    mockAuthenticateCase = MockAuthenticateUseCase();
    mockCheckCachedAuthCase = MockCheckCachedAuthUseCase();
    bloc = OnBoardingBloc(
        authUseCase: mockAuthenticateCase,
        checkAuthUseCase: mockCheckCachedAuthCase
    );
  });

  test('initial bloc state should be Empty', () {

  });

  group('', () {
    test(
      'Should call the Authentication use case',
      () async {
        // arrange
        when(mockAuthenticateCase(any))
            .thenAnswer((_) async => Right(true));
        // act
        bloc.add((AuthenticationEvent()));
        await untilCalled(mockAuthenticateCase(any));
        // assert
        verify(mockAuthenticateCase(NoParams()));
      },
    );

    test(
      'Should call the CheckCachedAuth use case',
          () async {
        // arrange
        when(mockCheckCachedAuthCase(any))
            .thenAnswer((_) async => Right(true));
        // act
        bloc.add((CheckCachedAuthEvent()));
        await untilCalled(mockCheckCachedAuthCase(any));
        // assert
        verify(mockCheckCachedAuthCase(NoParams()));
      },
    );

  });
}