import 'package:flutter/material.dart';
import 'package:learner_hub/core/shared_ui/custom_menu_page.dart';

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
      flexibleSpace: const Image(
        image: AssetImage('assets/background.png'),
        fit: BoxFit.cover,
      ),
      leading: Builder(
        builder: (appBarContext) {
          return IconButton(
              icon: Icon(icon),
              onPressed: () {
                CustomMenuPage.of(appBarContext)!.toggle();
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
