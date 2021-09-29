import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '/core/colours.dart';

class IndicatorIcon extends StatelessWidget {
  const IndicatorIcon({required this.isSelected});

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    const outerCircleSize = 12.0;
    const innerCircleSize = outerCircleSize - 4;

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
            width: outerCircleSize,
            height: outerCircleSize,
            decoration: const BoxDecoration(shape: BoxShape.circle, color: Colours.PRIMARY_TEXT_COLOR)),
        Container(
            width: innerCircleSize,
            height: innerCircleSize,
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: isSelected ? Colours.PRIMARY_TEXT_COLOR : Colours.PRIMARY_COLOR)),
      ],
    );
  }
}
