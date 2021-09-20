import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_confluence/core/error/failures.dart';
import 'package:flutter_confluence/core/usecases/usecase.dart';
import 'package:flutter_confluence/features/certifications/domain/entities/cloud_certification.dart';
import 'package:flutter_confluence/features/certifications/domain/entities/cloud_certification_type.dart';
import 'package:flutter_confluence/features/certifications/domain/repositories/cloud_certification_repository.dart';

class SearchParams extends Equatable {
  final String searchQuery;
  final CloudCertificationType dataType;

  const SearchParams({required this.searchQuery, required this.dataType});

  @override
  List<Object> get props => [searchQuery, dataType];
}

class SearchCertifications implements UseCase<List<CloudCertification>, SearchParams> {
  final CloudCertificationRepository repository;

  SearchCertifications(this.repository);

  @override
  Future<Either<Failure, List<CloudCertification>>> call(SearchParams searchParameters) async {
    return await repository.searchCertifications(searchParameters.searchQuery, searchParameters.dataType);
  }
}
