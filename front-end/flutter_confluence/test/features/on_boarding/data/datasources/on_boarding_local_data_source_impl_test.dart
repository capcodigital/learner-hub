import 'package:flutter_confluence/core/device.dart';
import 'package:flutter_confluence/core/utils/date_extensions.dart';
import 'package:flutter_confluence/features/onboarding/data/datasources/on_boarding_local_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mocktail/mocktail.dart';

class MockSharedPreferences extends Mock
    implements SharedPreferences {}

class MockLocalAuthentication extends Mock
    implements LocalAuthentication {}

class MockDevice extends Mock
    implements Device {}

void main() {
  late OnBoardingLocalDataSource dataSource;
  late MockSharedPreferences mockPrefs;
  late MockLocalAuthentication mockAuth;
  late MockDevice mockDevice;

  setUp(() {
    mockPrefs = MockSharedPreferences();
    mockAuth = MockLocalAuthentication();
    mockDevice = MockDevice();
    dataSource = OnBoardingLocalDataSourceImpl(auth: mockAuth, prefs: mockPrefs, device: mockDevice);
  });

  group('authenticate', () {
    setUp(() {
      when(() => mockDevice.isMobile).thenReturn(true);
    });

    void mockAuthenticateCall(bool result) {
      when(() => mockAuth.authenticate(
              localizedReason: AUTH_REASON,
              biometricOnly: BIOMETRIC_AUTH_ONLY,
              stickyAuth: true,
              useErrorDialogs: false))
          .thenAnswer((_) async {
        return result;
      });
    }

    void verifyAuthCallDone() {
      verify(() => mockAuth.authenticate(
              localizedReason: AUTH_REASON,
              biometricOnly: BIOMETRIC_AUTH_ONLY,
              stickyAuth: STICKY_AUTH,
              useErrorDialogs: USE_ERROR_DIALOGS))
          .called(1);
    }

    test(
      'Should return true when calling authenticate',
      () async {
        // arrange
        mockAuthenticateCall(true);
        // act
        final result = await dataSource.authenticate();
        // assert
        verifyAuthCallDone();
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
        verifyAuthCallDone();
        expect(result, equals(false));
      },
    );
  });

  group('saveAuthTimeStamp', () {
    test(
      'Should ',
      () async {
        // arrange
        final now = DateTime.parse("2021-01-12 21:12:01");
        CustomizableDateTime.customTime = now;
        when(() => mockPrefs.setInt(any(), any())).thenAnswer((_) => Future.value(true));
        // act
        await dataSource.saveAuthTimeStamp();
        // assert
        verify(() => mockPrefs.setInt(PREF_LAST_BIOMETRIC_AUTH_TIME_MILLIS,
                now.millisecondsSinceEpoch))
            .called(1);
      },
    );
  });

  group('checkAuthTimeStamp', () {
    test(
      'Should return valid cached auth',
      () async {
        // arrange
        final now = DateTime.parse("2021-05-12 20:15:00");
        final lastAuthDate = DateTime.parse("2021-05-12 15:35:00");
        CustomizableDateTime.customTime = now;
        when(() => mockPrefs.getInt(PREF_LAST_BIOMETRIC_AUTH_TIME_MILLIS))
            .thenReturn(lastAuthDate.millisecondsSinceEpoch);
        // act
        final result = await dataSource.checkCachedAuth();
        // assert
        verify(() => mockPrefs.getInt(PREF_LAST_BIOMETRIC_AUTH_TIME_MILLIS))
            .called(1);
        expect(result, equals(true));
      },
    );

    test(
      'Should return expired cached auth',
      () async {
        // arrange
        final now = DateTime.parse("2021-05-16 20:15:00");
        final lastAuthDate = DateTime.parse("2021-05-12 15:35:00");
        CustomizableDateTime.customTime = now;
        when(() => mockPrefs.getInt(PREF_LAST_BIOMETRIC_AUTH_TIME_MILLIS))
            .thenReturn(lastAuthDate.millisecondsSinceEpoch);
        // act
        final result = await dataSource.checkCachedAuth();
        // assert
        verify(() => mockPrefs.getInt(PREF_LAST_BIOMETRIC_AUTH_TIME_MILLIS))
            .called(1);
        expect(result, equals(false));
      },
    );
  });
}
