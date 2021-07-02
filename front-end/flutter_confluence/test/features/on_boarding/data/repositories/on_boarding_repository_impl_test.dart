import 'package:flutter_confluence/features/onboarding/data/datasources/on_boarding_data_source.dart';
import 'package:flutter_confluence/features/onboarding/data/repositories/on_boarding_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'on_boarding_repository_impl_test.mocks.dart';

@GenerateMocks([OnBoardingDataSource])
void main() {
  late OnBoardingRepositoryImpl repository;
  late MockOnBoardingDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockOnBoardingDataSource();
    repository = OnBoardingRepositoryImpl(onBoardingDataSource: mockDataSource);
  });

  group('', () {
    setUp(() {

    });

    test(
        '',
        () async {
      // arrange

      // act

      // assert

    });

  });

}
