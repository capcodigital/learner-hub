part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoginRequestEvent extends LoginEvent {
  LoginRequestEvent({required this.email, required this.password});

  final String email;
  final String password;

  @override
  List<Object> get props => [email, password];
}