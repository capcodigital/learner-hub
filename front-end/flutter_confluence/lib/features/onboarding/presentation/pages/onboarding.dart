import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../presentation/pages/home_page.dart';
import '../../../../core/constants.dart';
import '../bloc/on_boarding_bloc.dart';
import '../../../../injection_container.dart';
import '../widgets/platform_icon.dart';

class OnBoardingPage extends StatelessWidget {
  static const msgTrainingTypes = "Training Types";
  static const msgCardWelcome =
      "See the name, the date, the title of certification";
  static const msgWelcome =
      "See all your co-workers certifications within a swipe";
  static const msgAuthenticate = "Authenticate";

  static const dimen_6 = 6.0;
  static const dimen_8 = 8.0;
  static const dimen_16 = 16.0;
  static const dimen_20 = 20.0;
  static const dimen_26 = 26.0;
  static const dimen_34 = 34.0;
  static const dimen_48 = 48.0;
  static const dimen_80 = 80.0;

  static const card_radius = 15.0;

  static const cardWidth = 180.0;
  static const cardHeight = 260.0;

  void authenticate(BuildContext context) {
    BlocProvider.of<OnBoardingBloc>(context).add(AuthenticationEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: dimen_80),
        child: buildBody(context),
      ),
    );
  }

  BlocProvider<OnBoardingBloc> buildBody(BuildContext context) {
    return BlocProvider(create: (_) {
      final bloc = sl<OnBoardingBloc>();
      return bloc;
    }, child: BlocBuilder<OnBoardingBloc, OnBoardingState>(
      builder: (ctx, state) {
        if (state is Completed) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        }
        return buildMainBody(ctx);
      },
    ));
  }

  Widget buildMainBody(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [buildLeftCard(context), buildRightCard(context)],
        ),
        buildIcon(Constants.IC_FLUTTER, dimen_20),
        buildIcon(Constants.IC_PLUS, dimen_20),
        buildIcon(Constants.IC_CONFLUENCE, dimen_26),
        Container(
          child: Text(
            msgWelcome,
          ),
          margin: EdgeInsets.only(top: dimen_34),
        ),
        buildAuthButton(context)
      ],
    );
  }

  Widget buildCard(Widget childWidget) {
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
          child: childWidget),
    );
  }

  Widget buildLeftCard(BuildContext context) {
    return buildCard(buildLeftCardChild(context));
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
                      child:
                          PlatformIcon(Constants.IC_CLOUD_NATIVE)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildRightCard(BuildContext context) {
    return buildCard(buildRightCardChild(context));
  }

  Widget buildRightCardChild(BuildContext context) {
    return Center(
      child: Text(
        msgCardWelcome,
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

  Widget buildAuthButton(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: dimen_48),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(primary: Colors.white),
          onPressed: () {
            authenticate(context);
          },
          child: Padding(
            padding: const EdgeInsets.all(dimen_16),
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
