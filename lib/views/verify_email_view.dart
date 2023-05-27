import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testnotes/services/auth/bloc/auth_bloc.dart';
import 'package:testnotes/services/auth/bloc/auth_event.dart';

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
              // final user = AuthService.firebase().currentUser;
              //to send the email to the user, you have to call the user and
              //await user?.sendEmailVerification
              // await AuthService.firebase().sendEmailVerification();
              context.read<AuthBloc>().add(
                    const AuthEventSendEmailVerification(),
                  );
            },
            child: const Text('Send email verificatoin'),
          ),
          TextButton(
            onPressed: () async {
              context.read<AuthBloc>().add(
                    const AuthEventLogout(),
                  );
              // await FirebaseAuth.instance.signOut();
              // await AuthService.firebase().logOut();
              // Navigator.of(context).pushNamedAndRemoveUntil(
              //   registerRoute,
              //   (route) => false,
              // );
            },
            child: const Text('Restart'),
          )
        ],
      ),
    );
  }
}
