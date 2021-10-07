import 'package:flutter/material.dart';
// ignore: implementation_imports
import 'package:flutter/src/painting/image_resolution.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_confluence/core/constants.dart';
import 'package:flutter_confluence/core/shared_ui/custom_appbar.dart';

class CustomIconFont {
  CustomIconFont._();

  static const _kFontFam = 'CustomIconFont';
  static const String? _kFontPkg = null;

  static const IconData user_nav_bar =
      IconData(0xe806, fontFamily: _kFontFam, fontPackage: _kFontPkg);
}

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
    Text(
      'TODO',
      style: optionStyle,
    ),
    Text(
      'Chat',
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
        case 3:
          {
            _title = 'todo';
            break;
          }
        case 4:
          {
            _title = 'chat';
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
      bottomNavigationBar: Theme(
        data: ThemeData(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent),
        child: BottomNavigationBar(
          enableFeedback: true,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          unselectedItemColor: Colors.grey[850],
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(CustomIconFont.user_nav_bar, size: 75),
                backgroundColor: Colors.pink,
                label: 'USERS',
                tooltip: '',
                activeIcon: ImageIcon(
                    AssetImage(
                        'assets/nav_bar_icons/selected/user_nav_bar.png'),
                    size: 75)),
            BottomNavigationBarItem(
                icon: Icon(CustomIconFont.user_nav_bar, size: 75),
                label: '',
                tooltip: '',
                activeIcon: ImageIcon(
                    AssetImage(
                        'assets/nav_bar_icons/selected/certification_nav_bar.png'),
                    size: 75)),
            BottomNavigationBarItem(
                icon: Icon(CustomIconFont.user_nav_bar, size: 75),
                label: '',
                tooltip: '',
                activeIcon: ImageIcon(
                    AssetImage(
                        'assets/nav_bar_icons/selected/profile_nav_bar.png'),
                    size: 75)),
            BottomNavigationBarItem(
                icon: Icon(CustomIconFont.user_nav_bar, size: 75),
                label: '',
                tooltip: '',
                activeIcon: ImageIcon(
                    AssetImage(
                        'assets/nav_bar_icons/selected/study_nav_bar.png'),
                    size: 75)),
            BottomNavigationBarItem(
                icon: Icon(CustomIconFont.user_nav_bar, size: 75),
                label: '',
                tooltip: '',
                activeIcon: ImageIcon(
                    AssetImage(
                        'assets/nav_bar_icons/selected/chat_nav_bar.png'),
                    size: 75)),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.pink[200],
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
