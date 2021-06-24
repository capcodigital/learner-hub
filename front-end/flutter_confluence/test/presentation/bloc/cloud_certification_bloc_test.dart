import 'dart:convert';

import 'package:flutter_confluence/core/constants.dart';
import 'package:flutter_confluence/core/error/failures.dart';
import 'package:flutter_confluence/core/usecases/usecase.dart';
import 'package:flutter_confluence/data/models/cloud_certification_model.dart';
import 'package:flutter_confluence/domain/usecases/get_completed_certifications.dart';
import 'package:flutter_confluence/domain/usecases/get_in_progress_certifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_confluence/presentation/bloc/cloud_certification_bloc.dart';
import '../../fixtures/FixtureReader.dart';
import 'cloud_certification_bloc_test.mocks.dart';
import 'package:bloc_test/bloc_test.dart';

@GenerateMocks([GetCompletedCertifications, GetInProgressCertifications])
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

  late MockGetCompletedCertification mockCompletedCase;
  late MockGetInProgressCertification mockInProgressCase;
  late CloudCertificationBloc bloc;

  setUp(() {
    mockCompletedCase = MockGetCompletedCertification();
    mockInProgressCase = MockGetInProgressCertification();
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
      build: () {
        when(mockCompletedCase.execute(any))
            .thenAnswer((_) async => Right(mockCompletedCerts));
        return bloc;
        },
      act: (CloudCertificationBloc blo) => {
        blo.add(GetCompletedCertificationsEvent())
      },
      expect: () => orderCompleted,
    );

    blocTest(
      'should emit, Loading, ServerError',
      build: () {
        when(mockCompletedCase.execute(any))
            .thenAnswer((_) async => Left(ServerFailure()));
        return bloc;
        },
      act: (CloudCertificationBloc blo) => {
        blo.add(GetCompletedCertificationsEvent())
      },
      expect: () => orderServerError,
    );

    blocTest(
      'should emit Loading, CacheError',
      build: () {
        when(mockCompletedCase.execute(any))
            .thenAnswer((_) async => Left(CacheFailure()));
        return bloc;
      },
      act: (CloudCertificationBloc blo) => {
        blo.add(GetCompletedCertificationsEvent())
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
      build: () {
        when(mockInProgressCase.execute(any))
            .thenAnswer((_) async => Right(mockInProgressCerts));
        return bloc;
      },
      act: (CloudCertificationBloc blo) => {
        blo.add(GetInProgressCertificationsEvent())
      },
      expect: () => orderInProgress,
    );

    blocTest(
      'should emit Loading, ServerError',
      build: () {
        when(mockInProgressCase.execute(any))
            .thenAnswer((_) async => Left(ServerFailure()));
        return bloc;
      },
      act: (CloudCertificationBloc blo) => {
        blo.add(GetInProgressCertificationsEvent())
      },
      expect: () => orderServerError,
    );

    blocTest(
      'should emit Loading, CacheError',
      build: () {
        when(mockInProgressCase.execute(any))
            .thenAnswer((_) async => Left(CacheFailure()));
        return bloc;
      },
      act: (CloudCertificationBloc blo) => {
        blo.add(GetInProgressCertificationsEvent())
      },
      expect: () => orderCacheError,
    );

  });

}
