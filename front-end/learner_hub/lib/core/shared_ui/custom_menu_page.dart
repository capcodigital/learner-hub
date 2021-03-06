import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learner_hub/core/shared_ui/custom_appbar.dart';

import '/core/constants.dart';
import '/core/layout_constants.dart';
import '/core/ui/tech_radar_view.dart';
import '/core/utils/error_messages.dart';
import '/core/utils/media_util.dart';
import '/features/auth/presentation/bloc/auth_bloc.dart';
import '/features/onboarding/presentation/pages/on_boarding.dart';
import '/features/user_settings/presentation/pages/user_settings_page.dart';

class CustomMenuPage extends StatefulWidget {
  const CustomMenuPage({Key? key, required this.child}) : super(key: key);
  final Widget child;

  static CustomMenuPageState? of(BuildContext context) =>
      context.findAncestorStateOfType<CustomMenuPageState>();

  @override
  CustomMenuPageState createState() => CustomMenuPageState();
}

class CustomMenuPageState extends State<CustomMenuPage>
    with SingleTickerProviderStateMixin, CustomAlertDialog {
  static Duration duration = const Duration(milliseconds: 300);
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: CustomMenuPageState.duration);
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
    final MediaQueriesImpl mediaQueries =
        MediaQueriesImpl(buildContext: context);
    return Scaffold(
      appBar: const CustomAppBar(
        text: 'Menu',
        icon: Icons.close,
        color: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Container(
        height: mediaQueries.applyHeight(
            context, LayoutConstants.EXTRA_LARGE_SCALE),
        color: Colors.black,
        child: SafeArea(
          child: Theme(
            data: ThemeData(brightness: Brightness.dark),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Padding(
                    padding: EdgeInsets.only(
                        top: LayoutConstants.APP_DRAWER_LOGO_VERTICAL_PADDING,
                        bottom:
                            LayoutConstants.APP_DRAWER_LOGO_VERTICAL_PADDING,
                        right: 0,
                        left: LayoutConstants.APP_DRAWER_LOGO_LEFT_PADDING),
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
                MenuButton(
                  title: 'My Settings',
                  id: 3,
                  icon: Icons.settings,
                ),
                Expanded(
                  child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: MenuButton(
                      icon: Icons.logout,
                      id: 4,
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
              Navigator.pushNamed(context, WebViewExample.route);
              print('Tech Radar Pressed');
              break;
            case 3:
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const UserSettingsPage(),
                      fullscreenDialog: true));
              break;
            case 4:
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
