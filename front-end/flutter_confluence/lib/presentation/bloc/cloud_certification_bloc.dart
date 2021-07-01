import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_confluence/domain/usecases/search_certifications.dart';

import '../../core/constants.dart';
import '../../core/error/failures.dart';
import '../../core/usecases/usecase.dart';
import '../../domain/entities/cloud_certification.dart';
import '../../domain/usecases/get_completed_certifications.dart';
import '../../domain/usecases/get_in_progress_certifications.dart';

part 'cloud_certification_event.dart';
part 'cloud_certification_state.dart';

class CloudCertificationBloc
    extends Bloc<CloudCertificationEvent, CloudCertificationState> {
  final GetCompletedCertifications completedUseCase;
  final GetInProgressCertifications inProgressUseCase;
  final SearchCertifications searchUserCase;

  CloudCertificationBloc({
    required this.completedUseCase,
    required this.inProgressUseCase,
    required this.searchUserCase
  }) : super(Empty());

  @override
  Stream<CloudCertificationState> mapEventToState(
    CloudCertificationEvent event,
  ) async* {

    log(this.runtimeType.toString() + " - New event received: " + event.runtimeType.toString());

    if (event is GetCompletedCertificationsEvent) {
      yield Loading();
      final result = await completedUseCase(NoParams());
      yield* _getState(result, CloudCertificationType.completed);
    } else if (event is GetInProgressCertificationsEvent) {
      yield Loading();
      final result = await inProgressUseCase(NoParams());
      yield* _getState(result, CloudCertificationType.in_progress);
    } else if (event is SearchCertificationsEvent) {
      yield* _getSearchState(event.searchTerm);
    }
  }

  Stream<CloudCertificationState> _getState(Either<Failure, List<CloudCertification>> arg, CloudCertificationType dataType,{bool isSearch = false}) async* {
    yield arg.fold(
      (failure) => Error(message: _mapFailureToMessage(failure)),
      (certifications) {
        if (isSearch) {
          if (certifications.isNotEmpty) {
            return Loaded(items: certifications, type: dataType);
          } else {
            return EmptySearchResult(type: dataType);
          }
        }
        else {
          return Loaded(items: certifications, type: dataType);
        }
      }
    );
  }

  Stream<CloudCertificationState> _getSearchState(String searchTerm) async* {
    CloudCertificationType dataType;
    if (state is Loaded) {
      dataType = (state as Loaded).type;
    } else if (state is EmptySearchResult) {
      dataType = (state as EmptySearchResult).type;
    }
    else {
      // Error! You come back from an invalid state
      log("Incorrect state: " + state.runtimeType.toString());
      yield Error(message: "Something went wrong");
      return;
    }

    var searchParameters = SearchParams(
        searchQuery: searchTerm,
        dataType: dataType);

    yield Loading();
    final result = await searchUserCase(searchParameters);
    yield* _getState(result, searchParameters.dataType, isSearch: true);
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
