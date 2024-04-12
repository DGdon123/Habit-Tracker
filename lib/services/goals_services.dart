import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';

class GoalServices {
  final CollectionReference goalsCollection =
      FirebaseFirestore.instance.collection('goals');

  Future<void> addNewSleepTime({
    required String sleepTime,
    required String wakeTime,
    required String difference,
  }) async {
    var userID = FirebaseAuth.instance.currentUser!.uid;

    // Getting today's date, however it's system date
    var today = DateTime.now();
    String date =
        "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";

    // Reference to the specific day sleep subcollection within the user's document
    CollectionReference sleepCollection =
        goalsCollection.doc(userID).collection('sleep');

    // Add sleep time data to the sleep subcollection under the specified day
    await sleepCollection.add({
      "userID": userID,
      "sleepTime": sleepTime.toString(),
      "wakeTime": wakeTime.toString(),
      "addedAt": date,
      "difference": difference,
      "timestamp": DateTime.now().millisecondsSinceEpoch,
    });
  }

  Future<void> addNewScreenTime({
    required int minutes,
    required int hours,
  }) async {
    var userID = FirebaseAuth.instance.currentUser!.uid;

    // Getting today's date, however it's system date
    var today = DateTime.now();
    String date =
        "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";

    // Reference to the specific day sleep subcollection within the user's document
    CollectionReference sleepCollection =
        goalsCollection.doc(userID).collection('screen');

    // Add sleep time data to the sleep subcollection under the specified day
    await sleepCollection.add({
      "userID": userID,
      "hours": hours,
      "minutes": minutes,
      "addedAt": date,
      "timestamp": DateTime.now().millisecondsSinceEpoch,
    });
  }

  Future<void> addNewFocusTime({
    required int minutes,
    required int hours,
  }) async {
    var userID = FirebaseAuth.instance.currentUser!.uid;

    // Getting today's date, however it's system date
    var today = DateTime.now();
    String date =
        "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";

    // Reference to the specific day sleep subcollection within the user's document
    CollectionReference sleepCollection =
        goalsCollection.doc(userID).collection('focustimer');

    // Add sleep time data to the sleep subcollection under the specified day
    await sleepCollection.add({
      "userID": userID,
      "hours": hours,
      "minutes": minutes,
      "addedAt": date,
      "timestamp": DateTime.now().millisecondsSinceEpoch,
    });
  }

  Future<bool> addNewGymTime({
    required Time inTime,
    required Time outTime,
  }) async {
    var userID = FirebaseAuth.instance.currentUser!.uid;

    // Getting today's date, however it's system date
    var today = DateTime.now();
    String date =
        "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";
    Duration start = Duration(hours: inTime.hour, minutes: inTime.minute);

    Duration end = Duration(hours: outTime.hour, minutes: outTime.minute);
    // Reference to the specific day sleep subcollection within the user's document
    CollectionReference sleepCollection =
        goalsCollection.doc(userID).collection('workout');
    try {
      sleepCollection.add({
        "userID": userID,
        "InTime":
            "${start.inHours.toString().padLeft(2, '0')}:${(start.inMinutes % 60).toString().padLeft(2, '0')}",
        "OutTime":
            "${end.inHours.toString().padLeft(2, '0')}:${(end.inMinutes % 60).toString().padLeft(2, '0')}",
        "addedAt": date,
        "timestamp": DateTime.now().millisecondsSinceEpoch,
        "frequency": 1
      });

      return true; // Return true if both additions are successful
    } catch (e) {
      log('Error uploading data: $e');
      return false; // Return false if there's any error
    }
    // Add sleep time data to the sleep subcollection under the specified day
  }
}
