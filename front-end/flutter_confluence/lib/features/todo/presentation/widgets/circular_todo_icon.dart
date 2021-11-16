import 'package:flutter/material.dart';

class CircularTodoIcon extends StatelessWidget {
  const CircularTodoIcon(
      {Key? key, required this.backgroundColor, required this.iconColor})
      : super(key: key);

  final Color backgroundColor;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.pink,
      radius: 32,
      child: CircleAvatar(
          radius: 26,
          backgroundColor: backgroundColor,
          child: Icon(
            Icons.notes_rounded,
            color: iconColor,
          )),
    );
  }
}
