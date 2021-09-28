import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/core/colours.dart';
import '/core/dimen.dart';
import '/core/utils/validators/email_validator.dart';
import '/core/widgets/primary_button.dart';
import '/features/user_registration/presentation/bloc/user_registration_bloc.dart';

class LoginDetailsPage extends StatefulWidget {
  const LoginDetailsPage({Key? key}) : super(key: key);

  static const route = 'LoginDetailsPage';

  @override
  LoginDetailsPageState createState() {
    return LoginDetailsPageState();
  }
}

class LoginDetailsPageState extends State<LoginDetailsPage> {
  @override
  Widget build(BuildContext context) {
    // Create a global key that uniquely identifies the Form widget
    // and allows validation of the form.
    //
    // Note: This is a `GlobalKey<FormState>`,
    // not a GlobalKey<MyCustomFormState>.
    final _formKey = GlobalKey<FormState>();

    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    void onDone() {
      // if (_formKey.currentState!.validate()) {
      //   final email = emailController.text;
      //   final password = passwordController.text;
      //   final confirmPassword = confirmPasswordController.text;

      BlocProvider.of<UserRegistrationBloc>(context).add(UserRegistrationRequestEvent());
      // }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colours.PRIMARY_COLOR,
        title: Image.asset('assets/capco_logo.png'),
      ),
      body: BlocListener(
        bloc: BlocProvider.of<UserRegistrationBloc>(context),
        listener: (context, state) {
          // if (state is LoginSuccess) {
          //   // navigateToHome();
          // }
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
                    padding: const EdgeInsets.only(top: Dimen.extra_small_padding, bottom: Dimen.large_padding),
                    child: Text('Do you want to make this completed  message goes here',
                        textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyText2),
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
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Password',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password canont be empty';
                        }
                        return null;
                      }),
                  TextFormField(
                      controller: confirmPasswordController,
                      style: Theme.of(context).textTheme.headline2,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Job title',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Job title cannot be empty';
                        }
                        if (value != passwordController.text) {
                          return "Passwords don't match";
                        }
                        return null;
                      }),
                  const Spacer(),
                  PrimaryButton(text: 'Next', onPressed: onDone),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
