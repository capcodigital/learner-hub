import 'package:flutter/material.dart';

class CircularTodoIcon extends StatelessWidget {
  const CircularTodoIcon({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CircleAvatar(
      backgroundColor: Colors.pink,
      radius: 32,
      child: CircleAvatar(
          radius: 26,
          backgroundColor: Colors.black,
          child: Icon(
            Icons.note_add_rounded,
            color: Colors.white,
          )),
    );
  }
}
