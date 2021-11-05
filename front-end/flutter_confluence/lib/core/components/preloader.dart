import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

import '/core/colours.dart';
import '/core/shared_ui/custom_bottom_nav.dart';
import '/features/auth/presentation/bloc/auth_bloc.dart';
import '/features/onboarding/presentation/pages/on_boarding.dart';
import '../shared_ui/custom_menu_page.dart';

class PreLoadWidget extends StatelessWidget {
  static const STARTUP_DELAY_MILLIS = 2000;

  void _openHomePage(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => const CustomMenuPage(
                child: CustomBottomNavBar(),
              )),
    );
  }

  void _openOnBoardingPage(BuildContext context) {
    Navigator.pushReplacementNamed(context, OnBoardingPage.route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocListener(
            bloc: BlocProvider.of<AuthBloc>(context),
            listener: (context, state) {
              if (state is InvalidUser) {
                Future.delayed(
                    const Duration(milliseconds: STARTUP_DELAY_MILLIS), () {
                  _openOnBoardingPage(context);
                });
              }
              if (state is ValidUser) {
                Future.delayed(
                    const Duration(milliseconds: STARTUP_DELAY_MILLIS), () {
                  _openHomePage(context);
                });
              }
            },
            child: Container(
              color: Colours.ALTERNATIVE_COLOR,
              child: Center(
                child: Lottie.asset(
                  'assets/lottie-animation.json',
                ),
              ),
            )));
  }
}
