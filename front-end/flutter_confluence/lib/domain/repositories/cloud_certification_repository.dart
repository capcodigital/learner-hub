import 'package:dartz/dartz.dart';
import 'package:flutter_confluence/core/errors/failures.dart';

import '../entities/cloud_certification.dart';

abstract class CloudCertificationRepository {
  Future<Either<Failure, CloudCertification>> getCompletetedCertifications();
  Future<Either<Failure, CloudCertification>> getInProgressCertifications();
}
