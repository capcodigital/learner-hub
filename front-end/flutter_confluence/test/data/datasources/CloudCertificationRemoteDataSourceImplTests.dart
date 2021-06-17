import 'dart:convert';

import 'package:flutter_confluence/core/error/ServerException.dart';
import 'package:flutter_confluence/data/datasources/CloudCertificationRemoteDataSourceImpl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:flutter_confluence/core/error/ServerException.dart';
import '../../fixtures/FixtureReader.dart';

void main() {
  late CloudCertificationRemoteDataSourceImpl dataSource;
  late Client mockHttpClient;

  setUp(() {
    mockHttpClient = MockClient((request) async {
      return Response(json.encode({'error': 'Mock Not set'}), 200);
    });
    dataSource = CloudCertificationRemoteDataSourceImpl(client: mockHttpClient);
  });

  void setUpMockHttpClient(String fixtureName, {int statusCode = 200}) {
    var newClient = MockClient((request) async {
      var responseBody = fixture(fixtureName);
      var jsonMap = jsonDecode(responseBody);
      return Response(json.encode(jsonMap), statusCode);
    });
    dataSource = CloudCertificationRemoteDataSourceImpl(client: newClient);
  }

  group('getCompletedCertifications', () {
    test(
      'should return a list of completed certifications when the response code is 200 (success)',
      () async {
        setUpMockHttpClient("completed.json");
        final result = await dataSource.getCompletedCertifications();
        expect(result.length, equals(42));
      },
    );

    test(
      'should return a ServerException when the response code is not 200 (success)',
      ()  {
        setUpMockHttpClient("completed.json", statusCode: 500);
        expect(dataSource.getCompletedCertifications(),
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
        expect(result.length, equals(32));
      },
    );

    test(
      'should return a ServerException when the response code is not 200 (success)',
          ()  {
        setUpMockHttpClient("completed.json", statusCode: 500);
        expect(dataSource.getCompletedCertifications(),
            throwsA(TypeMatcher<ServerException>()));
      },
    );
  });
}
