import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learner_hub/core/shared_ui/custom_bottom_nav.dart';

import '/core/colours.dart';
import '/core/layout_constants.dart';
import '/core/shared_ui/custom_bottom_nav.dart';
import '/core/shared_ui/primary_button.dart';
import '/core/utils/error_messages.dart';
import '/core/utils/validators/email_validator.dart';
import '/features/user_registration/domain/entities/user_registration.dart';
import '/features/user_registration/presentation/bloc/user_registration_bloc.dart';
import '../../../../core/shared_ui/custom_menu_page.dart';

class LoginDetailsPage extends StatefulWidget {
  const LoginDetailsPage({Key? key, required this.navParameters})
      : super(key: key);

  static const route = 'LoginDetailsPage';
  final UserRegistration navParameters;

  @override
  LoginDetailsPageState createState() {
    return LoginDetailsPageState();
  }
}

class LoginDetailsPageState extends State<LoginDetailsPage>
    with CustomAlertDialog {
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
      if (_formKey.currentState!.validate()) {
        final registrationParameters = widget.navParameters
          ..email = emailController.text
          ..password = passwordController.text;

        BlocProvider.of<UserRegistrationBloc>(context)
            .add(RegisterUserEvent(parameters: registrationParameters));
      }
    }

    void navigateToHome() {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                const CustomMenuPage(child: CustomBottomNavBar()),
          ));
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colours.PRIMARY_COLOR,
        title: Image.asset('assets/capco_logo.png'),
      ),
      body: BlocListener(
        bloc: BlocProvider.of<UserRegistrationBloc>(context),
        listener: (context, state) {
          if (state is UserRegistrationSuccess) {
            navigateToHome();
          } else if (state is UserRegistrationError) {
            showAlertDialog(context, state.errorMessage);
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
                  Text('Almost done!',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline2),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: LayoutConstants.EXTRA_SMALL_PADDING,
                        bottom: LayoutConstants.LARGE_PADDING),
                    child: Text('To finish off, create your login credentials',
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
                          return 'Password cannot be empty';
                        }
                        return null;
                      }),
                  TextFormField(
                      controller: confirmPasswordController,
                      style: Theme.of(context).textTheme.headline2,
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Confirm password',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password cannot be empty';
                        }
                        if (value != passwordController.text) {
                          return "Passwords don't match";
                        }
                        return null;
                      }),
                  Expanded(
                      child: Align(
                          alignment: FractionalOffset.bottomCenter,
                          child: PrimaryButton(
                            text: 'Done',
                            onPressed: onDone,
                          ))),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
