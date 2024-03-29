import 'package:flutter/material.dart';
import 'package:habit_tracker/services/friend_firestore_services.dart';
import 'package:habit_tracker/services/user_firestore_services.dart';

class FriendRequestCard extends StatelessWidget {
  final String senderID;

  const FriendRequestCard({super.key, required this.senderID});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: FutureBuilder(
          future: UserFireStoreServices().searchUserByUid(senderID),
          builder: (_, snapshot) {
            debugPrint("Snapshot: ${snapshot.data?.data()}");
            if (snapshot.hasData) {
              var data = snapshot.data!.data() as Map<String, dynamic>;
              return ListTile(
                  leading: data["photoUrl"].isEmpty
                      ? CircleAvatar(
                          child: Text(data['name'][0]),
                        )
                      : CircleAvatar(
                          backgroundImage: NetworkImage(data['photoUrl']),
                        ),
                  title: Text(data['name']),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.check),
                        onPressed: () {
                          FriendFirestoreServices()
                              .acceptFriendRequest(senderID: senderID);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          FriendFirestoreServices()
                              .removeFriendRequest(senderID: senderID);
                        },
                      ),
                    ],
                  ));
            }
            return SizedBox();
          }),
    );
  }
}
