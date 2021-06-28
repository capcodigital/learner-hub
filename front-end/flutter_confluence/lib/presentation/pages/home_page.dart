import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../injection_container.dart';
import '../widgets/toggle-switch.dart';
import '../bloc/cloud_certification_bloc.dart';
import '../widgets/certifications_view.dart';

class HomePage extends StatelessWidget {
  static const double appTitleTextSize = 18.0;
  static const double toggleButtonPaddingTop = 23.0;
  static const double toggleButtonPaddingBottom = 16.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Cloud Certifications',
            style: TextStyle(fontSize: appTitleTextSize),
          ),
        ),
        body: Container(
            constraints: BoxConstraints.expand(),
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/back-layer.png"),
                    fit: BoxFit.cover)),
            child: Stack(
              children: <Widget>[
                Positioned(
                  child: ConstrainedBox(
                    constraints: BoxConstraints.expand(),
                    child: Image.asset('assets/front-layer.png'),
                  ),
                ),
                buildBody(context)
              ],
            )));
  }

  BlocProvider<CloudCertificationBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final bloc = sl<CloudCertificationBloc>();
        bloc..add(GetInProgressCertificationsEvent());
        return bloc;
      },
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(
                top: toggleButtonPaddingTop, bottom: toggleButtonPaddingBottom),
            child: ToggleButton(),
          ),
          BlocBuilder<CloudCertificationBloc, CloudCertificationState>(
            builder: (context, state) {
              if (state is Loaded) {
                return Expanded(child: CertificationsView(items: state.items));
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
