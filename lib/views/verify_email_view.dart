import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

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
          const Text(
            "We've sent you an email verification. Please open it to verify your accoun",
          ),
          const Text(
            "If you haven't received a verificatoi email yet, press the button below",
          ),
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
