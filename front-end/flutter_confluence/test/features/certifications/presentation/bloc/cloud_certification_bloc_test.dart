import 'dart:convert';

import 'package:flutter_confluence/core/constants.dart';
import 'package:flutter_confluence/core/error/failures.dart';
import 'package:flutter_confluence/core/usecases/usecase.dart';
import 'package:flutter_confluence/features/certifications/data/models/cloud_certification_model.dart';
import 'package:flutter_confluence/features/certifications/domain/entities/cloud_certification_type.dart';
import 'package:flutter_confluence/features/certifications/domain/usecases/get_completed_certifications.dart';
import 'package:flutter_confluence/features/certifications/domain/usecases/get_in_progress_certifications.dart';
import 'package:flutter_confluence/features/certifications/domain/usecases/search_certifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_confluence/features/certifications/presentation/bloc/cloud_certification_bloc.dart';
import '../../../../fixtures/FixtureReader.dart';
import 'cloud_certification_bloc_test.mocks.dart';
import 'package:bloc_test/bloc_test.dart';

@GenerateMocks([GetCompletedCertifications, GetInProgressCertifications, SearchCertifications])
void main() {
  final mockCompletedCerts =
      (json.decode(fixture('completed.json')) as List)
          .map((e) => CloudCertificationModel.fromJson(e))
          .toList();

  final mockInProgressCerts =
      (json.decode(fixture('in_progress.json')) as List)
          .map((e) => CloudCertificationModel.fromJson(e))
          .toList();

  final orderCompleted = [
    Loading(),
    Loaded(items: mockCompletedCerts, cloudCertificationType: CloudCertificationType.completed),
  ];

  final orderInProgress = [
    Loading(),
    Loaded(items: mockInProgressCerts, cloudCertificationType: CloudCertificationType.in_progress),
  ];

  final orderInProgressServerError = [
    Loading(),
    Error(certificationType: CloudCertificationType.in_progress,
        message: Constants.SERVER_FAILURE_MSG),
  ];

  final orderCompletedServerError = [
    Loading(),
    Error(certificationType: CloudCertificationType.completed,
        message: Constants.SERVER_FAILURE_MSG),
  ];

  final orderInProgressCacheError = [
    Loading(),
    Error(certificationType: CloudCertificationType.in_progress,
        message: Constants.CACHE_FAILURE_MSG),
  ];

  final orderCompletedCacheError = [
    Loading(),
    Error(certificationType: CloudCertificationType.completed,
        message: Constants.CACHE_FAILURE_MSG),
  ];

  late MockGetCompletedCertifications mockCompletedCase;
  late MockGetInProgressCertifications mockInProgressCase;
  late MockSearchCertifications mockSearchCase;
  late CloudCertificationBloc bloc;

  setUp(() {
    mockCompletedCase = MockGetCompletedCertifications();
    mockInProgressCase = MockGetInProgressCertifications();
    mockSearchCase = MockSearchCertifications();
    bloc = CloudCertificationBloc(
        completedUseCase: mockCompletedCase,
        inProgressUseCase: mockInProgressCase,
        searchUserCase: mockSearchCase
    );
  });

  test('initial bloc state should be Empty', () {
    expect(bloc.state, equals(Empty()));
  });

  group('GetCompletedCertifications', () {
    test(
      'should get list of completed certifications',
      () async {
        // arrange
        when(mockCompletedCase(any))
            .thenAnswer((_) async => Right(mockCompletedCerts));
        // act
        bloc.add(GetCompletedCertificationsEvent());
        await untilCalled(mockCompletedCase(any));
        // assert
        verify(mockCompletedCase(NoParams()));
      },
    );

    blocTest(
      'should emit Loading, Loaded',
      build: () {
        when(mockCompletedCase(any))
            .thenAnswer((_) async => Right(mockCompletedCerts));
        return bloc;
      },
      act: (CloudCertificationBloc blo) =>
          {blo.add(GetCompletedCertificationsEvent())},
      expect: () => orderCompleted,
    );

    blocTest(
      'should emit, Loading, ServerError',
      build: () {
        when(mockCompletedCase(any))
            .thenAnswer((_) async => Left(ServerFailure()));
        return bloc;
      },
      act: (CloudCertificationBloc blo) =>
          {blo.add(GetCompletedCertificationsEvent())},
      expect: () => orderCompletedServerError,
    );

    blocTest(
      'should emit Loading, CacheError',
      build: () {
        when(mockCompletedCase(any))
            .thenAnswer((_) async => Left(CacheFailure()));
        return bloc;
      },
      act: (CloudCertificationBloc blo) =>
          {blo.add(GetCompletedCertificationsEvent())},
      expect: () => orderCompletedCacheError,
    );
  });

  group('GetInProgressCertifications', () {
    test(
      'should get list of in progress certifications',
      () async {
        // arrange
        when(mockInProgressCase(any))
            .thenAnswer((_) async => Right(mockInProgressCerts));
        // act
        bloc.add(GetInProgressCertificationsEvent());
        await untilCalled(mockInProgressCase(any));
        // assert
        verify(mockInProgressCase(NoParams()));
      },
    );

    blocTest(
      'should emit Loading, Loaded',
      build: () {
        when(mockInProgressCase(any))
            .thenAnswer((_) async => Right(mockInProgressCerts));
        return bloc;
      },
      act: (CloudCertificationBloc blo) =>
          {blo.add(GetInProgressCertificationsEvent())},
      expect: () => orderInProgress,
    );

    blocTest(
      'should emit Loading, ServerError',
      build: () {
        when(mockInProgressCase(any))
            .thenAnswer((_) async => Left(ServerFailure()));
        return bloc;
      },
      act: (CloudCertificationBloc blo) =>
          {blo.add(GetInProgressCertificationsEvent())},
      expect: () => orderInProgressServerError,
    );

    blocTest(
      'should emit Loading, CacheError',
      build: () {
        when(mockInProgressCase(any))
            .thenAnswer((_) async => Left(CacheFailure()));
        return bloc;
      },
      act: (CloudCertificationBloc blo) =>
          {blo.add(GetInProgressCertificationsEvent())},
      expect: () => orderInProgressCacheError,
    );
  });

  group('SearchCertifications', () {

    final emptyList = <CloudCertificationModel>[];
    final filteredItems = mockCompletedCerts.take(1).toList();

    final searchCompletedWithResults = [
      Loading(),
      Loaded(items: mockCompletedCerts, cloudCertificationType: CloudCertificationType.completed),
      Loading(),
      Loaded(items: filteredItems, cloudCertificationType: CloudCertificationType.completed),
    ];

    final searchCompletedNoResults = [
      Loading(),
      Loaded(items: mockCompletedCerts, cloudCertificationType: CloudCertificationType.completed),
      Loading(),
      EmptySearchResult(cloudCertificationType: CloudCertificationType.completed),
    ];

    setUp(() {
      when(mockCompletedCase(any))
          .thenAnswer((_) async => Right(mockCompletedCerts));

      when(mockInProgressCase(any))
          .thenAnswer((_) async => Right(mockInProgressCerts));
    });

    blocTest(
      // First load the items, then search through them
      'should emit Loading, Loaded, Loading, EmptySearchResult',
      build: () {
        when(mockSearchCase(any))
            .thenAnswer((_) async => Right(emptyList));
        return bloc;
      },
      act: (CloudCertificationBloc blo) =>
      {
        blo.add(GetCompletedCertificationsEvent()),
        blo.add(SearchCertificationsEvent("search"))
      },
      expect: () => searchCompletedNoResults,
    );

    blocTest(
      // First load the items, then search through them
      'should emit Loading, Loaded, Loading, Loaded',
      build: () {
        when(mockSearchCase(any))
            .thenAnswer((_) async => Right(filteredItems));
        return bloc;
      },
      act: (CloudCertificationBloc blo) =>
      {
        blo.add(GetCompletedCertificationsEvent()),
        blo.add(SearchCertificationsEvent("search"))
      },
      expect: () => searchCompletedWithResults,
    );
  });
}