import 'dart:async';

import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../../core/usecases/usecase.dart';
import '../entities/certification.dart';

class GetInProgressCertifications
    implements UseCase<List<Certification>, void> {
  @override
  Future<Either<Failure, List<Certification>>> call() async {
    // Returning mock data atm
    return Right(certifications);
  }
}
