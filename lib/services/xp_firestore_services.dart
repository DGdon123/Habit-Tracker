import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class XpFirestoreServices {
  CollectionReference xpRef = FirebaseFirestore.instance.collection("xp");
  var userID = FirebaseAuth.instance.currentUser!.uid;
  CollectionReference userRef = FirebaseFirestore.instance.collection('users');
  Future<void> addXp(
      {required int xp,
      required String reason,
      required bool increment}) async {
    try {
      var userID = FirebaseAuth.instance.currentUser!
          .uid; // Move userID initialization inside the function
      debugPrint('xp: $xp, userID: $userID');

      // Update userRef collection
      await userRef.doc(userID).update({
        'xp': FieldValue.increment(xp),
      });

      // Add to xpRef
      await xpRef.add({
        'xp': xp,
        'userID': userID,
        'timestamp': DateTime.now(),
        'reason': reason,
        'increment': increment
      });

      log(reason);
    } catch (error) {
      print('Error adding XP: $error');
      // Handle error accordingly
    }
  }

  Future<void> subtractXp(
      {required int xp,
      required String receiverID,
      required String reason,
      required String reason2,required bool increment2,
      required bool increment}) async {
    try {
      var userID = FirebaseAuth.instance.currentUser!
          .uid; // Move userID initialization inside the function
      debugPrint('xp: $xp, userID: $userID');

      // Update userRef collection
      await userRef.doc(userID).update({
        'xp': FieldValue.increment(-xp),
      });
      await userRef.doc(receiverID).update({
        'xp': FieldValue.increment(xp),
      });

      // Add to xpRef
      await xpRef.add({
        'xp': xp,
        'userID': userID,
        'timestamp': DateTime.now(),
        'reason': reason,
        'increment': increment
      });

      // Add to xpRef
      await xpRef.add({
        'xp': xp,
        'userID': receiverID,
        'timestamp': DateTime.now(),
        'reason': reason2,
        'increment': increment2
      });

      log(reason);
    } catch (error) {
      print('Error adding XP: $error');
      // Handle error accordingly
    }
  }

  Stream<QuerySnapshot> listenForXpAdded() {
    // seven days ago, with time being 00:00:00
    DateTime sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));
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
