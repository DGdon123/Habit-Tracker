import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habit_tracker/pages/chat_room/chat_room.dart';
import 'package:habit_tracker/pages/home_page.dart';
import 'package:habit_tracker/pages/profile_page/widgets/friend_container.dart';
import 'package:habit_tracker/services/friend_firestore_services.dart';
import 'package:habit_tracker/utils/colors.dart';
import 'package:habit_tracker/utils/icons.dart';
import 'package:habit_tracker/utils/images.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

  @override
  State<FriendsPage> createState() => FriendsPageState();
}

class FriendsPageState extends State<FriendsPage> {
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
    return Scaffold(
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
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
                  Text(
                    '${friends.length} ${"Friends".tr()}',
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
                                var data = snapshot.data!.data()
                                    as Map<String, dynamic>;
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
          }),
    );
  }

  Widget FriendsContainer() {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: const EdgeInsets.all(16),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: Color(0xFFEAECF0)),
          borderRadius: BorderRadius.circular(16.r),
        ),
        shadows: [
          BoxShadow(
            color: Color(0x0F222C5C),
            blurRadius: 68,
            offset: Offset(58, 26),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Column(
                children: [
                  Image.asset(
                    AppImages.profileavatar,
                    height: 36.h,
                    width: 36.w,
                  ),
                ],
              ),
              SizedBox(
                width: 10.w,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'User Name'.tr(),
                    style: TextStyle(
                      color: Color(0xFF040415),
                      fontSize: 16.sp,
                      fontFamily: 'SFProText',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '912 XP',
                    style: TextStyle(
                      color: Color(0xFF9B9BA1),
                      fontSize: 14.sp,
                      fontFamily: 'SF Pro Text',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              )
            ],
          ),
          GestureDetector(
            onTap: () {},
            child: SvgPicture.asset(
              AppIcons.unfriend,
              height: 32.h,
            ),
          ),
        ],
      ),
    );
  }
}
