import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_confluence/core/Colours.dart';

import '../dimen.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({required this.text, this.onPressed});

  final String text;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = ElevatedButton.styleFrom(
        primary: Colours.ACCENT_COLOR,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(150)));

    // TODO(cgal-capco): Should this style be defined here?
    // It makes sense to be a themed style, but the theme
    // styles are very limited in number ¯\_(ツ)_/¯
    const TextStyle textStyle = TextStyle(
        color: Colours.PRIMARY_TEXT_COLOR,
        fontFamily: 'FuturaPT',
        fontWeight: FontWeight.w600,
        fontSize: 18.0);

    // ignore: sized_box_for_whitespace
    return Container(
        height: Dimen.button_widget_height,
        child: ElevatedButton(style: style, onPressed: onPressed, child: Text(text, style: textStyle)));
  }
}