import 'package:flutter_confluence/core/error/custom_exceptions.dart';
import 'package:flutter_confluence/features/certifications/data/datasources/certification_hive_helper.dart';
import 'package:flutter_confluence/features/certifications/data/models/cloud_certification_model.dart';

abstract class CloudCertificationLocalDataSource {
  Future<List<CloudCertificationModel>> getCompletedCertifications();
  Future<List<CloudCertificationModel>> getInProgressCertifications();

  Future<void> saveCompletedCertifications(
      List<CloudCertificationModel> certifications);
  Future<void> saveInProgressCertifications(
      List<CloudCertificationModel> certifications);
}

const COMPLETED_CERTIFICATIONS_KEY = 'CACHED_COMPLETED';
const IN_PROGRESS_CERTIFICATIONS_KEY = 'CACHED_IN_PROGRESS';

class CloudCertificationLocalDataSourceImpl
    implements CloudCertificationLocalDataSource {
  CloudCertificationLocalDataSourceImpl({required this.hiveHelper});
  final CertificationHiveHelper hiveHelper;

  @override
  Future<List<CloudCertificationModel>> getCompletedCertifications() async {
    final items = await hiveHelper.getCompleted();
    if (items.isNotEmpty)
      return items;
    else
      throw CacheException();
  }

  @override
  Future<List<CloudCertificationModel>> getInProgressCertifications() async {
    final items = await hiveHelper.getInProgress();
    if (items.isNotEmpty)
      return items;
    else
      throw CacheException();
  }

  @override
  Future<void> saveCompletedCertifications(
      List<CloudCertificationModel> certifications) {
    return Future.value(hiveHelper.saveCompleted(certifications));
  }

  @override
  Future<void> saveInProgressCertifications(
      List<CloudCertificationModel> certifications) {
    return Future.value(hiveHelper.saveInProgress(certifications));
  }
}
