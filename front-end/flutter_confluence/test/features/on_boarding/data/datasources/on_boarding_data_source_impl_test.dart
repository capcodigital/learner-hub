import 'package:flutter_confluence/core/time/time_info.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_confluence/features/onboarding/data/datasources/on_boarding_local_data_source.dart';

import 'on_boarding_data_source_impl_test.mocks.dart';

@GenerateMocks([SharedPreferences, LocalAuthentication, TimeInfo])
void main() {
  late OnBoardingLocalDataSourceImpl dataSource;
  late MockSharedPreferences mockPrefs;
  late MockLocalAuthentication mockAuth;
  late MockTimeInfo mockTimer;

  setUp(() {
    mockPrefs = MockSharedPreferences();
    mockAuth = MockLocalAuthentication();
    mockTimer = MockTimeInfo();
    dataSource = OnBoardingLocalDataSourceImpl(
        auth: mockAuth, prefs: mockPrefs, timeInfo: mockTimer);
  });

  group('authenticate', () {

    void mockAuthenticateCall(bool result) {
      when(mockAuth.authenticate(
          localizedReason: AUTH_REASON, biometricOnly: BIOMETRIC_AUTH_ONLY))
          .thenAnswer((_) async {
        return result;
      });
    }

    test(
      'Should return true when calling authenticate',
      () async {
        // arrange
        mockAuthenticateCall(true);
        // act
        final result = await dataSource.authenticate();
        // assert
        verify(mockAuth.authenticate(
                localizedReason: AUTH_REASON, biometricOnly: BIOMETRIC_AUTH_ONLY))
            .called(1);
        expect(result, equals(true));
      },
    );

    test(
      'Should return false when calling authenticate',
      () async {
        // arrange
        mockAuthenticateCall(false);
        // act
        final result = await dataSource.authenticate();
        // assert
        verify(mockAuth.authenticate(
                localizedReason: AUTH_REASON, biometricOnly: BIOMETRIC_AUTH_ONLY))
            .called(1);
        expect(result, equals(false));
      },
    );
  });

  group('saveAuthTimeStamp', () {
    test(
      'Should ',
      () async {
        // arrange
        when(mockPrefs.setInt(any, any)).thenAnswer((_) => Future.value(true));
        when(mockTimer.currentTimeMillis).thenReturn(100);
        // act
        await dataSource.saveAuthTimeStamp();
        // assert
        verify(mockPrefs.setInt(PREF_LAST_BIOMETRIC_AUTH_TIME_MILLIS, 100))
            .called(1);
      },
    );
  });

  group('checkAuthTimeStamp', () {
    test(
      'Should return valid cached auth',
      () async {
        // arrange
        when(mockPrefs.getInt(any)).thenReturn(1000);
        when(mockTimer.currentTimeMillis).thenReturn(ONE_DAY_MILLIS);
        // act
        final result = await dataSource.checkCachedAuth();
        // assert
        verify(mockPrefs.getInt(PREF_LAST_BIOMETRIC_AUTH_TIME_MILLIS)).called(1);
        expect(result, equals(true));
      },
    );

    test(
      'Should return expired cached auth',
      () async {
        // arrange
        when(mockPrefs.getInt(any)).thenReturn(1000);
        when(mockTimer.currentTimeMillis).thenReturn(ONE_DAY_MILLIS + 1100);
        // act
        final result = await dataSource.checkCachedAuth();
        // assert
        verify(mockPrefs.getInt(PREF_LAST_BIOMETRIC_AUTH_TIME_MILLIS)).called(1);
        expect(result, equals(false));
      },
    );
  });

  group('clearCachedAuth', () {
    test(
      'Should clear cached auth timestamp',
      () async {
        // arrange
        when(mockPrefs.remove(any)).thenAnswer((_) => Future.value(true));
        // act
        await dataSource.clearCachedAuth();
        // assert
        verify(mockPrefs.remove(PREF_LAST_BIOMETRIC_AUTH_TIME_MILLIS)).called(1);
      },
    );
  });
}
