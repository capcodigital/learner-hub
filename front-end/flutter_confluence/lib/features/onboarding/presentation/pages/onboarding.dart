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

  static const cardWidth = 180.0;
  static const cardHeight = 260.0;

  void authenticate(BuildContext context) {
    BlocProvider.of<OnBoardingBloc>(context).add(AuthenticationEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 80),
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
          children: [buildPlatformsCard(context), buildMessageCard(context)],
        ),
        Container(
          child: Image.asset('assets/${Constants.IC_FLUTTER}'),
          margin: EdgeInsets.only(top: 20),
        ),
        Container(
          child: Image.asset('assets/${Constants.IC_PLUS}'),
          margin: EdgeInsets.only(top: 20),
        ),
        Container(
          child: Image.asset('assets/${Constants.IC_CONFLUENCE}'),
          margin: EdgeInsets.only(top: 26),
        ),
        Container(
          child: Text(
            msgWelcome,
            softWrap: true,
          ),
          margin: EdgeInsets.only(top: 34),
        ),
        Container(
            margin: EdgeInsets.only(top: 48),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.white),
              onPressed: () {
                authenticate(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(msgAuthenticate,
                    style: Theme.of(context)
                        .textTheme
                        .headline1
                        ?.copyWith(color: Constants.JIRA_COLOR)),
              ),
            )),
      ],
    );
  }

  Widget buildPlatformsCard(BuildContext context) {
    return Card(
      child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/${Constants.IC_ONBOARDING_CARD_BG}"),
                fit: BoxFit.cover)),
        width: cardWidth,
        height: cardHeight,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(msgTrainingTypes,
                  style: Theme.of(context)
                      .textTheme
                      .headline2
                      ?.copyWith(color: Colors.white)),
              Container(
                margin: EdgeInsets.only(top: 6.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        PlatformIcon('assets/${Constants.IC_AWS}'),
                        PlatformIcon('assets/${Constants.IC_AZURE}'),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        PlatformIcon('assets/${Constants.IC_GCP}'),
                        PlatformIcon('assets/${Constants.IC_HASHICORP}'),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        PlatformIcon('assets/${Constants.IC_CLOUD_NATIVE}'),
                        Opacity(
                            opacity: 0.0,
                            child: PlatformIcon(
                                'assets/${Constants.IC_CLOUD_NATIVE}')),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMessageCard(BuildContext context) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/${Constants.IC_ONBOARDING_CARD_BG}"),
                fit: BoxFit.cover)),
        width: cardWidth,
        alignment: Alignment.center,
        height: cardHeight,
        child: Text(
          msgCardWelcome,
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .headline1
              ?.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
