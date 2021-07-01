import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/authenticate_use_case.dart';

part 'on_boarding_event.dart';
part 'on_boarding_state.dart';

class OnBoardingBloc extends Bloc<OnBoardingEvent, OnBoardingState> {
  final AuthenticateUseCase authUseCase;

  OnBoardingBloc({required this.authUseCase}) : super(Empty());

  @override
  Stream<OnBoardingState> mapEventToState(
    OnBoardingEvent event,
  ) async* {
    if (event is AuthenticationEvent) {
      yield Loading();
      final result = await authUseCase(NoParams());
      yield* _getState(result);
    }
  }

  Stream<OnBoardingState> _getState(Either<Failure, void> arg) async* {
    yield arg.fold(
      (failure) => Error(message: "Error"),
      (_) => Completed(),
    );
  }
}
