import 'package:flutter/material.dart';
// ignore: implementation_imports
import 'package:flutter/src/painting/image_resolution.dart';
import 'package:flutter_confluence/core/constants.dart';
import 'package:flutter_confluence/core/shared_ui/custom_appbar.dart';

class CustomBottomNavBar extends StatefulWidget {
  const CustomBottomNavBar({Key? key}) : super(key: key);
  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  int _selectedIndex = 0;
  late String _title;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Users',
      style: optionStyle,
    ),
    Text(
      'Certifications',
      style: optionStyle,
    ),
    Text(
      'My Profile',
      style: optionStyle,
    ),
  ];
  @override
  void initState() {
    super.initState();
    _title = 'Testing';
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      switch (index) {
        case 0:
          {
            _title = 'users';
            break;
          }
        case 1:
          {
            _title = 'certifications';
            break;
          }
        case 2:
          {
            _title = 'profile';
            break;
          }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        icon: Icons.menu,
        color: Constants.JIRA_COLOR,
        text: _title,
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: ImageIcon(
                  AssetImage('assets/nav_bar_icons/user_nav_bar.png'),
                  color: Colors.black),
              label: 'users',
              activeIcon: ImageIcon(
                AssetImage('assets/nav_bar_icons/selected/user_nav_bar.png'),
              )),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'certs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            activeIcon: Icon(Icons.access_alarm_outlined),
            label: 'my profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
