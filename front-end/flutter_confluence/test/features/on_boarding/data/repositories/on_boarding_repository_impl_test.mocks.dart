// Mocks generated by Mockito 5.0.10 from annotations
// in flutter_confluence/test/features/on_boarding/data/repositories/on_boarding_repository_impl_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i3;

import 'package:flutter_confluence/features/onboarding/data/datasources/on_boarding_local_data_source.dart'
    as _i2;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: comment_references
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis

/// A class which mocks [OnBoardingDataSource].
///
/// See the documentation for Mockito's code generation for more information.
class MockOnBoardingDataSource extends _i1.Mock
    implements _i2.OnBoardingLocalDataSource {
  MockOnBoardingDataSource() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<bool> authenticate() =>
      (super.noSuchMethod(Invocation.method(#authenticate, []),
          returnValue: Future<bool>.value(false)) as _i3.Future<bool>);
  @override
  _i3.Future<void> saveAuthTimeStamp() =>
      (super.noSuchMethod(Invocation.method(#saveAuthTimeStamp, []),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future.value()) as _i3.Future<void>);
  @override
  _i3.Future<bool> checkCachedAuth() =>
      (super.noSuchMethod(Invocation.method(#checkCachedAuth, []),
          returnValue: Future<bool>.value(false)) as _i3.Future<bool>);
  @override
  _i3.Future<void> clearCachedAuth() =>
      (super.noSuchMethod(Invocation.method(#clearCachedAuth, []),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future.value()) as _i3.Future<void>);
}
