import 'dart:convert';

import 'package:flutter_confluence/features/certifications/data/models/cloud_certification_model.dart';
import 'package:flutter_confluence/features/certifications/domain/entities/cloud_certification.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final model = CloudCertificationModel(
      name: 'Luke Skywalker',
      platform: 'Rebel Alliance',
      certificationName: 'Death Start Destruction Expert',
      date: '15 June 2021');

  test('should be a subclass of CloudCertification entity', () async {
    // assert
    expect(model, isA<CloudCertification>());
  });

  group('deserialization', () {
    test('should return a valid model when the JSON contains the proper data',
        () {
      final jsonMap =
          json.decode(fixture('certifications/cloud_certification_model.json'));
      final actual = CloudCertificationModel.fromJson(jsonMap);
      expect(actual, model);
    });
  });
}
