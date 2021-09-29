part of 'auth_bloc.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLogout extends AuthState {}
class AuthLogoutError extends AuthState {}
