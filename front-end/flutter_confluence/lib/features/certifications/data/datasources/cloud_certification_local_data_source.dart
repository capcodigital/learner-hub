import 'package:flutter_confluence/features/certifications/data/datasources/local_certification_dao.dart';
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
  final LocalCertificationDao dao;
  CloudCertificationLocalDataSourceImpl({required this.dao});

  @override
  Future<List<CloudCertificationModel>> getCompletedCertifications() {
    final items = dao.getCompleted();
    return Future.value(items);
  }

  @override
  Future<List<CloudCertificationModel>> getInProgressCertifications() {
    final items = dao.getInProgress();
    return Future.value(items);
  }

  @override
  Future<void> saveCompletedCertifications(
      List<CloudCertificationModel> certifications) {
    return Future.value(dao.cacheCompleted(certifications));
  }

  @override
  Future<void> saveInProgressCertifications(
      List<CloudCertificationModel> certifications) {
    return Future.value(dao.cacheInProgress(certifications));
  }
}
