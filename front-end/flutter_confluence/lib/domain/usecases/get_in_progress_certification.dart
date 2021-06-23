import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../core/errors/failures.dart';
import '../../core/usecases/usecase.dart';
import '../entities/cloud_certification.dart';
import '../repositories/cloud_certification_repository.dart';

class GetInProgressCertification
    implements UseCase<CloudCertification, NoParams> {
  final CloudCertificationRepository repository;

  GetInProgressCertification(this.repository);

  @override
  Future<Either<Failure, CloudCertification>> Execute(NoParams noParams) async {
    return await repository.getInProgressCertifications();
  }
}

class NoParams extends Equatable {
  List<Object> get props => [];
}
