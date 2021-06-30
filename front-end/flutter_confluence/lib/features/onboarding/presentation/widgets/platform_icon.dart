import 'package:flutter/material.dart';

class PlatformIcon extends StatelessWidget {
  final String iconPath;

  PlatformIcon(this.iconPath);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CircleAvatar(
        radius: 26,
        backgroundColor: Colors.white,
        backgroundImage: AssetImage(iconPath),
      ),
    );
  }
}
