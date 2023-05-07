/* So basically all the code below is just to show how to create  */

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:testnotes/services/auth/crud/crud_exceptions.dart';
import 'dart:developer' show log;

class NotesService {
  Database? _db;

  List<DatabaseNotes> _notes =
      []; // this is where our notes are going to be kept. Let's just say its our cache

// to make the NoteService class a Singleton
  static final NotesService _shared = NotesService._sharedInstance();
  NotesService._sharedInstance();
  factory NotesService() => _shared;

  final _noteStreamController =
      StreamController<List<DatabaseNotes>>.broadcast();
  // to create a streamController, you just say StreamController<> and specify the type of data that the stream
  // contain and put .broadcast ...
  // e.g final noteStreamController = StreamController<List<DatabaseNotes>>.broadcast();

  // getter for getting all notes
  Stream<List<DatabaseNotes>> get allNotes => _noteStreamController.stream;

// future functoin to make sure a user is associated to when the note service is used
  Future<DatabaseUser> getOrCreateUser({required String email}) async {
    try {
      final user = await getUser(email: email);
      return user;
    } on CouldNotFindUser {
      final createdUser = await createUser(email: email);
      return createdUser;
    } catch (e) {
      rethrow;
    }
  }

// future functon to read and cache data
  Future<void> _cacheNotes() async {
    final allNotes = await getAllNotes();
    _notes = allNotes.toList();
    _noteStreamController.add(
        _notes); // this is to update the streamController with the value of the notes
  }

  Database _getDatabaseOrThrow() {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpen();
    } else {
      return db;
    }
  }

// future function to update an existing note
  Future<DatabaseNotes> updateNote({
    required DatabaseNotes note,
    required String text,
  }) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    // the below code is to make sure the note exist
    await getNote(id: note.id);
    // the below to update the db
    final updateCount = await db.update(noteTable, {
      textColumn: text,
      isSyncedWithCloudColumn: 0,
    });

    if (updateCount == 0) {
      throw CouldNotUpdateNote();
    } else {
      final updatedNote = await getNote(id: note.id);
      _notes.removeWhere((note) => note.id == updatedNote);
      _notes.add(updatedNote);
      _noteStreamController.add(_notes);
      return updatedNote;
    }
  }

// future function to get all notes which returns a list or iterable
  Future<Iterable<DatabaseNotes>> getAllNotes() async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final notes = await db.query(noteTable);
    final results = notes.map((noteRow) => DatabaseNotes.fromRow(noteRow));
    if (notes.isEmpty) {
      throw CouldNotFindNote();
    } else {
      return results;
    }
  }

// future functoin to fetch a specific note
  Future<DatabaseNotes> getNote({required int id}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final notes = await db.query(
      noteTable,
      limit: 1,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (notes.isEmpty) {
      throw CouldNotFindNote();
    } else {
      final note = DatabaseNotes.fromRow(notes.first);
      _notes.removeWhere((note) => note.id == id);
      _notes.add(note);
      _noteStreamController.add(_notes);
      return note;
    }
  }

// future funtion which allows to delete all notes
  Future<int> deleteAllNotes() async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final numberOfDeletions = await db.delete(noteTable);
    _notes = [];
    _noteStreamController.add(_notes);
    return numberOfDeletions;
  }

