import 'package:flutter_confluence/features/user_registration/domain/entities/skills.dart';

class SkillsModel extends Skills {
  SkillsModel({
    required List<String> primarySkills,
    required List<String> secondarySkills})
      : super(primarySkills: primarySkills, secondarySkills: secondarySkills);

  Map<String, dynamic> toJson() {
    return {
      'primarySkills': primarySkills,
      'secondarySkills': secondarySkills};
  }
}

extension SkillsModelExtenstions on SkillsModel {
  Skills toSkillsEntity() {
    return Skills(primarySkills: primarySkills, secondarySkills: secondarySkills);
  }
}

extension SkillsExtenstions on Skills {
  SkillsModel toModel() {
    return SkillsModel(primarySkills: primarySkills, secondarySkills: secondarySkills);
  }
}
