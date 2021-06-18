import 'dart:convert';

import 'package:flutter_confluence/core/error/custom_exceptions.dart';
import 'package:flutter_confluence/data/models/cloud_certification_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class CloudCertificationLocalDataSource {
  Future<List<CloudCertificationModel>> getCompletedCertifications();
  Future<List<CloudCertificationModel>> getInProgressCertifications();

  Future<void> saveCompletedCertifications(List<CloudCertificationModel> certifications);
  Future<void> saveInProgressCertifications(List<CloudCertificationModel> certifications);
}

const COMPLETED_CERTIFICATIONS_KEY = 'CACHED_COMPLETED';
const IN_PROGRESS_CERTIFICATIONS_KEY = 'CACHED_IN_PROGRESS';

class CloudCertificationLocalDataSourceImpl implements CloudCertificationLocalDataSource {
  final SharedPreferences sharedPreferences;

  CloudCertificationLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<CloudCertificationModel>> getCompletedCertifications() {
    final jsonString = sharedPreferences.getString(COMPLETED_CERTIFICATIONS_KEY);
    if (jsonString != null) {
      var certifications = (json.decode(jsonString) as List)
          .map((e) => CloudCertificationModel.fromJson(e))
          .toList();
      return Future.value(certifications);
    } else {
      throw CacheException();
    }
  }

  @override
  Future<List<CloudCertificationModel>> getInProgressCertifications() {
    final jsonString =
        sharedPreferences.getString(IN_PROGRESS_CERTIFICATIONS_KEY);
    if (jsonString != null) {
      var certifications = (json.decode(jsonString) as List)
          .map((e) => CloudCertificationModel.fromJson(e))
          .toList();
      return Future.value(certifications);
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> saveCompletedCertifications(List<CloudCertificationModel> certifications) {
    return sharedPreferences.setString(
      COMPLETED_CERTIFICATIONS_KEY,
      json.encode(certifications),
    );
  }

  @override
  Future<void> saveInProgressCertifications(List<CloudCertificationModel> certifications) {
    return sharedPreferences.setString(
      IN_PROGRESS_CERTIFICATIONS_KEY,
      json.encode(certifications),
    );
  }
}