// future function that allows notes to be deleted
  Future<void> deleteNote({required int id}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(
      noteTable,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (deletedCount == 0) {
      throw CouldNotDeleteNote();
    } else {
      _notes.removeWhere((note) => note.id == id);
      _noteStreamController.add(_notes);
    }
  }

// future funtion to create a note which returns the DatabaseNotes
  Future<DatabaseNotes> createNote({required DatabaseUser owner}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    //make sure the current user already exist
    final dbUser = await getUser(email: owner.email);
    // basically the above function is us reusing the getUser function to access
    // the DatabaseUser class to then get the existing user4
    // we need to check if the dbUser is actually the owner
    // make sure owner exist in the database with the correct id
    if (dbUser != owner) {
      throw CouldNotFindUser();
    }

    const text = '';
    // create the note
    final noteId = await db.insert(noteTable, {
      userIdColumn: owner.id,
      textColumn: text,
      isSyncedWithCloudColumn: 1,
    });

    final note = DatabaseNotes(
      text: text,
      isSyncedWithCloud: true,
      id: noteId,
      userId: owner.id,
    );

    _notes.add(note);
    _noteStreamController.add(_notes);

    return note;
  }

// future function to get a user account which returns the database
  Future<DatabaseUser> getUser({required String email}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    final result = await db.query(
      userTable,
      limit: 1,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    ); // .query is used to write directly to the database
    if (result.isEmpty) {
      throw CouldNotFindUser();
      // that is if the user does not already exist then throw the exception
    } else {
      return DatabaseUser.fromRow(result.first);
    }
  }

// future function to create a users acconut which returns the database
  Future<DatabaseUser> createUser({required String email}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    //
    final result = await db.query(
      userTable,
      limit: 1,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    ); // .query is used to write directly to the database
    if (result.isNotEmpty) {
      throw UserAlreadyExists();
      // that is if the user already exist then throw the exception
    }
    // after checking if the user is not available in the database, we need to
    // insert the user in the databse. We do that by telling using db.insert()
    // in which table to give us a map of keys and value which is the column name
    // and the value for that column
    final userID = await db.insert(userTable, {
      emailColumn: email.toLowerCase(),
    });
    return DatabaseUser(
      id: userID,
      email: email,
    );
  }

// future<void> functoin to delete a users account
  Future<void> deleteUser({required String email}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(
      userTable,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );
    if (deletedCount != 1) {
      throw CouldNotDeleteUser();
    }
  }

//An async function that opens the database. Start
  Future<void> open() async {
    if (_db != null) {
      throw DatabaseAlreadyOpenException();
    }
    try {
      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docsPath.path, dbName);
      final db = await openDatabase(dbPath);
      _db = db;

      // sql code for creating the user table usibg Db Browser
      await db.execute(createUserTable);

      // sql code to create notes table using Db Browser
      await db.execute(createNoteTable);

      await _cacheNotes();

      /// this means that when we open our db and it reads the createUser and
      /// createNotes function, if they didn't exist then it will cache the data into
      /// the List _notes
    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumentDirectory();
    }
  } // end

// future function to check in notes service for db opening
  Future<void> _ensureDbIsOpen() async {
    try {
      await open();
    } on DatabaseAlreadyOpenException {
      // empty
    }
  }

// An async functon to close the database
  Future<void> close() async {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpen();
    } else {
      await db.close();
      _db = null;
    }
  }

//in other to get db to actually grab the fucntion
}

@immutable
class DatabaseUser {
  final int id;
  final String email;

  const DatabaseUser({
    required this.id,
    required this.email,
  });

  /// the code below is used to instantiate the DatabaseUser from a row
  DatabaseUser.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        email = map[emailColumn] as String;

  @override
  String toString() => 'Preson, ID = $id, email = $email';

  @override
  bool operator ==(covariant DatabaseUser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class DatabaseNotes {
  final String text;
  final bool isSyncedWithCloud;
  final int id;
  final int userId;

  const DatabaseNotes({
    required this.text,
    required this.isSyncedWithCloud,
    required this.id,
    required this.userId,
  });

  DatabaseNotes.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        userId = map[userIdColumn] as int,
        text = map[textColumn] as String,
        isSyncedWithCloud =
            (map[isSyncedWithCloudColumn] as int) == 1 ? true : false;

  @override
  String toString() =>
      'Note, ID = $id, userId = $userId, isSyncedWithCloud = $isSyncedWithCloud, text = $text';

  @override
  bool operator ==(covariant DatabaseUser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

const dbName = 'notes.db';
const noteTable = 'note';
const userTable = 'user';
const idColumn = "id";
const emailColumn = "email";
const userIdColumn = 'user_id';
const textColumn = 'text';
const isSyncedWithCloudColumn = 'is_synced_with_cloud';
const createUserTable = '''
      CREATE TABLE IF NOT EXISTS  "user"  (
	    "id"	INTEGER NOT NULL,
	    "email"	TEXT NOT NULL UNIQUE,
	    PRIMARY KEY("id" AUTOINCREMENT)
);
    ''';
const createNoteTable = '''
        CREATE TABLE IF NOT EXIST "note" (
      	"id"	INTEGER NOT NULL,
	      "user_id"	INTEGER NOT NULL,
      	"text"	TEXT,
      	"is_synced_with_cloud"	INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY("user_id") REFERENCES "user"("id")
      	PRIMARY KEY("id" AUTOINCREMENT),
);
''';
