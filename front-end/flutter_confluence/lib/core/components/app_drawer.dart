import 'package:flutter/material.dart';

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
    double maxSlide = 255;
    return AnimatedBuilder(
      builder: (context, _) {
        double animationValue = _controller.value;
        double translateValue = animationValue * maxSlide;
        double scaleValue = 1 - (animationValue * 0.3);
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
      backgroundColor: Colors.transparent,
      body: Container(
        color: Colors.black,
        child: SafeArea(
          child: Theme(
            data: ThemeData(brightness: Brightness.dark),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Flutter Confluence',
                    style: TextStyle(fontSize: 30, color: Colors.white),
                  ),
                ),
                MenuButton(
                  title: 'Item 1',
                  icon: Icons.home,
                ),
                MenuButton(
                  title: 'Item 2',
                  icon: Icons.info,
                ),
                MenuButton(
                  title: 'Item 3',
                  icon: Icons.settings,
                ),
                MenuButton(
                  title: 'Item 4',
                  icon: Icons.lock,
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
  final IconData icon;
  const MenuButton({
    Key? key,
    required this.title,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          print('Item is pressed, navigate to new route');
        },
        child: ListTile(
          leading: Icon(icon),
          title: Text(title),
        ),
      ),
    );
  }
}
