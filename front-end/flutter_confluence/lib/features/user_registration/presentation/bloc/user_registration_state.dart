part of 'user_registration_bloc.dart';

abstract class UserRegistrationState extends Equatable {
  @override
  List<Object> get props => [];
}

class UserRegistrationInitial extends UserRegistrationState {}

class UserRegistrationLoading extends UserRegistrationState {}

class UserRegistrationSuccess extends UserRegistrationState {}

class UserRegistrationError extends UserRegistrationState {
  UserRegistrationError({required this.errorMessage});

  final String errorMessage;

  @override
  List<Object> get props => [errorMessage];
}
