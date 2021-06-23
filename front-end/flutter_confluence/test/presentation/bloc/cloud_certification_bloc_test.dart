import 'package:flutter_confluence/core/constants.dart';
import 'package:flutter_confluence/core/errors/failures.dart';
import 'package:flutter_confluence/domain/usecases/get_completed_certification.dart';
import 'package:flutter_confluence/domain/usecases/get_in_progress_certification.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_confluence/presentation/bloc/cloud_certification_bloc.dart';
import 'cloud_certification_bloc_test.mocks.dart';
import 'package:bloc_test/bloc_test.dart';

@GenerateMocks([GetCompletedCertification, GetInProgressCertification])
void main() {

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

  late MockGetCompletedCertification mockCompletedCase = MockGetCompletedCertification();
  late MockGetInProgressCertification mockInProgressCase = MockGetInProgressCertification();
  late CloudCertificationBloc bloc;

  setUp(() {
    bloc = CloudCertificationBloc(
      completedUseCase: mockCompletedCase,
      inProgressUseCase: mockInProgressCase);
  });

  test('initial bloc state should be Empty', () {
    expect(bloc.state, equals(Empty()));
  });

  // initial state not emitted, https://github.com/felangel/bloc/issues/1518
  group('GetCompletedCertifications', () {

    test(
      'should get list of completed certifications use case',
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
      'emits success',
      build: () => bloc,
      act: (blo) => {
        when(mockCompletedCase.execute(any))
            .thenAnswer((_) async => Right(mockCompletedCerts)),
        bloc.add(GetCompletedCertificationsEvent())
      },
      expect: () => orderCompleted,
    );

    blocTest(
      'emits server error',
      build: () => bloc,
      act: (blo) => {
        when(mockCompletedCase.execute(any))
            .thenAnswer((_) async => Left(ServerFailure())),
        bloc.add(GetCompletedCertificationsEvent())
      },
      expect: () => orderServerError,
    );

    blocTest(
      'emits cache error',
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
      'should get list of in progress certifications use case',
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
      'emits success',
      build: () => bloc,
      act: (blo) => {
        when(mockInProgressCase.execute(any))
            .thenAnswer((_) async => Right(mockInProgressCerts)),
        bloc.add(GetInProgressCertificationsEvent())
      },
      expect: () => orderInProgress,
    );

    blocTest(
      'emits server error',
      build: () => bloc,
      act: (blo) => {
        when(mockInProgressCase.execute(any))
            .thenAnswer((_) async => Left(ServerFailure())),
        bloc.add(GetInProgressCertificationsEvent())
      },
      expect: () => orderServerError,
    );

    blocTest(
      'emits cache error',
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
