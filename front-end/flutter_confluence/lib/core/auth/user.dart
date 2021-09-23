import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;

class User extends Equatable {
  const User({
    required this.uid,
    required this.displayName,
    required this.email,
    required this.photoUrl,
  });

  final String uid;
  final String? displayName;
  final String? email;
  final String? photoUrl;

  @override
  List<Object?> get props => [uid, displayName, email, photoUrl];
}

extension FirebaseExtensions on firebase.User {
  User toAppUser() {
    return User(uid: uid, displayName: displayName, email: email, photoUrl: photoURL);
  }
}
