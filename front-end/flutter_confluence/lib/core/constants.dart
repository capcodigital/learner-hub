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
}

// Following 2 lists of dummy items used temporarily until show real items
// from network / cache

final List<CloudCertification> mockCompletedCerts = [
  CloudCertification(
      name: "John Smith",
      certificationType: "Professional Network Engineer",
      platform: "aws",
      certificationDate: "1/6/2021"),
  CloudCertification(
      name: "Jane Doe",
      certificationType: "GCP Associcate Cloud Engineer",
      platform: "gcp",
      certificationDate: "2/4/2020"),
  CloudCertification(
      name: "Jack Jones",
      certificationType: "Cloud Native Architect Associate",
      platform: "cloud_native",
      certificationDate: "1/7/2021"),
  CloudCertification(
      name: "Jane Smith",
      certificationType: "Microsoft Azure Data Fundamentals",
      platform: "azure",
      certificationDate: "12/4/20"),
  CloudCertification(
      name: "Jane Smith",
      certificationType: "Associate Terraform Engineer",
      platform: "hashicorp",
      certificationDate: "12/1/21"),
  CloudCertification(
      name: "Jack Jones",
      certificationType: "Cloud Native Architect Professional",
      platform: "cloud_native",
      certificationDate: "9/11/20"),
  CloudCertification(
      name: "Jane Smith",
      certificationType: "Microsoft Azure Data Fundamentals",
      platform: "azure",
      certificationDate: "11/3/20"),
  CloudCertification(
      name: "Jane Smith",
      certificationType: "Associate Terraform Engineer",
      platform: "hashicorp",
      certificationDate: "22/8/19"),
  CloudCertification(
      name: "Jane Doe",
      certificationType: "Chief Terraform Engineer",
      platform: "hashicorp",
      certificationDate: "2/8/20"),
  CloudCertification(
      name: "John Smith",
      certificationType: "Azure Chief Engineer",
      platform: "azure",
      certificationDate: "22/8/19"),
  CloudCertification(
      name: "Michael Jones",
      certificationType: "GCP Chief Engineer",
      platform: "gcp",
      certificationDate: "4/1/21"),
  CloudCertification(
      name: "Michael Jones",
      certificationType: "Azure Chief Architect",
      platform: "azure",
      certificationDate: "4/1/20"),
];

final List<CloudCertification> mockInrogressCerts = [
  CloudCertification(
      name: "Mathew Adams",
      certificationType: "Professional Network Engineer",
      platform: "aws",
      certificationDate: "1/6/2021"),
  CloudCertification(
      name: "Judie Blades",
      certificationType: "GCP Associcate Cloud Engineer",
      platform: "gcp",
      certificationDate: "2/4/2020"),
  CloudCertification(
      name: "Jack Jones",
      certificationType: "Cloud Native Architect Professional",
      platform: "cloud_native",
      certificationDate: "9/11/20"),
  CloudCertification(
      name: "Jane Smith",
      certificationType: "Microsoft Azure Data Fundamentals",
      platform: "azure",
      certificationDate: "11/3/20"),
  CloudCertification(
      name: "Jane Smith",
      certificationType: "Associate Terraform Engineer",
      platform: "hashicorp",
      certificationDate: "22/8/19"),
];
