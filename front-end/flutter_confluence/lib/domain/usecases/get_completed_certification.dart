import 'package:equatable/equatable.dart';
import 'package:flutter_confluence/core/usecases/usecase.dart';

import '../entities/cloud_certification.dart';
import '../repositories/cloud_certification_repository.dart';

class GetCompletedCertification implements UseCase<CloudCertification> {
  final CloudCertificationRepository repository;

  GetCompletedCertification(this.repository);

  @override
  Future<CloudCertification> call() async {
    return await repository.getCompletetedCertifications();
  }
}

class NoParams extends Equatable {
  List<Object> get props => [];
}
