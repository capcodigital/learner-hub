import 'dart:convert';
import 'dart:io';

import 'package:flutter_confluence/features/certifications/data/models/cloud_certification_model.dart';

String fixture(String name) => File('test/fixtures/$name').readAsStringSync();

List<CloudCertificationModel> getMockCompletedCertifications() {
  return (json.decode(fixture('completed.json')) as List)
      .map((e) => CloudCertificationModel.fromJson(e))
      .toList();
}

List<CloudCertificationModel> getMockInProgressCertifications() {
  return (json.decode(fixture('in_progress.json')) as List)
      .map((e) => CloudCertificationModel.fromJson(e))
      .toList();
}
