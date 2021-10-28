import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/core/colours.dart';
import '/core/layout_constants.dart';
import '/core/shared_ui/primary_button.dart';
import '/core/shared_ui/secondary_button.dart';
import '/core/shared_ui/skill_chip.dart';
import '/core/utils/error_messages.dart';
import '/core/utils/extensions/string_extensions.dart';
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
  final nameController = TextEditingController();
  final lastNameController = TextEditingController();
  final jobTitleController = TextEditingController();
  final bioController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // This is the first time we load the page.
    // So we trigger the 'loadUser' event here, when the page is "loaded"
    BlocProvider.of<UserSettingsBloc>(context).add(LoadUserEvent());
  }

  @override
  Widget build(BuildContext context) {
    void onStartEdit() {
      BlocProvider.of<UserSettingsBloc>(context).add(EnableEditEvent());
    }

    void onCancelEdit() {
      BlocProvider.of<UserSettingsBloc>(context).add(CancelEditingEvent());
    }

    void onChangePassword() {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const ChangePasswordPage()));
    }

    void onSaveChanges(User currentUser) {
      final newUser = User(
          name: nameController.text,
          lastName: lastNameController.text,
          jobTitle: jobTitleController.text,
          primarySkills: currentUser.primarySkills,
          secondarySkills: currentUser.secondarySkills,
          bio: bioController.text,
          email: currentUser.email);

      BlocProvider.of<UserSettingsBloc>(context).add(SaveChangesEvent(user: newUser));
    }

    return BlocConsumer<UserSettingsBloc, UserSettingsState>(
      listener: (context, state) {
        print('NEW STATE RECEIVED: ${state.runtimeType}');

        if (state is UserSettingsState) {
          nameController.text = state.user.name;
          lastNameController.text = state.user.lastName;
          jobTitleController.text = state.user.jobTitle;
          bioController.text = state.user.bio;
        }
        if (state is UserLoadErrorState) {
          showAlertDialog(context, state.errorMessage, onDismiss: () {
            Navigator.pop(context);
          });
        }
      },
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            foregroundColor: Colours.ALTERNATIVE_TEXT_COLOR,
            backgroundColor: Colours.ALTERNATIVE_COLOR,
            actions: [
              Visibility(
                  visible: state.isEditing == false,
                  child: IconButton(icon: Image.asset('assets/ic_edit.png'), tooltip: 'Edit', onPressed: onStartEdit))
            ],
            title: Text(
              'Settings',
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ),
          body: SafeArea(
            bottom: true,
            child: Visibility(
              visible: (state is Loading) == false,
              replacement: const Center(child: CircularProgressIndicator()),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(LayoutConstants.LARGE_PADDING),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colours.ACCENT_COLOR,
                        child: Text(
                          '${state.user.name.getFirstCharacter()}${state.user.lastName.getFirstCharacter()}',
                          style: Theme.of(context).textTheme.headline1,
                        ),
                      ),
                      Container(height: LayoutConstants.LARGE_PADDING),
                      TextFormField(
                        controller: nameController,
                        readOnly: state.isEditing == false,
                        style: Theme.of(context).textTheme.headline2,
                        cursorColor: Colours.ACCENT_COLOR,
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: state.isEditing ? Colours.ACCENT_COLOR : Colors.grey),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: state.isEditing ? Colours.ACCENT_COLOR : Colors.grey),
                          ),
                        ),
                      ),
                      Container(height: LayoutConstants.SMALL_PADDING),
                      TextFormField(
                        controller: lastNameController,
                        readOnly: state.isEditing == false,
                        style: Theme.of(context).textTheme.headline2,
                        cursorColor: Colours.ACCENT_COLOR,
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: state.isEditing ? Colours.ACCENT_COLOR : Colors.grey),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: state.isEditing ? Colours.ACCENT_COLOR : Colors.grey),
                          ),
                        ),
                      ),
                      Container(height: LayoutConstants.SMALL_PADDING),
                      TextFormField(
                        controller: jobTitleController,
                        readOnly: state.isEditing == false,
                        style: Theme.of(context).textTheme.headline3,
                        cursorColor: Colours.ACCENT_COLOR,
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: state.isEditing ? Colours.ACCENT_COLOR : Colors.grey),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: state.isEditing ? Colours.ACCENT_COLOR : Colors.grey),
                          ),
                        ),
                      ),
                      Container(height: LayoutConstants.LARGE_PADDING),
                      Text(
                        'Primary Skills',
                        style: Theme.of(context).textTheme.headline3,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: LayoutConstants.SMALL_PADDING,
                        ),
                        child: Wrap(
                          children: state.user.primarySkills
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
                          children: state.user.secondarySkills
                              .map((skillName) => SkillChip(
                                    skill: Skill(name: skillName, isPrimary: false, isSecondary: true),
                                    onPressed: null,
                                  ))
                              .toList(),
                        ),
                      ),
                      const Divider(
                        // Style the divider like the underline of the input fields
                        color: Colors.grey,
                        thickness: 1,
                      ),
                      Container(height: LayoutConstants.REGULAR_PADDING),
                      Text(
                        'Bio',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline3,
                      ),
                      TextFormField(
                        controller: bioController,
                        readOnly: state.isEditing == false,
                        style: Theme.of(context).textTheme.bodyText2,
                        textAlign: TextAlign.center,
                        cursorColor: Colours.ACCENT_COLOR,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: state.isEditing ? Colours.ACCENT_COLOR : Colors.grey),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: state.isEditing ? Colours.ACCENT_COLOR : Colors.grey),
                          ),
                        ),
                      ),
                      Container(height: LayoutConstants.REGULAR_PADDING),
                      Text(state.user.email, style: Theme.of(context).textTheme.headline3),
                      const Divider(
                        height: LayoutConstants.LARGE_PADDING,
                        color: Colors.grey,
                        thickness: 1,
                      ),
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
                        isEnabled: state.canCancel,
                      ),
                      Container(height: LayoutConstants.SMALL_PADDING),
                      PrimaryButton(
                        text: 'Save',
                        onPressed: () {
                          onSaveChanges(state.user);
                        },
                        isEnabled: state.canSave,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}