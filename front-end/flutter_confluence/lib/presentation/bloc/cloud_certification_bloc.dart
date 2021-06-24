import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_confluence/core/error/failures.dart';
import 'package:flutter_confluence/core/usecases/usecase.dart';
import 'package:flutter_confluence/domain/entities/cloud_certification.dart';
import 'package:flutter_confluence/domain/usecases/get_completed_certification.dart';
import 'package:flutter_confluence/domain/usecases/get_in_progress_certification.dart';

part 'cloud_certification_event.dart';
part 'cloud_certification_state.dart';

const SERVER_FAILURE_MSG = "Server Failure";
const CACHE_FAILURE_MSG = "Cache Failure";
const UNKNOWN_ERROR_MSG = "Unknown Error";

class CloudCertificationBloc
    extends Bloc<CloudCertificationEvent, CloudCertificationState> {
  final GetCompletedCertification completedUseCase;
  final GetInProgressCertification inProgressUseCase;

  CloudCertificationBloc(
      {required this.completedUseCase, required this.inProgressUseCase})
      : super(Empty());

  @override
  Stream<CloudCertificationState> mapEventToState(
    CloudCertificationEvent event,
  ) async* {
    if (event is GetCompletedCertificationsEvent) {
      yield Loading();
      final result = await completedUseCase.execute(NoParams());
      yield* _getState(result);
    } else if (event is GetInProgressCertificationsEvent) {
      yield Loading();
      final result = await inProgressUseCase.execute(NoParams());
      yield* _getState(result);
    }
  }

  Stream<CloudCertificationState> _getState(
      Either<Failure, List<CloudCertification>> arg) async* {
    yield arg.fold(
      (failure) => Error(message: _mapFailureToMessage(failure)),
      (certifications) => Loaded(items: certifications),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MSG;
      case CacheFailure:
        return CACHE_FAILURE_MSG;
      default:
        return UNKNOWN_ERROR_MSG;
    }
  }
}
