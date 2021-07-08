import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../constants.dart';
import '../dimen.dart';

class ErrorPage extends StatelessWidget {
  static const route = "ErrorPage";
  static const msgTitle = "Oops!";
  static const msgDescription = "Something went wrong. Please try again.";
  static const msgTryAgain = "Try Again";
  static const errorImageMarginTop = 20.0;
  static const titleMarginTop = 60.0;
  static const errorMsgMarginTop = 100.0;
  static const errorMsgWidth = 240.0;
  static const tryAgainBtnMarginTop = 140.0;

  String message = msgDescription;

  ErrorPage(this.message);

  void tryAgain() {
    // Not implemented
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Cloud Certifications',
              style: Theme.of(context).textTheme.headline1),
          automaticallyImplyLeading: false,
        ),
        body: Container(
            constraints: BoxConstraints.expand(),
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/${Constants.IC_BACK_LAYER}"),
                    fit: BoxFit.cover)),
            child: Stack(
              children: <Widget>[
                Positioned(
                  left: Dimen.bgFrontLayerLeft,
                  top: Dimen.bgFrontLayerTop,
                  child: Image.asset('assets/${Constants.IC_FRONT_LAYER}'),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: Dimen.dimen_40),
                  child: buildBody(context),
                )
              ],
            )));
  }

  Widget buildBody(BuildContext context) {
    return Column(
      children: [
        Container(
          child: Image.asset(
            'assets/${Constants.IC_ERROR}',
          ),
          margin: EdgeInsets.only(top: errorImageMarginTop),
        ),
        Container(
          alignment: Alignment.center,
          child: Text(
            msgTitle,
            style: Theme.of(context)
                .textTheme
                .headline2
                ?.copyWith(fontSize: 24),
            textAlign: TextAlign.center,
          ),
          margin: EdgeInsets.only(top: titleMarginTop),
        ),
        Container(
          alignment: Alignment.center,
          width: errorMsgWidth,
          child: Text(
            message,
            style: Theme.of(context).textTheme.headline2
                ?.copyWith(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          margin: EdgeInsets.only(top: errorMsgMarginTop),
        ),
        buildTryAgainBtn(context)
      ],
    );
  }

  Widget buildTryAgainBtn(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: tryAgainBtnMarginTop),
        width: Dimen.mainBtnWidth,
        height: Dimen.mainBtnHeight,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shadowColor: Colors.black,
            primary: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Dimen.mainBtnBorderRadius),
                side: BorderSide(
                    width: Dimen.mainBtnBorderWidth,
                    color: Constants.JIRA_COLOR)),
          ),
          onPressed: () {
            tryAgain();
          },
          child: Center(
            child: Text(msgTryAgain,
                style: Theme.of(context)
                    .textTheme
                    .headline1
                    ?.copyWith(color: Constants.JIRA_COLOR)),
          ),
        ));
  }
}
