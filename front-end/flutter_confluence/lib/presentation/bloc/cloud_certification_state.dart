part of 'cloud_certification_bloc.dart';

abstract class CloudCertificationState extends Equatable {
  @override
  List<Object> get props => [];
}

enum CloudCertificationType {
  completed,
  in_progress
}

class Empty extends CloudCertificationState { }

class Loading extends CloudCertificationState { }

class Loaded extends CloudCertificationState {
  final CloudCertificationType type;
  final List<CloudCertification> items;

  Loaded({required this.type, required this.items});

  @override
  List<Object> get props => [items, type];
}

class EmptySearchResult extends CloudCertificationState {
  final CloudCertificationType type;

  EmptySearchResult({required this.type});

  @override
  List<Object> get props => [type];
}


class Error extends CloudCertificationState {
  final String message;

  Error({required this.message});

  @override
  List<Object> get props => [message];
}
