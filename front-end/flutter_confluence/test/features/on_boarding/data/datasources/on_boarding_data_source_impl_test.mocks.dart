// Mocks generated by Mockito 5.0.10 from annotations
// in flutter_confluence/test/features/on_boarding/data/datasources/on_boarding_data_source_impl_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i3;

import 'package:local_auth/auth_strings.dart' as _i5;
import 'package:local_auth/local_auth.dart' as _i4;
import 'package:mockito/mockito.dart' as _i1;
import 'package:shared_preferences/shared_preferences.dart' as _i2;

// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: comment_references
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis

/// A class which mocks [SharedPreferences].
///
/// See the documentation for Mockito's code generation for more information.
class MockSharedPreferences extends _i1.Mock implements _i2.SharedPreferences {
  MockSharedPreferences() {
    _i1.throwOnMissingStub(this);
  }

  @override
  Set<String> getKeys() => (super.noSuchMethod(Invocation.method(#getKeys, []),
      returnValue: <String>{}) as Set<String>);
  @override
  Object? get(String? key) =>
      (super.noSuchMethod(Invocation.method(#get, [key])) as Object?);
  @override
  bool? getBool(String? key) =>
      (super.noSuchMethod(Invocation.method(#getBool, [key])) as bool?);
  @override
  int? getInt(String? key) =>
      (super.noSuchMethod(Invocation.method(#getInt, [key])) as int?);
  @override
  double? getDouble(String? key) =>
      (super.noSuchMethod(Invocation.method(#getDouble, [key])) as double?);
  @override
  String? getString(String? key) =>
      (super.noSuchMethod(Invocation.method(#getString, [key])) as String?);
  @override
  bool containsKey(String? key) =>
      (super.noSuchMethod(Invocation.method(#containsKey, [key]),
          returnValue: false) as bool);
  @override
  List<String>? getStringList(String? key) =>
      (super.noSuchMethod(Invocation.method(#getStringList, [key]))
          as List<String>?);
  @override
  _i3.Future<bool> setBool(String? key, bool? value) =>
      (super.noSuchMethod(Invocation.method(#setBool, [key, value]),
          returnValue: Future<bool>.value(false)) as _i3.Future<bool>);
  @override
  _i3.Future<bool> setInt(String? key, int? value) =>
      (super.noSuchMethod(Invocation.method(#setInt, [key, value]),
          returnValue: Future<bool>.value(false)) as _i3.Future<bool>);
  @override
  _i3.Future<bool> setDouble(String? key, double? value) =>
      (super.noSuchMethod(Invocation.method(#setDouble, [key, value]),
          returnValue: Future<bool>.value(false)) as _i3.Future<bool>);
  @override
  _i3.Future<bool> setString(String? key, String? value) =>
      (super.noSuchMethod(Invocation.method(#setString, [key, value]),
          returnValue: Future<bool>.value(false)) as _i3.Future<bool>);
  @override
  _i3.Future<bool> setStringList(String? key, List<String>? value) =>
      (super.noSuchMethod(Invocation.method(#setStringList, [key, value]),
          returnValue: Future<bool>.value(false)) as _i3.Future<bool>);
  @override
  _i3.Future<bool> remove(String? key) =>
      (super.noSuchMethod(Invocation.method(#remove, [key]),
          returnValue: Future<bool>.value(false)) as _i3.Future<bool>);
  @override
  _i3.Future<bool> commit() =>
      (super.noSuchMethod(Invocation.method(#commit, []),
          returnValue: Future<bool>.value(false)) as _i3.Future<bool>);
  @override
  _i3.Future<bool> clear() => (super.noSuchMethod(Invocation.method(#clear, []),
      returnValue: Future<bool>.value(false)) as _i3.Future<bool>);
  @override
  _i3.Future<void> reload() =>
      (super.noSuchMethod(Invocation.method(#reload, []),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future.value()) as _i3.Future<void>);
}

/// A class which mocks [LocalAuthentication].
///
/// See the documentation for Mockito's code generation for more information.
class MockLocalAuthentication extends _i1.Mock
    implements _i4.LocalAuthentication {
  MockLocalAuthentication() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<bool> get canCheckBiometrics =>
      (super.noSuchMethod(Invocation.getter(#canCheckBiometrics),
          returnValue: Future<bool>.value(false)) as _i3.Future<bool>);
  @override
  _i3.Future<bool> authenticateWithBiometrics(
          {String? localizedReason,
          bool? useErrorDialogs = true,
          bool? stickyAuth = false,
          _i5.AndroidAuthMessages? androidAuthStrings =
              const _i5.AndroidAuthMessages(),
          _i5.IOSAuthMessages? iOSAuthStrings = const _i5.IOSAuthMessages(),
          bool? sensitiveTransaction = true}) =>
      (super.noSuchMethod(
          Invocation.method(#authenticateWithBiometrics, [], {
            #localizedReason: localizedReason,
            #useErrorDialogs: useErrorDialogs,
            #stickyAuth: stickyAuth,
            #androidAuthStrings: androidAuthStrings,
            #iOSAuthStrings: iOSAuthStrings,
            #sensitiveTransaction: sensitiveTransaction
          }),
          returnValue: Future<bool>.value(false)) as _i3.Future<bool>);
  @override
  _i3.Future<bool> authenticate(
          {String? localizedReason,
          bool? useErrorDialogs = true,
          bool? stickyAuth = false,
          _i5.AndroidAuthMessages? androidAuthStrings =
              const _i5.AndroidAuthMessages(),
          _i5.IOSAuthMessages? iOSAuthStrings = const _i5.IOSAuthMessages(),
          bool? sensitiveTransaction = true,
          bool? biometricOnly = false}) =>
      (super.noSuchMethod(
          Invocation.method(#authenticate, [], {
            #localizedReason: localizedReason,
            #useErrorDialogs: useErrorDialogs,
            #stickyAuth: stickyAuth,
            #androidAuthStrings: androidAuthStrings,
            #iOSAuthStrings: iOSAuthStrings,
            #sensitiveTransaction: sensitiveTransaction,
            #biometricOnly: biometricOnly
          }),
          returnValue: Future<bool>.value(false)) as _i3.Future<bool>);
  @override
  _i3.Future<bool> stopAuthentication() =>
      (super.noSuchMethod(Invocation.method(#stopAuthentication, []),
          returnValue: Future<bool>.value(false)) as _i3.Future<bool>);
  @override
  _i3.Future<bool> isDeviceSupported() =>
      (super.noSuchMethod(Invocation.method(#isDeviceSupported, []),
          returnValue: Future<bool>.value(false)) as _i3.Future<bool>);
  @override
  _i3.Future<List<_i4.BiometricType>> getAvailableBiometrics() =>
      (super.noSuchMethod(Invocation.method(#getAvailableBiometrics, []),
              returnValue:
                  Future<List<_i4.BiometricType>>.value(<_i4.BiometricType>[]))
          as _i3.Future<List<_i4.BiometricType>>);
}
