class Item {
  String user;
  String certificationTitle;
  String certificationType;
  String date;
  String? iconName;

  Item(this.user, this.certificationTitle, this.certificationType, this.date) {
    this.iconName = getCertificationIconName(this.certificationType);
  }
}

final List<Item> dummyItems = [
  Item("John Smith", "Professional Network Engineer", "aws", "1/6/2021"),
  Item("Jane Doe", "GCP Associcate Cloud Engineer", "aws", "2/4/2020"),
  Item("Jack Jones", "Cloud Native Architect Associate", "cloud_native",
      "1/7/2021"),
  Item("Jane Smith", "Microsoft Azure Data Fundamentals", "azure", "12/4/20"),
  Item("Jane Smith", "Associate Terraform Engineer", "hashicorp", "12/1/21"),
  Item("Jack Jones", "Cloud Native Architect Professional", "cloud_native",
      "9/11/20"),
  Item("Jane Smith", "Microsoft Azure Data Fundamentals", "azure", "11/3/20"),
  Item("Jane Smith", "Associate Terraform Engineer", "hashicorp", "22/8/19"),
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
