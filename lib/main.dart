import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_notes/views/login_view.dart';

import 'package:my_notes/views/register_view.dart';
import 'package:my_notes/views/verify_email_view.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  //final Future<FirebaseApp> _fbApp = Firebase.initializeApp();
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
      routes: {
        '/login/': (context) => LoginView(),
        '/register/': (context) => const RegisterView()
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = FirebaseAuth.instance.currentUser;
            print(user);
            if (user != null) {
              if (user.emailVerified) {
                return LoginView();
              } else {
                return const VerifyEmailView();
              }
            } else {
              return const RegisterView();
            }
            
            
          default:
            return const Center(
              child: CircularProgressIndicator(),
            );
        }
      },
    );
  }
}
