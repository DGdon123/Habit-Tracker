import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GymFirestoreServices {
  var user = FirebaseAuth.instance.currentUser;

  Future<bool> upload(String inTime, String outTime) async {
    CollectionReference inRef =
        FirebaseFirestore.instance.collection('gym_in_time');
    CollectionReference outRef =
        FirebaseFirestore.instance.collection('gym_out_time');

    try {
      await Future.wait([
        outRef.add({
          'ID': user!.uid,
          'Name': user!.displayName,
          'Time': outTime,
          'Date': DateTime.now().toString(),
        }),
        inRef.add({
          'ID': user!.uid,
          'Name': user!.displayName,
          'Time': inTime,
          'Date': DateTime.now().toString(),
        }),
      ]);

      return true; // Return true if both additions are successful
    } catch (e) {
      log('Error uploading data: $e');
      return false; // Return false if there's any error
    }
  }
}
