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

  static const platformIconScale = 0.14;

  static const card_radius = 15.0;
  static const cardWidth = 160.0;
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
    return Scaffold(body: buildBodyWithBloc(context));
  }

  Widget buildBodyWithBloc(BuildContext context) {
    final orien = MediaQuery.of(context).orientation;
    print(orien.toString());
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
        height: getMediaHeight(context),
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/back-layer.png"), fit: BoxFit.cover)),
        child: LayoutBuilder(
            builder: (BuildContext ctx, BoxConstraints constraints) {
          if (constraints.maxHeight > constraints.maxWidth) {
            print("LayoutBuilder: portrait");
          } else {
            print("LayoutBuilder: landscape");
          }
          return Stack(children: <Widget>[
            Positioned(
              left: Dimen.bgFrontLayerLeft,
              top: Dimen.bgFrontLayerTop,
              child: Image.asset('assets/front-layer.png'),
            ),
            buildScrollableBody(context)
          ]);
        }));
  }

  Widget buildScrollableBody(BuildContext context) {
    return CustomScrollView(slivers: <Widget>[
      SliverList(
        delegate: SliverChildListDelegate(
          [
            Padding(
              padding: EdgeInsets.only(
                top: 30, // getHeightNoAppBar(context, 0.09)
              ),
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
            left: 0, //getWidth(context, 0.04), right: getWidth(context, 0.04)
          ),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            buildCard(child: buildLeftCardChild(context), context: context),
            buildCard(child: buildRightCardChild(context), context: context),
          ]),
        ),
        Padding(
          child: Image.asset('assets/${Constants.IC_FLUTTER}'),
          padding: EdgeInsets.only(
              top: 0 // getHeightNoAppBar(context, Dimen.scale_3_100)
              ),
        ),
        Padding(
          child: Image.asset('assets/${Constants.IC_PLUS}'),
          padding: EdgeInsets.only(
              top: 0 // getHeightNoAppBar(context, Dimen.scale_3_100)
              ),
        ),
        Padding(
          child: Image.asset('assets/${Constants.IC_CONFLUENCE}'),
          padding: EdgeInsets.only(
              top: 0 //getHeightNoAppBar(context, Dimen.scale_2_100)
              ),
        ),
        Padding(
          padding: EdgeInsets.only(
            top: 0, //getHeightNoAppBar(context, Dimen.scale_4_100),
            right: 0, //getWidth(context, Dimen.scale_9_100),
            left: 0, //getWidth(context, Dimen.scale_9_100)
          ),
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
        padding: EdgeInsets.all(10),
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
        width: isPortrait(context)
            ? getWidth(context, 0.4)
            : getWidth(context, 0.4),
        child: AspectRatio(
          aspectRatio: isPortrait(context) ? 4 / 7 : 8 / 13,
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
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 0),
                  child: Text(msgTrainingTypes,
                      maxLines: 1,
                      style: Theme.of(context)
                          .textTheme
                          .headline2
                          ?.copyWith(color: Colors.white, fontSize: Dimen.dimen_14)),
                ),
                GridView.count(
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.all(12),
                  crossAxisSpacing: 26,
                  mainAxisSpacing: 20,
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  children: getPlatformIcons(constraints.maxWidth),
                ),
              ],
            ),
          );
    });
  }

  List<Widget> getPlatformIcons(double parentWidth) {
    List<Widget> icons = [];
    icons.add(buildPlatformIcon(Constants.IC_AWS));
    icons.add(buildPlatformIcon(Constants.IC_AZURE));
    icons.add(buildPlatformIcon(Constants.IC_GCP));
    icons.add(buildPlatformIcon(Constants.IC_HASHICORP));
    icons.add(buildPlatformIcon(Constants.IC_CLOUD_NATIVE));
    return icons;
  }

  Widget buildPlatformIcon(String iconName) {
    return CircleAvatar(
      backgroundColor: Colors.white,
      backgroundImage: AssetImage('assets/$iconName'),
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
        width: getWidth(context, Dimen.scale_5_10),
        margin: EdgeInsets.only(
          top: 10, //getHeightNoAppBar(context, Dimen.scale_6_100),
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
}
