part of 'user_registration_bloc.dart';

abstract class UserRegistrationEvent {}

class RegisterUserEvent extends UserRegistrationEvent {
  RegisterUserEvent({required this.parameters, required this.password});

  final UserRegistration parameters;
  final String? password;
}
