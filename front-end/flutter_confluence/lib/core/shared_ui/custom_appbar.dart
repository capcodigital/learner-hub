import 'package:flutter/material.dart';
import 'package:flutter_confluence/core/shared_ui/app_drawer.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar(
      {Key? key, required this.text, required this.icon, required this.color})
      : super(key: key);
  final String text;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: color,
      leading: Builder(
        builder: (appBarContext) {
          return IconButton(
              icon: Icon(icon),
              onPressed: () {
                AppDrawer.of(appBarContext)!.toggle();
              });
        },
      ),
      title: Text(text, style: Theme.of(context).textTheme.headline1),
      automaticallyImplyLeading: false,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
