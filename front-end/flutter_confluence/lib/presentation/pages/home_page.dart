import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_confluence/presentation/widgets/toggle_view.dart';

import '../bloc/cloud_certification_bloc.dart';
import '../widgets/certifications_view.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  initState() {
    super.initState();
    fetchCertifications();
  }

  void fetchCertifications() {
    BlocProvider.of<CloudCertificationBloc>(context)
        .add(GetCompletedCertificationsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Cloud Certifications',
            style: TextStyle(fontFamily: 'Montserrat', fontSize: 18),
          ),
        ),
        body: buildBody(context));
  }

  Widget buildBody(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(),
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/ic_home_background.png"),
              fit: BoxFit.cover)),
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(16.0),
            child: ToggleView(() {
              print("called");
              fetchCertifications();
            }),
          ),
          BlocBuilder<CloudCertificationBloc, CloudCertificationState>(
            builder: (context, state) {
              if (state is Loaded) {
                return Expanded(child: CartificationsView(items: state.items));
              } else if (state is Loading)
                return Text('Loading');
              else if (state is Empty)
                return Text('Empty');
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
