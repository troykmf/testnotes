import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
        title: const Text('Verify Email'),
      ),
      body: Column(
        children: [
          const Text('Please verify your email'),
          TextButton(
            onPressed: () async {
              //this is to get the current use of the mail
              final user = FirebaseAuth.instance.currentUser;
              //to send the email to the user, you have to call the user and
              //await user?.sendEmailVerification
              await user?.sendEmailVerification();
            },
            child: const Text('Send email verificatoin'),
          )
        ],
      ),
    );
  }
}
