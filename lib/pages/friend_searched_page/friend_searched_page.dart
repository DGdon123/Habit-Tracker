import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:habit_tracker/main.dart';
import 'package:habit_tracker/services/friend_firestore_services.dart';
import 'package:habit_tracker/services/notification_services.dart';
import 'package:habit_tracker/utils/colors.dart';
import 'package:http/http.dart' as http;

class FriendSearchedPage extends StatefulWidget {
  final List<QueryDocumentSnapshot> searchResults;
  const FriendSearchedPage({super.key, required this.searchResults});
  @override
  State<FriendSearchedPage> createState() => _AccountSetupSetNameState();
}

class _AccountSetupSetNameState extends State<FriendSearchedPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  String? getUsername() {
    User? user = auth.currentUser;
    return user?.displayName;
  }

  String? getPhoto() {
    User? user = auth.currentUser;
    return user?.photoURL;
  }

  String? getUserID() {
    User? user = auth.currentUser;
    return user?.uid;
  }

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  Map<String, dynamic> userLabels = {};
  String? token;
  List<Map<String, dynamic>> dataList = [];

  Future<Map<String, dynamic>> fetchUsers() async {
    String? currentUserUid = getUserID();

    logger.d(currentUserUid);
    // Initialize a list to hold the Text widgets

    if (currentUserUid != null) {
      try {
        QuerySnapshot snapshot =
            await userCollection.where('uid', isEqualTo: currentUserUid).get();

        if (snapshot.docs.isNotEmpty) {
          for (var doc in snapshot.docs) {
            Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;
            // Add user data to the list
            setState(() {
              token = userData['device_token'];
            });

            logger.d(token);
          }
        } else {
          log('No data found for the current user');
        }
      } catch (error) {
        log("Failed to fetch users: $error");
      }
    } else {
      log('User ID is null');
    }

    return userLabels; // Return the list of Text widgets
  }

  @override
  void initState() {
    fetchUsers();
    super.initState();
  }

  Future<void> addNotifications(String sendername, String receiverID,
      String photourl, String devicetoken, String message) {
    CollectionReference users =
        FirebaseFirestore.instance.collection('notifications');

    return users
        .add({
          'sendername': sendername,
          'receiverID': receiverID,
          'photourl': photourl,
          'receiverdevicetoken': devicetoken,
          'message': message
        })
        .then((value) => print("User added successfully!"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  @override
  Widget build(BuildContext context) {
    NotificationServices notificationServices = NotificationServices();
    logger.d(token);
    return Scaffold(
      appBar: AppBar(),
      body: Center(
          child: ListView.builder(
        itemCount: widget.searchResults.length,
        itemBuilder: (context, index) {
          var data = widget.searchResults[index].data() as Map<String, dynamic>;
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              tileColor: AppColors.widgetColorB,
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
                    fontFamily: 'SfProText',
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.01,
                    fontSize: 18.sp),
              ),
              subtitle: Text(
                data['email'],
                style: TextStyle(
                    fontFamily: 'SfProText',
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.01,
                    fontSize: 13.sp),
              ),
              trailing: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FriendFirestoreServices()
                      .listenForFriendRequestSend(receiverID: data["uid"]),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                      return const Icon(Icons.check);
                    }
                    return Container(
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                            spreadRadius: 0.3,
                            offset: const Offset(0, .5),
                            color: Colors.black.withOpacity(0.5))
                      ], shape: BoxShape.circle, color: AppColors.white),
                      height: 46,
                      child: IconButton(
                        icon: const Icon(Icons.person_add),
                        onPressed: () {
                          FriendFirestoreServices()
                              .sendFriendRequestNotification(
                                  receiverID: data["uid"],
                                  photourl: getPhoto().toString(),
                                  token: token.toString(),
                                  name: getUsername().toString());
                          notificationServices
                              .getDeviceToken()
                              .then((value) async {
                            log(data.toString());
                            var data1 = {
                              'to': data["device_token"],
                              'priority': 'high',
                              'notification': {
                                'title': 'Habit Tracker',
                                'body':
                                    '${getUsername()} has sent you a friend request.'
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
                          addNotifications(
                              getUserName().toString(),
                              data["uid"],
                              getPhoto().toString(),
                              data["device_token"],
                              '${getUsername()} has sent you a friend request.');
                        },
                      ),
                    );
                  }),
            ),
          );
        },
      )),
    );
  }
}
