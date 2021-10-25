import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '/core/colours.dart';
import '/core/constants.dart';
import '/core/layout_constants.dart';
import '/core/shared_ui/primary_button.dart';
import '/features/user_registration/domain/entities/user_registration.dart';
import '/features/user_registration/presentation/pages/bio_page.dart';
import '/features/user_registration/presentation/widgets/skill_chip.dart';

class SkillsPage extends StatefulWidget {
  const SkillsPage({Key? key, required this.navParameters}) : super(key: key);

  static const route = 'PrimarySkillsPage';
  final UserRegistration navParameters;

  @override
  _SkillsPageState createState() {
    return _SkillsPageState();
  }
}

class _SkillsPageState extends State<SkillsPage> {
  List<Skill> _skillItems = [];

  @override
  void initState() {
    super.initState();

    _skillItems = Constants.SKILLS
        .map(
            (skill) => Skill(name: skill, isPrimary: false, isSecondary: false))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    void onSkillSelected(Skill selectedSkill) {
      setState(() {
        final itemIndex = _skillItems
            .indexWhere((element) => element.name == selectedSkill.name);
        if (itemIndex > -1) {
          Skill newItem;
          if (selectedSkill.isPrimary) {
            // Move to secondary
            newItem =
                selectedSkill.copyWith(isPrimary: false, isSecondary: true);
          } else if (selectedSkill.isSecondary) {
            // Move to not-selected
            newItem =
                selectedSkill.copyWith(isPrimary: false, isSecondary: false);
          } else {
            // Move to primary
            newItem =
                selectedSkill.copyWith(isPrimary: true, isSecondary: false);
          }
          _skillItems[itemIndex] = newItem;
        } else {
          // Item not found
          print('Item $selectedSkill not found');
        }
      });
    }

    final _skillsWidgets = _skillItems
        .map((skill) => SkillChip(
              skill: skill,
              onPressed: onSkillSelected,
            ))
        .toList();

    void onNext() {
      final primarySkill = _skillItems
          .where((element) => element.isPrimary)
          .map((e) => e.name)
          .toList();
      final secondarySkills = _skillItems
          .where((element) => element.isSecondary)
          .map((e) => e.name)
          .toList();

      final navParameters = widget.navParameters
        ..primarySkills = primarySkill
        ..secondarySkills = secondarySkills;

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => UserBioPage(navParameters: navParameters)));
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
            padding: const EdgeInsets.all(LayoutConstants.LARGE_PADDING),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Your skillset',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline1),
                Padding(
                  padding: const EdgeInsets.only(
                      top: LayoutConstants.EXTRA_SMALL_PADDING,
                      bottom: LayoutConstants.LARGE_PADDING),
                  child: RichText(
                      textAlign: TextAlign.center,
                      key: const Key('subtitleText'),
                      text: TextSpan(
                          text: 'Select from the list below all of your',
                          style: Theme.of(context).textTheme.bodyText1,
                          children: const <TextSpan>[
                            TextSpan(
                                text: ' primary',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colours.ACCENT_2_COLOR)),
                            TextSpan(text: ' and'),
                            TextSpan(
                                text: ' secondary',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colours.ACCENT_3_COLOR)),
                            TextSpan(text: ' skills'),
                          ])),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Wrap(
                      spacing: LayoutConstants.EXTRA_SMALL_PADDING,
                      runSpacing: LayoutConstants.EXTRA_SMALL_PADDING / 2,
                      children: _skillsWidgets,
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: LayoutConstants.SMALL_PADDING),
                  child: PrimaryButton(
                    text: 'Next',
                    onPressed: () {
                      onNext();
                    },
                    color: Constants.ACCENT_COLOR,
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
