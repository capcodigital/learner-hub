import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/toggle-switch.dart';
import '../bloc/cloud_certification_bloc.dart';
import '../widgets/certifications_view.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const double appTitleTextSize = 18.0;
  static const double toggleButtonPaddingTop = 23.0;
  static const double toggleButtonPaddingBottom = 16.0;

  @override
  initState() {
    super.initState();
    fetchInProgressCertifications();
  }

  void fetchCompletedCertifications() {
    BlocProvider.of<CloudCertificationBloc>(context)
        .add(GetCompletedCertificationsEvent());
  }

  void fetchInProgressCertifications() {
    BlocProvider.of<CloudCertificationBloc>(context)
        .add(GetInProgressCertificationsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Cloud Certifications',
            style: TextStyle(fontSize: appTitleTextSize),
          ),
        ),
        body: Container(constraints: BoxConstraints.expand(),
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/ic_home_background.png"),
              fit: BoxFit.cover), child: buildBody(context),));
  }

  BlocProvider<CloudCertificationBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CloudCertificationBloc>(),
      ),
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(
                top: toggleButtonPaddingTop, bottom: toggleButtonPaddingBottom),
            child: ToggleButton((toggleState) {
              if (toggleState == ToggleState.COMPLETED) {
                fetchCompletedCertifications();
              } else if (toggleState == ToggleState.IN_PROGRESS) {
                fetchInProgressCertifications();
              }
            }),
          ),
          BlocBuilder<CloudCertificationBloc, CloudCertificationState>(
            builder: (context, state) {
              if (state is Loaded) {
                return Expanded(child: CartificationsView(items: state.items));
              } else if (state is Loading)
                return Text('Loading...');
              else if (state is Empty)
                return Text('No results');
              else if (state is Error)
                return Text('Error');
              else
                return Text('Unknown state');
            },
          )
        ],
      ),
    );
  }
}
