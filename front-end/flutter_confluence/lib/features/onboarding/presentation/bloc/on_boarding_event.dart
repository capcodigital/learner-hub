part of 'on_boarding_bloc.dart';

abstract class OnBoardingEvent extends Equatable {
  const OnBoardingEvent();

  @override
  List<Object> get props => [];
}

class AuthEvent extends OnBoardingEvent {
  AuthEvent();
}

class CheckAuthEvent extends OnBoardingEvent {
  CheckAuthEvent();
}