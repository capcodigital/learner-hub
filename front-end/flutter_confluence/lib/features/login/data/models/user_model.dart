import '/features/login/domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required uid,
    displayName,
    email,
    photoUrl,
  }) : super(uid: uid, displayName: displayName, email: email, photoUrl: photoUrl);
}
