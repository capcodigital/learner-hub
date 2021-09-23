import 'package:flutter_confluence/core/device.dart';
import 'package:flutter_confluence/core/utils/extensions/date_extensions.dart';
import 'package:flutter_confluence/features/onboarding/data/datasources/bio_auth_hive_helper.dart';
import 'package:flutter_confluence/features/onboarding/data/datasources/on_boarding_local_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mocktail/mocktail.dart';

class MockBioAuthHiveHelper extends Mock implements BioAuthHiveHelper {}

class MockLocalAuthentication extends Mock implements LocalAuthentication {}

class MockDevice extends Mock implements Device {}

void main() {
  late OnBoardingLocalDataSource dataSource;
  late MockBioAuthHiveHelper mockHiveHelper;
  late MockLocalAuthentication mockAuth;
  late MockDevice mockDevice;

  setUp(() {
    mockHiveHelper = MockBioAuthHiveHelper();
    mockAuth = MockLocalAuthentication();
    mockDevice = MockDevice();
    dataSource = OnBoardingLocalDataSourceImpl(
        auth: mockAuth, authHiveHelper: mockHiveHelper, device: mockDevice);
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
          useErrorDialogs: false)).thenAnswer((_) async {
        return result;
      });
    }

    void verifyAuthCallDone() {
      verify(() => mockAuth.authenticate(
          localizedReason: AUTH_REASON,
          biometricOnly: BIOMETRIC_AUTH_ONLY,
          stickyAuth: STICKY_AUTH,
          useErrorDialogs: USE_ERROR_DIALOGS)).called(1);
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
        final now = DateTime.parse('2021-01-12 21:12:01');
        CustomizableDateTime.customTime = now;
        when(() => mockHiveHelper.save(any()))
            .thenAnswer((_) => Future.value(true));
        // act
        await dataSource.saveAuthTimeStamp();
        // assert
        verify(() => mockHiveHelper.save(now.millisecondsSinceEpoch)).called(1);
      },
    );
  });

  group('checkAuthTimeStamp', () {
    test(
      'Should return valid cached auth',
      () async {
        // arrange
        final now = DateTime.parse('2021-05-12 20:15:00');
        final lastAuthDate = DateTime.parse('2021-05-12 15:35:00');
        CustomizableDateTime.customTime = now;
        when(() => mockHiveHelper.getLatestBioAuthTime()).thenAnswer(
            (_) => Future.value(lastAuthDate.millisecondsSinceEpoch));
        // act
        final result = await dataSource.checkCachedAuth();
        // assert
        verify(() => mockHiveHelper.getLatestBioAuthTime()).called(1);
        expect(result, equals(true));
      },
    );

    test(
      'Should return expired cached auth',
      () async {
        // arrange
        final now = DateTime.parse('2021-05-16 20:15:00');
        final lastAuthDate = DateTime.parse('2021-05-12 15:35:00');
        CustomizableDateTime.customTime = now;
        when(() => mockHiveHelper.getLatestBioAuthTime()).thenAnswer(
            (_) => Future.value(lastAuthDate.millisecondsSinceEpoch));
        // act
        final result = await dataSource.checkCachedAuth();
        // assert
        verify(() => mockHiveHelper.getLatestBioAuthTime()).called(1);
        expect(result, equals(false));
      },
    );
  });
}
