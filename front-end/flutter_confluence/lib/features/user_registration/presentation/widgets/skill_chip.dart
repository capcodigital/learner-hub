import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_confluence/core/colours.dart';

class Skill extends Equatable {
  const Skill({required this.name, required this.isPrimary, required this.isSecondary});

  final String name;
  final bool isPrimary;
  final bool isSecondary;

  @override
  List<Object?> get props => [name, isPrimary, isSecondary];

  Skill copyWith({String? name, bool? isPrimary, bool? isSecondary}) {
    return Skill(
        name: name ?? this.name, isPrimary: isPrimary ?? this.isPrimary, isSecondary: isSecondary ?? this.isSecondary);
  }
}

class SkillChip extends StatelessWidget {
  const SkillChip({required this.skill, required this.onPressed});

  final Skill skill;
  final Function(Skill) onPressed;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      side: const BorderSide(width: 1, color: Colours.PRIMARY_TEXT_COLOR),
      backgroundColor: skill.isPrimary
          ? Colours.ACCENT_2_COLOR
          : skill.isSecondary
              ? Colours.ACCENT_3_COLOR
              : Colours.PRIMARY_COLOR,
      label: Text(
        skill.name,
        style: Theme.of(context).textTheme.button,
      ),
      onPressed: () {
        onPressed(skill);
      },
    );
  }
}
