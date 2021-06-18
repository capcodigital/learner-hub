import 'dart:async';

import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../../core/usecases/usecase.dart';
import '../entities/certification.dart';

class GetCloudCertifications implements UseCase<List<Certification>, NoParams> {
  @override
  Future<Either<Failure, List<Certification>>> call(NoParams params) {
    return Future.sync(() => Right(certifications));
  }
}
