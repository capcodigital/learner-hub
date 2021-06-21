part of 'cloud_certification_bloc.dart';

abstract class CloudCertificationEvent extends Equatable {
  const CloudCertificationEvent();

  @override
  List<Object> get props => [];
}

class GetCompletedCertificationsEvent extends CloudCertificationEvent {
  GetCompletedCertificationsEvent();
}

class GetInProgressCertificationsEvent extends CloudCertificationEvent {
  GetInProgressCertificationsEvent();
}
