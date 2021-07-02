import 'package:flutter_confluence/features/onboarding/domain/usecases/authenticate_use_case.dart';
import 'package:flutter_confluence/features/onboarding/domain/usecases/check_cached_auth_use_case.dart';
import 'package:flutter_confluence/features/onboarding/presentation/bloc/on_boarding_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';

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
      '',
      () async {
        // arrange

        // act

        // assert

      },
    );

  });
}