import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_confluence/core/utils/media_util.dart';
import 'package:flutter_confluence/features/certifications/domain/entities/cloud_certification_type.dart';
import 'package:flutter_confluence/features/certifications/presentation/bloc/cloud_certification_bloc.dart';

import '../../../../core/constants.dart';
import '../../../../core/layout_constants.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({required this.error});
  static const route = 'ErrorPage';
  static const msgTitle = 'Oops!';
  static const msgTryAgain = 'Try Again';

  final Error error;

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
    final MediaQueriesImpl mediaQueries = MediaQueriesImpl(buildContext: context);
    return Column(
      children: [
        Image.asset(
          'assets/${Constants.IC_ERROR}',
        ),
        Center(
          child: Text(
            msgTitle,
            style:
                Theme.of(context).textTheme.headline2?.copyWith(fontSize: 24),
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          alignment: Alignment.center,
          width: mediaQueries.applyWidth(context, LayoutConstants.LARGE_SCALE),
          child: Text(
            error.message,
            style:
                Theme.of(context).textTheme.headline2?.copyWith(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          margin: EdgeInsets.only(top: mediaQueries.applyHeight(context,
              LayoutConstants.LARGE_SCALE)),
        ),
        buildTryAgainBtn(context)
      ],
    );
  }

  Widget buildTryAgainBtn(BuildContext context) {
    final MediaQueriesImpl mediaQueries = MediaQueriesImpl(buildContext: context);
    return Container(
        margin: EdgeInsets.only(top: mediaQueries.applyHeight(context,
            LayoutConstants.LARGE_SCALE)),
        width: LayoutConstants.MAIN_BTN_WIDTH,
        height: LayoutConstants.MAIN_BTN_HEIGHT,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shadowColor: Colors.black,
            primary: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(LayoutConstants.MAIN_BTN_BORDER_RADIUS),
                side: const BorderSide(
                    width: LayoutConstants.MAIN_BTN_BORDER_WIDTH,
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
