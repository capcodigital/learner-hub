import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../injection_container.dart';
import '../widgets/toggle-switch.dart';
import '../bloc/cloud_certification_bloc.dart';
import '../widgets/certifications_view.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  static const double appTitleTextSize = 18.0;
  static const double togglePaddingTop = 23.0;
  static const double togglePaddingBottom = 16.0;
  static const double frontLayerLeftMargin = 40;
  static const double frontLayerInitialTop = 130;
  static const double parallaxSmoothFactor = 0.1;
  var frontLayerTop = frontLayerInitialTop;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cloud Certifications',
          style: TextStyle(fontSize: appTitleTextSize),
        ),
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return NotificationListener(
        onNotification: (notification) {
          if (notification is ScrollUpdateNotification) {
            if (notification.scrollDelta != null) {
              final delta = notification.scrollDelta!;
              setState(() {
                frontLayerTop += delta * parallaxSmoothFactor;
              });
            }
          }
          return true;
        },
        child: Container(
            constraints: BoxConstraints.expand(),
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/back-layer.png"),
                    fit: BoxFit.cover)),
            child: Stack(
              children: <Widget>[
                Positioned(
                  left: frontLayerLeftMargin,
                  top: frontLayerTop,
                  child: Image.asset('assets/front-layer.png'),
                ),
                buildBlocProvidedBody(context)
              ],
            )));
  }

  BlocProvider<CloudCertificationBloc> buildBlocProvidedBody(BuildContext context) {
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
                top: togglePaddingTop, bottom: togglePaddingBottom),
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
