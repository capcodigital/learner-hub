import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_confluence/core/shared_ui/custom_menu_page.dart';

import '/core/colours.dart';
import '/core/layout_constants.dart';
import '/core/shared_ui/custom_bottom_nav.dart';
import '/core/shared_ui/primary_button.dart';
import '/core/utils/media_util.dart';
import '/features/onboarding/presentation/widgets/onboarding_carousel.dart';
import '/features/user_registration/presentation/pages/user_details_page.dart';
import 'login_page.dart';

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
          builder: (context) =>
              const CustomMenuPage(child: CustomBottomNavBar()),
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
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(),
          OnBoardingCarousel(),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(
                vertical: LayoutConstants.LARGE_PADDING,
                horizontal: LayoutConstants.SMALL_PADDING),
            child: PrimaryButton(
                text: 'Log in',
                onPressed: () {
                  login(context);
                }),
          ),
          getFooter(context),
        ]);
  }

  Widget getFooter(BuildContext context) {
    final MediaQueriesImpl mediaQueries =
        MediaQueriesImpl(buildContext: context);
    return Column(
      children: [
        Container(
            color: Colours.ALTERNATIVE_COLOR,
            height: 64,
            width: mediaQueries.applyWidth(context, 1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Not a member yet?',
                    style: Theme.of(context).textTheme.subtitle1),
                TextButton(
                    style: TextButton.styleFrom(
                        primary: Colours.ACCENT_COLOR,
                        textStyle: Theme.of(context)
                            .textTheme
                            .subtitle2
                            ?.copyWith(fontStyle: FontStyle.italic)),
                    onPressed: () {
                      register(context);
                    },
                    child: const Text('Register!'))
              ],
            )),
        Container(
          height: LayoutConstants.REGULAR_PADDING,
          width: mediaQueries.applyWidth(context, 1),
          color: Colors.white,
        )
      ],
    );
  }
}
