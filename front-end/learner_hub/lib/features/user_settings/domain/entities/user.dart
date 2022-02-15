import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({
    required this.name,
    required this.lastName,
    required this.jobTitle,
    required this.primarySkills,
    required this.secondarySkills,
    required this.bio,
    required this.email,
  });

  factory User.emptyUser() {
    return const User(name: '', lastName: '', email: '', bio: '', jobTitle: '', primarySkills: [], secondarySkills: []);
  }

  final String name;
  final String lastName;
  final String jobTitle;
  final List<String> primarySkills;
  final List<String> secondarySkills;
  final String bio;
  final String email;

  @override
  List<Object?> get props => [name, lastName, jobTitle, primarySkills, secondarySkills, bio, email];
}
