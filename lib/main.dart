import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testnotes/constants/routes.dart';
import 'package:testnotes/notes/create_update_note_view.dart';
import 'package:testnotes/services/auth/bloc/auth_bloc.dart';
import 'package:testnotes/services/auth/bloc/auth_event.dart';
import 'package:testnotes/services/auth/bloc/auth_state.dart';
import 'package:testnotes/services/auth/firebase_auth_provider.dart';
import 'package:testnotes/views/login_view.dart';
import 'package:testnotes/notes/notes_view.dart';
import 'package:testnotes/views/register_view.dart';
import 'package:testnotes/views/verify_email_view.dart';

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
      // our blocProvider code would be written within the home
      // home: const HomePage(),
      home: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(FirebaseAuthProvider()),
        child: const HomePage(),
      ),
      //below is how to use a Named route
      routes: {
        // loginRoute: (context) => const LoginView(),
        // registerRoute: (context) => const RegisterView(),
        // notesRoute: (context) => const NotesView(),
        // verifyEmailRoute: (context) => const VerifyEmailView(),
        createOrUpdateNoteRoute: (context) => const CreateUpdateNewNote()
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        // we need to handle various states that could occur
        if (state is AuthStateLoggedIn) {
          return const NotesView();
        } else if (state is AuthStateNeedsVerification) {
          return const VerifyEmailView();
        } else if (state is AuthStateLoggedOut) {
          return const LoginView();
        } else if (state is AuthStateRegistering) {
          return const RegisterView();
        } else {
          return const Scaffold(
            body: CircularProgressIndicator(),
          );
        }
      },
    );

    // return FutureBuilder(
    //   future: AuthService.firebase().initialize(),
    //   builder: (context, snapshot) {
    //     switch (snapshot.connectionState) {
    //       case ConnectionState.done:
    //         final user = AuthService.firebase().currentUser;
    //         if (user != null) {
    //           if (user.isEmailVerified) {
    //             return const NotesView();
    //           } else {
    //             return const VerifyEmailView();
    //           }
    //         } else {
    //           return const LoginView();
    //         }
    //       //to verify the user of an email address,
    //       // final user = FirebaseAuth.instance.currentUser;
    //       // if (user?.emailVerified ?? false) {
    //       //   print('You are verified.');
    //       // } else {
    //       //   return const VerifyEmailView();
    //       /* NOTE: we are not pushing verifyemailview as a screen because
    //               it's just like pushing an entire screen into the main screen
    //               since the main screen already contains a scaffold and an appbar
    //               so instead, we would only be pushing a widget or rather we
    //               would be returning a widget like we did above */
    //       //p.s the below route is an anonymous route
    //       // Navigator.of(context).push(
    //       //   MaterialPageRoute(
    //       //     builder: (context) => const VerifyEmailView(),
    //       //   ),
    //       // );
    //       // print('You need to verify your email first');
    //       // }
    //       // return const Text('Done');
    //       // return const LoginView();
    //       default:
    //         return const Center(child: CircularProgressIndicator());
    //     }
    //   },
    // );
  }
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

/// to share our data, we need use a PLUG-IN called SHARE-PLUS PLUGIN
/// A Package is extends the existing capabilities of flutter to new heights while
/// A Plug-in takes a completely new route and basically goes well beyond what flutter
/// internally can deliver. A plug-in would need to be developed by a developer or
/// set of devs specifically for each platform.
///
/// bLoc
/// bLoc allows us to separate our business logic from our presentation
/// Its a libraary created by very good ventures. Using bLoc lib internally
/// is using streams and streamControllers and futures but is like taking
/// it up a notch since it is all built into bLoc
/// The reason why we use bloc is to allow the UI to take care of only the
/// presentation of the UI and leaving the rest to a business logic "bLoc"
/// bLoc internally is a library that works with streams and streamControllers
///
/// Flutter bLoc
/// It is a set of flutter specific bLoc code that helps us with creating widgets
///
/// Different parts of bLoc library
/// 1. bLoc Class is like a container, imagine a class and every event you
/// add to the class can produce a state. SO its a class that begins with
/// a state so its output is always a state and the input are the events such as
/// 2. bLoc provider is used to provide like an instance of the bLoc class.
/// It creates a bLoc instance and provides it to you. It gives you a chance to create a child.
/// 3. bLoc listener listens to changes of a bLoc. It can react to changes in your bLoc
/// 4. bLoc builder uses bLoc state changes to provide you with a widget.
/// Inside the child you can create a bLoc builder that listens to changes inside the bloc and
/// helps to build/create new widgets based on the changes. Its like FutureBuilder or StreamBuilder
/// 5. bLoc Consumer combines bLoc listener and bLoc builder.
/// A bLoc consumer listens to changes inside a bLoc and it allows you
/// to create a side effect using bLoc listener and also create a widget to display
/// based on the changes.
///
/// Every bLoc has two important things which are a STATE and an EVENT.
/// An EVENT enters the bLoc and STATE comes out.
/// STATE describes the state of the bLoc
///
///within the build function, we have to use bLoc provider and bLoc consumer
///
/// USING BLOC AS AN EXAMPLE
///
/// A  SIMPLE INCREMENTING AND DECREMENTING CALCULATOR USING BLOC
/// 
// class HomePage extends StatefulWidget {
//   const HomePage({Key? key}) : super(key: key);

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   late final TextEditingController _controller;

