import 'package:dartz/dartz.dart';
import 'package:flutter_confluence/core/constants.dart';
import 'package:flutter_confluence/core/errors/failures.dart';

import '../entities/cloud_certification.dart';

abstract class CloudCertificationRepository {
  Future<Either<Failure, List<CloudCertification>>>
      getCompletetedCertifications();
  Future<Either<Failure, List<CloudCertification>>>
      getInProgressCertifications();
}

// Repository impl returns mock data atm
class CloudCertificationRepositoryImpl implements CloudCertificationRepository {
  Future<Either<Failure, List<CloudCertification>>>
      getCompletetedCertifications() async {
    return Future.delayed(Duration(milliseconds: 2000), () {
      return Right(mockCompletedCerts);
    });
  }

  Future<Either<Failure, List<CloudCertification>>>
      getInProgressCertifications() async {
    // Return mock data atm
    return Future.delayed(Duration(milliseconds: 2000), () {
      return Right(mockInrogressCerts);
    });
  }
}
