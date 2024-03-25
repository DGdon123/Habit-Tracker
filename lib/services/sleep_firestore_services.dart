import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:day_night_time_picker/lib/state/time.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SleepFireStoreServices {
  void addNewSleepTime(
      {required String sleepTime,
      required String wakeTime,
      required String difference}) {
    debugPrint("Sleep time: $sleepTime, Wake time: $wakeTime");

    var sleepTimeRef = FirebaseFirestore.instance.collection("sleep-time");
    var userID = FirebaseAuth.instance.currentUser!.uid;

    // Getting today's date, however it's system date
    var today = DateTime.now();
    String date =
        "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";

    sleepTimeRef.add({
      "userID": userID,
      "sleepTime": sleepTime.toString(),
      "wakeTime": wakeTime.toString(),
      "addedAt": date,
      "difference": difference,
      "timestamp": DateTime.now().millisecondsSinceEpoch
    });
  }

  // listens to today time added only
  Stream<QuerySnapshot<Map<String, dynamic>>> get listenToTodayAddedSleepTime {
    var user = FirebaseAuth.instance.currentUser;
    var today = DateTime.now();
    String date =
        "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";

    return FirebaseFirestore.instance
        .collection('sleep-time')
        .where("userID", isEqualTo: user!.uid)
        .where("addedAt", isEqualTo: date)
        .snapshots();
  }

  // returns sleep data range from start date to end date
  Stream<QuerySnapshot<Map<String, dynamic>>> getSleepDataRange(
      {required DateTime startDate, required DateTime endDate}) {
    var user = FirebaseAuth.instance.currentUser;

    return FirebaseFirestore.instance
        .collection("sleep-time")
        .where("userID", isEqualTo: user!.uid)
        .snapshots();
  }
}
