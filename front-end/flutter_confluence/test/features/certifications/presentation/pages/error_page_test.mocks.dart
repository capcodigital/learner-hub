// Mocks generated by Mockito 5.0.10 from annotations
// in flutter_confluence/test/features/certifications/presentation/pages/error_page_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i6;

import 'package:bloc/src/bloc.dart' as _i8;
import 'package:bloc/src/transition.dart' as _i7;
import 'package:flutter_confluence/features/certifications/domain/usecases/get_completed_certifications.dart'
    as _i2;
import 'package:flutter_confluence/features/certifications/domain/usecases/get_in_progress_certifications.dart'
    as _i3;
import 'package:flutter_confluence/features/certifications/domain/usecases/search_certifications.dart'
    as _i4;
import 'package:flutter_confluence/features/certifications/presentation/bloc/cloud_certification_bloc.dart'
    as _i5;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: comment_references
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis

class _FakeGetCompletedCertifications extends _i1.Fake
    implements _i2.GetCompletedCertifications {}

class _FakeGetInProgressCertifications extends _i1.Fake
    implements _i3.GetInProgressCertifications {}

class _FakeSearchCertifications extends _i1.Fake
    implements _i4.SearchCertifications {}

class _FakeCloudCertificationState extends _i1.Fake
    implements _i5.CloudCertificationState {}

class _FakeStreamSubscription<T> extends _i1.Fake
    implements _i6.StreamSubscription<T> {}

/// A class which mocks [CloudCertificationBloc].
///
/// See the documentation for Mockito's code generation for more information.
class MockCloudCertificationBloc extends _i1.Mock
    implements _i5.CloudCertificationBloc {
  MockCloudCertificationBloc() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.GetCompletedCertifications get completedUseCase =>
      (super.noSuchMethod(Invocation.getter(#completedUseCase),
              returnValue: _FakeGetCompletedCertifications())
          as _i2.GetCompletedCertifications);
  @override
  _i3.GetInProgressCertifications get inProgressUseCase =>
      (super.noSuchMethod(Invocation.getter(#inProgressUseCase),
              returnValue: _FakeGetInProgressCertifications())
          as _i3.GetInProgressCertifications);
  @override
  _i4.SearchCertifications get searchUserCase => (super.noSuchMethod(
      Invocation.getter(#searchUserCase),
      returnValue: _FakeSearchCertifications()) as _i4.SearchCertifications);
  @override
  _i5.CloudCertificationState get state =>
      (super.noSuchMethod(Invocation.getter(#state),
              returnValue: _FakeCloudCertificationState())
          as _i5.CloudCertificationState);
  @override
  _i6.Stream<_i5.CloudCertificationState> get stream =>
      (super.noSuchMethod(Invocation.getter(#stream),
              returnValue: Stream<_i5.CloudCertificationState>.empty())
          as _i6.Stream<_i5.CloudCertificationState>);
  @override
  _i6.Stream<_i5.CloudCertificationState> mapEventToState(
          _i5.CloudCertificationEvent? event) =>
      (super.noSuchMethod(Invocation.method(#mapEventToState, [event]),
              returnValue: Stream<_i5.CloudCertificationState>.empty())
          as _i6.Stream<_i5.CloudCertificationState>);
  @override
  void add(_i5.CloudCertificationEvent? event) =>
      super.noSuchMethod(Invocation.method(#add, [event]),
          returnValueForMissingStub: null);
  @override
  void onEvent(_i5.CloudCertificationEvent? event) =>
      super.noSuchMethod(Invocation.method(#onEvent, [event]),
          returnValueForMissingStub: null);
  @override
  _i6.Stream<_i7.Transition<_i5.CloudCertificationEvent, _i5.CloudCertificationState>>
      transformEvents(
              _i6.Stream<_i5.CloudCertificationEvent>? events,
              _i8.TransitionFunction<_i5.CloudCertificationEvent,
                      _i5.CloudCertificationState>?
                  transitionFn) =>
          (super.noSuchMethod(
                  Invocation.method(#transformEvents, [events, transitionFn]),
                  returnValue:
                      Stream<_i7.Transition<_i5.CloudCertificationEvent, _i5.CloudCertificationState>>.empty())
              as _i6.Stream<_i7.Transition<_i5.CloudCertificationEvent, _i5.CloudCertificationState>>);
  @override
  void emit(_i5.CloudCertificationState? state) =>
      super.noSuchMethod(Invocation.method(#emit, [state]),
          returnValueForMissingStub: null);
  @override
  void onTransition(
          _i7.Transition<_i5.CloudCertificationEvent,
                  _i5.CloudCertificationState>?
              transition) =>
      super.noSuchMethod(Invocation.method(#onTransition, [transition]),
          returnValueForMissingStub: null);
  @override
  _i6.Stream<_i7.Transition<_i5.CloudCertificationEvent, _i5.CloudCertificationState>>
      transformTransitions(
              _i6.Stream<_i7.Transition<_i5.CloudCertificationEvent, _i5.CloudCertificationState>>?
                  transitions) =>
          (super.noSuchMethod(
                  Invocation.method(#transformTransitions, [transitions]),
                  returnValue:
                      Stream<_i7.Transition<_i5.CloudCertificationEvent, _i5.CloudCertificationState>>.empty())
              as _i6.Stream<
                  _i7.Transition<_i5.CloudCertificationEvent, _i5.CloudCertificationState>>);
  @override
  _i6.Future<void> close() => (super.noSuchMethod(Invocation.method(#close, []),
      returnValue: Future<void>.value(),
      returnValueForMissingStub: Future.value()) as _i6.Future<void>);
  @override
  _i6.StreamSubscription<_i5.CloudCertificationState> listen(
          void Function(_i5.CloudCertificationState)? onData,
          {Function? onError,
          void Function()? onDone,
          bool? cancelOnError}) =>
      (super.noSuchMethod(
              Invocation.method(#listen, [
                onData
              ], {
                #onError: onError,
                #onDone: onDone,
                #cancelOnError: cancelOnError
              }),
              returnValue:
                  _FakeStreamSubscription<_i5.CloudCertificationState>())
          as _i6.StreamSubscription<_i5.CloudCertificationState>);
  @override
  void onChange(_i7.Change<_i5.CloudCertificationState>? change) =>
      super.noSuchMethod(Invocation.method(#onChange, [change]),
          returnValueForMissingStub: null);
  @override
  void addError(Object? error, [StackTrace? stackTrace]) =>
      super.noSuchMethod(Invocation.method(#addError, [error, stackTrace]),
          returnValueForMissingStub: null);
  @override
  void onError(Object? error, StackTrace? stackTrace) =>
      super.noSuchMethod(Invocation.method(#onError, [error, stackTrace]),
          returnValueForMissingStub: null);
}
