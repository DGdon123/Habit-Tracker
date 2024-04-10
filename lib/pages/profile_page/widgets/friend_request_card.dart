import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:habit_tracker/main.dart';
import 'package:habit_tracker/services/friend_firestore_services.dart';
import 'package:habit_tracker/services/notification_services.dart';
import 'package:habit_tracker/services/user_firestore_services.dart';
import 'package:habit_tracker/utils/colors.dart';
import 'package:http/http.dart' as http;

class FriendRequestCard extends StatefulWidget {
  final String senderID;
  final String token;
  final String photourl;
  final String name;
  const FriendRequestCard(
      {super.key,
      required this.senderID,
      required this.token,
      required this.photourl,
      required this.name});
  @override
  State<FriendRequestCard> createState() => _AccountSetupSetNameState();
}

class _AccountSetupSetNameState extends State<FriendRequestCard> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  String? getUsername() {
    User? user = auth.currentUser;
    return user?.displayName;
  }

  String? getUserID() {
    User? user = auth.currentUser;
    return user?.uid;
  }

  Future<void> addNotifications(String sendername, String uid, String photourl,
      String devicetoken, String message) {
    CollectionReference users =
        FirebaseFirestore.instance.collection('notifications');

    return users
        .add({
          'sendername': sendername,
          'receiverID': uid,
          'photourl': photourl,
          'receiverdevicetoken': devicetoken,
          'message': message
        })
        .then((value) => print("User added successfully!"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  String? getPhoto() {
    User? user = auth.currentUser;
    return user?.photoURL;
  }

  @override
  Widget build(BuildContext context) {
    NotificationServices notificationServices = NotificationServices();

    return Card(
      elevation: 0,
      color: AppColors.widgetColorG,
      child: FutureBuilder<QueryDocumentSnapshot>(
          future: UserFireStoreServices().searchUserByUid(widget.senderID),
          builder: (_, snapshot) {
            debugPrint("Snapshot: ${snapshot.data?.data()}");
            if (snapshot.hasData) {
              var data = snapshot.data!.data() as Map<String, dynamic>;
              debugPrint("name: ${data['name']}");
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                    contentPadding: EdgeInsets.all(3),
                    tileColor: AppColors.widgetColorG,
                    leading: data["photoUrl"].isEmpty
                        ? CircleAvatar(
                            child: Text(data['name'][0]),
                          )
                        : CircleAvatar(
                            backgroundImage: NetworkImage(data['photoUrl']),
                          ),
                    title: Text(
                      data['name'],
                      style: TextStyle(
                          color: AppColors.black,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'SfProText'),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () {
                            FriendFirestoreServices()
                                .acceptFriendRequest(senderID: widget.senderID);
                            notificationServices
                                .getDeviceToken()
                                .then((value) async {
                              var data1 = {
                                'to': widget.token,
                                'priority': 'high',
                                'notification': {
                                  'title': 'Habit Tracker',
                                  'body':
                                      '${getUserName()} has accepted your friend request.'
                                },
                                'data': {'type': 'msg'}
                              };
                              await http.post(
                                  Uri.parse(
                                      'https://fcm.googleapis.com/fcm/send'),
                                  body: jsonEncode(data1),
                                  headers: {
                                    'Content-Type':
                                        'application/json; charset=UTF-8',
                                    'Authorization':
                                        'key=AAAAclKtwpw:APA91bE40rUSq6qXigGzh_3Y6D4mtkr1vjbkZt2_7HDJMzYWB9r53AXdxnWeOue5ZEwSXb_xQnhtJjh3y5AnkApfWJPmicHaIUdbJ2LDs47EhcBQQmk0FhN8sy_vW-b1AEgVxva7lu0n'
                                  });
                            });
                            log(widget.token);
                            addNotifications(
                                getUserName().toString(),
                                widget.senderID,
                                getPhoto().toString(),
                                widget.token,
                                '${getUserName()} has accepted your friend request.');
                          },
                          child: Container(
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: Colors.green),
                            child: Icon(
                              Icons.check,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 7.w,
                        ),
                        GestureDetector(
                          onTap: () {
                            FriendFirestoreServices()
                                .removeFriendRequest(senderID: widget.senderID);
                          },
                          child: Container(
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: CupertinoColors.destructiveRed),
                            child: Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    )),
              );
            }
            return const SizedBox();
          }),
    );
  }
}
