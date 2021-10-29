import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '/core/layout_constants.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton(
      {required this.text,
      required this.onPressed,
      required this.color,
      this.borderColor});

  final String text;
  final VoidCallback? onPressed;
  final Color color;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = ElevatedButton.styleFrom(
        primary: color,
        splashFactory: NoSplash.splashFactory,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(150),
            side: BorderSide(
                color: borderColor ?? Colors.transparent, width: 2)));

    // ignore: sized_box_for_whitespace
    return Container(
        height: LayoutConstants.BTN_WIDGET_HEIGHT,
        width: double.infinity,
        child: ElevatedButton(
            style: style,
            onPressed: onPressed,
            child: Text(text, style: Theme.of(context).textTheme.button)));
  }
}
