import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_confluence/core/colours.dart';

class Skill {
  Skill({required this.name, required this.isPrimary, required this.isSecondary});

  final String name;
  final bool isPrimary;
  final bool isSecondary;
}

class SkillChip extends StatefulWidget {
  const SkillChip({required this.skill, required this.onPressed});

  final Skill skill;
  final Function(Skill) onPressed;

  @override
  State<StatefulWidget> createState() {
    return _SkillChipState();
  }
}

class _SkillChipState extends State<SkillChip> {
  @override
  Widget build(BuildContext context) {
    return ActionChip(
      side: const BorderSide(width: 1, color: Colours.PRIMARY_TEXT_COLOR),
      backgroundColor: widget.skill.isPrimary
          ? Colours.ACCENT_2_COLOR
          : widget.skill.isSecondary
              ? Colours.ACCENT_3_COLOR
              : Colours.PRIMARY_COLOR,
      label: Text(
        widget.skill.name,
        style: Theme.of(context).textTheme.button,
      ),
      onPressed: () {
        widget.onPressed(widget.skill);
      },
    );
  }
}
