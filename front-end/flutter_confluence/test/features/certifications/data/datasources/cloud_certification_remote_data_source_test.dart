import 'package:flutter_confluence/core/constants.dart';
import 'package:flutter_confluence/core/error/custom_exceptions.dart';
import 'package:flutter_confluence/features/certifications/data/datasources/cloud_certification_remote_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/FixtureReader.dart';
import 'cloud_certification_remote_data_source_test.mocks.dart';

/*
------------------
When using GenerateMocks(), you will need to run this command so the runner
can generate the mocks:

$pub run build_runner build

More information here: - https://github.com/dart-lang/mockito/blob/master/NULL_SAFETY_README.md
------------------
*/
@GenerateMocks([http.Client])
void main() {
  late CloudCertificationRemoteDataSourceImpl dataSource;
  late MockClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockClient();
    dataSource = CloudCertificationRemoteDataSourceImpl(client: mockHttpClient);
  });

  void setUpMockHttpClient(String fixtureName, {int statusCode = 200}) {
    when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
        (_) async => http.Response(fixture(fixtureName), statusCode));
  }

  group('getCompletedCertifications', () {
    test(
      'should return a list of completed certifications when the response code is 200 (success)',
      () async {
        setUpMockHttpClient("completed.json");
        final result = await dataSource.getCompletedCertifications();
        expect(result.length, equals(40));
      },
    );

    test(
      'should return a generic ServerException when status code is '
      'not 200 (success), 500, 404',
      () {
        setUpMockHttpClient("completed.json", statusCode: 224);

        expect(
            () async => await dataSource.getCompletedCertifications(),
            throwsA(predicate((e) =>
                e is ServerException &&
                e.message == Constants.SERVER_FAILURE_MSG)));
      },
    );

    test(
      'should return a ServerException for 500 when status code is 500',
      () {
        setUpMockHttpClient("completed.json", statusCode: 500);

        expect(
            () async => await dataSource.getCompletedCertifications(),
            throwsA(predicate((e) =>
                e is ServerException &&
                e.message == Constants.SERVER_ERROR_500)));
      },
    );

    test(
      'should return a ServerException for 404 when status code is 404',
          () {
        setUpMockHttpClient("completed.json", statusCode: 404);

        expect(
                () async => await dataSource.getCompletedCertifications(),
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
        setUpMockHttpClient("in_progress.json");
        final result = await dataSource.getInProgressCertifications();
        expect(result.length, equals(35));
      },
    );

    test(
      'should return a ServerException when the response code is not 200 (success)',
      () {
        setUpMockHttpClient("in_progress.json", statusCode: 500);
        expect(() async => await dataSource.getCompletedCertifications(),
            throwsA(TypeMatcher<ServerException>()));
      },
    );
  });
}
