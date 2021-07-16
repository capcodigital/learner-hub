import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_confluence/core/dimen.dart';
import 'package:flutter_confluence/core/utils/error_messages.dart';

import '../../../../core/constants.dart';
import '../../../certifications/presentation/pages/home_page.dart';
import '../bloc/on_boarding_bloc.dart';

class OnBoardingPage extends StatelessWidget with CustomAlertDialog {
  static const route = "OnBoardingPage";

  static const msgTrainingTypes = "Training Types";
  static const msgCardDescription =
      "See the name, the date, the title of certification";
  static const msgDescription =
      "See all your co-workers certifications within a swipe";
  static const msgAuthenticate = "Authenticate";
  static const msgAuthenticateNotSupported = "Continue";

  static const platformIconRadius = 20.0;
  static const card_radius = 15.0;
  static const cardWidth = 160.0;
  static const cardHeight = 220.0;

  void authenticate(BuildContext context) {
    BlocProvider.of<OnBoardingBloc>(context).add(AuthEvent());
  }

  void openHomePage(BuildContext context) {
    Navigator.pushNamed(context, HomePage.route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: buildPageBody(context));
  }

  Widget buildPageBody(BuildContext context) {
    return BlocListener(
      bloc: BlocProvider.of<OnBoardingBloc>(context),
      listener: (context, state) {
        if (state is AuthError) {
          showAlertDialog(context, state.message);
        }
      },
      child: buildDecoratedBody(context),
    );
  }

  Widget buildDecoratedBody(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/back-layer.png"), fit: BoxFit.cover)),
        child: Stack(
          children: <Widget>[
            Positioned(
              left: Dimen.bgFrontLayerLeft,
              top: Dimen.bgFrontLayerTop,
              child: Image.asset('assets/front-layer.png'),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: buildBody(context),
            )
          ],
        ));
  }

  Widget buildBody(BuildContext context) {
    return Column(
      children: [
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildCard(child: buildLeftCardChild(context)),
              buildCard(child: buildRightCardChild(context)),
            ]),
        Padding(
          child: Image.asset('assets/${Constants.IC_FLUTTER}'),
          padding: EdgeInsets.only(top: Dimen.dimen_20),
        ),
        Padding(
          child: Image.asset('assets/${Constants.IC_PLUS}'),
          padding: EdgeInsets.only(top: Dimen.dimen_20),
        ),
        Padding(
          child: Image.asset('assets/${Constants.IC_CONFLUENCE}'),
          padding: EdgeInsets.only(top: Dimen.dimen_26),
        ),
        Padding(
          padding: EdgeInsets.only(
              top: 10, right: Dimen.dimen_68, left: Dimen.dimen_68),
          child: Center(
            child: Text(
              msgDescription,
              // TODO: Missing maxLines was related to UI test failure
              maxLines: 2,
              style: Theme.of(context).textTheme.headline2,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        buildAuthButton(context)
      ],
    );
  }

  Widget buildCard({required Widget child}) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(card_radius),
      ),
      child: Container(
          padding: EdgeInsets.all(Dimen.dimen_8),
          decoration: BoxDecoration(
            color: Constants.JIRA_COLOR,
            borderRadius: BorderRadius.circular(card_radius),
            boxShadow: [
              BoxShadow(
                color: Constants.BLACK_25,
                blurRadius: 3,
                offset: Offset(0.0, 3.0),
              ),
            ],
          ),
          width: cardWidth,
          height: cardHeight,
          child: child),
    );
/*
    return Container(
      margin: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Constants.JIRA_COLOR,
        borderRadius: BorderRadius.circular(card_radius),
        boxShadow: [
          BoxShadow(
            color: Constants.BLACK_25,
            blurRadius: 3,
            offset: Offset(0.0, 3.0),
          ),
        ],
      ),
      width: cardWidth,
      height: cardHeight,
      child: Card(
        color: Constants.JIRA_COLOR,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(card_radius),
        ),
        child: child,
      ),
    );*/
  }

  Widget buildLeftCardChild(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Text(msgTrainingTypes,
              style: Theme.of(context).textTheme.headline2?.copyWith(
                  color: Colors.white,
                  // TODO: Larger font causes UI test fail
                  fontSize: 12)),
        ),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildPlatformIcon(Constants.IC_AWS),
                buildPlatformIcon(Constants.IC_AZURE),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildPlatformIcon(Constants.IC_GCP),
                buildPlatformIcon(Constants.IC_HASHICORP),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildPlatformIcon(Constants.IC_CLOUD_NATIVE),
                Opacity(
                    opacity: 0.0,
                    child: buildPlatformIcon(Constants.IC_CLOUD_NATIVE)),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget buildRightCardChild(BuildContext context) {
    return Center(
      child: Text(
        msgCardDescription,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headline1?.copyWith(
            color: Colors.white,
            // TODO: Larger font causes UI test fail
            fontSize: 12),
      ),
    );
  }

  Widget buildAuthButton(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 10,
           left: 60, right: 60
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(
                vertical: 20,
                // TODO: Check why horizontal padding is not working
                horizontal: 1),
            shadowColor: Colors.black,
            primary: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Dimen.mainBtnBorderRadius),
                side: BorderSide(
                    width: Dimen.mainBtnBorderWidth,
                    color: Constants.JIRA_COLOR)),
          ),
          onPressed: () {
            authenticate(context);
          },
          child: Center(
            child: Text(kIsWeb ? msgAuthenticateNotSupported : msgAuthenticate,
                style: Theme.of(context)
                    .textTheme
                    .headline1
                    ?.copyWith(color: Constants.JIRA_COLOR)),
          ),
        ));
  }

  Widget buildPlatformIcon(String iconName) {
    return Padding(
      padding: const EdgeInsets.all(Dimen.dimen_8),
      child: CircleAvatar(
        radius: platformIconRadius,
        backgroundColor: Colors.white,
        backgroundImage: AssetImage('assets/$iconName'),
      ),
    );
  }
}
