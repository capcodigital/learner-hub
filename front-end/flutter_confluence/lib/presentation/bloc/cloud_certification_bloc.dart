import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../core/error/failures.dart';
import '../../core/usecases/usecase.dart';
import '../../domain/usecases/get_cloud_certifications.dart';
import '../../domain/entities/certification.dart';

part 'cloud_certification_event.dart';
part 'cloud_certification_state.dart';

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
      final result = await getCloudCertifications(NoParams());
      yield* _getState(result);
    }
  }

  Stream<CloudCertificationState> _getState(
      Either<Failure, List<Certification>> arg) async* {
    yield arg.fold(
      (failue) => Error(message: "Error"),
      (certifications) => Loaded(items: certifications),
    );
  }
}
