import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
      'name': name.toLowerCase().trim(),
      'photoUrl': photoUrl,
      "uid": uid,
    });
  }

  /// searches username by username
  Future<List<QueryDocumentSnapshot>> searchUserByUserName(String name) async {
    final startTerm = name.toLowerCase();
    final endTerm =
        name.toLowerCase() + '\uf8ff'; // '\uf8ff' is a high surrogate character

    var uid = FirebaseAuth.instance.currentUser!.uid;

    debugPrint("Uid: $uid");

    final response = await userCollection
        .where('name', isGreaterThanOrEqualTo: startTerm)
        .where('name', isLessThanOrEqualTo: endTerm)
        .get();

    List<QueryDocumentSnapshot> searchResults = [];

    for (var doc in response.docs) {
      if (doc.get("uid") == uid) {
        debugPrint("Uid matched: ${doc.get("uid")} ${doc.get("name")}");
        continue;
      }
      searchResults.add(doc);
    }

    return searchResults;
  }
}
