import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker/pages/profile_page/widgets/friend_request_card.dart';
import 'package:habit_tracker/services/friend_firestore_services.dart';

class ReceivedFriendRequest extends StatelessWidget {
  const ReceivedFriendRequest({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FriendFirestoreServices()
            .listenForReceivedFriendRequestNotification(),
        builder: (_, snapshot) {
          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            debugPrint(
                "Friend request received: ${snapshot.data!.docs.length}");
            var docs = snapshot.data!.docs;

            var cards = <Widget>[];

            for (var doc in docs) {
              var data = doc.data();
              cards.add(FriendRequestCard(
                token: data["token"],
                senderID: data["senderID"],
                name: data['sendername'],
              ));
            }

            return Column(
              children: [
                Text("Received Friend Request ${cards.length}"),
                ...cards
              ],
            );
          }
          return const SizedBox();
        });
  }
}
