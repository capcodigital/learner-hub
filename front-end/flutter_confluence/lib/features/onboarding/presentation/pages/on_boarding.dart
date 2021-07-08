import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_confluence/core/utils/error_messages.dart';

import '../../../../core/constants.dart';
import '../../../certifications/presentation/pages/home_page.dart';
import '../bloc/on_boarding_bloc.dart';

class OnBoardingPage extends StatelessWidget {
  static const route = "OnBoardingPage";

  static const msgTrainingTypes = "Training Types";
  static const msgCardDescription =
      "See the name, the date, the title of certification";
  static const msgDescription =
      "See all your co-workers certifications within a swipe";
  static const msgAuthenticate = "Authenticate";
  static const msgAuthenticateNotSupported = "Continue";

  static const dimen_6 = 6.0;
  static const dimen_8 = 8.0;
  static const dimen_16 = 16.0;
  static const dimen_20 = 20.0;
  static const dimen_26 = 26.0;
  static const dimen_34 = 34.0;
  static const dimen_48 = 48.0;
  static const dimen_68 = 68.0;
  static const dimen_80 = 80.0;

  static const platformIconRadius = 26.0;
  static const card_radius = 15.0;
  static const cardWidth = 180.0;
  static const cardHeight = 260.0;
  static const authBtnHeight = 60.0;
  static const authBtnWidth = 230.0;
  static const authBtnBorderRadius = 20.0;
  static const authBtnBorderWidth = 1.0;
  static const frontLayerLeft = 88.0;
  static const frontLayerTop = 270.0;

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
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/back-layer.png"), fit: BoxFit.cover)),
        child: Stack(
          children: <Widget>[
            Positioned(
              left: frontLayerLeft,
              top: frontLayerTop,
              child: Image.asset('assets/front-layer.png'),
            ),
            Padding(
              padding: const EdgeInsets.only(top: dimen_80),
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              buildCard(child: buildLeftCardChild(context)),
              buildCard(child: buildRightCardChild(context)),
            ]),
        Container(
          child: Image.asset('assets/${Constants.IC_FLUTTER}'),
          margin: EdgeInsets.only(top: dimen_20),
        ),
        Container(
          child: Image.asset('assets/${Constants.IC_PLUS}'),
          margin: EdgeInsets.only(top: dimen_20),
        ),
        Container(
          child: Image.asset('assets/${Constants.IC_CONFLUENCE}'),
          margin: EdgeInsets.only(top: dimen_26),
        ),
        Container(
          alignment: Alignment.center,
          child: Text(
            msgDescription,
            style: Theme.of(context).textTheme.headline2,
            textAlign: TextAlign.center,
          ),
          margin:
              EdgeInsets.only(top: dimen_34, right: dimen_68, left: dimen_68),
        ),
        buildAuthButton(context)
      ],
    );
  }

  Widget buildCard({required Widget child}) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(card_radius),
      ),
      child: Container(
          padding: EdgeInsets.all(dimen_8),
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
  }

  Widget buildLeftCardChild(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(msgTrainingTypes,
            style: Theme.of(context)
                .textTheme
                .headline2
                ?.copyWith(color: Colors.white)),
        Container(
          margin: EdgeInsets.only(top: dimen_6),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  buildPlatformIcon(Constants.IC_AWS),
                  buildPlatformIcon(Constants.IC_AZURE),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  buildPlatformIcon(Constants.IC_GCP),
                  buildPlatformIcon(Constants.IC_HASHICORP),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  buildPlatformIcon(Constants.IC_CLOUD_NATIVE),
                  Opacity(
                      opacity: 0.0,
                      child: buildPlatformIcon(Constants.IC_CLOUD_NATIVE)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildRightCardChild(BuildContext context) {
    return Center(
      child: Text(
        msgCardDescription,
        textAlign: TextAlign.center,
        style: Theme.of(context)
            .textTheme
            .headline1
            ?.copyWith(color: Colors.white),
      ),
    );
  }

  Widget buildAuthButton(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: dimen_48),
        width: authBtnWidth,
        height: authBtnHeight,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shadowColor: Colors.black,
            primary: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(authBtnBorderRadius),
                side: BorderSide(
                    width: authBtnBorderWidth, color: Constants.JIRA_COLOR)),
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
      padding: const EdgeInsets.all(dimen_8),
      child: CircleAvatar(
        radius: platformIconRadius,
        backgroundColor: Colors.white,
        backgroundImage: AssetImage('assets/$iconName'),
      ),
    );
  }
}
