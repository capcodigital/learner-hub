import 'dart:ui';

import 'package:flutter/material.dart';

class Constants {
  // Colors
  static const JIRA_COLOR = const Color(0xff0052CC);
  static const BLACK_75 = const Color(0xBF000000);
  static final BLACK_25 = Colors.black.withOpacity(0.25);

  // Icons
  static const IC_FLUTTER = 'ic_flutter.png';
  static const IC_PLUS = 'ic_plus.png';
  static const IC_CONFLUENCE = 'ic_confluence.png';
  static const IC_ERROR = 'ic_error.png';
  static const IC_BACK_LAYER = 'back-layer.png';
  static const IC_FRONT_LAYER = 'front-layer.png';

  // Certification icons
  static const IC_GCP = 'ic_gcp.png';
  static const IC_AZURE = 'ic_azure.png';
  static const IC_CLOUD_NATIVE = 'ic_cloud_native.png';
  static const IC_HASHICORP = 'ic_hashicorp.png';
  static const IC_AWS = 'ic_aws.png';
  static const IC_UNKNOWN = 'ic_unknown.png';
  static const IC_ONBOARDING_CARD_BG = 'ic_rectangle.png';

  // Certification platforms
  static const GCP = 'gcp';
  static const AZURE = 'azure';
  static const CLOUD_NATIVE = 'cloud native foundation';
  static const CNCF = 'cncf';
  static const HASHICORP = 'hashicorp';
  static const AWS = 'aws';

  // Backend Endpoints
  static const BASE_API_URL = 'http://127.0.0.1:8000';
  static const COMPLETED_URL = 'completed';
  static const IN_PROGRESS_URL = 'in_progress';

  // Certifications Errors
  static const SERVER_FAILURE_MSG = "Server Failure";
  static const CACHE_FAILURE_MSG = "Cache Failure";
  static const UNKNOWN_ERROR_MSG = "Unknown Error";

  static const ERROR_500_599 = "Something went wrong. Please try again";
  static const ERROR_401 = "Client is not authenticated";
  static const ERROR_403 = "Client does not have access rights";
  static const ERROR_404 = "Server can not find requested resource";

  // Biometric Auth Error Messages
  static const BIO_AUTH_PASSCODE_NOT_SET =
      "A Passcode (iOS) or PIN / Pattern / Password (Android) on the "
      "device has not yet been configured";
  static const BIO_AUTH_NOT_ENROLLED =
      "Biometric authentication is not setup on your device. Please either "
      "enable Touch ID or Face ID on your phone";
  static const BIO_AUTH_NOT_AVAILABLE =
      "The device does not have a Touch ID/fingerprint scanner. Did you allow "
      "Authentication in the Settings ?";
  static const BIO_AUTH_OTHER_OPERATING_SYSTEM =
      "It looks like device operating system is not iOS or Android";
  static const BIO_AUTH_LOCKED_OUT =
      "Authentication has been locked out due to too many attempts";
  static const BIO_AUTH_PERMANENTLY_LOCKED_OUT =
      "Authentication has been disabled due to too many lock outs. "
      "Strong authentication like PIN / Pattern / Password is required to unlock";
  static const BIO_AUTH_DEFAULT_AUTH_FAILED = "Authentication failed";

  static const NO_RESULTS = 'No results';
  static const UNKNOWN_ERROR = 'Unknown Error';
}
