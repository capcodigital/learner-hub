import 'package:flutter/material.dart';

class AppDrawer extends StatefulWidget {
  final Widget child;
  const AppDrawer({Key? key, required this.child}) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [CustomDrawer(), widget.child],
    );
  }
}

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.purple,
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
              ListTile(
                leading: Icon(Icons.home),
                title: Text('Item 1'),
              ),
              ListTile(
                leading: Icon(Icons.info),
                title: Text('Item 2'),
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Item 3'),
              ),
              ListTile(
                leading: Icon(Icons.lock),
                title: Text('Item 4'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
