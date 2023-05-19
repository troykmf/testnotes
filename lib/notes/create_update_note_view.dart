import 'package:flutter/material.dart';
import 'package:testnotes/services/auth/auth_service.dart';
import 'package:testnotes/services/auth/crud/notes_service.dart';
import 'package:testnotes/utilities/generics/get_arguments.dart';

class CreateUpdateNewNote extends StatefulWidget {
  const CreateUpdateNewNote({Key? key}) : super(key: key);

  @override
  State<CreateUpdateNewNote> createState() => _CreateUpdateNewNoteState();
}

class _CreateUpdateNewNoteState extends State<CreateUpdateNewNote> {
  DatabaseNotes? _note;
  late final NotesService _noteService;
  late final TextEditingController _textController;

  @override
  void initState() {
    _noteService = NotesService();
    _textController = TextEditingController();
    super.initState();
  }

  void _textControllerListener() async {
    final note = _note;
    if (note == null) {
      return;
    }
    final text = _textController.text;
    await _noteService.updateNote(
      note: note,
      text: text,
    );
  }

  void _setupTextControllerListener() {
    _textController.removeListener(_textControllerListener);
    _textController.addListener(_textControllerListener);
  }

// the future funtion is the make sure if a note is existing, and if there isnt,
// it will create a new note
  Future<DatabaseNotes> createOrGetExistingNote(BuildContext context) async {
    // function to grab existing note if its there, from line 46 to 57
    final widgetNote = context.getArgument<DatabaseNotes>();

    if (widgetNote != null) {
      // meaning we're updating an existing note
      _note = widgetNote;
      _textController.text = widgetNote.text;
      return widgetNote;
    }

    final existingNote = _note;
    if (existingNote != null) {
      return existingNote;
    }
    final currentUser = AuthService.firebase().currentUser!;
    final email = currentUser.email!;
    final owner = await _noteService.getUser(email: email);
    final newNote = await _noteService.createNote(owner: owner);
    _note = newNote;
    return newNote;
  }

// basically the function below is for if there isn't a text in the textfield or
// if the note is empty. Therefore, if the user should in case press the back button
// without including any text, hence delete the note instead of saving an empty note.
  void _deleteNoteIfTextIsEmpty() {
    final note = _note;
    if (_textController.text.isEmpty && note != null) {
      _noteService.deleteNote(id: note.id);
    }
  }

  /// Basically the code below is to automatically save the note as long as there
  /// is a text and the note is not empty. Instead of using a save button, it saves
  /// automatically.
  void _saveNoteIfTextNotEmpty() async {
    final note = _note;
    final text = _textController.text;
    if (note != null && text.isNotEmpty) {
      await _noteService.updateNote(
        note: note,
        text: text,
      );
    }
  }

  @override
  void dispose() {
    _deleteNoteIfTextIsEmpty();
    _saveNoteIfTextNotEmpty();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Note'),
      ),
      body: FutureBuilder(
        future: createOrGetExistingNote(context),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              // _note = snapshot.data as DatabaseNotes;
              _setupTextControllerListener();
              return TextField(
                controller: _textController,
                // this would allow you to have multilines in your textfield
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: 'Start typing your note...',
                ),
              );
            default:
              const CircularProgressIndicator();
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}
