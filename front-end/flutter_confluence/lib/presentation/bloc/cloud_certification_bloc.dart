import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../core/error/failures.dart';
import '../../domain/usecases/get_cloud_certifications.dart';
import '../../domain/entities/certification.dart';

part 'cloud_certification_event.dart';
part 'cloud_certification_state.dart';

const SERVER_FAILURE_MSG = "Server Failure";
const CACHE_FAILURE_MSG = "Cache Failure";
const UNKNOWN_ERROR_MSG = "Unknown Error";

class CloudCertificationBloc
    extends Bloc<CloudCertificationEvent, CloudCertificationState> {
  final GetCloudCertifications getCloudCertifications;

  CloudCertificationBloc({required this.getCloudCertifications})
      : super(CloudCertificationInitial());

  @override
  CloudCertificationState get initialState => Empty();

  @override
  Stream<CloudCertificationState> mapEventToState(
    CloudCertificationEvent event,
  ) async* {
    if (event is GetCertificationsEvent) {
      yield Loading();
      final result = await getCloudCertifications();
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
