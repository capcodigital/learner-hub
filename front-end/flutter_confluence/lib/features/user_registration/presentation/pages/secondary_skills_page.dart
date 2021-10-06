import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '/core/colours.dart';
import '/core/constants.dart';
import '/core/layout_constants.dart';
import '/core/shared_ui/primary_button.dart';
import '/features/user_registration/domain/entities/user_registration.dart';
import '/features/user_registration/presentation/pages/bio_page.dart';
import '/features/user_registration/presentation/widgets/skill_chip.dart';

class SecondarySkillsPage extends StatefulWidget {
  const SecondarySkillsPage({Key? key, required this.navParameters}) : super(key: key);

  static const route = 'SecondarySkillsPage';
  final UserRegistration navParameters;

  @override
  SecondarySkillsPageState createState() {
    return SecondarySkillsPageState();
  }
}

class SecondarySkillsPageState extends State<SecondarySkillsPage> {
  List<Skill> _skillItems = [];

  @override
  void initState() {
    super.initState();

    final selectedPrimarySkills = widget.navParameters.primarySkills ?? [];
    _skillItems = Constants.SKILLS
        .map((skill) =>
            Skill(name: skill, isPrimary: selectedPrimarySkills.any((element) => element == skill), isSecondary: false))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    void onSkillSelected(Skill selectedSkill) {
      print('Selected ${selectedSkill.name} skill');
      setState(() {
        final itemIndex = _skillItems.indexWhere((element) => element.name == selectedSkill.name);
        if (itemIndex > -1) {
          final item = _skillItems[itemIndex];
          if (item.isPrimary) {
            print('Not allowed to update primary skills in this screen');
          } else {
            final newItem = item.copyWith(isSecondary: !item.isSecondary);
            _skillItems[itemIndex] = newItem;
          }
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
      final selectedSkills = _skillItems.where((element) => element.isSecondary).toList();
      final navParameters = widget.navParameters..secondarySkills = selectedSkills.map((e) => e.name).toList();

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
            padding: const EdgeInsets.all(LayoutConstants.LARGE_PADDING),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Your secondary skillset', textAlign: TextAlign.center, style: Theme.of(context).textTheme.headline1),
                Padding(
                  padding: const EdgeInsets.only(top: LayoutConstants.EXTRA_SMALL_PADDING, bottom: LayoutConstants.LARGE_PADDING),
                  child: Text('Select from below the technologies that you are interested in or are currently learning',
                      textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyText1),
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
                  padding: const EdgeInsets.only(top: LayoutConstants.SMALL_PADDING),
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
