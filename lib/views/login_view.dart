import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:testnotes/constants/routes.dart';
import 'package:testnotes/firebase_options.dart';
import 'package:testnotes/utilities/show_error_dialog.dart';
import 'package:testnotes/views/register_view.dart';
import 'dart:developer' as devtools show log;

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
        title: const Text('Login'),
      ),
      body: Column(
        children: [
          TextField(
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            keyboardAppearance: Brightness.dark,
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
                final userCredential =
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: email,
                  password: password,
                );
                Navigator.of(context).pushNamedAndRemoveUntil(
                  notesRoute,
                  (route) => false,
                );
                // devtools.log(userCredential.toString());
              } on FirebaseAuthException catch (e) {
                if (e.code == 'user-not-found') {
                  await showErrorDialog(
                    context,
                    'User not found',
                  );
                  // devtools.log('User not found');
                } else if (e.code == 'wrong-password') {
                  await showErrorDialog(
                    context,
                    'Wrong password',
                  );
                  // devtools.log('Wrong password');
                } else {
                  await showErrorDialog(
                    context,
                    'Error: ${e.code}',
                  );
                }
              } catch (e) {
                //the below errorDialog is meant to catch any other error that
                //we did not list. So any error that is thrown and we didn't
                //record it, would be caught by the below catch block.
                await showErrorDialog(
                  context,
                  e.toString(),
                );
              }
            },
            child: const Text('Login'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                registerRoute,
                (route) => false,
              );
            },
            child: const Text('Not registered yet? Register here!'),
          ),
        ],
      ),
    );
  }
}

// Scaffold(
//     appBar: AppBar(
//       title: const Text('Login'),
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
//this code is for creating a va;id account using firebase
// final userCredential = await FirebaseAuth.instance
//     .createUserWithEmailAndPassword(
//   email: email,
//   password: password,
// );

///this code is for sigining in an already existing user
///final userCredential = await FirebaseAuth.instance
///                                 .signInWithEmailandPassword(
///                               email: email,
///                               password: password,
///                               );

///There are various kinds of exception you can come across when working with firebase
///Error on Signing In a User
/// 1. Handling

///on FirebaseAuthException catch(e) {
/// print(e.code);
/// if (e.code == User-not-found){
/// print('user not found);
/// }
///}
// catch (e) {
//   print('something bad happened');
//   print(e.runtimeType);
//   print(e);
// }
