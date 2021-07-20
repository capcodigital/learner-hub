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

  void authenticate(BuildContext context) {
    BlocProvider.of<OnBoardingBloc>(context).add(AuthEvent());
  }

  void openHomePage(BuildContext context) {
    Navigator.pushNamed(context, HomePage.route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: buildBodyWithBloc(context));
  }

  Widget buildBodyWithBloc(BuildContext context) {
    return BlocListener(
      bloc: BlocProvider.of<OnBoardingBloc>(context),
      listener: (context, state) {
        if (state is AuthError) {
          showAlertDialog(context, state.message);
        }
      },
      child: buildWithLayoutBuilder(context),
    );
  }

  Widget buildWithLayoutBuilder(BuildContext context) {
    return Container(
        width: getMediaWidth(context),
        // TODO: If we subtract status bar height, then background image not cover
        // all screen. There is a white portion on the bottom equal to status bar height
        height: getMediaHeight(context),
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/back-layer.png"), fit: BoxFit.cover)),
        child: LayoutBuilder(
            builder: (BuildContext ctx, BoxConstraints constraints) {
          return Stack(children: <Widget>[
            Positioned(
              left: Dimen.bgFrontLayerLeft,
              top: Dimen.bgFrontLayerTop,
              child: Image.asset('assets/front-layer.png'),
            ),
            buildScrollableBody(context, constraints)
          ]);
        }));
  }

  Widget buildScrollableBody(BuildContext context, BoxConstraints constraints) {
    return CustomScrollView(slivers: <Widget>[
      SliverList(
        delegate: SliverChildListDelegate(
          [
            Padding(
              padding: EdgeInsets.only(
                  top: constraints.maxHeight * Dimen.scale_8_100,
                  bottom: constraints.maxHeight * Dimen.scale_8_100),
              child: buildBody(context, constraints),
            )
          ],
        ),
      )
    ]);
  }

  Widget buildBody(BuildContext context, BoxConstraints constraints) {
    final topMargin = isPortrait(context)
        ? constraints.maxHeight * Dimen.scale_2_100
        : constraints.maxHeight * Dimen.scale_6_100;

    final msgTopMargin = isPortrait(context)
        ? constraints.maxHeight * Dimen.scale_3_100
        : constraints.maxHeight * Dimen.scale_3_100;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
              left: constraints.maxWidth * Dimen.scale_3_100,
              right: constraints.maxWidth * Dimen.scale_3_100),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            buildCard(
                child: buildLeftCardChild(context),
                context: context,
                constraints: constraints),
            buildCard(
                child: buildRightCardChild(context),
                context: context,
                constraints: constraints),
          ]),
        ),
        Padding(
          child: Image.asset('assets/${Constants.IC_FLUTTER}'),
          padding: EdgeInsets.only(top: topMargin),
        ),
        Padding(
          child: Image.asset('assets/${Constants.IC_PLUS}'),
          padding: EdgeInsets.only(top: topMargin),
        ),
        Padding(
          child: Image.asset('assets/${Constants.IC_CONFLUENCE}'),
          padding: EdgeInsets.only(top: topMargin),
        ),
        Padding(
          padding: EdgeInsets.only(
              top: msgTopMargin,
              right: constraints.maxWidth * Dimen.scale_9_100,
              left: constraints.maxWidth * Dimen.scale_9_100),
          child: Center(
            child: Text(
              msgDescription,
              style: Theme.of(context).textTheme.headline2,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        buildAuthButton(context, constraints)
      ],
    );
  }

  Widget buildCard(
      {required BuildContext context,
      required Widget child,
      required BoxConstraints constraints}) {
    final cardWidth = isPortrait(context)
        ? constraints.maxWidth * Dimen.scale_40_100
        : constraints.maxWidth * Dimen.scale_22_100;
    final borderRadius = BorderRadius.circular(cardWidth * Dimen.scale_9_100);
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Constants.JIRA_COLOR,
          borderRadius: borderRadius,
          boxShadow: [
            BoxShadow(
              color: Constants.BLACK_25,
              blurRadius: 3,
              offset: Offset(0.0, 4.0),
            ),
          ],
        ),
        width: cardWidth,
        child: AspectRatio(
          aspectRatio: isPortrait(context) ? 4 / 5.5 : 8 / 11.5,
          child: child,
        ),
      ),
    );
  }

  Widget buildLeftCardChild(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext ctx, BoxConstraints constraints) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  bottom: constraints.maxHeight * Dimen.scale_2_100),
              child: Text(msgTrainingTypes,
                  maxLines: 1,
                  style: Theme.of(context).textTheme.headline2?.copyWith(
                      color: Colors.white, fontSize: Dimen.dimen_14)),
            ),
            GridView.count(
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.only(
                  top: constraints.maxHeight * Dimen.scale_3_100,
                  left: constraints.maxWidth * Dimen.scale_12_100,
                  right: constraints.maxWidth * Dimen.scale_12_100),
              crossAxisSpacing: constraints.maxWidth * Dimen.scale_15_100,
              mainAxisSpacing: constraints.maxHeight * Dimen.scale_4_100,
              crossAxisCount: 2,
              shrinkWrap: true,
              children: getPlatformIcons(constraints.maxWidth, constraints),
            ),
          ],
        ),
      );
    });
  }

  List<Widget> getPlatformIcons(
      double parentWidth, BoxConstraints constraints) {
    List<Widget> icons = [];
    icons.add(buildPlatformIcon(Constants.IC_AWS, constraints));
    icons.add(buildPlatformIcon(Constants.IC_AZURE, constraints));
    icons.add(buildPlatformIcon(Constants.IC_GCP, constraints));
    icons.add(buildPlatformIcon(Constants.IC_HASHICORP, constraints));
    icons.add(buildPlatformIcon(Constants.IC_CLOUD_NATIVE, constraints));
    return icons;
  }

  Widget buildPlatformIcon(String iconName, BoxConstraints constraints) {
    return Padding(
      padding: EdgeInsets.all(constraints.maxWidth * 0.025),
      child: CircleAvatar(
        backgroundColor: Colors.white,
        backgroundImage: AssetImage('assets/$iconName'),
      ),
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

  Widget buildAuthButton(BuildContext context, BoxConstraints constraints) {
    final btnVerticalPadding = isPortrait(context)
        ? constraints.maxHeight * Dimen.scale_22_1000
        : constraints.maxHeight * 0.048;
    return Container(
        // Horizontal padding on ElevatedButton not working at all ?.
        width: constraints.maxWidth * Dimen.scale_50_100,
        margin: EdgeInsets.only(
          top: constraints.maxHeight * Dimen.scale_6_100,
        ),
        child: LayoutBuilder(
            builder: (BuildContext ctx, BoxConstraints constraints) {
          final btnBorderRadius = isPortrait(context)
              ? constraints.maxWidth * 0.08
              : constraints.maxWidth * 0.05;
          final btnBorderWidth = isPortrait(context)
              ? constraints.maxWidth * 0.006
              : constraints.maxWidth * 0.003;
          return ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: btnVerticalPadding),
              shadowColor: Colors.black,
              primary: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(btnBorderRadius),
                  side: BorderSide(
                      width: btnBorderWidth, color: Constants.JIRA_COLOR)),
            ),
            onPressed: () {
              authenticate(context);
            },
            child: Center(
              child: Text(
                  kIsWeb ? msgAuthenticateNotSupported : msgAuthenticate,
                  style: Theme.of(context)
                      .textTheme
                      .headline1
                      ?.copyWith(color: Constants.JIRA_COLOR)),
            ),
          );
        }));
  }
}
