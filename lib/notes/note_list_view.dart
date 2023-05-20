import 'package:flutter/material.dart';
import 'package:testnotes/services/auth/cloud/cloud_note.dart';
import 'package:testnotes/utilities/dialogs/delete_dialog.dart';

// typedef NoteCallBack = void Function(DatabaseNotes notes);
typedef NoteCallBack = void Function(CloudNote notes);

class NotesListView extends StatelessWidget {
  // final List<DatabaseNotes> notes
  final Iterable<CloudNote> notes;
  final NoteCallBack onDeleteNote;
  final NoteCallBack onTap;
  const NotesListView({
    Key? key,
    required this.notes,
    required this.onDeleteNote,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        // final note = notes[index];
        final note = notes.elementAt(index);
        return ListTile(
          /// the ontap function allows me to be able to tap on the existing notes
          /// to update it as usual
          onTap: () {
            onTap(note);
          },
          title: Text(
            note.text,
            maxLines: 1,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
          // subtitle: Text(DateTime.now().toString()),
          trailing: IconButton(
            onPressed: () async {
              final shouldDelete = await showDeleteDialog(context);
              if (shouldDelete) {
                onDeleteNote(note);
              }
            },
            icon: const Icon(Icons.delete),
          ),
        );
      },
    );
  }
}
