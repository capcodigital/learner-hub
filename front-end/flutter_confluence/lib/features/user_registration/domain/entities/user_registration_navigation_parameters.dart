import '/features/user_registration/presentation/widgets/skill_chip.dart';

class UserRegistrationNavigationParameters {
  UserRegistrationNavigationParameters({
    this.name,
    this.lastName,
    this.jobTitle,
    this.primarySkills,
    this.secondarySkills,
    this.bio,
    this.email,
    this.password,
  });

  String? name;
  String? lastName;
  String? jobTitle;
  List<Skill>? primarySkills;
  List<Skill>? secondarySkills;
  String? bio;
  String? email;
  String? password;

  @override
  String toString() {
    return 'UserRegistrationNavigationParameters:/n'
        '- Name: $name\n'
        '- LastName: $lastName\n'
        '- JobTitle: $jobTitle\n'
        '- primarySkills: $primarySkills\n'
        '- secondarySkills: $secondarySkills\n'
        '- bio: $bio\n'
        '- email: $email\n';
  }
}
