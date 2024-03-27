import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserFireStoreServices {
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  Future<void> addUser(
      {required String uid,
      required String email,
      required String name,
      required String photoUrl}) async {
    final ifExists =
        await userCollection.where('email', isEqualTo: email).get();

    debugPrint(
        "ifExists: ${ifExists.docs.isNotEmpty} ${ifExists.docs} ${ifExists.docs.length}");

    // adding only when the user is not already present
    if (ifExists.docs.isNotEmpty) {
      return;
    }

    await userCollection.doc(uid).set({
      'email': email,
      'name': name,
      'photoUrl': photoUrl,
      "uid": uid,
    });
  }
}
