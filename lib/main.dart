import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:testnotes/constants/routes.dart';
import 'package:testnotes/views/login_view.dart';
import 'package:testnotes/views/register_view.dart';
import 'package:testnotes/views/verify_email_view.dart';
import 'firebase_options.dart';
import 'dart:developer' as devtools show log;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
      //below is how to use a Named route
      routes: {
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        notesRoute: (context) => const NotesView(),
        verifyEmailRoute: (context) => const VerifyEmailView()
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
            if (user != null) {
              if (user.emailVerified) {
                return const NotesView();
              } else {
                return const VerifyEmailView();
              }
            } else {
              return const LoginView();
            }

          //to verify the user of an email address,
          // final user = FirebaseAuth.instance.currentUser;
          // if (user?.emailVerified ?? false) {
          //   print('You are verified.');
          // } else {
          //   return const VerifyEmailView();
          /* NOTE: we are not pushing verifyemailview as a screen because
                  it's just like pushing an entire screen into the main screen
                  since the main screen already contains a scaffold and an appbar 
                  so instead, we would only be pushing a widget or rather we 
                  would be returning a widget like we did above */
          //p.s the below route is an anonymous route
          // Navigator.of(context).push(
          //   MaterialPageRoute(
          //     builder: (context) => const VerifyEmailView(),
          //   ),
          // );
          // print('You need to verify your email first');
          // }
          // return const Text('Done');
          // return const LoginView();
          default:
            return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

enum MenuAction { logout }

class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Main UI'),
          actions: [
            PopupMenuButton<MenuAction>(
              onSelected: (value) async {
                // devtools.log(value.toString());
                switch (value) {
                  case MenuAction.logout:
                    // the below code is to get the value of the options on the alert dialog
                    final shouldLogout = await showLogOutDialog(context);
                    //the below code simply means that if the user shouldLogout then log the
                    //person out and take him out of the home page
                    if (shouldLogout) {
                      await FirebaseAuth.instance.signOut(); //the signout code
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        loginRoute,
                        (_) => false,
                      );
                    }
                    devtools.log(shouldLogout.toString());
                    break;
                }
              },
              itemBuilder: (context) {
                return const [
                  PopupMenuItem<MenuAction>(
                    value: MenuAction
                        .logout, // value is what the programmmer sees and
                    child: Text('Log out'), // child is what the users will see
                  ),
                ];
              },
            )
          ],
        ),
        body: const Text('Hello world'));
  }
}

/* this is a function to create a popUpMenu that shows an alert dialog when 
pressed that returns a bool cause a dialog basically returns a true or false value */
Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Log out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text('Log out'),
          )
        ],
      );
    },
    /*what this last line means is that if a user doesnt press any action or 
    pressed something else that is not a true or false value declared, it should
    either return the value selected or false that is it should dismiss the dialog*/
  ).then((value) => value ?? false);
}

// class HomePage extends StatefulWidget {
//   const HomePage({Key? key, required this.title}) : super(key: key);
//   final String title;

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   int _counter = 0;

//   void _incrementCounter() {
//     setState(() {
//       _counter++;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text(
//               'You have pushed the button this many times:',
//             ),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headline4,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
//}
