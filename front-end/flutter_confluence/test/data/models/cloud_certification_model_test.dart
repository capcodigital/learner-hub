import 'dart:convert';

import 'package:flutter_confluence/data/models/cloud_certification_model.dart';
import 'package:flutter_confluence/domain/entities/cloud_certification.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fixtures/FixtureReader.dart';

void main() {
  var model = CloudCertificationModel(
      name: "Luke Skywalker",
      platform: "Rebel Alliance",
      certificationName: "Death Start Destruction Expert",
      date: "15 June 2021");

  test('should be a subclass of CloudCertification entity', () async {
    // assert
    expect(model, isA<CloudCertification>());
  });

  group('deserialization', () {
    test('should return a valid model when the JSON contains the proper data',
        () {
      var jsonMap = json.decode(fixture('cloud_certification_model.json'));
      final actual = CloudCertificationModel.fromJson(jsonMap);
      expect(actual, model);
    });
  });
}
