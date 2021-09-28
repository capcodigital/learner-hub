import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/core/colours.dart';
import '/core/components/app_drawer.dart';
import '/core/components/custom_appbar.dart';
import '/core/constants.dart';
import '/core/dimen.dart';
import '/core/widgets/primary_button.dart';
import '/features/certifications/presentation/pages/home_page.dart';
import '/features/login/presentation/bloc/login_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  static const route = 'LoginPage';

  @override
  LoginPageState createState() {
    return LoginPageState();
  }
}

class LoginPageState extends State<LoginPage> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    void onLogin() {
      if (_formKey.currentState!.validate()) {
        final email = emailController.text;
        final password = passwordController.text;

        BlocProvider.of<LoginBloc>(context).add(LoginRequestEvent(email: email, password: password));
      }
    }

    void navigateToHome() {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const AppDrawer(
                child: HomePage(
              appBar: CustomAppBar(
                icon: Icons.menu,
                color: Constants.JIRA_COLOR,
                text: 'Cloud Certifications',
              ),
            )),
          ));
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colours.PRIMARY_COLOR,
        title: Image.asset('assets/capco_logo.png'),
      ),
      body: BlocListener(
        bloc: BlocProvider.of<LoginBloc>(context),
        listener: (context, state) {
          if (state is LoginSuccess) {
            navigateToHome();
          }
        },
        child: SafeArea(
          bottom: true,
          child: Padding(
            padding: const EdgeInsets.all(Dimen.large_padding),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Nice title goes here',
                      textAlign: TextAlign.center, style: Theme.of(context).textTheme.headline2),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: Dimen.extra_small_padding,
                      bottom: Dimen.large_padding
                    ),
                    child: Text('Do you want to make this completed  message goes here',
                        textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyText2),
                  ),
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Email',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        // TODO(cgal-capco): Write a valid email validator
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Password',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a valid password';
                        }
                        return null;
                      }),
                  const Spacer(),
                  PrimaryButton(
                      text: 'Log in',
                      onPressed: () {
                        onLogin();
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}