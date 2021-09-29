class UserRegistration {
  UserRegistration({
    required this.name,
    required this.lastName,
    required this.jobTitle,
    required this.primarySkills,
    required this.secondarySkills,
    required this.bio,
    required this.email,
    required this.password,
  });

  final String name;
  final String lastName;
  final String jobTitle;
  final List<String> primarySkills;
  final List<String> secondarySkills;
  final String bio;
  final String email;
  final String password;
}
