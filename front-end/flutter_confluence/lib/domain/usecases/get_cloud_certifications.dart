import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_confluence/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_confluence/core/usecases/usecase.dart';
import 'package:flutter_confluence/domain/entities/certification.dart';

class GetCloudCertifications implements UseCase<List<Certification>, NoParams> {
  @override
  Future<Either<Failure, List<Certification>>> call(NoParams params) {
    return Future.sync(() => Right(certifications));
  }
}
