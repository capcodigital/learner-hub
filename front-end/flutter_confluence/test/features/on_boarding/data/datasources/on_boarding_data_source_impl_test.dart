import 'package:flutter_test/flutter_test.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mockito/annotations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_confluence/features/onboarding/data/datasources/on_boarding_data_source.dart';

import 'on_boarding_data_source_impl_test.mocks.dart';

@GenerateMocks([SharedPreferences, LocalAuthentication])
void main() {
  late OnBoardingDataSourceImpl dataSource;
  late MockSharedPreferences mockSharedPreferences;
  late MockLocalAuthentication mockLocalAuthentication;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    mockLocalAuthentication = MockLocalAuthentication();
    dataSource = OnBoardingDataSourceImpl(
        auth: mockLocalAuthentication, prefs: mockSharedPreferences);
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
