import 'dart:convert';

import 'package:flutter_confluence/data/models/cloud_certification_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fixtures/FixtureReader.dart';

void main() {
  group('deserialization', () {
    test('should return a valid model when the JSON contains the proper data',
        () {
      var expected = CloudCertificationModel(
          name: "Luke Skywalker",
          platform: "Rebel Alliance",
          certificationName: "Death Start Destruction Expert",
          date: "15 June 2021");

      var jsonMap = json.decode(fixture('cloud_certification_model.json'));
      final actual = CloudCertificationModel.fromJson(jsonMap);
      expect(actual, expected);
    });
  });
}
