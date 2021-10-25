import '/core/utils/extensions/extensions.dart';
import '/features/user_registration/domain/entities/user_registration.dart';

class UserRegistrationModel extends UserRegistration {
  UserRegistrationModel({
    required name,
    required lastName,
    required jobTitle,
    required primarySkills,
    required secondarySkills,
    required bio,
    required email,
    required password,
  }) : super(
          name: name,
          lastName: lastName,
          jobTitle: jobTitle,
          primarySkills: primarySkills,
          secondarySkills: secondarySkills,
          bio: bio,
          email: email,
          password: password,
        );

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'name': name,
      'lastName': lastName,
      'jobTitle': jobTitle,
      'bio': bio,
      'skills': {
        'primarySkills': primarySkills?.toJson(),
        'secondarySkills': secondarySkills?.toJson(),
      }
    };
  }
}
