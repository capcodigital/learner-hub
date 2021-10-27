import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/core/colours.dart';
import '/core/layout_constants.dart';
import '/core/shared_ui/primary_button.dart';
import '/core/utils/error_messages.dart';
import '/core/utils/validators/password_validator.dart';
import '/features/user_settings/presentation/bloc/user_settings_bloc.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  static const route = 'ChangePasswordPage';

  @override
  ChangePasswordPageState createState() {
    return ChangePasswordPageState();
  }
}

class ChangePasswordPageState extends State<ChangePasswordPage> with CustomAlertDialog {
  final _formKey = GlobalKey<FormState>();

  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void onUpdatePassword() {
    if (_formKey.currentState!.validate()) {
      final password = newPasswordController.text;

      BlocProvider.of<UserSettingsBloc>(context).add(UpdatePasswordEvent(newPassword: password));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colours.PRIMARY_COLOR,
        title: Image.asset('assets/capco_logo.png'),
      ),
      body: BlocListener(
        bloc: BlocProvider.of<UserSettingsBloc>(context),
        listener: (context, state) {
          print('New State received: ${state.runtimeType}');
          if (state is PasswordUpdateSuccess) {
            // Navigate back
            Navigator.pop(context);
          } else if (state is PasswordUpdateError) {
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
                  Text('Change your password',
                      textAlign: TextAlign.center, style: Theme.of(context).textTheme.headline2),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: LayoutConstants.EXTRA_SMALL_PADDING, bottom: LayoutConstants.LARGE_PADDING),
                    child: Text('To change your password, use the form below.',
                        textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyText2),
                  ),
                  TextFormField(
                    controller: currentPasswordController,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    style: Theme.of(context).textTheme.headline2,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Current password',
                    ),
                    validator: (value) {
                      if (!PasswordValidator.isValid(value)) {
                        return 'Password has to be at least 6 characters';
                      }

                      return null;
                    },
                  ),
                  TextFormField(
                      controller: newPasswordController,
                      style: Theme.of(context).textTheme.headline2,
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'New password',
                      ),
                      validator: (value) {
                        if (!PasswordValidator.isValid(value)) {
                          return 'Password has to be at least 6 characters';
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
                          return 'This cannot be empty';
                        }
                        if (value != newPasswordController.text) {
                          return "Passwords don't match";
                        }
                        return null;
                      }),
                  Expanded(
                      child: Align(
                          alignment: FractionalOffset.bottomCenter,
                          child: PrimaryButton(text: 'Update Password', onPressed: onUpdatePassword))),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
