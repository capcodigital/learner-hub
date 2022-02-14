import 'package:flutter/material.dart';
import 'package:flutter_confluence/core/colours.dart';

import '/core/layout_constants.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton(
      {required this.text,
      required this.onPressed,
      this.color = Colours.ACCENT_COLOR,
      this.borderColor,
      this.isEnabled = true});

  final String text;
  final bool isEnabled;
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

    final ButtonStyle disabledStyle = ElevatedButton.styleFrom(
        onSurface: Colours.ACCENT_COLOR,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(150)));

    // ignore: sized_box_for_whitespace
    return Container(
        height: LayoutConstants.BTN_WIDGET_HEIGHT,
        width: double.infinity,
        child: ElevatedButton(
            style: isEnabled ? style : disabledStyle,
            onPressed: isEnabled ? onPressed : null,
            child: Text(text, style: Theme.of(context).textTheme.button)));
  }
}
