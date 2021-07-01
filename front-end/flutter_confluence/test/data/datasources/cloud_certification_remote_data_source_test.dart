import 'package:flutter_confluence/core/error/custom_exceptions.dart';
import 'package:flutter_confluence/data/datasources/cloud_certification_remote_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../fixtures/FixtureReader.dart';
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
      'should return a ServerException when the response code is not 200 (success)',
      () {
        setUpMockHttpClient("completed.json", statusCode: 500);
        expect(() async => await dataSource.getCompletedCertifications(),
            throwsA(TypeMatcher<ServerException>()));
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
