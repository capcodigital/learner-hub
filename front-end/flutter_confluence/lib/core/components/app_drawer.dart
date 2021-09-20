import 'package:flutter/material.dart';
import 'package:flutter_confluence/core/components/custom_appbar.dart';
import 'package:flutter_confluence/core/dimen.dart';
import 'package:flutter_confluence/core/utils/media_util.dart';

class AppDrawer extends StatefulWidget {
  final Widget child;
  const AppDrawer({Key? key, required this.child}) : super(key: key);

  static _AppDrawerState? of(BuildContext context) =>
      context.findAncestorStateOfType<_AppDrawerState>();

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer>
    with SingleTickerProviderStateMixin {
  static Duration duration = Duration(milliseconds: 300);
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: _AppDrawerState.duration);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void open() => _controller.forward();
  void close() => _controller.reverse();
  void toggle() => _controller.isCompleted ? close() : open();

  @override
  Widget build(BuildContext context) {
    const double maxSlide = 255;
    return AnimatedBuilder(
      builder: (context, _) {
        final double animationValue = _controller.value;
        final double translateValue = animationValue * maxSlide;
        final double scaleValue = 1 - (animationValue * 0.3);
        return Stack(
          children: [
            CustomDrawer(),
            Transform(
                alignment: Alignment.centerLeft,
                transform: Matrix4.identity()
                  ..translate(translateValue)
                  ..scale(scaleValue),
                child: GestureDetector(
                  child: widget.child,
                  onTap: () {
                    if (_controller.isCompleted) {
                      close();
                    }
                  },
                ))
          ],
        );
      },
      animation: _controller,
    );
  }
}

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        text: 'Menu',
        icon: Icons.close,
        color: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Container(
        height: getHeight(context, Dimen.scale_95_100),
        color: Colors.black,
        child: SafeArea(
          child: Theme(
            data: ThemeData(brightness: Brightness.dark),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Padding(
                    padding: EdgeInsets.only(
                        top: Dimen.dimen_48,
                        bottom: Dimen.dimen_48,
                        right: 0,
                        left: Dimen.dimen_32),
                    child: Image(
                      image: AssetImage('assets/capco_logo.png'),
                    )),
                MenuButton(
                  title: 'My Profile',
                  id: 1,
                  icon: Icons.home,
                ),
                Expanded(
                  child: MenuButton(
                    title: 'Code Standards',
                    id: 2,
                    icon: Icons.code,
                  ),
                ),
                MenuButton(
                  icon: Icons.logout,
                  id: 3,
                  title: 'Logout',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MenuButton extends StatelessWidget {
  final String title;
  final int id;
  final IconData icon;
  const MenuButton({
    Key? key,
    required this.id,
    required this.title,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          switch (id) {
            case 1:
              print('My Profile pressed');
              break;
            case 2:
              print('Standards pressed');
              break;
            case 3:
              print('Logout pressed');
              break;
          }
        },
        child: ListTile(
          leading: Icon(icon),
          title: Text(title),
        ),
      ),
    );
  }
}
