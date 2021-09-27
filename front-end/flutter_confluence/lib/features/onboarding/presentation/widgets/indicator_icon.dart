import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '/core/colours.dart';

class IndicatorIcon extends StatelessWidget {
  const IndicatorIcon({required this.isSelected});

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
            width: 12.0, height: 12.0, decoration: const BoxDecoration(shape: BoxShape.circle, color: Colours.PRIMARY_TEXT_COLOR)),
        Container(
            width: 7.5,
            height: 7.5,
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: isSelected ? Colours.PRIMARY_TEXT_COLOR : Colours.PRIMARY_COLOR)),
      ],
    );
  }
}
