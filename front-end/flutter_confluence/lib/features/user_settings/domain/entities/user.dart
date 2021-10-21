class User {
  User({
    this.name,
    this.lastName,
    this.jobTitle,
    this.primarySkills,
    this.secondarySkills,
    this.bio,
    this.email,
  });

  String? name;
  String? lastName;
  String? jobTitle;
  List<String>? primarySkills;
  List<String>? secondarySkills;
  String? bio;
  String? email;
}
