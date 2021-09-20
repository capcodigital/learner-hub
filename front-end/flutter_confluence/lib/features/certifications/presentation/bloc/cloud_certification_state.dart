part of 'cloud_certification_bloc.dart';

abstract class CloudCertificationState extends Equatable {
  final CloudCertificationType cloudCertificationType;

  const CloudCertificationState(
      {this.cloudCertificationType = CloudCertificationType.in_progress});

  @override
  List<Object> get props => [cloudCertificationType];
}

class Empty extends CloudCertificationState {}

class Loading extends CloudCertificationState {}

class Loaded extends CloudCertificationState {
  final List<CloudCertification> items;

  const Loaded({required this.items, required cloudCertificationType})
      : super(cloudCertificationType: cloudCertificationType);

  @override
  List<Object> get props => [items, cloudCertificationType];
}

class EmptySearchResult extends CloudCertificationState {
  @override
  final CloudCertificationType cloudCertificationType;

  const EmptySearchResult({required this.cloudCertificationType});

  @override
  List<Object> get props => [cloudCertificationType];
}

class Error extends CloudCertificationState {
  final String message;

  const Error({required this.message, required cloudCertificationType})
      : super(cloudCertificationType: cloudCertificationType);

  @override
  List<Object> get props => [message, cloudCertificationType];
}
