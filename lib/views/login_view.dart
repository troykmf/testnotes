import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testnotes/services/auth/auth_exceptions.dart';
import 'package:testnotes/services/auth/bloc/auth_bloc.dart';
import 'package:testnotes/services/auth/bloc/auth_event.dart';
import 'package:testnotes/services/auth/bloc/auth_state.dart';
import 'package:testnotes/utilities/dialogs/error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;

  late final TextEditingController _password;

  // CloseDialog? _closeDialogHandle;

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
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        // if (state is AuthStateLoggedOut) {
        //   // final closeDialog = _closeDialogHandle;
        //   if (!state.isLoading && closeDialog != null) {
        //     // closeDialog();
        //     // _closeDialogHandle = null;
        //   } else if (state.isLoading && closeDialog == null) {
        //     // _closeDialogHandle = showLoadingDialog(
        //     //   context: context,
        //     //   text: 'please wait...',
        //     // );
        //   }
        if (state is AuthStateLoggedOut) {
          if (state.exception is UserNotFoundAuthException) {
            await showErrorDialog(context, 'User not found');
          } else if (state.exception is WrongPasswordAuthException) {
            await showErrorDialog(context, 'Wrong credentials');
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, 'Authntication error');
          }
        }
      },
      child: Scaffold(
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
                context.read<AuthBloc>().add(
                      AuthEventLogin(
                        email,
                        password,
                      ),
                    );
              },
              child: const Text('Login'),
            ),
            TextButton(
              onPressed: () {
                context.read<AuthBloc>().add(
                      const AuthEventShouldRegister(),
                    );
                // Navigator.of(context).pushNamedAndRemoveUntil(
                //   registerRoute,
                //   (route) => false,
                // );
              },
              child: const Text('Not registered yet? Register here!'),
            ),
          ],
        ),
      ),
    );
  }
}


// BlocListener<AuthBloc, AuthState>(
            //   listener: (context, state) async {
            //     if (state is AuthStateLoggedOut) {
            //       if (state.exception is UserNotFoundAuthException) {
            //         await showErrorDialog(
            //           context,
            //           'User not found',
            //         );
            //       } else if (state.exception is WrongPasswordAuthException) {
            //         await showErrorDialog(
            //           context,
            //           'Wrong credentials',
            //         );
            //       } else if (state.exception is GenericAuthException) {
            //         await showErrorDialog(
            //           context,
            //           'Authntication error',
            //         );
            //       }
            //     }
            //   },
            // ),
  //   try {
                  //     // await AuthService.firebase().logIn(
                  //     //   email: email,
                  //     //   password: password,
                  //     // );
                  //     // // await FirebaseAuth.instance.signInWithEmailAndPassword(
                  //     // //   email: email,
                  //     // //   password: password,
                  //     // // );
                  //     // final user = AuthService.firebase().currentUser;
                  //     // if (user?.isEmailVerified ?? false) {
                  //     //   Navigator.of(context).pushNamedAndRemoveUntil(
                  //     //     notesRoute,
                  //     //     (route) => false,
                  //     //   );
                  //     // } else {
                  //     //   Navigator.of(context).pushNamedAndRemoveUntil(
                  //     //     verifyEmailRoute,
                  //     //     (route) => false,
                  //     //   );
                  //     // }
                  //     // devtools.log(userCredential.toString());
                  //   // } on UserNotFoundAuthException {
                  //   //   await showErrorDialog(
                  //   //     context,
                  //   //     'User not found',
                  //   //   );
                  //   // } on WrongPasswordAuthException {
                  //   //   await showErrorDialog(
                  //   //     context,
                  //   //     'Wrong credentials',
                  //   //   );
                  //   // } on GenericAuthException {
                  //   //   await showErrorDialog(
                  //   //     context,
                  //   //     'Authntication error',
                  //   //   );
                  //   // }


// on FirebaseAuthException catch (e) {
            //     if (e.code == 'user-not-found') {                  
            //       // await showErrorDialog(
            //       //   context,
            //       //   'User not found',
            //       // );
            //       // devtools.log('User not found');
            //     } else if (e.code == 'wrong-password') {
            //       await showErrorDialog(
            //         context,
            //         'Wrong password',
            //       );
            //       // devtools.log('Wrong password');
            //     } else {
            //       await showErrorDialog(
            //         context,
            //         'Error: ${e.code}',
            //       );
            //     }
            //   } catch (e) {
            //     //the below errorDialog is meant to catch any other error that
            //     //we did not list. So any error that is thrown and we didn't
            //     //record it, would be caught by the below catch block.
            //     await showErrorDialog(
            //       context,
            //       e.toString(),
            //     );
            //   }
            // },

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
