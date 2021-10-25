import 'package:equatable/equatable.dart';

class Skills extends Equatable {
  const Skills({
    required this.primarySkills,
    required this.secondarySkills,
  });

  final List<String> primarySkills;
  final List<String> secondarySkills;

  @override
  List<Object?> get props => [primarySkills, secondarySkills];
}
