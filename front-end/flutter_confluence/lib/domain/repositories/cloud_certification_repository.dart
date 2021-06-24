import 'package:dartz/dartz.dart';
import 'package:flutter_confluence/core/error/failures.dart';

import '../entities/cloud_certification.dart';

abstract class CloudCertificationRepository {
  Future<Either<Failure, List<CloudCertification>>> getCompletedCertifications();
  Future<Either<Failure, List<CloudCertification>>> getInProgressCertifications();
}