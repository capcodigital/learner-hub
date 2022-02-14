import 'package:equatable/equatable.dart';

import '/features/user_registration/data/models/skills_model.dart';

class UserRegistrationModel with EquatableMixin {
  UserRegistrationModel({
    required this.name,
    required this.lastName,
    required this.jobTitle,
    required this.skills,
    required this.bio,
    required this.email,
  });

  final String? name;
  final String? lastName;
  final String? jobTitle;
  final SkillsModel? skills;
  final String? bio;
  final String? email;

  @override
  List<Object?> get props => [name, lastName, jobTitle, skills, bio, email];

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'name': name,
      'lastName': lastName,
      'jobTitle': jobTitle,
      'bio': bio,
      'skills': skills?.toJson()
    };
  }
}
