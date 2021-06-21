import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_confluence/injection_container.dart';
import 'package:flutter_confluence/presentation/bloc/cloud_certification_bloc.dart';
import 'package:flutter_confluence/core/constants.dart';
import 'presentation/pages/home_page.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<CloudCertificationBloc>(
        create: (_) => sl<CloudCertificationBloc>(),
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: ThemeData(primaryColor: Constants.JIRA_COLOR),
            home: HomePage()));
  }
}
