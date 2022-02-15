import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '/core/colours.dart';

class IndicatorIcon extends StatelessWidget {
  const IndicatorIcon({required this.isSelected});

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        width: 8,
        height: 8,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colours.PRIMARY_TEXT_COLOR, width: 1),
            color: isSelected
                ? Colours.PRIMARY_TEXT_COLOR
                : Colours.PRIMARY_COLOR));
  }
}
