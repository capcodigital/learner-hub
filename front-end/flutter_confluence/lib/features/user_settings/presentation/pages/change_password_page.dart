import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '/core/colours.dart';

class UserSettingsPage extends StatefulWidget {
  const UserSettingsPage({Key? key}) : super(key: key);

  static const route = 'UserSettingsPage';

  @override
  UserSettingsPageState createState() {
    return UserSettingsPageState();
  }
}

class UserSettingsPageState extends State<UserSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colours.ALTERNATIVE_COLOR,
        title: Text(
          'Settings',
          style: Theme.of(context).textTheme.bodyText2,
        ),
      ),
      body: SafeArea(
        bottom: true,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Change password page',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyText2,),

            ],
          ),
        ),
      ),
    );
  }
}
