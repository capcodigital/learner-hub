import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_confluence/core/colours.dart';
import 'package:flutter_confluence/core/components/app_drawer.dart';
import 'package:flutter_confluence/core/components/custom_appbar.dart';
import 'package:flutter_confluence/core/dimen.dart';
import 'package:flutter_confluence/core/utils/error_messages.dart';
import 'package:flutter_confluence/core/utils/media_util.dart';
import 'package:flutter_confluence/core/widgets/primary_button.dart';
import 'package:flutter_confluence/features/onboarding/presentation/widgets/onboarding_carousel.dart';

import '../../../../core/constants.dart';
import '../../../certifications/presentation/pages/home_page.dart';
import '../bloc/on_boarding_bloc.dart';

class OnBoardingPage extends StatelessWidget with CustomAlertDialog {
  static const route = 'OnBoardingPage';

  void login(BuildContext context) {
    navigateToLoginPage(context);
  }

  void register(BuildContext context) {
    navigateToRegisterPage(context);
  }

  void navigateToHomePage(BuildContext context) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const AppDrawer(
              child: HomePage(
            appBar: CustomAppBar(
              icon: Icons.menu,
              text: 'Cloud Certifications',
              color: Constants.JIRA_COLOR,
            ),
          )),
        ));
  }

  void navigateToLoginPage(BuildContext context) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const AppDrawer(
              child: HomePage(
            appBar: CustomAppBar(
              icon: Icons.menu,
              text: 'Login Page',
              color: Constants.JIRA_COLOR,
            ),
          )),
        ));
  }

  void navigateToRegisterPage(BuildContext context) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const AppDrawer(
              child: HomePage(
            appBar: CustomAppBar(
              icon: Icons.menu,
              text: 'Register an account',
              color: Constants.JIRA_COLOR,
            ),
          )),
        ));
  }

  @override
  Widget build(BuildContext context) {
    // Change Status bar background colour
    // TODO(cgal-capco): Should this be global? Or driven by each page, as
    // according to FIGMA there are different status bars?
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colours.PRIMARY_COLOR,
    ));

    return Scaffold(
      body: buildBodyWithBloc(context),
      backgroundColor: Colours.PRIMARY_COLOR,
    );
  }

  Widget buildBodyWithBloc(BuildContext context) {
    return BlocListener(
      bloc: BlocProvider.of<OnBoardingBloc>(context),
      listener: (context, state) {
        if (state is AuthError) {
          showAlertDialog(context, state.message);
        } else if (state is Completed) {
          navigateToHomePage(context);
        }
      },
      child: buildWithLayoutBuilder(context),
    );
  }

  Widget buildWithLayoutBuilder(BuildContext context) {
    return SafeArea(
        top: true,
        bottom: true,
        child: Column(
          children: [
            Expanded(
              child: Container(
                  color: Colours.PRIMARY_COLOR,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Padding(
                          padding:
                              const EdgeInsets.symmetric(vertical: Dimen.big_padding, horizontal: Dimen.small_padding),
                          child: Image.asset('assets/capco_logo.png'),
                        ),
                      ),
                      Expanded(child: OnBoardingCarousel()),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Dimen.small_padding, vertical: Dimen.big_padding),
                        child: PrimaryButton(
                            text: 'Log in',
                            onPressed: () {
                              login(context);
                            }),
                      )
                    ],
                  )),
            ),
            getFooter(context)
          ],
        ));
  }

  Widget getFooter(BuildContext context) {
    return Container(
        color: Colours.ALTERNATIVE_COLOR,
        height: Dimen.dimen_62,
        width: getMediaWidth(context),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Not a member yet?',
                style: TextStyle(
                    color: Colours.ALTERNATIVE_TEXT_COLOR,
                    fontFamily: 'FuturaPT',
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.italic)),
            TextButton(
                style: TextButton.styleFrom(
                  primary: Colours.ACCENT_COLOR,
                  textStyle: const TextStyle(
                      fontSize: 18, fontFamily: 'FuturaPT', fontWeight: FontWeight.w600, fontStyle: FontStyle.italic),
                ),
                onPressed: () {
                  register(context);
                },
                child: const Text('Register!'))
          ],
        ));
  }
}
