import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:habit_tracker/pages/profile_page/widgets/friend_container.dart';
import 'package:habit_tracker/services/friend_firestore_services.dart';

class FriendsListView extends StatelessWidget {
  const FriendsListView({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FriendFirestoreServices().getAllFriends(),
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            debugPrint("Snapshot: ${snapshot.data}");
            if (snapshot.data!.docs.isEmpty) {
              return const Text("Add friends to see them here");
            }
            var data = snapshot.data!.docs.first;
            var friends = data["friends"] as List<dynamic>;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${friends.length} Friends',
                  style: TextStyle(
                    color: const Color(0xFF040415),
                    fontSize: 16.sp,
                    fontFamily: 'SFProText',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: friends.length,
                    itemBuilder: (_, index) {
                      return FutureBuilder<
                              DocumentSnapshot<Map<String, dynamic>>>(
                          future: FriendFirestoreServices()
                              .getDetailsOfFriend(friendID: friends[index]),
                          builder: (_, snapshot) {
                            if (snapshot.hasData) {
                              var data =
                                  snapshot.data!.data() as Map<String, dynamic>;

                              return FriendContainer(
                                name: data["name"],
                                photoUrl: data["photoUrl"],
                                uid: data["uid"],
                              );
                            }
                            return const SizedBox();
                          });
                    },
                  ),
                ),
              ],
            );
          }
          return const SizedBox();
        });
  }
}
