import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:day_night_time_picker/lib/state/time.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SleepFireStoreServices {
  void addNewSleepTime({required Time sleepTime, required Time wakeTime}) {
    debugPrint("Sleep time: $sleepTime, Wake time: $wakeTime");

    var sleepTimeRef = FirebaseFirestore.instance.collection("sleep-time");
    var userID = FirebaseAuth.instance.currentUser!.uid;

    sleepTimeRef.add({
      "userID": userID,
      "sleepTime": sleepTime.toString(),
      "wakeTime": wakeTime.toString(),
    });
  }
}
