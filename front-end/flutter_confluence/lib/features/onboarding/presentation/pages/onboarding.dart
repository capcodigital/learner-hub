import 'package:flutter/material.dart';

class OnBoardingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _OnBoardingPageState();
  }
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  static const trainingTypesMsg = "Training Types";
  static const cardWelcomeMsg =
      "See the name, the date, the title of certification";
      //"See";
  static const confluenceMsg = "Confluence";
  static const welcomeMsg =
      "See all your co-workers certifications within a swipe";
  static const authenticateMsg = "Authenticate";

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
            Container(
              width: 180,
              child: Card(
                child: //Text(cardWelcomeMsg),
                Column(
                  children: [
                    Text(cardWelcomeMsg),
                    Row(
                      children: [
                        Image.asset('assets/ic_aws.png'),
                        Image.asset('assets/ic_azure.png'),
                      ],
                    ),
                    Row(
                      children: [
                        Image.asset('assets/ic_gcp.png'),
                        Image.asset('assets/ic_hashicorp.png'),
                      ],
                    ),
                    Row(
                      children: [
                        Image.asset('assets/ic_cloud_native.png'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: 180,
              child: Card(
                child: Text(cardWelcomeMsg),
              ),
            )
          ],
        ),
        Container(child: Image.asset('assets/ic_flutter.png')),
        Container(child: Image.asset('assets/ic_plus.png')),
        Row(),
        Text(welcomeMsg),
        ElevatedButton(onPressed: () {}, child: Text(authenticateMsg)),
      ],
    );
  }
}
