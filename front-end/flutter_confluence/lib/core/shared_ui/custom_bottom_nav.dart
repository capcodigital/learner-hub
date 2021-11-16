import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_confluence/core/colours.dart';
import 'package:flutter_confluence/core/shared_ui/custom_appbar.dart';
import 'package:flutter_confluence/features/todo/presentation/pages/todo_page.dart';

class CustomBottomNavBar extends StatefulWidget {
  const CustomBottomNavBar({Key? key}) : super(key: key);

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  int _selectedIndex = 0;
  String _title = 'Users';
  final _kFontFam = 'CustomIconFont';
  TextStyle optionStyle =
      const TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  late final List<Widget> _widgetOptions = <Widget>[
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
    const TodoPage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      switch (index) {
        case 0:
          _title = 'Users';
          break;

        case 1:
          _title = 'Certifications';
          break;

        case 2:
          _title = 'My Profile';
          break;

        case 3:
          _title = 'My TODOs';
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        icon: Icons.menu,
        color: Colours.ACCENT_COLOR,
        text: _title,
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        enableFeedback: true,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Colors.grey[850],
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            // Users
            icon: Icon(IconData(0xe801, fontFamily: _kFontFam), size: 75),
            label: '',
            tooltip: '',
          ),
          BottomNavigationBarItem(
            // Certifications
            icon: Icon(IconData(0xe800, fontFamily: _kFontFam), size: 75),
            label: '',
            tooltip: '',
          ),
          BottomNavigationBarItem(
            // My Profile
            icon: Icon(IconData(0xe802, fontFamily: _kFontFam), size: 75),
            label: '',
            tooltip: '',
          ),
          BottomNavigationBarItem(
            // My TODOs
            icon: Icon(IconData(0xe803, fontFamily: _kFontFam), size: 75),
            label: '',
            tooltip: '',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colours.ACCENT_COLOR,
        onTap: _onItemTapped,
      ),
    );
  }
}
