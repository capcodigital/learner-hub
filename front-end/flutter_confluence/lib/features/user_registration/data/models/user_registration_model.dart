import 'package:equatable/equatable.dart';

import '/features/user_registration/data/models/skills_model.dart';
import '/features/user_registration/domain/entities/user_registration.dart';

// ignore: must_be_immutable
class UserRegistrationModel extends UserRegistration with EquatableMixin {
  UserRegistrationModel({
    required this.name,
    required this.lastName,
    required this.jobTitle,
    required this.skills,
    required this.bio,
    required this.email,
  }) : super(
          name: name,
          lastName: lastName,
          jobTitle: jobTitle,
          skills: skills,
          bio: bio,
          email: email,
        );

  @override
  final String? name;
  @override
  final String? lastName;
  @override
  final String? jobTitle;
  @override
  final SkillsModel? skills;
  @override
  final String? bio;
  @override
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
