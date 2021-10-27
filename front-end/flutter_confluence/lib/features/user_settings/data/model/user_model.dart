import 'package:flutter_confluence/features/user_settings/domain/entities/user.dart';

import '/core/utils/extensions/extensions.dart';

class UserModel extends User {
  const UserModel({
    required name,
    required lastName,
    required jobTitle,
    required primarySkills,
    required secondarySkills,
    required bio,
    required email,
  }) : super(
            name: name,
            lastName: lastName,
            jobTitle: jobTitle,
            primarySkills: primarySkills,
            secondarySkills: secondarySkills,
            bio: bio,
            email: email);

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> skills = json['skills'];

    return UserModel(
      name: json['name'],
      email: json['email'],
      lastName: json['lastName'],
      bio: json['bio'],
      jobTitle: json['jobTitle'],
      primarySkills: (skills['primarySkills'] as List).map((name) => name.toString()).toList(),
      secondarySkills: (skills['secondarySkills'] as List).map((name) => name.toString()).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'name': name,
      'lastName': lastName,
      'jobTitle': jobTitle,
      'bio': bio,
      'primarySkills': primarySkills.toJson(),
      'secondarySkills': secondarySkills.toJson(),
    };
  }

  @override
  List<Object?> get props => [name, lastName, jobTitle, primarySkills, secondarySkills, bio, email];
}

extension UserExtensions on User {
  UserModel toModel() {
    return UserModel(
        name: name,
        lastName: lastName,
        jobTitle: jobTitle,
        primarySkills: primarySkills,
        secondarySkills: secondarySkills,
        bio: bio,
        email: email);
  }
}
