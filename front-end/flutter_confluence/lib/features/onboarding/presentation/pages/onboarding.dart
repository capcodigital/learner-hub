import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../certifications/presentation/pages/home_page.dart';
import '../../../../core/constants.dart';
import '../bloc/on_boarding_bloc.dart';
import '../widgets/platform_icon.dart';

class OnBoardingPage extends StatelessWidget {
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

  static const card_radius = 15.0;
  static const cardWidth = 180.0;
  static const cardHeight = 260.0;
  static const authBtnHeight = 60.0;
  static const authBtnWidth = 230.0;
  static const authBtnBorderRadius = 20.0;
  static const authBtnBorderWidth = 1.0;

  void authenticate(BuildContext context) {
    BlocProvider.of<OnBoardingBloc>(context).add(AuthEvent());
  }

  void openHomePage(BuildContext context) {
    Navigator.pushNamed(context, HomePage.route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: dimen_80),
        child: buildBlocListener(context),
      ),
    );
  }

  BlocListener<OnBoardingBloc, OnBoardingState> buildBlocListener(
      BuildContext context) {
    return BlocListener<OnBoardingBloc, OnBoardingState>(
      listener: (ctx, state) {
        if (state is Completed) openHomePage(ctx);
      },
      child: buildBody(context),
    );
  }

  Widget buildBody(BuildContext context) {
    return Column(
      children: [
        buildCardsRow(context),
        buildIcon(Constants.IC_FLUTTER, dimen_20),
        buildIcon(Constants.IC_PLUS, dimen_20),
        buildIcon(Constants.IC_CONFLUENCE, dimen_26),
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
                  PlatformIcon(Constants.IC_AWS),
                  PlatformIcon(Constants.IC_AZURE),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  PlatformIcon(Constants.IC_GCP),
                  PlatformIcon(Constants.IC_HASHICORP),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  PlatformIcon(Constants.IC_CLOUD_NATIVE),
                  Opacity(
                      opacity: 0.0,
                      child: PlatformIcon(Constants.IC_CLOUD_NATIVE)),
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
          color: Constants.black25,
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
        style: Theme.of(context)
            .textTheme
            .headline2,
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
            child: Text(msgAuthenticate,
                style: Theme.of(context)
                    .textTheme
                    .headline1
                    ?.copyWith(color: Constants.JIRA_COLOR)),
          ),
        ));
  }

  Widget buildIcon(String iconName, double marginTop) {
    return Container(
      child: Image.asset('assets/$iconName'),
      margin: EdgeInsets.only(top: marginTop),
    );
  }
}
