import '../../core/constants.dart';

class Certification {
  final String name;
  final String certification;
  final String platform;
  final String date;
  String? icon;

  Certification(
      {required this.name,
      required this.certification,
      required this.platform,
      required this.date}) {
    setupIcon();
  }

  void setupIcon() {
    switch (this.platform) {
      case Constants.GCP:
        icon = Constants.IC_GCP;
        break;
      case Constants.AZURE:
        icon = Constants.IC_AZURE;
        break;
      case Constants.CLOUD_NATIVE:
        icon = Constants.IC_CLOUD_NATIVE;
        break;
      case Constants.HASHICORP:
        icon = Constants.IC_HASHICORP;
        break;
      case Constants.AWS:
        icon = Constants.IC_AWS;
        break;
    }
  }
}

// Following 2 lists of dummy items used temporarily until show real items
// from network / cache

final List<Certification> mockCompletedCerts = [
  Certification(
      name: "John Smith",
      certification: "Professional Network Engineer",
      platform: "aws",
      date: "1/6/2021"),
  Certification(
      name: "Jane Doe",
      certification: "GCP Associcate Cloud Engineer",
      platform: "gcp",
      date: "2/4/2020"),
  Certification(
      name: "Jack Jones",
      certification: "Cloud Native Architect Associate",
      platform: "cloud_native",
      date: "1/7/2021"),
  Certification(
      name: "Jane Smith",
      certification: "Microsoft Azure Data Fundamentals",
      platform: "azure",
      date: "12/4/20"),
  Certification(
      name: "Jane Smith",
      certification: "Associate Terraform Engineer",
      platform: "hashicorp",
      date: "12/1/21"),
  Certification(
      name: "Jack Jones",
      certification: "Cloud Native Architect Professional",
      platform: "cloud_native",
      date: "9/11/20"),
  Certification(
      name: "Jane Smith",
      certification: "Microsoft Azure Data Fundamentals",
      platform: "azure",
      date: "11/3/20"),
  Certification(
      name: "Jane Smith",
      certification: "Associate Terraform Engineer",
      platform: "hashicorp",
      date: "22/8/19"),
  Certification(
      name: "Jane Doe",
      certification: "Chief Terraform Engineer",
      platform: "hashicorp",
      date: "2/8/20"),
  Certification(
      name: "John Smith",
      certification: "Azure Chief Engineer",
      platform: "azure",
      date: "22/8/19"),
  Certification(
      name: "Michael Jones",
      certification: "GCP Chief Engineer",
      platform: "gcp",
      date: "4/1/21"),
  Certification(
      name: "Michael Jones",
      certification: "Azure Chief Architect",
      platform: "azure",
      date: "4/1/20"),
];

final List<Certification> mockInrogressCerts = [
  Certification(
      name: "Penny Hardaway",
      certification: "Professional Network Engineer",
      platform: "aws",
      date: "1/6/2021"),
  Certification(
      name: "Scottie Pippen",
      certification: "GCP Associcate Cloud Engineer",
      platform: "gcp",
      date: "2/4/2020"),
  Certification(
      name: "Jack Jones",
      certification: "Cloud Native Architect Associate",
      platform: "cloud_native",
      date: "1/7/2021"),
  Certification(
      name: "Jane Smith",
      certification: "Microsoft Azure Data Fundamentals",
      platform: "azure",
      date: "12/4/20"),
  Certification(
      name: "Jane Smith",
      certification: "Associate Terraform Engineer",
      platform: "hashicorp",
      date: "12/1/21"),
  Certification(
      name: "Jack Jones",
      certification: "Cloud Native Architect Professional",
      platform: "cloud_native",
      date: "9/11/20"),
  Certification(
      name: "Jane Smith",
      certification: "Microsoft Azure Data Fundamentals",
      platform: "azure",
      date: "11/3/20"),
  Certification(
      name: "Jane Smith",
      certification: "Associate Terraform Engineer",
      platform: "hashicorp",
      date: "22/8/19"),
  Certification(
      name: "Jane Doe",
      certification: "Chief Terraform Engineer",
      platform: "hashicorp",
      date: "2/8/20"),
  Certification(
      name: "John Smith",
      certification: "Azure Chief Engineer",
      platform: "azure",
      date: "22/8/19"),
  Certification(
      name: "Michael Jones",
      certification: "GCP Chief Engineer",
      platform: "gcp",
      date: "4/1/21"),
  Certification(
      name: "Michael Jones",
      certification: "Azure Chief Architect",
      platform: "azure",
      date: "4/1/20"),
];
