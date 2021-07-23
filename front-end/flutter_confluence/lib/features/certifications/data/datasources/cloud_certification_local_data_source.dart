import 'package:flutter_confluence/core/error/custom_exceptions.dart';
import 'package:flutter_confluence/features/certifications/data/datasources/certification_local_dao.dart';
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
  final CertificationLocalDao dao;
  CloudCertificationLocalDataSourceImpl({required this.dao});

  @override
  Future<List<CloudCertificationModel>> getCompletedCertifications() async {
    final items = await dao.getCompleted();
    if (items.isNotEmpty)
      return items;
    else
      throw CacheException();
  }

  @override
  Future<List<CloudCertificationModel>> getInProgressCertifications() async {
    final items = await dao.getInProgress();
    if (items.isNotEmpty)
      return items;
    else
      throw CacheException();
  }

  @override
  Future<void> saveCompletedCertifications(
      List<CloudCertificationModel> certifications) {
    return Future.value(dao.saveCompleted(certifications));
  }

  @override
  Future<void> saveInProgressCertifications(
      List<CloudCertificationModel> certifications) {
    return Future.value(dao.saveInProgress(certifications));
  }
}
