import '../../core/usecases/usecase.dart';
import '../entities/cloud_certification.dart';
import '../repositories/cloud_certification_repository.dart';

class GetInProgressCertification implements UseCase<CloudCertification> {
  final CloudCertificationRepository repository;

  GetInProgressCertification(this.repository);

  @override
  Future<CloudCertification> call() async {
    return await repository.getInProgressCertifications();
  }
}
