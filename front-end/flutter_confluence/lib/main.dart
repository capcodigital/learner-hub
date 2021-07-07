import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/constants.dart';
import 'features/onboarding/presentation/bloc/on_boarding_bloc.dart';
import 'features/onboarding/presentation/pages/on_boarding.dart';
import 'features/certifications/presentation/pages/home_page.dart';
import 'features/certifications/presentation/bloc/cloud_certification_bloc.dart';

import 'injection_container.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static const authErrorDialogBtnWidth = 132.0;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CloudCertificationBloc>(
          create: (_) => sl<CloudCertificationBloc>()
            ..add(GetInProgressCertificationsEvent()),
        ),
        BlocProvider<OnBoardingBloc>(
          create: (_) => sl<OnBoardingBloc>()..add(CheckAuthEvent()),
        ),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: buildAppTheme(),
          routes: {
            HomePage.route: (context) => HomePage(),
            OnBoardingPage.route: (context) => OnBoardingPage(),
          },
          // home: OnBoardingPage(),
          home: OnBoardingPage()),
    );
  }

  void openHomePage(BuildContext context) {
    Navigator.pushNamed(context, HomePage.route);
  }

  void openOnBoardingPage(BuildContext context) {
    Navigator.pushNamed(context, OnBoardingPage.route);
  }
}

ThemeData buildAppTheme() {
  return ThemeData(
    primaryColor: Constants.JIRA_COLOR,
    fontFamily: 'Montserrat',
    textTheme: TextTheme(
      headline1: TextStyle(
          fontSize: 20.0, color: Colors.white, fontWeight: FontWeight.w600),
      headline2: TextStyle(
          color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.w600),
      headline3: TextStyle(
          color: Constants.BLACK_75,
          fontSize: 12.0,
          fontWeight: FontWeight.w400),
    ),
  );
}

// Place in utilities file called error_messages.dart
Widget showCustomDialog(BuildContext context, String message) {
  return Container(
    child: AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 132,
                  child: ElevatedButton(
                    child: new Text("OK"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                Container(
                  width: 132,
                  child: ElevatedButton(
                    child: new Text("Settings"),
                    onPressed: () {
                      AppSettings.openAppSettings();
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    ),
  );
}
