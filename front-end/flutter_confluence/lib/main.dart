import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_confluence/core/components/custom_appbar.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/components/preloader.dart';
import 'core/constants.dart';
import 'core/themes.dart';
import 'features/certifications/data/models/cloud_certification_model.dart';
import 'features/certifications/presentation/bloc/cloud_certification_bloc.dart';
import 'features/certifications/presentation/pages/home_page.dart';
import 'features/login/presentation/bloc/login_bloc.dart';
import 'features/login/presentation/pages/login_page.dart';
import 'features/onboarding/presentation/bloc/on_boarding_bloc.dart';
import 'features/onboarding/presentation/pages/on_boarding.dart';
import 'injection_container.dart';
import 'injection_container.dart' as di;

// ignore: avoid_void_async
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(CloudCertificationModelAdapter());
  await Firebase.initializeApp();
  // Initialize Local Auth Emulator if necessary
  // await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  ThemeData buildAppTheme() {
    return Themes.appTheme;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<CloudCertificationBloc>(
            create: (_) => sl<CloudCertificationBloc>()
              ..add(GetInProgressCertificationsEvent()),
          ),
          BlocProvider<OnBoardingBloc>(
            create: (_) => sl<OnBoardingBloc>()..add(const CheckAuthEvent()),
          ),
          BlocProvider<LoginBloc>(
            create: (_) => sl<LoginBloc>(),
          )
        ],
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: buildAppTheme(),
            routes: {
              HomePage.route: (context) => const HomePage(
                    appBar: CustomAppBar(
                      icon: Icons.menu,
                      text: 'Cloud Certification',
                      color: Constants.JIRA_COLOR,
                    ),
                  ),
              OnBoardingPage.route: (context) => OnBoardingPage(),
              LoginPage.route: (context) => const LoginPage(),
            },
            home: PreLoadWidget()));
  }
}
