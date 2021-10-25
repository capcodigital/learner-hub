import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/core/colours.dart';
import '/core/constants.dart';
import '/core/layout_constants.dart';
import '../../../../core/shared_ui/custom_menu_page.dart';
import '/core/shared_ui/custom_appbar.dart';
import '/core/shared_ui/primary_button.dart';
import '/core/utils/error_messages.dart';
import '/core/utils/validators/email_validator.dart';
import '/features/auth/presentation/bloc/auth_bloc.dart';
import '/features/certifications/presentation/pages/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  static const route = 'LoginPage';

  @override
  LoginPageState createState() {
    return LoginPageState();
  }
}

class LoginPageState extends State<LoginPage> with CustomAlertDialog {
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

        BlocProvider.of<AuthBloc>(context)
            .add(LoginEvent(email: email, password: password));
      }
    }

    void navigateToHome() {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const CustomMenuPage(
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
        bloc: BlocProvider.of<AuthBloc>(context),
        listener: (context, state) {
          if (state is LoginSuccess) {
            navigateToHome();
          } else if (state is AuthError) {
            showAlertDialog(context, state.message);
          }
        },
        child: SafeArea(
          bottom: true,
          child: Padding(
            padding: const EdgeInsets.all(LayoutConstants.LARGE_PADDING),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Welcome back',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline2),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: LayoutConstants.EXTRA_SMALL_PADDING,
                        bottom: LayoutConstants.LARGE_PADDING),
                    child: Text('To access your account, log in below',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyText2),
                  ),
                  TextFormField(
                    controller: emailController,
                    style: Theme.of(context).textTheme.headline2,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Email',
                    ),
                    validator: (value) {
                      if (!EmailValidator.isValid(value)) {
                        return 'Please enter a valid email address';
                      }

                      return null;
                    },
                  ),
                  TextFormField(
                      controller: passwordController,
                      style: Theme.of(context).textTheme.headline2,
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
                  Expanded(
                    child: Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: PrimaryButton(
                        text: 'Log in',
                        onPressed: onLogin,
                        color: Constants.ACCENT_COLOR,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
