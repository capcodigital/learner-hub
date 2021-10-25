import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '/core/colours.dart';
import '/core/layout_constants.dart';
import '/core/shared_ui/primary_button.dart';
import '/features/user_registration/domain/entities/user_registration.dart';
import '/features/user_registration/presentation/pages/skills_page.dart';

class UserDetailsPage extends StatefulWidget {
  const UserDetailsPage({Key? key}) : super(key: key);

  static const route = 'UserDetailsPage';

  @override
  UserDetailsPageState createState() {
    return UserDetailsPageState();
  }
}

class UserDetailsPageState extends State<UserDetailsPage> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final lastNameController = TextEditingController();
  final jobTitleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    void onNext() {
      if (_formKey.currentState!.validate()) {
        final name = nameController.text;
        final lastName = lastNameController.text;
        final jobTitle = jobTitleController.text;

        final navigationParameters = UserRegistration(
            name: name,
            lastName: lastName,
            jobTitle: jobTitle,
            bio: null,
            email: null,
            skills: null);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    SkillsPage(navParameters: navigationParameters)));
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colours.PRIMARY_COLOR,
        title: Image.asset('assets/capco_logo.png'),
      ),
      body: SafeArea(
        bottom: true,
        child: Padding(
          padding: const EdgeInsets.all(LayoutConstants.LARGE_PADDING),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Sign up',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline2),
                Padding(
                  padding: const EdgeInsets.only(
                      top: LayoutConstants.EXTRA_SMALL_PADDING,
                      bottom: LayoutConstants.LARGE_PADDING),
                  child: Text(
                      'To get started, fill out your name and job title',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyText2),
                ),
                TextFormField(
                  controller: nameController,
                  style: Theme.of(context).textTheme.headline2,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Name cannot be empty';
                    }
                    return null;
                  },
                ),
                TextFormField(
                    controller: lastNameController,
                    style: Theme.of(context).textTheme.headline2,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Last name',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Last name cannot be empty';
                      }
                      return null;
                    }),
                TextFormField(
                    controller: jobTitleController,
                    style: Theme.of(context).textTheme.headline2,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Job title',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Job title cannot be empty';
                      }
                      return null;
                    }),
                Expanded(
                  child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: PrimaryButton(
                        text: 'Next',
                        onPressed: () {
                          onNext();
                        }),
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
