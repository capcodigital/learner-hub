import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../core/errors/failures.dart';
import '../entities/cloud_certification.dart';
import '../repositories/cloud_certification_repository.dart';

class GetCompletedCertification {
  final CloudCertificationRepository repository;

  GetCompletedCertification(this.repository);

  Future<Either<Failure, List<CloudCertification>>> execute(
      NoParams noParams) async {
    return await repository.getCompletetedCertifications();
  }
}

@override
class NoParams extends Equatable {
  List<Object> get props => [];
}
