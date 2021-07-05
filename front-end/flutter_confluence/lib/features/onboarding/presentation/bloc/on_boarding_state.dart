part of 'on_boarding_bloc.dart';

abstract class OnBoardingState extends Equatable {
  const OnBoardingState();
  
  @override
  List<Object> get props => [];
}

class Empty extends OnBoardingState {}

class Loading extends OnBoardingState {}

class Completed extends OnBoardingState {}

class Expired extends OnBoardingState {}

class Error extends OnBoardingState {
  final String message;

  Error({required this.message});

  @override
  List<Object> get props => [message];
}
