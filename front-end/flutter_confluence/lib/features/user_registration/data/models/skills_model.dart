import 'package:equatable/equatable.dart';

class SkillsModel with EquatableMixin {
  SkillsModel({required this.primarySkills, required this.secondarySkills});

  Map<String, dynamic> toJson() {
    return {'primarySkills': primarySkills, 'secondarySkills': secondarySkills};
  }

  @override
  List<Object?> get props => [primarySkills, secondarySkills];

  final List<String> primarySkills;
  final List<String> secondarySkills;
}
