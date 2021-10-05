import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../colours.dart';
import '../layout_constants.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({required this.text, this.onPressed});

  final String text;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = ElevatedButton.styleFrom(
        primary: Colours.ACCENT_COLOR,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(150)));

    // ignore: sized_box_for_whitespace
    return Container(
        height: LayoutConstants.button_widget_height,
        width: double.infinity,
        child: ElevatedButton(
            style: style,
            onPressed: onPressed,
            child: Text(text, style: Theme.of(context).textTheme.button)));
  }
}
