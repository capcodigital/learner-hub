import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_confluence/core/utils/media_util.dart';
import 'package:flutter_confluence/features/certifications/domain/entities/cloud_certification_type.dart';
import 'package:flutter_confluence/features/certifications/presentation/bloc/cloud_certification_bloc.dart';

import '../../../../core/constants.dart';
import '../../../../core/dimen.dart';

class ErrorPage extends StatelessWidget {
  static const route = "ErrorPage";
  static const msgTitle = "Oops!";
  static const msgTryAgain = "Try Again";

  final Error error;

  ErrorPage({required this.error});

  void tryAgain(BuildContext context) {
    switch (error.cloudCertificationType) {
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
    return CustomScrollView(slivers: <Widget>[
      SliverList(
        delegate: SliverChildListDelegate(
          [Container(child: buildBody(context))],
        ),
      )
    ]);
  }

  Widget buildBody(BuildContext context) {
    return Column(
      children: [
        Container(
          child: Image.asset(
            'assets/${Constants.IC_ERROR}',
          ),
          margin: EdgeInsets.only(top: getHeight(context, 0.002)),
        ),
        Container(
          alignment: Alignment.center,
          child: Text(
            msgTitle,
            style:
                Theme.of(context).textTheme.headline2?.copyWith(fontSize: 24),
            textAlign: TextAlign.center,
          ),
          //margin: EdgeInsets.only(top: getHeight(context, 0.05)),
        ),
        Container(
          alignment: Alignment.center,
          width: getWidth(context, 0.8),
          child: Text(
            error.message,
            style:
                Theme.of(context).textTheme.headline2?.copyWith(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          margin: EdgeInsets.only(top: getHeight(context, 0.05)),
        ),
        buildTryAgainBtn(context)
      ],
    );
  }

  Widget buildTryAgainBtn(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: getHeight(context, 0.05)),
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
