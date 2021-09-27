import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
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
    Navigator.push(
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
    Navigator.push(
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Image.asset('assets/capco_logo.png'),
      ),
      body: buildWithLayoutBuilder(context),
      backgroundColor: Colors.black,
    );
  }

  Widget buildWithLayoutBuilder(BuildContext context) {
    return SafeArea(
      child:
          Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
        const Spacer(),
        OnBoardingCarousel(),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: Dimen.large_padding, horizontal: Dimen.small_padding),
          child: PrimaryButton(
              text: 'Log in',
              onPressed: () {
                login(context);
              }),
        ),
        getFooter(context),
      ]),
    );
  }

  Widget getFooter(BuildContext context) {
    return Container(
        color: Colours.ALTERNATIVE_COLOR,
        height: Dimen.dimen_62,
        width: getMediaWidth(context),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Not a member yet?', style: Theme.of(context).textTheme.subtitle1),
            TextButton(
                style: TextButton.styleFrom(
                    primary: Colours.ACCENT_COLOR,
                    textStyle: Theme.of(context).textTheme.subtitle2?.copyWith(fontStyle: FontStyle.italic)),
                onPressed: () {
                  register(context);
                },
                child: const Text('Register!'))
          ],
        ));
  }
}
