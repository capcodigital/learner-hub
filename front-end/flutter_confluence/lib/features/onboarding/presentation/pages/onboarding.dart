import 'package:flutter/material.dart';
import 'package:flutter_confluence/core/constants.dart';
import 'package:flutter_confluence/features/onboarding/presentation/widgets/platform_icon.dart';

class OnBoardingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _OnBoardingPageState();
  }
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  static const msgTrainingTypes = "Training Types";
  static const msgCardWelcome =
      "See the name, the date, the title of certification";
  static const msgWelcome =
      "See all your co-workers certifications within a swipe";
  static const msgAuthenticate = "Authenticate";

  static const cardWidth = 180.0;
  static const cardHeight = 400.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cloud Certifications',
            style: Theme.of(context).textTheme.headline1),
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
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
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                PlatformIcon('assets/ic_aws.png'),
                                PlatformIcon('assets/ic_azure.png'),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                PlatformIcon('assets/ic_gcp.png'),
                                PlatformIcon('assets/ic_hashicorp.png'),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                PlatformIcon('assets/ic_cloud_native.png'),
                                Padding(
                                  padding: const EdgeInsets.all(0),
                                  child: Opacity(
                                    opacity: 0.0,
                                    child: PlatformIcon('assets/ic_cloud_native.png')
                                  ),
                                )
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
                ),
              ),
            )
          ],
        ),
        Container(child: Image.asset('assets/ic_flutter.png')),
        Container(child: Image.asset('assets/ic_plus.png')),
        Container(child: Image.asset('assets/ic_confluence.png')),
        Text(msgWelcome),
        ElevatedButton(
          style: ElevatedButton.styleFrom(primary: Colors.white),
          onPressed: () {},
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(msgAuthenticate,
                style: Theme.of(context)
                    .textTheme
                    .headline2
                    ?.copyWith(color: Constants.JIRA_COLOR)),
          ),
        ),
      ],
    );
  }
}
