import 'package:flutter/material.dart';
import 'package:flutter_confluence/core/constants.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 80),
        child: buildBody(context),
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Card(
              child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/ic_rectangle.png"),
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
                                PlatformIcon(
                                    'assets/${Constants.IC_HASHICORP}'),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                PlatformIcon(
                                    'assets/${Constants.IC_CLOUD_NATIVE}'),
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
            ),
            Card(
              child: Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/ic_rectangle.png"),
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
            )
          ],
        ),
        Container(
          child: Image.asset('assets/ic_flutter.png'),
          margin: EdgeInsets.only(top: 20),
        ),
        Container(
          child: Image.asset('assets/ic_plus.png'),
          margin: EdgeInsets.only(top: 20),
        ),
        Container(
          child: Image.asset('assets/ic_confluence.png'),
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
            onPressed: () {},
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(msgAuthenticate,
                  style: Theme.of(context)
                      .textTheme
                      .headline1
                      ?.copyWith(color: Constants.JIRA_COLOR)),
            ),
          ),
        ),
      ],
    );
  }
}
