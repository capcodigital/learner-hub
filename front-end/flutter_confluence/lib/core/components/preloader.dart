import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_confluence/core/components/custom_bottom_nav.dart';
import 'package:lottie/lottie.dart';

import '/core/colours.dart';
import '/core/shared_ui/app_drawer.dart';
import '/features/auth/presentation/bloc/auth_bloc.dart';
import '/features/onboarding/presentation/pages/on_boarding.dart';

class PreLoadWidget extends StatelessWidget {
  static const STARTUP_DELAY_MILLIS = 2000;

  void _goToBottomNavigationBar(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => const AppDrawer(
                child: CustomBottomNavBar(),
              )),
    );
  }

  void openOnBoardingPage(BuildContext context) {
    Navigator.pushReplacementNamed(context, OnBoardingPage.route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocListener(
            bloc: BlocProvider.of<AuthBloc>(context),
            listener: (context, state) {
              // For testing purposes, let's go straight to the bottom
              // nav screen as soon as the app opens.
              _goToBottomNavigationBar(context);

              // if (state is InvalidUser) {
              //   Future.delayed(
              //       const Duration(milliseconds: STARTUP_DELAY_MILLIS), () {
              //     openOnBoardingPage(context);
              //   });
              // }
              // if (state is ValidUser) {
              //   Future.delayed(
              //       const Duration(milliseconds: STARTUP_DELAY_MILLIS), () {
              //     openHomePage(context);
              //   });
              // }
            },
            child: Container(
              color: Colours.PRIMARY_COLOR,
              child: Center(
                child: Lottie.asset(
                  'assets/lottie-animation.json',
                ),
              ),
            )));
  }
}
