import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserFireStoreServices {
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  Future<void> addUser(
      {required String uid,
      required String email,
      required String name,
      required String dob,
      required String photoUrl,
      required double latitude,
      required double longitude}) async {
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
      'dob':dob,
      'latitude': latitude,
      'longitude': longitude,
      "uid": uid,
    });
  }

  /// searches username by username
  Future<QuerySnapshot> searchUserByUserName(String name) async {
    final startTerm = name.toLowerCase();
    final endTerm =
        '${name.toLowerCase()}\uf8ff'; // '\uf8ff' is a high surrogate character

    final response = await userCollection
        .where('name', isGreaterThanOrEqualTo: startTerm)
        .where('name', isLessThanOrEqualTo: endTerm)
        .get();

    return response;
  }
}
