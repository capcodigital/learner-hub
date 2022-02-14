import 'package:flutter_confluence/core/shared_ui/skill_chip.dart';

/// This is a really simple class to hold values across widgets
/// Although it contains the word "controller" in the name, it won't notify
/// any listener.
class SkillsController {
  List<String> primarySkills = [];
  List<String> secondarySkills = [];

  void setSkills(List<Skill> skillItems) {
    primarySkills = skillItems.where((skill) => skill.isPrimary).map((e) => e.name).toList();
    secondarySkills = skillItems.where((skill) => skill.isSecondary).map((e) => e.name).toList();
  }
}
