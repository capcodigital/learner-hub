import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_confluence/features/certifications/domain/entities/cloud_certification_type.dart';
import 'package:flutter_confluence/features/certifications/presentation/bloc/cloud_certification_bloc.dart';

import '../constants.dart';
import '../dimen.dart';

class ErrorPage extends StatelessWidget {
  static const route = "ErrorPage";
  static const msgTitle = "Oops!";
  static const msgDescription = "Something went wrong. Please try again.";
  static const msgTryAgain = "Try Again";
  static const errorImageMarginTop = 10.0;
  static const titleMarginTop = 30.0;
  static const errorMsgMarginTop = 60.0;
  static const errorMsgWidth = 240.0;
  static const tryAgainBtnMarginTop = 20.0;

  final Error error;

  ErrorPage({required this.error});

  void tryAgain(BuildContext context) {
    switch (error.certificationType) {
      case CloudCertificationType.completed:
        BlocProvider.of<CloudCertificationBloc>(context)
            .add(GetCompletedCertificationsEvent());
        break;
      case CloudCertificationType.in_progress:
        BlocProvider.of<CloudCertificationBloc>(context)
            .add(GetInProgressCertificationsEvent());
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
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
            style:
                Theme.of(context).textTheme.headline2?.copyWith(fontSize: 24),
            textAlign: TextAlign.center,
          ),
          margin: EdgeInsets.only(top: titleMarginTop),
        ),
        Container(
          alignment: Alignment.center,
          width: errorMsgWidth,
          child: Text(
            "th dd  fddf dfd f dfdf ddf dfdf dfdfdfd dd",
            style:
                Theme.of(context).textTheme.headline2?.copyWith(fontSize: 18),
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
            tryAgain(context);
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
