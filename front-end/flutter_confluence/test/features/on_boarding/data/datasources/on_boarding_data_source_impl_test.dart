import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_auth/error_codes.dart' as auth_error;

import 'package:flutter_confluence/features/onboarding/data/datasources/on_boarding_data_source.dart';

import 'on_boarding_data_source_impl_test.mocks.dart';

@GenerateMocks([SharedPreferences, LocalAuthentication])
void main() {
  late OnBoardingDataSourceImpl dataSource;
  late MockSharedPreferences mockPrefs;
  late MockLocalAuthentication mockAuth;

  setUp(() {
    mockPrefs = MockSharedPreferences();
    mockAuth = MockLocalAuthentication();
    dataSource = OnBoardingDataSourceImpl(auth: mockAuth, prefs: mockPrefs);
  });

  void stabMockAuth(bool result) {
    when(mockAuth.authenticate(
            localizedReason: 'Please authenticate to proceed',
            biometricOnly: true))
        .thenAnswer((_) async {
      return result;
    });
  }

  group('', () {

    test(
      'Should return true when calling authenticate',
      () async {
        // arrange
        stabMockAuth(true);
        // act
        final result = await dataSource.authenticate();
        // assert
        verify(mockAuth.authenticate(
                localizedReason: 'Please authenticate to proceed',
                biometricOnly: true))
            .called(1);
        expect(result, equals(true));
      },
    );

    test(
      'Should return false when calling authenticate',
      () async {
        // arrange
        stabMockAuth(false);
        // act
        final result = await dataSource.authenticate();
        // assert
        verify(mockAuth.authenticate(
                localizedReason: 'Please authenticate to proceed',
                biometricOnly: true))
            .called(1);
        expect(result, equals(false));
      },
    );

  });
}
