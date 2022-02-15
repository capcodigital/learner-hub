import 'package:flutter/material.dart';

import '/core/layout_constants.dart';
import '/core/shared_ui/skill_chip.dart';

class ReadOnlySkills extends StatelessWidget {
  const ReadOnlySkills({
    required this.primarySkills,
    required this.secondarySkills,
  });

  final List<String> primarySkills;
  final List<String> secondarySkills;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Primary Skills',
          style: Theme.of(context).textTheme.headline3,
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: LayoutConstants.SMALL_PADDING,
          ),
          child: Wrap(
            spacing: LayoutConstants.EXTRA_EXTRA_SMALL_PADDING,
            children: primarySkills
                .map((skillName) => SkillChip(
                      isLightMode: true,
                      skill: Skill(name: skillName, isPrimary: true, isSecondary: false),
                      onPressed: null,
                    ))
                .toList(),
          ),
        ),
        Container(height: LayoutConstants.REGULAR_PADDING),
        Text(
          'Secondary Skills',
          style: Theme.of(context).textTheme.headline3,
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: LayoutConstants.SMALL_PADDING,
          ),
          child: Wrap(
            spacing: LayoutConstants.EXTRA_EXTRA_SMALL_PADDING,
            children: secondarySkills
                .map((skillName) => SkillChip(
                      isLightMode: true,
                      skill: Skill(name: skillName, isPrimary: false, isSecondary: true),
                      onPressed: null,
                    ))
                .toList(),
          ),
        )
      ],
    );
  }
}
