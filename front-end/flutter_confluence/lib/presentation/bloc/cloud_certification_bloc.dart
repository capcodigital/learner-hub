import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'cloud_certification_event.dart';
part 'cloud_certification_state.dart';

class CloudCertificationBloc extends Bloc<CloudCertificationEvent, CloudCertificationState> {
  CloudCertificationBloc() : super(CloudCertificationInitial());

  @override
  Stream<CloudCertificationState> mapEventToState(
    CloudCertificationEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
