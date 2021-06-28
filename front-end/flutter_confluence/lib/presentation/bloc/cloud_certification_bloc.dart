import 'dart:async';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../core/error/failures.dart';
import '../../core/usecases/usecase.dart';
import '../../core/constants.dart';
import '../../domain/entities/cloud_certification.dart';
import '../../domain/usecases/get_completed_certifications.dart';
import '../../domain/usecases/get_in_progress_certifications.dart';

part 'cloud_certification_event.dart';
part 'cloud_certification_state.dart';

class CloudCertificationBloc
    extends Bloc<CloudCertificationEvent, CloudCertificationState> {
  final GetCompletedCertifications completedUseCase;
  final GetInProgressCertifications inProgressUseCase;

  CloudCertificationBloc(
      {required this.completedUseCase, required this.inProgressUseCase})
      : super(Empty());

  @override
  Stream<CloudCertificationState> mapEventToState(
    CloudCertificationEvent event,
  ) async* {

    log(this.runtimeType.toString() + " - New event received: " + event.runtimeType.toString());

    if (event is GetCompletedCertificationsEvent) {
      yield Loading();
      final result = await completedUseCase(NoParams());
      yield* _getState(result);
    } else if (event is GetInProgressCertificationsEvent) {
      yield Loading();
      final result = await inProgressUseCase(NoParams());
      yield* _getState(result);
    }

    if(event is SearchCertificationsEvent) {
      var searchTerm = event.searchTerm;
      if (searchTerm.isEmpty) {
        //TODO: Reset to latest state with data
      }
      else{
        yield Loading();
        //TODO: Filter data here
        yield EmptySearchResult();
      }
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
        return Constants.SERVER_FAILURE_MSG;
      case CacheFailure:
        return Constants.CACHE_FAILURE_MSG;
      default:
        return Constants.UNKNOWN_ERROR_MSG;
    }
  }
}
