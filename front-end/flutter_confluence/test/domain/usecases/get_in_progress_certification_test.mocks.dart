// Mocks generated by Mockito 5.0.10 from annotations
// in flutter_confluence/test/domain/usecases/get_in_progress_certification_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i4;

import 'package:dartz/dartz.dart' as _i2;
import 'package:flutter_confluence/core/error/failures.dart' as _i5;
import 'package:flutter_confluence/domain/entities/cloud_certification.dart'
    as _i6;
import 'package:flutter_confluence/domain/entities/cloud_certification_type.dart'
    as _i7;
import 'package:flutter_confluence/domain/repositories/cloud_certification_repository.dart'
    as _i3;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: comment_references
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis

class _FakeEither<L, R> extends _i1.Fake implements _i2.Either<L, R> {
  @override
  String toString() => super.toString();
}

/// A class which mocks [CloudCertificationRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockCloudCertificationRepository extends _i1.Mock
    implements _i3.CloudCertificationRepository {
  MockCloudCertificationRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<_i2.Either<_i5.Failure, List<_i6.CloudCertification>>>
      getCompletedCertifications() => (super.noSuchMethod(
          Invocation.method(#getCompletedCertifications, []),
          returnValue: Future<
                  _i2.Either<_i5.Failure, List<_i6.CloudCertification>>>.value(
              _FakeEither<_i5.Failure, List<_i6.CloudCertification>>())) as _i4
          .Future<_i2.Either<_i5.Failure, List<_i6.CloudCertification>>>);
  @override
  _i4.Future<_i2.Either<_i5.Failure, List<_i6.CloudCertification>>>
      getInProgressCertifications() => (super.noSuchMethod(
          Invocation.method(#getInProgressCertifications, []),
          returnValue: Future<
                  _i2.Either<_i5.Failure, List<_i6.CloudCertification>>>.value(
              _FakeEither<_i5.Failure, List<_i6.CloudCertification>>())) as _i4
          .Future<_i2.Either<_i5.Failure, List<_i6.CloudCertification>>>);
  @override
  _i4.Future<
      _i2.Either<_i5.Failure, List<_i6.CloudCertification>>> searchCertifications(
          String? searchQuery, _i7.CloudCertificationType? dataType) =>
      (super.noSuchMethod(
          Invocation.method(#searchCertifications, [searchQuery, dataType]),
          returnValue:
              Future<_i2.Either<_i5.Failure, List<_i6.CloudCertification>>>.value(
                  _FakeEither<_i5.Failure, List<_i6.CloudCertification>>())) as _i4
          .Future<_i2.Either<_i5.Failure, List<_i6.CloudCertification>>>);
}
