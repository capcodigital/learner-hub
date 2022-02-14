import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_confluence/core/ui/tech_radar_view.dart';
import 'package:flutter_confluence/features/todo/data/models/todo_model.dart';
import 'package:flutter_confluence/features/todo/presentation/bloc/todo_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '/core/components/preloader.dart';
import '/core/themes.dart';
import '/features/auth/presentation/bloc/auth_bloc.dart';
import '/features/onboarding/presentation/pages/login_page.dart';
import '/features/onboarding/presentation/pages/on_boarding.dart';
import '/features/user_registration/presentation/bloc/user_registration_bloc.dart';
import '/features/user_registration/presentation/pages/user_details_page.dart';
import '/features/user_settings/presentation/bloc/user_settings_bloc.dart';
import '/injection_container.dart';
import '/injection_container.dart' as di;

// ignore: avoid_void_async
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TodoModelAdapter());
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
          BlocProvider<AuthBloc>(
            create: (_) => sl<AuthBloc>()..add(CheckAuthEvent()),
          ),
          BlocProvider<UserRegistrationBloc>(
            create: (_) => sl<UserRegistrationBloc>(),
          ),
          BlocProvider<TodoBloc>(
              create: (_) => sl<TodoBloc>()..add(GetTodosEvent())),
          BlocProvider<UserSettingsBloc>(
            create: (_) => sl<UserSettingsBloc>(),
          )
        ],
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: buildAppTheme(),
            routes: {
              OnBoardingPage.route: (context) => OnBoardingPage(),
              LoginPage.route: (context) => const LoginPage(),
              UserDetailsPage.route: (context) => const UserDetailsPage(),
              WebViewExample.route: (context) => const WebViewExample()
            },
            home: PreLoadWidget()));
  }
}
