import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_confluence/core/colours.dart';

class Skill extends Equatable {
  const Skill(
      {required this.name, required this.isPrimary, required this.isSecondary});

  final String name;
  final bool isPrimary;
  final bool isSecondary;

  @override
  List<Object?> get props => [name, isPrimary, isSecondary];

  Skill copyWith({String? name, bool? isPrimary, bool? isSecondary}) {
    return Skill(
        name: name ?? this.name,
        isPrimary: isPrimary ?? this.isPrimary,
        isSecondary: isSecondary ?? this.isSecondary);
  }
}

class SkillChip extends StatelessWidget {
  const SkillChip(
      {required this.skill, required this.onPressed, this.isLightMode = false});

  final Skill skill;
  final Function(Skill)? onPressed;
  final bool isLightMode;

  get _borderColour =>
      isLightMode ? Colours.ALTERNATIVE_TEXT_COLOR : Colours.PRIMARY_TEXT_COLOR;
  get _backgroundColour =>
      isLightMode ? Colours.ALTERNATIVE_COLOR : Colours.PRIMARY_COLOR;
  get _isSelected => skill.isPrimary || skill.isSecondary;
  get _textColour => isLightMode && _isSelected == false
      ? Colours.ALTERNATIVE_TEXT_COLOR
      : Colours.PRIMARY_TEXT_COLOR;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      side: BorderSide(width: 1, color: _borderColour),
      backgroundColor: skill.isPrimary
          ? Colours.ACCENT_2_COLOR
          : skill.isSecondary
              ? Colours.ACCENT_3_COLOR
              : _backgroundColour,
      label: Text(skill.name,
          style:
              Theme.of(context).textTheme.button?.copyWith(color: _textColour)),
      onPressed: () {
        if (onPressed != null) {
          onPressed!(skill);
        }
      },
    );
  }
}
