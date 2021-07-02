import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_confluence/features/onboarding/domain/usecases/check_auth_use_case.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/auth_use_case.dart';

part 'on_boarding_event.dart';
part 'on_boarding_state.dart';

class OnBoardingBloc extends Bloc<OnBoardingEvent, OnBoardingState> {
  final AuthUseCase authUseCase;
  final CheckAuthUseCase checkAuthUseCase;

  OnBoardingBloc({required this.authUseCase, required this.checkAuthUseCase})
      : super(Empty());

  @override
  Stream<OnBoardingState> mapEventToState(
    OnBoardingEvent event,
  ) async* {
    if (event is AuthEvent) {
      yield Loading();
      final result = await authUseCase(NoParams());
      yield* _getState(result);
    }
    if (event is CheckAuthEvent) {
      yield Loading();
      final result = await checkAuthUseCase(NoParams());
      yield* _getState(result);
    }
  }

  Stream<OnBoardingState> _getState(Either<Failure, bool> arg) async* {
    yield arg.fold(
      (failure) => Error(message: "error"),
      (result) => result ? Completed() : Error(message: 'error'),
    );
  }
}
