import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/constants.dart';
import 'core/utils/error_messages.dart';
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
            home: PreLoadWidget()));
  }
}

class PreLoadWidget extends StatelessWidget {
  void openHomePage(BuildContext context) {
    Navigator.pushNamed(context, HomePage.route);
  }

  void openOnBoardingPage(BuildContext context) {
    Navigator.pushNamed(context, OnBoardingPage.route);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: BlocProvider.of<OnBoardingBloc>(context),
      builder: (context, state) {
        print(state);
        if (state is AuthError) {
          final dialog = showCustomDialog(context, state.message, () {
            openOnBoardingPage(context);
          });
          return Scaffold(body: dialog);
        }
        if (state is Expired) {
          return OnBoardingPage();
        }
        if (state is Completed) {
          return HomePage();
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
