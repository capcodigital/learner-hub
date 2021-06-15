class Certification {
  String userName;
  String certificationTitle;
  String certificationType;
  String certificationDate;
  late String certificationIconName;

  Certification(this.userName, this.certificationTitle, this.certificationType,
      this.certificationDate) {
    this.certificationIconName =
        getCertificationIconName(this.certificationType);
  }
}

final List<Certification> dummyItems = [
  Certification(
      "John Smith", "Professional Network Engineer", "aws", "1/6/2021"),
  Certification("Jane Doe", "GCP Associcate Cloud Engineer", "aws", "2/4/2020"),
  Certification("Jack Jones", "Cloud Native Architect Associate",
      "cloud_native", "1/7/2021"),
  Certification(
      "Jane Smith", "Microsoft Azure Data Fundamentals", "azure", "12/4/20"),
  Certification(
      "Jane Smith", "Associate Terraform Engineer", "hashicorp", "12/1/21"),
  Certification("Jack Jones", "Cloud Native Architect Professional",
      "cloud_native", "9/11/20"),
  Certification(
      "Jane Smith", "Microsoft Azure Data Fundamentals", "azure", "11/3/20"),
  Certification(
      "Jane Smith", "Associate Terraform Engineer", "hashicorp", "22/8/19"),
  Certification("Jane Doe", "Chief Terraform Engineer", "hashicorp", "2/8/20"),
  Certification("John Smith", "Azure Chief Engineer", "azure", "22/8/19"),
  Certification("Michael Jones", "GCP Chief Engineer", "gcp", "4/1/21"),
  Certification("Michael Jones", "Azure Chief Architect", "azure", "4/1/20"),
];

String getCertificationIconName(String identifier) {
  switch (identifier) {
    case "gcp":
      return "ic_gcp.png";
    case "azure":
      return "ic_azure.png";
    case "cloud_native":
      return "ic_cloud_native.png";
    case "hashicorp":
      return "ic_hashicorp.png";
  }
  return "ic_gcp.png";
}
