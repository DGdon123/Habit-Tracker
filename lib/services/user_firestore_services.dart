import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class UserFireStoreServices {
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  Future<void> addUser(
      {required String uid,
      required String email,
      required String devicetoken,
      required String name,
      required String photoUrl,
      required double latitude,
      required int sleep,
      required int screen,
      required int focus,
      required int workout,
      required double longitude,required bool hello}) async {
    final ifExists =
        await userCollection.where('email', isEqualTo: email).get();

    debugPrint(
        "ifExists: ${ifExists.docs.isNotEmpty} ${ifExists.docs} ${ifExists.docs.length}");

    // adding only when the user is not already present
    if (ifExists.docs.isNotEmpty) {
      return;
    }

    debugPrint("Adding info to db: $email $uid");

    await userCollection.doc(uid).set({
      'email': email,
      'name': name.trim(),
      'searchKey': name.toLowerCase().trim(),
      'photoUrl': photoUrl,
      'device_token': devicetoken,
      'latitude': latitude,
      'sleepGoals': sleep,
      'screenTime': screen,
      'focusTime': focus,
      'workoutFrequency': workout,
      'longitude': longitude,
      "uid": uid,
      "xp": 0,
      "isAutomatic":hello
    });
  }

  Future<void> manualaddUser({
    required String uid,
    required String email,
    required String devicetoken,
    required String name,
    required String photoUrl,
    required int sleep,
    required int screen,
    required int focus,
    required int workout,
  }) async {
    final ifExists =
        await userCollection.where('email', isEqualTo: email).get();

    debugPrint(
        "ifExists: ${ifExists.docs.isNotEmpty} ${ifExists.docs} ${ifExists.docs.length}");

    // adding only when the user is not already present
    if (ifExists.docs.isNotEmpty) {
      return;
    }

    debugPrint("Adding info to db: $email $uid");

    await userCollection.doc(uid).set({
      'email': email,
      'name': name,
      'photoUrl': photoUrl,
      'device_token': devicetoken,
      'sleepGoals': sleep,
      'screenTime': screen,
      'focusTime': focus,
      'workoutFrequency': workout,
      "uid": uid,
      "xp": 0
    });
  }

   /// searches by uid
  Future<QueryDocumentSnapshot> searchUserByUid(String uid) async {
    final response = await userCollection.where('uid', isEqualTo: uid).get();

    return response.docs.first;
  }

  /// searches username by username
  Future<List<QueryDocumentSnapshot>> searchUserByUserName(String name) async {
    final startTerm = name.toLowerCase();
    final endTerm =
        '${name.toLowerCase()}\uf8ff'; // '\uf8ff' is a high surrogate character

    var uid = FirebaseAuth.instance.currentUser!.uid;

    debugPrint("Uid: $uid");

    final response = await userCollection
        .where('searchKey', isGreaterThanOrEqualTo: startTerm)
        .where('searchKey', isLessThanOrEqualTo: endTerm)
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

  /// Check if the user is already present in the database
  Future<bool> checkIfUserExists(String email) async {
    final response =
        await userCollection.where('email', isEqualTo: email).get();

    return response.docs.isNotEmpty;
  }
}