//   @override
//   void initState() {
//     _controller = TextEditingController();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // bLoc provoder is a flutter_bLoc package that gets a CREATE function
//     // which accepts a context and returns a bLoc(bLoc containing both the event and state, it can be completed with vs code help)
//     // it also takes in a child which returns a widget
//     return BlocProvider(
//       create: (context) => CounterBloc(),
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('Testing bLoc'),
//         ),
//         // a bLoc consumer is the combination of a bLoc listener and bLoc builder
//         //                      |             |
//         //                     bLoc         state
//         body: BlocConsumer<CounterBloc, CounterState>(
//           listener: (context, state) {
//             _controller.clear();
//           },
//           builder: (context, state) {
//             final invalidValue =
//                 (state is CounterStateInvalidNumber) ? state.invalidNumber : '';
//             return Column(
//               children: [
//                 Text('Current value => ${state.value}'),
//                 Visibility(
//                   visible: state is CounterStateInvalidNumber,
//                   child: Text('Invalid input: $invalidValue'),
//                 ),
//                 TextField(
//                   controller: _controller,
//                   decoration:
//                       const InputDecoration(hintText: 'Enter a number here'),
//                   keyboardType: TextInputType.number,
//                 ),
//                 Row(
//                   children: [
//                     TextButton(
//                       onPressed: () {
//                         // the context.read() is function that allows us to read from bLoc
//                         context.read<CounterBloc>().add(
//                               DecrementEvent(_controller.text),
//                             );
//                       },
//                       child: const Text('-'),
//                     ),
//                     TextButton(
//                       onPressed: () {
//                         context.read<CounterBloc>().add(
//                               IncrementEvent(_controller.text),
//                             );
//                       },
//                       child: const Text('+'),
//                     ),
//                   ],
//                 )
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

// // a basic state of a bLoc
// @immutable
// abstract class CounterState {
//   final int value;
//   const CounterState(this.value);
// }

// class CounterStateValid extends CounterState {
//   const CounterStateValid(int value) : super(value);
// }

// class CounterStateInvalidNumber extends CounterState {
//   final String invalidNumber;

//   const CounterStateInvalidNumber({
//     required this.invalidNumber,
//     required int previousValue,
//   }) : super(previousValue);
// }

// @immutable
// abstract class CounterEvent {
//   final String value;
//   const CounterEvent(this.value);
// }

// class IncrementEvent extends CounterEvent {
//   const IncrementEvent(String value) : super(value);
// }

// class DecrementEvent extends CounterEvent {
//   const DecrementEvent(String value) : super(value);
// }

// // every bLoc needs an initial state and thats what you pass into the super()
// class CounterBloc extends Bloc<CounterEvent, CounterState> {
//   CounterBloc() : super(const CounterStateValid(0)) {
//     on<IncrementEvent>(
//       (event, emit) {
//         //tryParse is a int function that would try to parse a String
//         // value into an integer and if it cant, it would return null.
//         final integer = int.tryParse(event.value);
//         if (integer == null) {
//           /// basically the function below is that since we're emitting,
//           /// we are sending a state out the bLoc.
//           /// Given the integer cou;dn't be parsed as an integer then emit
//           /// CounterStateInvalidNumber
//           emit(
//             CounterStateInvalidNumber(
//               invalidNumber: event.value,
//               previousValue: state.value,
//             ),
//           );
//         } else {
//           // emit is a  function on its own that allows you to pass a state out of bLoc
//           emit(
//             CounterStateValid(state.value + integer),
//           );
//         }
//       },
//     );
//     on<DecrementEvent>(
//       (event, emit) {
//         final integer = int.tryParse(event.value);
//         if (integer == null) {
//           emit(
//             CounterStateInvalidNumber(
//               invalidNumber: event.value,
//               previousValue: state.value,
//             ),
//           );
//         } else {
//           emit(
//             CounterStateValid(state.value - integer),
//           );
//         }
//       },
//     );
//   }
// }
