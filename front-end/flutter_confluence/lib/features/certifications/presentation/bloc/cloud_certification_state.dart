part of 'cloud_certification_bloc.dart';

abstract class CloudCertificationState extends Equatable {
  const CloudCertificationState(
      {this.cloudCertificationType = CloudCertificationType.in_progress});
  final CloudCertificationType cloudCertificationType;

  @override
  List<Object> get props => [cloudCertificationType];
}

class Empty extends CloudCertificationState {}

class Loading extends CloudCertificationState {}

class Loaded extends CloudCertificationState {
  const Loaded({required this.items, required cloudCertificationType})
      : super(cloudCertificationType: cloudCertificationType);
  final List<CloudCertification> items;

  @override
  List<Object> get props => [items, cloudCertificationType];
}

class EmptySearchResult extends CloudCertificationState {
  const EmptySearchResult({required this.cloudCertificationType});
  @override
  final CloudCertificationType cloudCertificationType;

  @override
  List<Object> get props => [cloudCertificationType];
}

class Error extends CloudCertificationState {
  const Error({required this.message, required cloudCertificationType})
      : super(cloudCertificationType: cloudCertificationType);
  final String message;

  @override
  List<Object> get props => [message, cloudCertificationType];
}
