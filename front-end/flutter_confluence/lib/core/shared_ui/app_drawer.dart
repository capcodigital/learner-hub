import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/core/constants.dart';
import '/core/dimen.dart';
import '/core/utils/error_messages.dart';
import '/core/utils/media_util.dart';
import '/features/auth/presentation/bloc/auth_bloc.dart';
import '/features/onboarding/presentation/pages/on_boarding.dart';
import 'custom_appbar.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({Key? key, required this.child}) : super(key: key);
  final Widget child;

  static AppDrawerState? of(BuildContext context) =>
      context.findAncestorStateOfType<AppDrawerState>();

  @override
  AppDrawerState createState() => AppDrawerState();
}

class AppDrawerState extends State<AppDrawer>
    with SingleTickerProviderStateMixin, CustomAlertDialog {
  static Duration duration = const Duration(milliseconds: 300);
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: AppDrawerState.duration);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void open() => _controller.forward();

  void close() => _controller.reverse();

  void toggle() => _controller.isCompleted ? close() : open();

  void openOnBoardingPage(BuildContext context) {
    Navigator.pushReplacementNamed(context, OnBoardingPage.route);
  }

  @override
  Widget build(BuildContext context) {
    const double maxSlide = 255;
    return BlocListener(
      bloc: BlocProvider.of<AuthBloc>(context),
      listener: (context, state) {
        print('State received: ${state.runtimeType}');
        if (state is AuthLogout) {
          openOnBoardingPage(context);
        } else if (state is AuthError) {
          showAlertDialog(context, Constants.LOGOUT_ERROR);
        }
      },
      child: AnimatedBuilder(
        builder: (context, _) {
          final double animationValue = _controller.value;
          final double translateValue = animationValue * maxSlide;
          final double scaleValue = 1 - (animationValue * 0.3);
          return Stack(
            children: [
              const CustomDrawer(),
              Transform(
                  alignment: Alignment.centerLeft,
                  transform: Matrix4.identity()
                    ..translate(translateValue)
                    ..scale(scaleValue),
                  child: GestureDetector(
                    child: widget.child,
                    onTap: () {
                      if (_controller.isCompleted) {
                        close();
                      }
                    },
                  ))
            ],
          );
        },
        animation: _controller,
      ),
    );
  }
}

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        text: 'Menu',
        icon: Icons.close,
        color: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Container(
        height: getHeight(context, Dimen.scale_95_100),
        color: Colors.black,
        child: SafeArea(
          child: Theme(
            data: ThemeData(brightness: Brightness.dark),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Padding(
                    padding: EdgeInsets.only(
                        top: Dimen.dimen_48,
                        bottom: Dimen.dimen_48,
                        right: 0,
                        left: Dimen.dimen_32),
                    child: Image(
                      image: AssetImage('assets/capco_logo.png'),
                    )),
                MenuButton(
                  title: 'My Profile',
                  id: 1,
                  icon: Icons.home,
                ),
                MenuButton(
                  title: 'Code Standards',
                  id: 2,
                  icon: Icons.code,
                ),
                Expanded(
                  child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: MenuButton(
                      icon: Icons.logout,
                      id: 3,
                      title: 'Logout',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MenuButton extends StatelessWidget {
  const MenuButton({
    Key? key,
    required this.id,
    required this.title,
    required this.icon,
  }) : super(key: key);
  final String title;
  final int id;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          switch (id) {
            case 1:
              print('My Profile pressed');
              break;
            case 2:
              print('Standards pressed');
              break;
            case 3:
              BlocProvider.of<AuthBloc>(context).add(LogoutEvent());
              break;
          }
        },
        child: ListTile(
          leading: Icon(icon),
          title: Text(title),
        ),
      ),
    );
  }
}
