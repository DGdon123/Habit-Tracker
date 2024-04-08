import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GymFirestoreServices {
  var user = FirebaseAuth.instance.currentUser;

  Future<void> upload(String inTime, String outTime) async {
    CollectionReference inRef =
        FirebaseFirestore.instance.collection('gym_in_time');
    var outRef = FirebaseFirestore.instance.collection('gym_out_time');

    await outRef.add({
      'ID': user!.uid,
      'Name': user!.displayName,
      'Time': outTime,
      'Date': DateTime.now().toString(),
    });

    await inRef.add({
      'ID': user!.uid,
      'Name': user!.displayName,
      'Time': inTime,
      'Date': DateTime.now().toString(),
    });
  }
}
