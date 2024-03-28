import 'package:flutter/material.dart';
import 'package:habit_tracker/pages/profile_page/widgets/friend_request_card.dart';
import 'package:habit_tracker/services/friend_request_firestore_services.dart';

class ReceivedFriendRequest extends StatelessWidget {
  const ReceivedFriendRequest({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FriendRequestFirestoreServices()
            .listenForReceivedFriendRequestNotification(),
        builder: (_, snapshot) {
          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            var docs = snapshot.data!.docs;

            var cards = <Widget>[];

            for (var doc in docs) {
              var data = doc.data();
              cards.add(FriendRequestCard(
                senderID: data["senderID"],
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
