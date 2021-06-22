import '../entities/cloud_certification.dart';

abstract class CloudCertificationRepository {
  Future<CloudCertification> getCompletetedCertifications();
  Future<CloudCertification> getInProgressCertifications();
}
