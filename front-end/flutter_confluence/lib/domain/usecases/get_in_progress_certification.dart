import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../core/errors/failures.dart';
import '../entities/cloud_certification.dart';
import '../repositories/cloud_certification_repository.dart';

class GetInProgressCertification {
  final CloudCertificationRepository repository;

  GetInProgressCertification(this.repository);

  Future<Either<Failure, CloudCertification>> execute(NoParams noParams) async {
    return await repository.getInProgressCertifications();
  }
}

@override
class NoParams extends Equatable {
  List<Object> get props => [];
}
