import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_confluence/domain/usecases/get_completed_certifications.dart';

import '../../core/error/failures.dart';
import '../../domain/usecases/get_in_progress_certifications.dart';
import '../../domain/entities/certification.dart';

part 'cloud_certification_event.dart';
part 'cloud_certification_state.dart';

const SERVER_FAILURE_MSG = "Server Failure";
const CACHE_FAILURE_MSG = "Cache Failure";
const UNKNOWN_ERROR_MSG = "Unknown Error";

class CloudCertificationBloc
    extends Bloc<CloudCertificationEvent, CloudCertificationState> {
  final GetCompletedCertifications completedUseCase;
  final GetInProgressCertifications inProgressUseCase;

  CloudCertificationBloc(
      {required this.completedUseCase, required this.inProgressUseCase})
      : super(CloudCertificationInitial());

  @override
  CloudCertificationState get initialState => Empty();

  @override
  Stream<CloudCertificationState> mapEventToState(
    CloudCertificationEvent event,
  ) async* {
    if (event is GetCompletedCertificationsEvent) {
      yield Loading();
      final result = await completedUseCase();
      yield* _getState(result);
    } else if (event is GetInProgressCertificationsEvent) {
      yield Loading();
      final result = await inProgressUseCase();
      yield* _getState(result);
    }
  }

  Stream<CloudCertificationState> _getState(
      Either<Failure, List<Certification>> arg) async* {
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
