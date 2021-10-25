import '/features/user_registration/domain/entities/skills.dart';

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
