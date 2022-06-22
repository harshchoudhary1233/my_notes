// ignore_for_file: avoid_print, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:my_notes/constants/routes.dart';
import 'package:my_notes/services/auth/auth_exceptions.dart';
import 'package:my_notes/services/auth/auth_service.dart';
import '../utilities/show_error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign up')),
      body: Column(
        children: [
          TextField(
            keyboardType:
                TextInputType.emailAddress, // add @ sign in main keyboard page
            decoration: const InputDecoration(
                labelText: 'Email', hintText: 'Enter your email address'),
            controller: _email,
          ),
          TextField(
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(
                labelText: 'Password', hintText: 'Enter your password'),
            controller: _password,
          ),
          TextButton(
            onPressed: () async {
              try {
                final email = _email.text;
                final password = _password.text;
                await AuthService.firebase().createUser(
                  email: email,
                  password: password,
                );
                AuthService.firebase().sendEmailVerification();
                Navigator.of(context).pushNamed(verifyEmailRoute);
              } on WeakPasswordAuthException {
                await showErrorDialog(
                    context,
                    'Weak password',
                  );
              } on EmailAlreadyInUseAuthException {
                await showErrorDialog(
                    context,
                    'Email already in use',
                  );
              } on InvalidEmailAuthException {
                 await showErrorDialog(
                    context,
                    'This is an invalid email address',
                  );
              } on GenericAuthException {
                await showErrorDialog(
                    context,
                    'Failed to register',
                  );
              }
              
            },
            child: const Text('Sign up'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(loginRoute, (route) => false);
            },
            child: const Text('Already registered? Login here'),
          )
        ],
      ),
    );
  }
}
