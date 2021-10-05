part of 'auth_bloc.dart';

@immutable
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthError extends AuthState {
  const AuthError({required this.message});

  final String message;

  @override
  List<Object> get props => [message];
}

// Check User
class ValidUser extends AuthState {}
class InvalidUser extends AuthState {}

// Login States
class LoginLoading extends AuthState {}
class LoginSuccess extends AuthState {}

// Logout
class AuthLogout extends AuthState {}
