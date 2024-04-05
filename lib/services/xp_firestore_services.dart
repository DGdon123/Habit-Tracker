import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class XpFirestoreServices {
  var xpRef = FirebaseFirestore.instance.collection("xp");
  var userID = FirebaseAuth.instance.currentUser!.uid;
  final userRef = FirebaseFirestore.instance.collection('users');

  Future<void> addXp({required int xp, required String reason}) async {
    debugPrint('xp: $xp, userID: $userID');
    // updating to userRef collection
    await userRef.doc(userID).update({
      'xp': FieldValue.increment(xp),
    });

    // adding to xpRef
    await xpRef.add({
      'xp': xp,
      'userID': userID,
      'timestamp': DateTime.now(),
      'reason': reason,
    });
  }

  Stream<QuerySnapshot> listenForXpAdded() {
    // seven days ago, with time being 00:00:00
    DateTime sevenDaysAgo = DateTime.now().subtract(Duration(days: 7));
    DateTime sevenDaysAgoMidnight = DateTime(
      sevenDaysAgo.year,
      sevenDaysAgo.month,
      sevenDaysAgo.day,
    );

    return xpRef
        .where('userID', isEqualTo: userID)
        .where("timestamp", isGreaterThanOrEqualTo: sevenDaysAgoMidnight)
        .snapshots();
  }
}
