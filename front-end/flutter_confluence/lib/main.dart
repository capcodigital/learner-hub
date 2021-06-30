import 'package:flutter/material.dart';
import 'package:flutter_confluence/core/constants.dart';
import 'presentation/pages/home_page.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primaryColor: Constants.JIRA_COLOR,
          fontFamily: 'Montserrat',
          textTheme: TextTheme(
            headline1: TextStyle(
                fontSize: 20.0,
                color: Colors.white,
                fontWeight: FontWeight.w600),
            headline2: TextStyle(
                color: Colors.black,
                fontSize: 16.0,
                fontWeight: FontWeight.w600),
            headline3: TextStyle(
                color: Constants.BLACK_75,
                fontSize: 12.0,
                fontWeight: FontWeight.w400),
          ),
        ),
        home: HomePage());
  }
}
