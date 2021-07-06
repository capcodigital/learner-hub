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

const BIO_AUTH_PASSCODE_NOT_SET =
    "A Passcode (iOS) or PIN / Pattern / Password (Android) on the "
    "device has not yet been configured";
const BIO_AUTH_NOT_ENROLLED =
    "Biometric authentication is not setup on your device. Please either "
    "enable Touch ID or Face ID on your phone";
const BIO_AUTH_NOT_AVAILABLE =
    "The device does not have a Touch ID/fingerprint scanner. Did you allow "
    "Authentication in the Settings ?";
const BIO_AUTH_OTHER_OPERATING_SYSTEM =
    "It looks like device operating system is not iOS or Android";
const BIO_AUTH_LOCKED_OUT =
    "Authentication has been locked out due to too many attempts";
const BIO_AUTH_PERMANENTLY_LOCKED_OUT =
    "Authentication has been disabled due to too many lock outs. "
    "Strong authentication like PIN / Pattern / Password is required to unlock";
const BIO_AUTH_DEFAULT_AUTH_FAILED = "Authentication Failed";
