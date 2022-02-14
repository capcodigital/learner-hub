import 'package:flutter/widgets.dart';
import 'package:learner_hub/core/layout_constants.dart';

import '/core/constants.dart';
import '/core/shared_ui/skill_chip.dart';
import '/features/user_settings/presentation/widgets/skills/skills_controller.dart';

class EditSkills extends StatefulWidget {
  const EditSkills({
    required this.controller,
    Key? key,
  }) : super(key: key);

  final SkillsController controller;

  @override
  _EditSkillsState createState() => _EditSkillsState();
}

class _EditSkillsState extends State<EditSkills> {
  List<Skill> _skillItems = [];

  @override
  void initState() {
    super.initState();

    _skillItems = Constants.SKILLS.map((skill) {
      final isPrimary = widget.controller.primarySkills.contains(skill);
      final isSecondary = widget.controller.secondarySkills.contains(skill);
      return Skill(name: skill, isPrimary: isPrimary, isSecondary: isSecondary);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    void onSkillSelected(Skill selectedSkill) {
      setState(() {
        final itemIndex = _skillItems.indexWhere((element) => element.name == selectedSkill.name);
        if (itemIndex > -1) {
          Skill newItem;
          if (selectedSkill.isPrimary) {
            // Move to secondary
            newItem = selectedSkill.copyWith(isPrimary: false, isSecondary: true);
          } else if (selectedSkill.isSecondary) {
            // Move to not-selected
            newItem = selectedSkill.copyWith(isPrimary: false, isSecondary: false);
          } else {
            // Move to primary
            newItem = selectedSkill.copyWith(isPrimary: true, isSecondary: false);
          }
          _skillItems[itemIndex] = newItem;

          widget.controller.setSkills(_skillItems);
        } else {
          // Item not found
          print('Item $selectedSkill not found');
        }
      });
    }

    final _skillsWidgets = _skillItems
        .map((skill) => SkillChip(
              skill: skill,
              onPressed: onSkillSelected,
              isLightMode: true,
            ))
        .toList();

    return SizedBox(
      height: 250,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Wrap(
          spacing: LayoutConstants.EXTRA_SMALL_PADDING,
          children: _skillsWidgets,
        ),
      ),
    );
  }
}
