import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '/core/colours.dart';
import '/core/dimen.dart';
import '/core/shared_ui/primary_button.dart';
import '/features/user_registration/domain/entities/user_registration_navigation_parameters.dart';
import '/features/user_registration/presentation/pages/login_details_page.dart';

class UserBioPage extends StatefulWidget {
  const UserBioPage({Key? key, required this.navParameters}) : super(key: key);

  final UserRegistrationNavigationParameters navParameters;

  static const route = 'UserBioPage';

  @override
  UserBioPageState createState() {
    return UserBioPageState();
  }
}

class UserBioPageState extends State<UserBioPage> {
  @override
  Widget build(BuildContext context) {
    final bioController = TextEditingController();

    void onNext() {
      final navParameters = widget.navParameters..bio = bioController.text;

      Navigator.push(context, MaterialPageRoute(builder: (context) => LoginDetailsPage(navParameters: navParameters)));
    }

    void onSkip() {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginDetailsPage(navParameters: widget.navParameters)));
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('BIO', textAlign: TextAlign.center, style: Theme.of(context).textTheme.headline2),
              Padding(
                padding: const EdgeInsets.only(top: Dimen.extra_small_padding, bottom: Dimen.large_padding),
                child: Text('Do you want to make this completed  message goes here',
                    textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyText2),
              ),
              Expanded(
                child: TextField(
                  controller: bioController,
                  expands: true,
                  minLines: null,
                  maxLines: null,
                  style: Theme.of(context).textTheme.bodyText2,
                  decoration: const InputDecoration(border: UnderlineInputBorder(), hintText: 'Type here...'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: Dimen.small_padding, horizontal: 0),
                child: TextButton(
                    style: TextButton.styleFrom(
                        primary: Colours.ALTERNATIVE_TEXT_COLOR, textStyle: Theme.of(context).textTheme.button),
                    onPressed: onSkip,
                    child: const Text('Skip')),
              ),
              PrimaryButton(text: 'Next', onPressed: onNext),
            ],
          ),
        ),
      ),
    );
  }
}
