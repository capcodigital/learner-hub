// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_confluence/core/components/app_drawer.dart';
// import 'package:flutter_confluence/core/components/custom_appbar.dart';
// import 'package:flutter_confluence/core/constants.dart';
// import 'package:flutter_confluence/features/certifications/presentation/pages/home_page.dart';
// import 'package:flutter_confluence/features/onboarding/presentation/bloc/on_boarding_bloc.dart';
// import 'package:flutter_confluence/features/onboarding/presentation/pages/on_boarding.dart';
// import 'package:lottie/lottie.dart';

// class PreLoadWidget extends StatelessWidget {
//   static const STARTUP_DELAY_MILLIS = 2000;

//   void openHomePage(BuildContext context) {
//     Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (context) => const AppDrawer(
//               child: HomePage(
//             appBar: CustomAppBar(
//               icon: Icons.menu,
//               color: Constants.JIRA_COLOR,
//               text: 'Cloud Certifications',
//             ),
//           )),
//         ));
//   }

//   void openOnBoardingPage(BuildContext context) {
//     Navigator.pushReplacementNamed(context, OnBoardingPage.route);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: BlocListener(
//             bloc: BlocProvider.of<OnBoardingBloc>(context),
//             listener: (context, state) {
//               if (state is Expired) {
//                 Future.delayed(
//                     const Duration(milliseconds: STARTUP_DELAY_MILLIS), () {
//                   openOnBoardingPage(context);
//                 });
//               }
//               if (state is Completed) {
//                 Future.delayed(
//                     const Duration(milliseconds: STARTUP_DELAY_MILLIS), () {
//                   openHomePage(context);
//                 });
//               }
//             },
//             child: Container(
//               color: Colors.white,
//               child: Center(
//                 child: Lottie.asset(
//                   'assets/lottie-animation.json',
//                 ),
//               ),
//             )));
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_confluence/core/components/app_drawer.dart';
import 'package:flutter_confluence/core/components/custom_appbar.dart';
import 'package:flutter_confluence/core/constants.dart';
import 'package:flutter_confluence/features/onboarding/presentation/bloc/on_boarding_bloc.dart';
import 'package:flutter_confluence/features/onboarding/presentation/pages/on_boarding.dart';
import 'package:lottie/lottie.dart';
class PreLoadWidget extends StatelessWidget {
  static const STARTUP_DELAY_MILLIS = 2000;
  void openHomePage(BuildContext context) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => const AppDrawer(
                  child: MyStatefulWidget(),
                )));
  }
  void openOnBoardingPage(BuildContext context) {
    Navigator.pushReplacementNamed(context, OnBoardingPage.route);
  }
  @override  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocListener(
            bloc: BlocProvider.of<OnBoardingBloc>(context),
            listener: (context, state) {
              openHomePage(context);
              // if (state is Expired) {              //   Future.delayed(              //       const Duration(milliseconds: STARTUP_DELAY_MILLIS), () {              //     openOnBoardingPage(context);              //   });              // }              // if (state is Completed) {              //   Future.delayed(              //       const Duration(milliseconds: STARTUP_DELAY_MILLIS), () {              //     openHomePage(context);              //   });              // }            },
            child: Container(
              color: Colors.white,
              child: Center(
                child: Lottie.asset(
                  'assets/lottie-animation.json',
                ),
              ),
            )));
  }
}
/// This is the stateful widget that the main application instantiates.class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);
  @override  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}
/// This is the private State class that goes with MyStatefulWidget.class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;
  late String _title;
  static const TextStyle optionStyle =      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'My Profile',
      style: optionStyle,
    ),
    Text(
      'Certifications',
      style: optionStyle,
    ),
    Text(
      'Chats',
      style: optionStyle,
    ),
  ];
  @override  void initState() {
    super.initState();
    _title = 'Testing';
  }
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      switch (index) {
        case 0:
          {
            _title = 'button 1';
            break;
          }
        case 1:
          {
            _title = 'button 2';
            break;
          }
        case 2:
          {
            _title = 'button 3';
            break;
          }
      }
    });
  }
  @override  Widget build(BuildContext context) {
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
            icon: Icon(Icons.home),
            label: 'Button 1',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Button 2',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            activeIcon: Icon(Icons.access_alarm_outlined),
            label: 'Button 2',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}