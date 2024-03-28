import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FriendRequestFirestoreServices {
  var friendRequestRef =
      FirebaseFirestore.instance.collection("friend-request");
  var userID = FirebaseAuth.instance.currentUser!.uid;

  Stream<QuerySnapshot<Map<String, dynamic>>>
      listenForReceivedFriendRequestNotification() {
    return friendRequestRef.where("receiverID", isEqualTo: userID).snapshots();
  }

  void sendFriendRequestNotification({required String receiverID}) {
    friendRequestRef.add({
      "senderID": userID,
      "receiverID": receiverID,
      "timestamp": DateTime.now().millisecondsSinceEpoch
    });
  }

  void removeFriendRequest({required String senderID}) {
    friendRequestRef
        .where("senderID", isEqualTo: senderID)
        .where("receiverID", isEqualTo: userID)
        .get()
        .then((value) {
      for (var doc in value.docs) {
        doc.reference.delete();
      }
    });
  }
}
