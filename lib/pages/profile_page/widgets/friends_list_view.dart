import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:habit_tracker/pages/chat_room/chat_room.dart';
import 'package:habit_tracker/pages/profile_page/widgets/friend_container.dart';
import 'package:habit_tracker/services/friend_firestore_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FriendsListView extends StatefulWidget {
  const FriendsListView({super.key});
  @override
  State<FriendsListView> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<FriendsListView> {
  Map<String, dynamic>? userMap;
  String chatRoomId(String user1, String user2) {
    List<String> ids = [user1, user2];
    ids.sort();
    String chatRoomID = ids.join('_');
    return chatRoomID;
  }

  String? getUsername() {
    User? user = _auth.currentUser;
    return user?.uid;
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FriendFirestoreServices().getAllFriends(),
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            debugPrint("Snapshot: ${snapshot.data}");
            if (snapshot.data!.docs.isEmpty) {
              return Text("Add friends to see them here".tr());
            }
            var data = snapshot.data!.docs.first;
            var friends = data["friends"] as List<dynamic>;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Text(
                    '${friends.length} ${"Friends".tr()}',
                    style: TextStyle(
                      color: const Color(0xFF040415),
                      fontSize: 16.sp,
                      fontFamily: 'SFProText',
                      fontWeight: FontWeight.w600,
                    ),
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
                                onPressed: () {
                                  log(data["device_token"]);
                                  String roomId = chatRoomId(
                                    _auth.currentUser!.uid,
                                    data['uid'],
                                  );

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ChatRoom(
                                              receiverDeviceToken:
                                                  data["device_token"],
                                              chatRoomId: roomId,
                                              receiverID: data['uid'],
                                              photoURL: data["photoUrl"],
                                              name: data['name'])));
                                },
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
