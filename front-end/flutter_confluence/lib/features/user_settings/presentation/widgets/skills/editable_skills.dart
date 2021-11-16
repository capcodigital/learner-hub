import 'package:flutter/material.dart';

import '/features/user_settings/presentation/widgets/skills/edit_skills.dart';
import '/features/user_settings/presentation/widgets/skills/read_only_skills.dart';
import '/features/user_settings/presentation/widgets/skills/skills_controller.dart';

class EditableSkills extends StatelessWidget {
  const EditableSkills({required this.isReadOnly, required this.controller});

  final bool isReadOnly;
  final SkillsController controller;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isReadOnly,
      child: ReadOnlySkills(
        primarySkills: controller.primarySkills,
        secondarySkills: controller.secondarySkills,
      ),
      replacement: EditSkills(
        controller: controller,
      ),
    );
  }
}
