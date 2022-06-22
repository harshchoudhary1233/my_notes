// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:my_notes/constants/routes.dart';
import 'package:my_notes/services/auth/auth_service.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Email verification'),
      ),
      body: Column(children: [
        const Text("We've sent you an email verification"),
        const Text("Didn't received the mail yet? Click here"),
        TextButton(
            onPressed: () async {
              AuthService.firebase().sendEmailVerification();
            },
            child: const Text('Verify here')),
        TextButton(
          onPressed: () async {
            await AuthService.firebase().logOut();
            Navigator.of(context).pushNamedAndRemoveUntil(
              registerRoute,
              (route) => false,
            );
          },
          child: const Text('Restart'),
        )
      ]),
    );
  }
}
