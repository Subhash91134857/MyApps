import 'package:app2/views/login-view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:app2/views/register-view.dart';

import 'firebase_options.dart';

void main() {
//  Widget binding to intiallise the firebase before the app start
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Collage App',
      home: HomePage(),
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("HOME ")),
      body: FutureBuilder(
          future:
              // firebase intiallization
              Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform,
          ),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                final user = FirebaseAuth.instance.currentUser;
                final emailVerified = user?.emailVerified ?? false;
                print(emailVerified);
                if (emailVerified) {
                  return const Text("Done");
                } else {
                  // Future.delayed(Duration.zero, () {
                  //   Navigator.of(context).push(MaterialPageRoute(
                  //       builder: (context) => const VerifyEmailView()));
                  // });
                  return const LoginView();
                }
              default:
                return const Text("Loading.........");
            }
          }),
    );
  }
}

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Please verify your email address:"),
        TextButton(
            onPressed: () async {
              final user = FirebaseAuth.instance.currentUser;
              // print(user?.email);
              final userVerificationLink = await user?.sendEmailVerification();
            },
            child: const Text("Send email verification link"))
      ],
    );
  }
}
