class Certification {
  static const IC_GCP = 'ic_gcp.png';
  static const IC_AZURE = 'ic_azure.png';
  static const IC_CLOUD_NATIVE = 'ic_cloud_native.png';
  static const IC_HASHICORP = 'ic_hashicorp.png';
  static const IC_AWS = 'ic_aws.png';

  static const GCP = 'gcp';
  static const AZURE = 'azure';
  static const CLOUD_NATIVE = 'cloud_native';
  static const HASHICORP = 'hashicorp';
  static const AWS = 'aws';

  final String userName;
  final String certificationTitle;
  // Field certificationType is used temporarily to determine the certification icon
  final String certificationType;
  final String certificationDate;
  late String certificationIconName;

  Certification(
      {required this.userName,
      required this.certificationTitle,
      required this.certificationType,
      required this.certificationDate}) {
    this.certificationIconName = getCertificationIconName();
  }

  String getCertificationIconName() {
    switch (this.certificationType) {
      case GCP:
        return IC_GCP;
      case AZURE:
        return IC_AZURE;
      case CLOUD_NATIVE:
        return IC_CLOUD_NATIVE;
      case HASHICORP:
        return IC_HASHICORP;
      case AWS:
        return IC_AWS;
    }
    return "";
  }
}

// This list of dummy items is used temporarily and will be removed when
// we add the real data
final List<Certification> certifications = [
  Certification(
      userName: "John Smith",
      certificationTitle: "Professional Network Engineer",
      certificationType: "aws",
      certificationDate: "1/6/2021"),
  Certification(
      userName: "Jane Doe",
      certificationTitle: "GCP Associcate Cloud Engineer",
      certificationType: "gcp",
      certificationDate: "2/4/2020"),
  Certification(
      userName: "Jack Jones",
      certificationTitle: "Cloud Native Architect Associate",
      certificationType: "cloud_native",
      certificationDate: "1/7/2021"),
  Certification(
      userName: "Jane Smith",
      certificationTitle: "Microsoft Azure Data Fundamentals",
      certificationType: "azure",
      certificationDate: "12/4/20"),
  Certification(
      userName: "Jane Smith",
      certificationTitle: "Associate Terraform Engineer",
      certificationType: "hashicorp",
      certificationDate: "12/1/21"),
  Certification(
      userName: "Jack Jones",
      certificationTitle: "Cloud Native Architect Professional",
      certificationType: "cloud_native",
      certificationDate: "9/11/20"),
  Certification(
      userName: "Jane Smith",
      certificationTitle: "Microsoft Azure Data Fundamentals",
      certificationType: "azure",
      certificationDate: "11/3/20"),
  Certification(
      userName: "Jane Smith",
      certificationTitle: "Associate Terraform Engineer",
      certificationType: "hashicorp",
      certificationDate: "22/8/19"),
  Certification(
      userName: "Jane Doe",
      certificationTitle: "Chief Terraform Engineer",
      certificationType: "hashicorp",
      certificationDate: "2/8/20"),
  Certification(
      userName: "John Smith",
      certificationTitle: "Azure Chief Engineer",
      certificationType: "azure",
      certificationDate: "22/8/19"),
  Certification(
      userName: "Michael Jones",
      certificationTitle: "GCP Chief Engineer",
      certificationType: "gcp",
      certificationDate: "4/1/21"),
  Certification(
      userName: "Michael Jones",
      certificationTitle: "Azure Chief Architect",
      certificationType: "azure",
      certificationDate: "4/1/20"),
];
