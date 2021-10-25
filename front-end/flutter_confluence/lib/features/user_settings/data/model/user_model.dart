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

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'name': name,
      'lastName': lastName,
      'jobTitle': jobTitle,
      'bio': bio,
      'primarySkills': primarySkills?.toJson(),
      'secondarySkills': secondarySkills?.toJson(),
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
