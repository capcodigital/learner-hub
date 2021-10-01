import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '/core/colours.dart';
import '/core/dimen.dart';
import '/core/shared_ui/primary_button.dart';
import '/features/user_registration/domain/entities/user_registration_navigation_parameters.dart';
import '/features/user_registration/presentation/pages/primary_skills_page.dart';

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

        final navigationParameters =
            UserRegistrationNavigationParameters(name: name, lastName: lastName, jobTitle: jobTitle);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => PrimarySkillsPage(navParameters: navigationParameters)));
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
          padding: const EdgeInsets.all(Dimen.large_padding),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Nice title goes here', textAlign: TextAlign.center, style: Theme.of(context).textTheme.headline2),
                Padding(
                  padding: const EdgeInsets.only(top: Dimen.extra_small_padding, bottom: Dimen.large_padding),
                  child: Text('Do you want to make this completed  message goes here',
                      textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyText2),
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
