import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_confluence/core/usecases/usecase.dart';

import '../../core/error/failures.dart';
import '../entities/cloud_certification.dart';
import '../repositories/cloud_certification_repository.dart';

class GetCompletedCertification {
  final CloudCertificationRepository repository;

  GetCompletedCertification(this.repository);

  Future<Either<Failure, List<CloudCertification>>> execute(
      NoParams noParams) async {
    return await repository.getCompletedCertifications();
// =======
//   Future<Either<Failure, List<CloudCertification>>> execute(NoParams noParams) async {
//     return await repository.getCompletedCertifications();
// >>>>>>> develop
  }
}

