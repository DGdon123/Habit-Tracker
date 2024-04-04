import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class XpFirestoreServices {
  var xpRef = FirebaseFirestore.instance.collection("xp");
  var userID = FirebaseAuth.instance.currentUser!.uid;
  final userRef = FirebaseFirestore.instance.collection('users');

  Future<void> addXp(int xp) async {
    debugPrint('xp: $xp, userID: $userID');
    // updating to userRef collection
    await userRef.doc(userID).update({
      'xp': FieldValue.increment(xp),
    });

    // adding to xpRef
    await xpRef.add({
      'xp': xp,
      'userID': userID,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
