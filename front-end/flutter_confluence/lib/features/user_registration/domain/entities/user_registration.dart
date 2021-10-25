class Skills {
  Skills({
    required this.primarySkills,
    required this.secondarySkills,
  });

  List<String> primarySkills;
  List<String> secondarySkills;

  Map<String, dynamic> toJson() {
    return {
      'primarySkills': primarySkills,
      'secondarySkills': secondarySkills
    };
  }
}

class UserRegistration {
  UserRegistration({
    this.name,
    this.lastName,
    this.jobTitle,
    this.skills,
    this.bio,
    this.email,
    this.password,
  });

  String? name;
  String? lastName;
  String? jobTitle;
  Skills? skills;
  String? bio;
  String? email;
  String? password;
}
