import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_confluence/core/constants.dart';
import 'package:flutter_confluence/core/shared_ui/app_drawer.dart';
import 'package:flutter_confluence/core/shared_ui/custom_appbar.dart';
import 'package:flutter_confluence/features/certifications/presentation/pages/home_page.dart';
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
              child: HomePage(
            appBar: CustomAppBar(
              icon: Icons.menu,
              color: Constants.JIRA_COLOR,
              text: 'Cloud Certifications',
            ),
          )),
        ));
  }

  void openOnBoardingPage(BuildContext context) {
    Navigator.pushReplacementNamed(context, OnBoardingPage.route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocListener(
            bloc: BlocProvider.of<OnBoardingBloc>(context),
            listener: (context, state) {
              if (state is Expired) {
                Future.delayed(
                    const Duration(milliseconds: STARTUP_DELAY_MILLIS), () {
                  openOnBoardingPage(context);
                });
              }
              if (state is Completed) {
                Future.delayed(
                    const Duration(milliseconds: STARTUP_DELAY_MILLIS), () {
                  openHomePage(context);
                });
              }
            },
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
