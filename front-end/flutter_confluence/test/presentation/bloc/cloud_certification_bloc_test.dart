import 'dart:convert';

import 'package:flutter_confluence/core/constants.dart';
import 'package:flutter_confluence/core/error/failures.dart';
import 'package:flutter_confluence/core/usecases/usecase.dart';
import 'package:flutter_confluence/data/models/cloud_certification_model.dart';
import 'package:flutter_confluence/domain/usecases/get_completed_certification.dart';
import 'package:flutter_confluence/domain/usecases/get_in_progress_certification.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_confluence/presentation/bloc/cloud_certification_bloc.dart';
import '../../fixtures/FixtureReader.dart';
import 'cloud_certification_bloc_test.mocks.dart';
import 'package:bloc_test/bloc_test.dart';

@GenerateMocks([GetCompletedCertification, GetInProgressCertification])
void main() {

  final mockCompletedCerts =
  (json.decode(fixture('completed.json')) as Map<String, dynamic>)
      .values
      .map((e) => CloudCertificationModel.fromJson(e))
      .toList();

  final mockInProgressCerts =
  (json.decode(fixture('in_progress.json')) as Map<String, dynamic>)
      .values
      .map((e) => CloudCertificationModel.fromJson(e))
      .toList();

  final orderCompleted = [
    Loading(),
    Loaded(items: mockCompletedCerts),
  ];

  final orderInProgress = [
    Loading(),
    Loaded(items: mockInProgressCerts),
  ];

  final orderServerError = [
    Loading(),
    Error(message: SERVER_FAILURE_MSG),
  ];

  final orderCacheError = [
    Loading(),
    Error(message: CACHE_FAILURE_MSG),
  ];

  final MockGetCompletedCertification mockCompletedCase = MockGetCompletedCertification();
  final MockGetInProgressCertification mockInProgressCase = MockGetInProgressCertification();
  late CloudCertificationBloc bloc;

  setUp(() {
    bloc = CloudCertificationBloc(
      completedUseCase: mockCompletedCase,
      inProgressUseCase: mockInProgressCase);
  });

  test('initial bloc state should be Empty', () {
    expect(bloc.state, equals(Empty()));
  });

  group('GetCompletedCertifications', () {

    test(
      'should get list of completed certifications',
          () async {
        // arrange
        when(mockCompletedCase.execute(any))
            .thenAnswer((_) async => Right(mockCompletedCerts));
        // act
        bloc.add(GetCompletedCertificationsEvent());
        await untilCalled(mockCompletedCase.execute(any));
        // assert
        verify(mockCompletedCase.execute(NoParams()));
      },
    );

    blocTest(
      'should emit Loading, Loaded',
      build: () => bloc,
      act: (blo) => {
        when(mockCompletedCase.execute(any))
            .thenAnswer((_) async => Right(mockCompletedCerts)),
        bloc.add(GetCompletedCertificationsEvent())
      },
      expect: () => orderCompleted,
    );

    blocTest(
      'should emit, Loading, ServerError',
      build: () => bloc,
      act: (blo) => {
        when(mockCompletedCase.execute(any))
            .thenAnswer((_) async => Left(ServerFailure())),
        bloc.add(GetCompletedCertificationsEvent())
      },
      expect: () => orderServerError,
    );

    blocTest(
      'should emit Loading, CacheError',
      build: () => bloc,
      act: (blo) => {
        when(mockCompletedCase.execute(any))
            .thenAnswer((_) async => Left(CacheFailure())),
        bloc.add(GetCompletedCertificationsEvent())
      },
      expect: () => orderCacheError,
    );

  });

  group('GetInProgressCertifications', () {
    test(
      'should get list of in progress certifications',
          () async {
        // arrange
        when(mockInProgressCase.execute(any))
            .thenAnswer((_) async => Right(mockInProgressCerts));
        // act
        bloc.add(GetInProgressCertificationsEvent());
        await untilCalled(mockInProgressCase.execute(any));
        // assert
        verify(mockInProgressCase.execute(NoParams()));
      },
    );

    blocTest(
      'should emit Loading, Loaded',
      build: () => bloc,
      act: (blo) => {
        when(mockInProgressCase.execute(any))
            .thenAnswer((_) async => Right(mockInProgressCerts)),
        bloc.add(GetInProgressCertificationsEvent())
      },
      expect: () => orderInProgress,
    );

    blocTest(
      'should emit Loading, ServerError',
      build: () => bloc,
      act: (blo) => {
        when(mockInProgressCase.execute(any))
            .thenAnswer((_) async => Left(ServerFailure())),
        bloc.add(GetInProgressCertificationsEvent())
      },
      expect: () => orderServerError,
    );

    blocTest(
      'should emit Loading, CacheError',
      build: () => bloc,
      act: (blo) => {
        when(mockInProgressCase.execute(any))
            .thenAnswer((_) async => Left(CacheFailure())),
        bloc.add(GetInProgressCertificationsEvent())
      },
      expect: () => orderCacheError,
    );

  });

}
