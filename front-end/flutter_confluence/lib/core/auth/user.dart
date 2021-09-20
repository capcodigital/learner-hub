import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as Firebase;

class User extends Equatable {
  final String uid;
  final String? displayName;
  final String? email;
  final String? photoUrl;

  User({
    required this.uid,
    required this.displayName,
    required this.email,
    required this.photoUrl,
  });

  @override
  List<Object?> get props => [uid, displayName, email, photoUrl];
}

extension FirebaseExtensions on Firebase.User {
  User toAppUser() {
    return User(
        uid: this.uid,
        displayName: this.displayName,
        email: this.email,
        photoUrl: this.photoURL);
  }
}
