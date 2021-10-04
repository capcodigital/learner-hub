import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '/core/colours.dart';
import '/core/constants.dart';
import '/core/dimen.dart';
import '/core/shared_ui/primary_button.dart';
import '/features/user_registration/domain/entities/user_registration.dart';
import '/features/user_registration/presentation/pages/secondary_skills_page.dart';
import '/features/user_registration/presentation/widgets/skill_chip.dart';

class PrimarySkillsPage extends StatefulWidget {
  const PrimarySkillsPage({Key? key, required this.navParameters}) : super(key: key);

  static const route = 'PrimarySkillsPage';
  final UserRegistration navParameters;

  @override
  _PrimarySkillsPageState createState() {
    return _PrimarySkillsPageState();
  }
}

class _PrimarySkillsPageState extends State<PrimarySkillsPage> {
  List<Skill> _skillItems = [];

  @override
  void initState() {
    super.initState();

    _skillItems = Constants.SKILLS.map((skill) => Skill(name: skill, isPrimary: false, isSecondary: false)).toList();
  }

  @override
  Widget build(BuildContext context) {
    void onSkillSelected(Skill selectedSkill) {
      print('Selected ${selectedSkill.name} skill');
      setState(() {
        final itemIndex = _skillItems.indexWhere((element) => element.name == selectedSkill.name);
        if (itemIndex > -1) {
          final item = _skillItems[itemIndex];
          final newItem = item.copyWith(isPrimary: !item.isPrimary);
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
      final selectedSkills = _skillItems.where((element) => element.isPrimary).toList();
      final navParameters = widget.navParameters..primarySkills = selectedSkills.map((e) => e.name).toList();

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => SecondarySkillsPage(navParameters: navParameters)));
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
                    scrollDirection: Axis.horizontal,
                    child: Wrap(
                      spacing: Dimen.extra_small_padding,
                      runSpacing: Dimen.extra_small_padding / 2,
                      children: _skillsWidgets,
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
