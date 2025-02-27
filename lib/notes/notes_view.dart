import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show ReadContext;
import 'package:testnotes/constants/routes.dart';
import 'package:testnotes/enums/menu_action.dart';
import 'package:testnotes/notes/note_list_view.dart';
import 'package:testnotes/services/auth/auth_service.dart';
import 'package:testnotes/services/auth/bloc/auth_bloc.dart';
import 'package:testnotes/services/auth/bloc/auth_event.dart';
import 'package:testnotes/services/auth/cloud/cloud_note.dart';
import 'package:testnotes/services/auth/cloud/firebase_cloud_storage.dart';
import 'package:testnotes/utilities/dialogs/logout_dialog.dart';

class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  // here i created an instance of the noteservice class
  //  late final NoteService _notesService;

  late final FirebaseCloudStorage _notesService;

  // to get the user email at the front of currentUser! and email! is used to forcfefully fetch the current user and it email respectfully
  // String get emailId => AuthService.firebase().currentUser!.email;
  // the ! is used to focefully get the currentUser and email of the user

  String get userId => AuthService.firebase().currentUser!.id;

  /// the reason why ensureDbIsOpen is created is before any of the functons are called
  /// the notes would actually open our db

// open the db
  @override
  void initState() {
    //     _notesService = NoteService();
    _notesService = FirebaseCloudStorage();
    // _notesService.open();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Your Notes'),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(createOrUpdateNoteRoute);
              },
              icon: const Icon(Icons.add),
            ),
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
                      // await AuthService.firebase().logOut();
                      // Navigator.of(context).pushNamedAndRemoveUntil(
                      //   loginRoute,
                      //   (_) => false,
                      // );
                      // await FirebaseAuth.instance.signOut(); //the signout code
                      context.read<AuthBloc>().add(const AuthEventLogout());
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
        body: StreamBuilder(
          // stream: _noteService.allNotes,
          stream: _notesService.allNotes(ownerUserId: userId),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.active:
                if (snapshot.hasData) {
                  final allNotes = snapshot.data as Iterable<CloudNote>;
                  // final allNotes = snapshot.data as List<DatabaseNotes>;
                  // print(allNotes);
                  // return const Text('Got all notes...');
                  return NotesListView(
                    notes: allNotes,
                    onDeleteNote: (note) async {
                      await _notesService.deleteNote(
                        documentId: note.documentId,
                      );
                      // await _notesService.deleteNote(id: note.id);
                    },
                    onTap: (notes) {
                      Navigator.of(context).pushNamed(
                        createOrUpdateNoteRoute,
                        arguments: notes,
                      );
                    },
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              // return const Text('Waiting for all notes...');
              default:
                return const CircularProgressIndicator();
            }
          },
        )
        // FutureBuilder(
        //   future: _notesService.getOrCreateUser(email: userEmail),
        //   builder: (context, snapshot) {
        //     switch (snapshot.connectionState) {
        //       case ConnectionState.done:
        //         return
        //       default:
        //         return const CircularProgressIndicator();
        //     }
        //   },
        // ),
        );
  }
// p.s don't play with closing of the database inside any of the widgets
// cause its going to interfere with the internals and how the noteService is
// supposed to work

  // close the db
  // @override
  // void dispose() {
  //   _notesService.close();
  //   super.dispose();
  // }
}
