import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_confluence/core/components/custom_appbar.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/components/preloader.dart';
import 'core/constants.dart';
import 'features/certifications/data/models/cloud_certification_model.dart';
import 'features/onboarding/presentation/bloc/on_boarding_bloc.dart';
import 'features/onboarding/presentation/pages/on_boarding.dart';
import 'features/certifications/presentation/pages/home_page.dart';
import 'features/certifications/presentation/bloc/cloud_certification_bloc.dart';
import 'injection_container.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(CloudCertificationModelAdapter());
  await Firebase.initializeApp();
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
        // NEW STYLES FOR THE NEW UI
        bodyText1: TextStyle(
            color: Colors.white,
            fontFamily: 'Lato',
            fontWeight: FontWeight.w400,
            fontSize: 16.0),
        button: TextStyle(
            color: Colors.white,
            fontFamily: 'Lato',
            fontWeight: FontWeight.w700,
            fontSize: 18.0),
        headline6: TextStyle(
            color: Colors.white,
            fontFamily: 'FuturaPT',
            fontWeight: FontWeight.w800,
            fontSize: 22.0),
        subtitle1: TextStyle(
            color: Colors.black,
            fontFamily: 'FuturaPT',
            fontWeight: FontWeight.w400,
            fontSize: 18.0),
        subtitle2: TextStyle(
            color: Constants.ACCENT_COLOR,
            fontFamily: 'FuturaPT',
            fontWeight: FontWeight.w600,
            fontSize: 18.0),
      ),
    );
  }

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
              HomePage.route: (context) => HomePage(
                    appBar: CustomAppBar(
                      icon: Icons.menu,
                      text: 'Cloud Certification',
                      color: Constants.JIRA_COLOR,
                    ),
                  ),
              OnBoardingPage.route: (context) => OnBoardingPage(),
            },
            home: PreLoadWidget()));
  }
}
