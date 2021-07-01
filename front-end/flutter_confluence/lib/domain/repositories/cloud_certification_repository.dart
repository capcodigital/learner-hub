import 'package:dartz/dartz.dart';
import 'package:flutter_confluence/domain/entities/cloud_certification_type.dart';
import 'package:flutter_confluence/presentation/bloc/cloud_certification_bloc.dart';
import '../../core/error/failures.dart';
import '../entities/cloud_certification.dart';

abstract class CloudCertificationRepository {
  Future<Either<Failure, List<CloudCertification>>>
      getCompletedCertifications();
  Future<Either<Failure, List<CloudCertification>>>
      getInProgressCertifications();
  Future<Either<Failure, List<CloudCertification>>>
      searchCertifications(String searchQuery, CloudCertificationType dataType);
}
