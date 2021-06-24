import 'package:dartz/dartz.dart';
import 'package:flutter_confluence/core/usecases/usecase.dart';

import '../../core/error/failures.dart';
import '../entities/cloud_certification.dart';
import '../repositories/cloud_certification_repository.dart';
import 'get_completed_certification.dart';

class GetInProgressCertification {
  final CloudCertificationRepository repository;

  GetInProgressCertification(this.repository);

  // Future<Either<Failure, List<CloudCertification>>> execute(
  //     NoParams noParams) async {

  Future<Either<Failure, List<CloudCertification>>> execute(NoParams noParams) async {
    return await repository.getInProgressCertifications();
  }
}
