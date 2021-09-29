import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '/core/colours.dart';
import '/core/components/app_drawer.dart';
import '/core/components/custom_appbar.dart';
import '/core/constants.dart';
import '/core/dimen.dart';
import '/core/utils/media_util.dart';
import '/core/widgets/primary_button.dart';
import '/features/certifications/presentation/pages/home_page.dart';
import '/features/login/presentation/pages/login_page.dart';
import '/features/onboarding/presentation/widgets/onboarding_carousel.dart';
import '/features/user_registration/presentation/pages/user_details_page.dart';

class OnBoardingPage extends StatelessWidget {
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
    Navigator.pushNamed(context, LoginPage.route);
  }

  void navigateToRegisterPage(BuildContext context) {
    Navigator.pushNamed(context, UserDetailsPage.route);
  }

  @override
  Widget build(BuildContext context) {
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
