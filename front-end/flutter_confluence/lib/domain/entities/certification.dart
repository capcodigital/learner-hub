import '../../core/constants.dart';

class Certification {
  final String userName;
  final String certificationTitle;
  // Field certificationType is used temporarily to determine the certification icon
  final String certificationType;
  final String certificationDate;
  String? certificationIconName;

  Certification(
      {required this.userName,
      required this.certificationTitle,
      required this.certificationType,
      required this.certificationDate}) {
    setCertificationIconName();
  }

  void setCertificationIconName() {
    switch (this.certificationType) {
      case Constants.GCP:
        certificationIconName = Constants.IC_GCP;
        break;
      case Constants.AZURE:
        certificationIconName = Constants.IC_AZURE;
        break;
      case Constants.CLOUD_NATIVE:
        certificationIconName = Constants.IC_CLOUD_NATIVE;
        break;
      case Constants.HASHICORP:
        certificationIconName = Constants.IC_HASHICORP;
        break;
      case Constants.AWS:
        certificationIconName = Constants.IC_AWS;
        break;
    }
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
