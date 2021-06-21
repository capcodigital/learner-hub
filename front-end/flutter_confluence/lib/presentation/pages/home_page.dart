import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/cloud_certification_bloc.dart';
import '../widgets/list_view_certif.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  initState() {
    super.initState();
    BlocProvider.of<CloudCertificationBloc>(context)
        .add(GetCompletedCertificationsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Flutter Confluence'),
        ),
        body: buildBody(context));
  }

  Widget buildBody(BuildContext context) {
    return Column(
      children: [
        BlocBuilder<CloudCertificationBloc, CloudCertificationState>(
          builder: (context, state) {
            if (state is Loaded) {
              return Expanded(child: ListViewCertif(items: state.items));
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
    );
  }
}
