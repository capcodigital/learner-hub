import 'package:equatable/equatable.dart';
import 'package:flutter_confluence/features/user_registration/domain/entities/skills.dart';

class SkillsModel extends Skills with EquatableMixin {
  SkillsModel({required this.primarySkills, required this.secondarySkills})
      : super(primarySkills: primarySkills, secondarySkills: secondarySkills);

  Map<String, dynamic> toJson() {
    return {'primarySkills': primarySkills, 'secondarySkills': secondarySkills};
  }

  @override
  List<Object?> get props => [primarySkills, secondarySkills];

  @override
  final List<String> primarySkills;
  @override
  final List<String> secondarySkills;
}
