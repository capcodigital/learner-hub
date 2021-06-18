part of 'cloud_certification_bloc.dart';

abstract class CloudCertificationState extends Equatable {
  const CloudCertificationState();

  @override
  List<Object> get props => [];
}

class CloudCertificationInitial extends CloudCertificationState {}

class Empty extends CloudCertificationState {}

class Loading extends CloudCertificationState {}

class Loaded extends CloudCertificationState {
  final List<Certification> items;
  
  Loaded({required this.items});

  @override
  List<Object> get props => [items];
}

class Error extends CloudCertificationState {
  final String message;

  Error({required this.message})

  @override
  List<Object> get props => [message];
}
