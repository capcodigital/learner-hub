import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_confluence/core/dimen.dart';
import 'package:flutter_confluence/core/utils/error_messages.dart';
import 'package:flutter_confluence/core/utils/media_util.dart';

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

  static const platformIconRadius = 24.0;
  static const card_radius = 15.0;
  static const cardHeight = 250.0;
  static const authBtnVerticalPadding = 20.0;

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
            buildScrollableBody(context)
          ],
        ));
  }

  Widget buildScrollableBody(BuildContext context) {
    return CustomScrollView(slivers: <Widget>[
      SliverList(
        delegate: SliverChildListDelegate(
          [
            Padding(
              padding: EdgeInsets.only(top: getHeight(context, 0.09)),
              child: buildBody(context),
            )
          ],
        ),
      )
    ]);
  }

  Widget buildBody(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
              left: getWidth(context, 0.04), right: getWidth(context, 0.04)),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            buildCard(child: buildLeftCardChild(context), context: context),
            buildCard(child: buildRightCardChild(context), context: context),
          ]),
        ),
        Padding(
          child: Image.asset('assets/${Constants.IC_FLUTTER}'),
          padding: EdgeInsets.only(top: getHeight(context, 0.03)),
        ),
        Padding(
          child: Image.asset('assets/${Constants.IC_PLUS}'),
          padding: EdgeInsets.only(top: getHeight(context, 0.03)),
        ),
        Padding(
          child: Image.asset('assets/${Constants.IC_CONFLUENCE}'),
          padding: EdgeInsets.only(top: getHeight(context, 0.02)),
        ),
        Padding(
          padding: EdgeInsets.only(
              top: getHeight(context, 0.04),
              right: getWidth(context, 0.09),
              left: getWidth(context, 0.09)),
          child: Center(
            child: Text(
              msgDescription,
              style: Theme.of(context).textTheme.headline2,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        buildAuthButton(context)
      ],
    );
  }

  Widget buildCard({required BuildContext context, required Widget child}) {
    return Card(
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
          width: getWidth(context, 0.4),
          height: cardHeight, //getHeight(context, 0.3),
          child: child),
    );
  }

  Widget buildLeftCardChild(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: Dimen.dimen_10),
          child: Text(msgTrainingTypes,
              maxLines: 1,
              style: Theme.of(context)
                  .textTheme
                  .headline2
                  ?.copyWith(color: Colors.white, fontSize: Dimen.dimen_14)),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            buildPlatformIcon(Constants.IC_AWS),
            buildPlatformIcon(Constants.IC_AZURE),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            buildPlatformIcon(Constants.IC_GCP),
            buildPlatformIcon(Constants.IC_HASHICORP),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            buildPlatformIcon(Constants.IC_CLOUD_NATIVE),
            Opacity(
                opacity: 0.0,
                child: buildPlatformIcon(Constants.IC_CLOUD_NATIVE)),
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
        style: Theme.of(context)
            .textTheme
            .headline1
            ?.copyWith(color: Colors.white),
      ),
    );
  }

  Widget buildAuthButton(BuildContext context) {
    return Container(
        // Using Container to restrict ElevatedButton width cause it was full screen width
        // Horizontal padding on ElevatedButton was not working, still btn was full screen width
        width: getWidth(context, 0.5),
        margin: EdgeInsets.only(
          top: getHeight(context, 0.06),
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: authBtnVerticalPadding),
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
      padding: EdgeInsets.all(Dimen.dimen_8),
      child: CircleAvatar(
        radius: platformIconRadius,
        backgroundColor: Colors.white,
        backgroundImage: AssetImage('assets/$iconName'),
      ),
    );
  }
}
