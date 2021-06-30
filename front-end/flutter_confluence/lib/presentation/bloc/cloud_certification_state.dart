part of 'cloud_certification_bloc.dart';

abstract class CloudCertificationState extends Equatable {
  final List<CloudCertification> items;

  CloudCertificationState({required this.items});

  @override
  List<Object> get props => [items];
}

class Empty extends CloudCertificationState {
  Empty() : super(items: List.empty());
}

class Loading extends CloudCertificationState {
  Loading() : super(items: List.empty());
}

class EmptySearchResult extends CloudCertificationState {
  EmptySearchResult({required items}) : super(items: items);
}

class Loaded extends CloudCertificationState {
  Loaded({required items}) : super(items: items);
}

class Filtered extends CloudCertificationState {
  final List<CloudCertification> filteredItems;

  Filtered({
    required items,
    required this.filteredItems,
  }) : super(items: items);

  @override
  List<Object> get props => [items, filteredItems];
}

class Error extends CloudCertificationState {
  final String message;

  Error({required this.message}) : super(items: List.empty());

  @override
  List<Object> get props => [message];
}
