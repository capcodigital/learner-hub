import 'package:dartz/dartz.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/error/failures.dart';
import '../entities/cloud_certification.dart';
import '../repositories/cloud_certification_repository.dart';

class GetInProgressCertifications
    implements UseCase<List<CloudCertification>, NoParams> {
  final CloudCertificationRepository repository;

  GetInProgressCertifications(this.repository);

  Future<Either<Failure, List<CloudCertification>>> call(
      NoParams noParams) async {
    return await repository.getInProgressCertifications();
  }
}
