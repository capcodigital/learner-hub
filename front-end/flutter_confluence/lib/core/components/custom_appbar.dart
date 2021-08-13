import 'package:flutter/material.dart';
import 'package:flutter_confluence/core/components/app_drawer.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String text;
  final IconData icon;
  const CustomAppBar(
      {Key? key, required String this.text, required IconData this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
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
