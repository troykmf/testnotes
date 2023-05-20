import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:testnotes/services/auth/cloud/cloud_storage_constants.dart';
import 'package:flutter/material.dart';

/// there are 3 things that a cloud note has to contain namely:
/// 1. the Actual/Primary key
/// 2. textfield
/// 3. a userId field

@immutable
class CloudNote {
  final String documentId;
  final String ownerUserId;
  final String text;
  const CloudNote({
    required this.documentId,
    required this.ownerUserId,
    required this.text,
  });

  /// this like a constructor that we call from snaoshot and the constructor allows
  /// firestore to give us a snapshot of a cloud note and we are going to create an
  /// instance of the cloud note from it

  CloudNote.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        ownerUserId = snapshot.data()[ownerUserIdFieldName],
        text = snapshot.data()[textFieldName] as String;
}
