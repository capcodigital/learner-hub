import 'dart:ui';

import 'package:flutter_confluence/domain/entities/cloud_certification.dart';

class Constants {
  // Colors
  static const JIRA_COLOR = const Color(0xff0052CC);

  // Certifications
  static const IC_GCP = 'ic_gcp.png';
  static const IC_AZURE = 'ic_azure.png';
  static const IC_CLOUD_NATIVE = 'ic_cloud_native.png';
  static const IC_HASHICORP = 'ic_hashicorp.png';
  static const IC_AWS = 'ic_aws.png';
  static const IC_UNKNOWN = 'ic_unknown.png';

  static const GCP = 'gcp';
  static const AZURE = 'azure';
  static const CLOUD_NATIVE = 'cloud_native';
  static const HASHICORP = 'hashicorp';
  static const AWS = 'aws';

  // Backend Endpoints
  static const BASE_API_URL = 'http://127.0.0.1:8000';
  static const COMPLETED_URL = 'completed';
  static const IN_PROGRESS_URL = 'in_progress';

  static const SERVER_FAILURE_MSG = "Server Failure";
  static const CACHE_FAILURE_MSG = "Cache Failure";
  static const UNKNOWN_ERROR_MSG = "Unknown Error";
}
