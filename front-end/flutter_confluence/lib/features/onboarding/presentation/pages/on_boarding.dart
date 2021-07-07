import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../certifications/presentation/pages/home_page.dart';
import '../../../../core/constants.dart';
import '../bloc/on_boarding_bloc.dart';

class OnBoardingPage extends StatefulWidget {
  static const route = "OnBoardingPage";

  @override
  State<StatefulWidget> createState() {
    return new _OnBoardingPageState();
  }
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  static const msgTrainingTypes = "Training Types";
  static const msgCardDescription =
      "See the name, the date, the title of certification";
  static const msgDescription =
      "See all your co-workers certifications within a swipe";
  static const msgAuthenticate = "Authenticate";

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
  static const authErrorDialogBtnWidth = 132.0;

  //var isCheckingCachedAuth = true;

  void authenticate(BuildContext context) {
    BlocProvider.of<OnBoardingBloc>(context).add(AuthEvent());
  }

  void openHomePage(BuildContext context) {
    Navigator.pushNamed(context, HomePage.route);
  }

  @override
  Widget build(BuildContext context) {
    // return Scaffold(body: buildBlocListener(context));
    return Scaffold(body: buildPageBody(context));
  }

  // BlocListener<OnBoardingBloc, OnBoardingState> buildBlocListener(
  //     BuildContext context) {
  //   return BlocListener<OnBoardingBloc, OnBoardingState>(
  //     listener: (ctx, state) {
  //       if (state is AuthError) {
  //         _showDialog(context, state.message);
  //       }
  //       if (state is Completed) {
  //         openHomePage(ctx);
  //       } else if (state is Expired)
  //         setState(() {
  //           isCheckingCachedAuth = false;
  //         });
  //     },
  //     child: buildPageBody(context),
  //   );
  // }

  Widget buildPageBody(BuildContext context) {
    // If user is already authenticated, Onboarding screen may still
    // be shown for a while before HomePage opens. To solve this we
    // show a Loading Message until cached auth check completes.

    // if (isCheckingCachedAuth)
    //   return buildLoadingView();
    // else
      return buildDecoratedBody(context);
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
        buildCardsRow(context),
        buildImage(Constants.IC_FLUTTER, dimen_20),
        buildImage(Constants.IC_PLUS, dimen_20),
        buildImage(Constants.IC_CONFLUENCE, dimen_26),
        buildDescriptionText(context),
        buildAuthButton(context)
      ],
    );
  }

  Widget buildCardsRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [buildLeftCard(context), buildRightCard(context)],
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
          decoration: buildShadowDecoration(),
          width: cardWidth,
          height: cardHeight,
          child: child),
    );
  }

  Widget buildLeftCard(BuildContext context) {
    return buildCard(child: buildLeftCardChild(context));
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
                  buildInvisibleWidget(
                      buildPlatformIcon(Constants.IC_CLOUD_NATIVE))
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildRightCard(BuildContext context) {
    return buildCard(child: buildRightCardChild(context));
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

  BoxDecoration buildShadowDecoration() {
    return BoxDecoration(
      color: Constants.JIRA_COLOR,
      borderRadius: BorderRadius.circular(card_radius),
      boxShadow: [
        BoxShadow(
          color: Constants.BLACK_25,
          blurRadius: 3,
          offset: Offset(0.0, 3.0), // changes position of shadow
        ),
      ],
    );
  }

  Widget buildDescriptionText(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Text(
        msgDescription,
        style: Theme.of(context).textTheme.headline2,
        textAlign: TextAlign.center,
      ),
      margin: EdgeInsets.only(top: dimen_34, right: dimen_68, left: dimen_68),
    );
  }

  Widget buildAuthButton(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: dimen_48),
        width: authBtnWidth,
        height: authBtnHeight,
        child: ElevatedButton(
          style: buildAuthButtonStyle(),
          onPressed: () {
            authenticate(context);
          },
          child: Center(
            child: Text(msgAuthenticate,
                style: Theme.of(context)
                    .textTheme
                    .headline1
                    ?.copyWith(color: Constants.JIRA_COLOR)),
          ),
        ));
  }

  ButtonStyle buildAuthButtonStyle() {
    return ElevatedButton.styleFrom(
      shadowColor: Colors.black,
      primary: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(authBtnBorderRadius),
          side: BorderSide(
              width: authBtnBorderWidth, color: Constants.JIRA_COLOR)),
    );
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

  Widget buildInvisibleWidget(Widget child) {
    return Opacity(
      opacity: 0.0,
      child: child,
    );
  }

  Widget buildImage(String iconName, double marginTop) {
    return Container(
      child: Image.asset('assets/$iconName'),
      margin: EdgeInsets.only(top: marginTop),
    );
  }

  Widget buildLoadingView() {
    return Center(
      child: Text("Checking user authentication..."),
    );
  }

  // void _showDialog(BuildContext context, String message) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         content: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             Text(message),
  //             Container(
  //               margin: EdgeInsets.only(top: 10),
  //               child: Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                 crossAxisAlignment: CrossAxisAlignment.center,
  //                 children: [
  //                   Container(
  //                     width: authErrorDialogBtnWidth,
  //                     child: ElevatedButton(
  //                       child: new Text("OK"),
  //                       onPressed: () {
  //                         Navigator.of(context).pop();
  //                       },
  //                     ),
  //                   ),
  //                   Container(
  //                     width: authErrorDialogBtnWidth,
  //                     child: ElevatedButton(
  //                       child: new Text("Settings"),
  //                       onPressed: () {
  //                         AppSettings.openAppSettings();
  //                       },
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             )
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }
}
