import 'package:flutter/material.dart';
import 'package:testnotes/constants/routes.dart';
import 'package:testnotes/enums/menu_action.dart';
import 'package:testnotes/main.dart';
import 'package:testnotes/services/auth/auth_service.dart';

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
                      await AuthService.firebase().logOut();
                      // await FirebaseAuth.instance.signOut(); //the signout code
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        loginRoute,
                        (_) => false,
                      );
                    }
                    // devtools.log(shouldLogout.toString());
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
