import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:habit_tracker/services/xp_firestore_services.dart';

class GymFirestoreServices {
  var user = FirebaseAuth.instance.currentUser;

  Future<bool> upload({required Time inTime, required Time outTime}) async {
    CollectionReference gymRef =
        FirebaseFirestore.instance.collection('manual_gym_time');

    // Getting today's date, however it's system date
    var today = DateTime.now();
    String date =
        "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";

    Duration start = Duration(hours: inTime.hour, minutes: inTime.minute);

    Duration end = Duration(hours: outTime.hour, minutes: outTime.minute);

    Duration diff = end - start;
    int xpEarned = diff.inMinutes;
    try {
      gymRef.add({
        'ID': user!.uid,
        'Name': user!.displayName,
        "InTime":
            "${start.inHours.toString().padLeft(2, '0')}:${(start.inMinutes % 60).toString().padLeft(2, '0')}",
        'OutTime':
            "${end.inHours.toString().padLeft(2, '0')}:${(end.inMinutes % 60).toString().padLeft(2, '0')}",
        'Date': date,
      });
      await XpFirestoreServices()
          .addXp(xp: xpEarned, reason: 'Earned from Workout', increment: true);

      return true; // Return true if both additions are successful
    } catch (e) {
      log('Error uploading data: $e');
      return false; // Return false if there's any error
    }
  }

  // listens to today time added only
  Stream<QuerySnapshot<Map<String, dynamic>>> get listenToTodayGymTime {
    var user = FirebaseAuth.instance.currentUser;
    var today = DateTime.now();
    String date =
        "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";

    return FirebaseFirestore.instance
        .collection('manual_gym_time')
        .where("ID", isEqualTo: user!.uid)
        .where("Date", isEqualTo: date)
        .snapshots();
  }
}
