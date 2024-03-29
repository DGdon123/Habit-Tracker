import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FriendFirestoreServices {
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

  void acceptFriendRequest({required String senderID}) {
    // first removing
    removeFriendRequest(senderID: senderID);

    // adding to friends collection
    FirebaseFirestore.instance.collection("friends").doc(userID).set({
      "friends": FieldValue.arrayUnion([senderID])
    }, SetOptions(merge: true));
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getDetailsOfFriend(
      {required String friendID}) {
    return FirebaseFirestore.instance.collection("users").doc(friendID).get();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getAllFriends() {
    return FirebaseFirestore.instance.collection("friends").doc(userID).get();
  }

  void removeAddedFriend({required String friendID}) {
    FirebaseFirestore.instance.collection("friends").doc(userID).update({
      "friends": FieldValue.arrayRemove([friendID])
    });
  }
}
