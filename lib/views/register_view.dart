// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../firebase_options.dart';

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
      appBar: AppBar(
        title: const Text('My Notes'),
      ),
      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return Column(
                children: [
                  TextField(
                    keyboardType: TextInputType
                        .emailAddress, // add @ sign in main keyboard page
                    decoration: const InputDecoration(
                        labelText: 'Email',
                        hintText: 'Enter your email address'),
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
                        await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                                email: email, password: password);
                      } on FirebaseAuthException catch (e) {
                        if (e.code == "weak-password") {
                          print('Weak password');
                        } else if (e.code == 'email-already-in-use') {
                          print('email already in use');
                        }
                      } catch (e) {
                        print(e);
                     }
                    },
                    child: const Text('Sign up'),
                  ),
                ],
              );
            default:
              return const Text('Loading...');
          }
        },
      ),
    );
  }
}