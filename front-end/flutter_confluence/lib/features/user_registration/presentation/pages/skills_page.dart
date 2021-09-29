import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_confluence/core/shared_ui/primary_button.dart';

import '/core/colours.dart';
import '/core/dimen.dart';
import '/features/user_registration/domain/entities/user_registration_navigation_parameters.dart';
import '/features/user_registration/presentation/pages/bio_page.dart';

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
    final skills = [
      'React Native',
      'Gradle',
      'Swift',
      'Kotlin',
      'Java',
      'Ionic',
      'Flutter',
      'React',
      'Angular',
      'Vue',
      'Typescript',
      'Node',
      'Go',
      'Python',
      'Scala',
      'Groovy',
      'Postgress',
      'Neo4J',
      'MongoDB',
      'SQL Server',
      'MySQL',
      'Oracle',
      'BigQuery',
      'Liquibase',
      'Snowflake',
      'Rest',
      'Camel',
      'gRPC',
      'Kafka',
      'ActiveM',
      'IBM MQ',
      'GraphQL',
      'GCP',
      'AWS',
      'Azure',
      'Digital Ocean',
      'Grafana',
      'Kubernetes',
      'Serverless',
      'OpenShift',
      'PCF',
      'PKS',
      'Selenium',
      'Cucumber',
      'Appium',
      'Rest-assured',
      'BrowserStack',
      'Sauce Labs',
      'WireMock',
      'Applitools',
      'JMeter',
      'Axe',
      'Cypress',
      'Gatling',
      'PACT contract testing',
      'GitHub',
      'CircleCI',
      'Terraform',
      'Vault',
      'SonarQube',
      'Elastic',
      'Bitbucket',
      'Jenkins',
      'TeamCity',
      'Istio',
      'Ansible',
      'Packer',
      'Twistlock',
      'Kiali',
      'ConcourseCl',
      'Consul',
    ];

    final skillsWidgets =
        skills.map((skill) => Chip(label: Text(skill))).toList();

    void onNext() {
      final navParameters = widget.navParameters
        ..primarySkills = ['primaryTest']
        ..secondarySkills = ['secondaryTest'];

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
            padding: const EdgeInsets.all(Dimen.large_padding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Primary skills',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline1),
                Padding(
                  padding: const EdgeInsets.only(
                      top: Dimen.extra_small_padding,
                      bottom: Dimen.large_padding),
                  child: Text(
                      'Do you want to make this completed  message goes here',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyText1),
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
