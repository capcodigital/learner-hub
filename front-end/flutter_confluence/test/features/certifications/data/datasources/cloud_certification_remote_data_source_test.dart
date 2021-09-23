import 'package:flutter_confluence/core/constants.dart';
import 'package:flutter_confluence/core/error/custom_exceptions.dart';
import 'package:flutter_confluence/features/certifications/data/datasources/cloud_certification_remote_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockClient extends Mock implements http.Client {}

void main() {
  const STATUS_CODE_224 = 224;
  const STATUS_CODE_357 = 357;
  const NUM_OF_COMPLETED_CERT = 40;
  const NUM_OF_IN_PROGRESS_CERT = 35;

  late CloudCertificationRemoteDataSourceImpl dataSource;
  late MockClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockClient();
    dataSource = CloudCertificationRemoteDataSourceImpl(client: mockHttpClient);
    registerFallbackValue<Uri>(Uri());
  });

  void setUpMockHttpClient(String fixtureName,
      {int statusCode = Constants.STATUS_CODE_200}) {
    when(() => mockHttpClient.get(any(), headers: any(named: 'headers')))
        .thenAnswer(
            (_) async => http.Response(fixture(fixtureName), statusCode));
  }

  group('getCompletedCertifications', () {
    test(
      'should return a list of completed certifications when the response code is 200 (success)',
      () async {
        setUpMockHttpClient('completed.json');
        final result = await dataSource.getCompletedCertifications();
        expect(result.length, equals(NUM_OF_COMPLETED_CERT));
      },
    );

    test(
      'should return a generic ServerException when status code is '
      'not 200 (success), 500, 404',
      () {
        setUpMockHttpClient('completed.json', statusCode: STATUS_CODE_224);
        expect(
            () async => dataSource.getCompletedCertifications(),
            throwsA(predicate((e) =>
                e is ServerException &&
                e.message == Constants.SERVER_FAILURE_MSG)));
      },
    );

    test(
      'should return a ServerException for 500 when status code is 500',
      () {
        setUpMockHttpClient('completed.json',
            statusCode: Constants.STATUS_CODE_500);
        expect(
            () async => dataSource.getCompletedCertifications(),
            throwsA(predicate((e) =>
                e is ServerException &&
                e.message == Constants.SERVER_ERROR_500)));
      },
    );

    test(
      'should return a ServerException for 404 when status code is 404',
      () {
        setUpMockHttpClient('completed.json',
            statusCode: Constants.STATUS_CODE_404);
        expect(
            () async => dataSource.getCompletedCertifications(),
            throwsA(predicate((e) =>
                e is ServerException &&
                e.message == Constants.SERVER_ERROR_404)));
      },
    );
  });

  group('getInProgressCertifications', () {
    test(
      'should return a list of in progress certifications when the response code is 200 (success)',
      () async {
        setUpMockHttpClient('in_progress.json');
        final result = await dataSource.getInProgressCertifications();
        expect(result.length, equals(NUM_OF_IN_PROGRESS_CERT));
      },
    );

    test(
      'should return a generic ServerException when status code is not 200 (success), '
      '500, 404',
      () {
        setUpMockHttpClient('in_progress.json', statusCode: STATUS_CODE_357);
        expect(
            () async => dataSource.getInProgressCertifications(),
            throwsA(predicate((e) =>
                e is ServerException &&
                e.message == Constants.SERVER_FAILURE_MSG)));
      },
    );

    test(
      'should return a ServerException for 500 when status code is 500',
      () {
        setUpMockHttpClient('in_progress.json',
            statusCode: Constants.STATUS_CODE_500);
        expect(
            () async => dataSource.getInProgressCertifications(),
            throwsA(predicate((e) =>
                e is ServerException &&
                e.message == Constants.SERVER_ERROR_500)));
      },
    );

    test(
      'should return a ServerException for 404 when status code is 404',
      () {
        setUpMockHttpClient('in_progress.json',
            statusCode: Constants.STATUS_CODE_404);
        expect(
            () async => dataSource.getInProgressCertifications(),
            throwsA(predicate((e) =>
                e is ServerException &&
                e.message == Constants.SERVER_ERROR_404)));
      },
    );
  });
}
