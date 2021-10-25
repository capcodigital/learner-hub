import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/core/colours.dart';
import '/core/layout_constants.dart';
import '/core/shared_ui/primary_button.dart';
import '/core/shared_ui/secondary_button.dart';
import '/core/shared_ui/skill_chip.dart';
import '/core/utils/error_messages.dart';
import '/features/user_settings/domain/entities/user.dart';
import '/features/user_settings/presentation/bloc/user_settings_bloc.dart';
import 'change_password_page.dart';

class UserSettingsPage extends StatefulWidget {
  const UserSettingsPage({Key? key}) : super(key: key);

  static const route = 'UserSettingsPage';

  @override
  UserSettingsPageState createState() {
    return UserSettingsPageState();
  }
}

class UserSettingsPageState extends State<UserSettingsPage> with CustomAlertDialog {

  @override
  Widget build(BuildContext context) {
    final primarySkill = ['React Native', 'Node', 'Flutter', 'Go', 'Gradle'];
    final secondarySkill = ['Swift', 'Angular', 'Python', 'Scala'];

    void onEditPhoto() {
      BlocProvider.of<UserSettingsBloc>(context).add(EditPhotoEvent());
    }

    void onStartEdit() {
      BlocProvider.of<UserSettingsBloc>(context).add(EnableEditEvent());
    }

    void onCancelEdit() {
      BlocProvider.of<UserSettingsBloc>(context).add(CancelEditingEvent());
    }

    void onChangePassword() {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const ChangePasswordPage()));
    }

    void onSaveChanges() {
      // TODO(cgal-capco): Get the actual values
      const user = User(
          name: 'name',
          lastName: 'lastName',
          jobTitle: 'jobTitle',
          primarySkills: [],
          secondarySkills: [],
          bio: 'bio',
          email: 'email');
      BlocProvider.of<UserSettingsBloc>(context).add(const SaveChangesEvent(user: user));
    }

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colours.ALTERNATIVE_TEXT_COLOR,
        backgroundColor: Colours.ALTERNATIVE_COLOR,
        actions: [IconButton(icon: Image.asset('assets/ic_edit.png'), tooltip: 'Edit', onPressed: onStartEdit)],
        title: Text(
          'Settings',
          style: Theme.of(context).textTheme.bodyText2,
        ),
      ),
      body: BlocListener(
        bloc: BlocProvider.of<UserSettingsBloc>(context),
        listener: (context, state) {
          print('NEW STATE RECEIVED: ${state.runtimeType}');
        },
        child: SafeArea(
          bottom: true,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(LayoutConstants.LARGE_PADDING),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage('https://i.pravatar.cc/100'),
                  ),
                  Container(height: LayoutConstants.REGULAR_PADDING),
                  TextButton(
                    onPressed: onEditPhoto,
                    child: Text(
                      'Edit Photo',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ),
                  Container(height: LayoutConstants.LARGE_PADDING),
                  Text(
                    'Hanna',
                    style: Theme.of(context).textTheme.headline2,
                  ),
                  const Divider(height: LayoutConstants.LARGE_PADDING),
                  Text(
                    'Calzon',
                    style: Theme.of(context).textTheme.headline2,
                  ),
                  const Divider(height: LayoutConstants.LARGE_PADDING),
                  Text(
                    'Java Developer',
                    style: Theme.of(context).textTheme.headline3,
                  ),
                  Container(height: LayoutConstants.EXTRA_LARGE_PADDING),
                  Text(
                    'Primary Skills',
                    style: Theme.of(context).textTheme.headline3,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: LayoutConstants.SMALL_PADDING,
                    ),
                    child: Wrap(
                      children: primarySkill
                          .map((skillName) => SkillChip(
                                skill: Skill(name: skillName, isPrimary: true, isSecondary: false),
                                onPressed: null,
                              ))
                          .toList(),
                    ),
                  ),
                  Container(height: LayoutConstants.REGULAR_PADDING),
                  Text(
                    'Secondary Skills',
                    style: Theme.of(context).textTheme.headline3,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: LayoutConstants.SMALL_PADDING,
                      bottom: LayoutConstants.REGULAR_PADDING,
                    ),
                    child: Wrap(
                      children: secondarySkill
                          .map((skillName) => SkillChip(
                                skill: Skill(name: skillName, isPrimary: false, isSecondary: true),
                                onPressed: null,
                              ))
                          .toList(),
                    ),
                  ),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.all(LayoutConstants.REGULAR_PADDING),
                    child: Text(
                      'Bio',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline3,
                    ),
                  ),
                  Text(
                      'Cras facilisis, dui nec aliquam porttitor, sem dolor pharetra tellus, at finibus mi mauris ac elit. Fusce eget tincidunt ante. Etiam id porttitor eros. Vivamus eget placerat est, ac aliquet dolor. Praesent tristique condimentum rhoncus. Proin at lacus ac lectus porta congue. Quisque nec orci nec arcu tempus elementum. Suspendisse efficitur ut lorem eget porta. Etiam ut ornare lacus. Etiam mattis tellus nisi, sit amet sagittis est placerat ac.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyText2),
                  const Divider(height: LayoutConstants.LARGE_PADDING),
                  Text('hanna@capco.com', style: Theme.of(context).textTheme.headline3),
                  const Divider(height: LayoutConstants.LARGE_PADDING),
                  GestureDetector(
                    onTap: onChangePassword,
                    child: Row(
                      children: [
                        Text('Change password', style: Theme.of(context).textTheme.headline3),
                        const Expanded(
                          child: Align(
                              alignment: Alignment.centerRight,
                              child: Icon(
                                Icons.arrow_forward_ios,
                                color: Colours.ALTERNATIVE_TEXT_COLOR,
                                semanticLabel: 'Change password',
                              )),
                        )
                      ],
                    ),
                  ),
                  Container(height: LayoutConstants.EXTRA_LARGE_PADDING),
                  SecondaryButton(
                    text: 'Cancel',
                    onPressed: onCancelEdit,
                    isEnabled: false,
                  ),
                  Container(height: LayoutConstants.SMALL_PADDING),
                  PrimaryButton(
                    text: 'Save',
                    onPressed: onSaveChanges,
                    isEnabled: false,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
