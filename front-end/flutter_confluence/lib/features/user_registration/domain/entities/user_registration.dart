import 'package:equatable/equatable.dart';

import '/features/user_registration/domain/entities/skills.dart';

// ignore: must_be_immutable
class UserRegistration extends Equatable {
  UserRegistration({
    required this.name,
    required this.lastName,
    required this.jobTitle,
    required this.skills,
    required this.bio,
    required this.email,
    required this.password,
  });

  late String? name;
  late String? lastName;
  late String? jobTitle;
  late Skills? skills;
  late String? bio;
  late String? email;
  late String? password;

  @override
  List<Object?> get props => [name, lastName, jobTitle, skills, bio, email, password];
}
