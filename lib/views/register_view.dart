import 'package:flutter/material.dart';
import 'package:testnotes/constants/routes.dart';
import 'package:testnotes/services/auth/auth_exceptions.dart';
import 'package:testnotes/services/auth/auth_service.dart';
import 'package:testnotes/utilities/show_error_dialog.dart';

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
        title: const Text('Register'),
      ),
      body: Column(
        children: [
          TextField(
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            controller: _email,
            decoration:
                const InputDecoration(hintText: 'Enter your email here'),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(
              hintText: 'Enter your password here',
            ),
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try {
                await AuthService.firebase().createUser(
                  email: email,
                  password: password,
                );
                // await FirebaseAuth.instance.createUserWithEmailAndPassword(
                //   email: email,
                //   password: password,
                // );
                final user = AuthService.firebase().currentUser;
                AuthService.firebase().sendEmailVerification();
                Navigator.of(context).pushNamed(
                  verifyEmailRoute,
                );
                // dev tools.log(userCredential.toString());
              } on WeakPassworddAuthException {
                showErrorDialog(
                  context,
                  'Weak password',
                );
              } on EmailAlreadyInUseAuthException {
                showErrorDialog(
                  context,
                  'Email is already in use',
                );
              } on InvalidEmailAuthException {
                showErrorDialog(
                  context,
                  'This is an invalid email address',
                );
              } on GenericAuthException {
                showErrorDialog(context, 'Failed to Register');
              }
            },
            child: const Text('Register'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                loginRoute,
                (route) => false,
              );
            },
            child: const Text('Already registered? Login here!'),
          ),
        ],
      ),
    );
  }
}

//  on FirebaseAuthException catch (e) {
              //   if (e.code == 'weak-password') {
              //     showErrorDialog(
              //       context,
              //       'Weak password',
              //     );
              //     // devtools.log('Weak password');
              //   } else if (e.code == 'email-already-in-use') {
              //     showErrorDialog(
              //       context,
              //       'Email is already in use',
              //     );
              //     // devtools.log('Email already in use');
              //   } else if (e.code == 'invalid-email') {
              //     showErrorDialog(
              //       context,
              //       'This is an invalid email address',
              //     );
              //     // devtools.log('Invalid email');
              //   } else {
              //     showErrorDialog(
              //       context,
              //       'Error: ${e.code}',
              //     );
              //   }
              // } catch (e) {
              //   //the below errorDialog is meant to catch any other error that
              //   //we did not list. So any error that is thrown and we didn't
              //   //record it, would be caught by the below catch block.
              //   await showErrorDialog(
              //     context,
              //     e.toString(),
              //   );
              // }
                  // Scaffold(
    //     appBar: AppBar(
    //       title: const Text('Register'),
    //     ),
    //     body: FutureBuilder(
    //       future: Firebase.initializeApp(
    //         options: DefaultFirebaseOptions.currentPlatform,
    //       ),
    //       builder: (context, snapshot) {
    //         switch (snapshot.connectionState) {
    //           case ConnectionState.done:
    //             return
    //           default:
    //             return const Text('Loading...');
    //         }
    //       },
    //     ));
