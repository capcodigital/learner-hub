import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/cloud_certification.dart';
import '../repositories/cloud_certification_repository.dart';

class GetCompletedCertifications
    implements UseCase<List<CloudCertification>, NoParams> {
  GetCompletedCertifications(this.repository);
  final CloudCertificationRepository repository;

  @override
  Future<Either<Failure, List<CloudCertification>>> call(
      NoParams noParams) async {
    return repository.getCompletedCertifications();
  }
}
