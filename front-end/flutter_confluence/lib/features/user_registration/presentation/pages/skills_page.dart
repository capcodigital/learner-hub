import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '/core/colours.dart';
import '/core/constants.dart';
import '/core/dimen.dart';
import '/core/shared_ui/primary_button.dart';
import '/features/user_registration/domain/entities/user_registration_navigation_parameters.dart';
import '/features/user_registration/presentation/pages/bio_page.dart';
import '/features/user_registration/presentation/widgets/skill_chip.dart';

class SkillsPage extends StatefulWidget {
  const SkillsPage({Key? key, required this.navParameters}) : super(key: key);

  static const route = 'SkillsPage';
  final UserRegistrationNavigationParameters navParameters;

  @override
  SkillsPageState createState() {
    return SkillsPageState();
  }
}

class SkillsPageState extends State<SkillsPage> {
  @override
  Widget build(BuildContext context) {
    final _randomGenerator = Random();
    final skillItems = Constants.SKILLS.map((skill) =>
        Skill(name: skill, isPrimary: _randomGenerator.nextBool(), isSecondary: _randomGenerator.nextBool()));

    void onSkillSelected(Skill selectedSkill) {
      print('Selected ${selectedSkill.name} skill');
    }

    final skillsWidgets = skillItems
        .map((skill) => SkillChip(
              skill: skill,
              onPressed: onSkillSelected,
            ))
        .toList();

    void onNext() {
      final navParameters = widget.navParameters
        ..primarySkills = ['primaryTest']
        ..secondarySkills = ['secondaryTest'];

      Navigator.push(context, MaterialPageRoute(builder: (context) => UserBioPage(navParameters: navParameters)));
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colours.PRIMARY_COLOR,
        title: Image.asset('assets/capco_logo.png'),
      ),
      body: Container(
        color: Colours.PRIMARY_COLOR,
        child: SafeArea(
          bottom: true,
          child: Padding(
            padding: const EdgeInsets.all(Dimen.large_padding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Primary skills', textAlign: TextAlign.center, style: Theme.of(context).textTheme.headline1),
                Padding(
                  padding: const EdgeInsets.only(top: Dimen.extra_small_padding, bottom: Dimen.large_padding),
                  child: Text('Do you want to make this completed  message goes here',
                      textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyText1),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Wrap(
                      spacing: Dimen.extra_small_padding,
                      runSpacing: Dimen.extra_small_padding / 2,
                      children: skillsWidgets,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: Dimen.small_padding),
                  child: PrimaryButton(
                      text: 'Next',
                      onPressed: () {
                        onNext();
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
