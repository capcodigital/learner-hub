import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_confluence/domain/entities/certification.dart';
import 'package:flutter_confluence/domain/usecases/get_cloud_certifications.dart';
import '../bloc/cloud_certification_bloc.dart';
import '../../injection_container.dart';
import '../widgets/list_view_certif.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Flutter Confluence'),
        ),
        body: buildBody(context));
  }

  BlocProvider<CloudCertificationBloc> buildBody(BuildContext context) {
    return BlocProvider(
        create: (_) => sl<CloudCertificationBloc>(),
        child: Column(
          children: [
            BlocBuilder<CloudCertificationBloc, CloudCertificationState>(
              builder: (context, state) {
                if (state is Loaded)
                  return ListViewCertif(items: state.items);
                else if (state is Loading)
                  return Text('Loading');
                else if (state is Empty)
                  return Text('Empty');
                else if (state is Error) return Text('Error');
                return Text('Unknown state');
              },
            )
          ],
        ));
  }
}
