import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:testnotes/services/auth/cloud/cloud_note.dart';
import 'package:testnotes/services/auth/cloud/cloud_storage_constants.dart';
import 'package:testnotes/services/auth/cloud/cloud_storage_exceptions.dart';

class FirebaseCloudStorage {
  // below is how you talk to the firestore
  final notes = FirebaseFirestore.instance.collection('notes');

  // future function to delete notes
  Future<void> deleteNote({required String documentId}) async {
    try {
      await notes.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteNoteException();
    }
  }

  // function to update existing notes
  Future<void> updateNote({
    required String documentId,
    required String text,
  }) async {
    try {
      await notes.doc(documentId).update({textFieldName: text});
    } catch (e) {
      throw CouldNotUpdateNoteException();
    }
  }

  /// we need to expose our notes stream so that it can read all the notes for the particular user
  /// when we want to grab a stream of data as it is evolving to subscribe to all the
  /// changes, we need to use snapshot whereas 'where' is a query and get is a Future
  /// Get takes the snapshot at that particular point and then returns it but to see all the
  /// changes, we need to subscribe to the stream of datas
  Stream<Iterable<CloudNote>> allNotes({required String ownerUserId}) =>
      notes.snapshots().map(
            (event) => event.docs
                .map((doc) => CloudNote.fromSnapshot(doc))
                .where((note) => note.ownerUserId == ownerUserId),
          );

  //function to red/get notes by user ID
  Future<Iterable<CloudNote>> getNotes({required String ownerUserId}) async {
    try {
      return await notes
          .where(
            ownerUserIdFieldName,
            isEqualTo: ownerUserId,
          )
          .get()
          .then(
            (value) => value.docs.map(
              (doc) {
                return CloudNote(
                  documentId: doc.id,
                  ownerUserId: doc.data()[ownerUserIdFieldName] as String,
                  text: doc.data()[textFieldName] as String,
                );
              },
            ),
          );
    } catch (e) {
      throw CouldNotGetAllNotesException();
    }
  }

  // function to create a new note by user ID
  void createNewNote({required String ownerUserId}) async {
    await notes.add({
      ownerUserIdFieldName: ownerUserId,
      textFieldName: '',
    });
  }

  /// we need to make FirebaseCloudStorage a singleton and the code is below
  /// explaining the code below:
  /// we have a private constructor firebasecloudStorage._sharedInstance(); which then
  /// talks to the factory contructor of firebasecloudstorage to return _shared and
  /// finally goes to the static final firebasecloudStorgae which returns a _sharedInstance constructor

  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();
  FirebaseCloudStorage._sharedInstance();
  factory FirebaseCloudStorage() => _shared;
}
