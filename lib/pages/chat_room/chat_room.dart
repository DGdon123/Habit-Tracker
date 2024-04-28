import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:habit_tracker/provider/index_provider.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habit_tracker/utils/buttons.dart';
import 'package:habit_tracker/utils/colors.dart';
import 'package:habit_tracker/utils/icons.dart';
import 'package:hive/hive.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import '../../main.dart';
import '../../services/notification_services.dart';
import '../../services/xp_firestore_services.dart';
import '../home_page.dart';

class ChatRoom extends StatefulWidget {
  final String chatRoomId;
  final String photoURL;
  final String name;
  final String receiverID;
  final String receiverDeviceToken;
  const ChatRoom({
    super.key,
    required this.receiverDeviceToken,
    required this.receiverID,
    required this.name,
    required this.photoURL,
    required this.chatRoomId,
  });

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final TextEditingController _message = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  NotificationServices notificationServices = NotificationServices();
  final xpController = TextEditingController();

  String? getUsername() {
    User? user = _auth.currentUser;
    return user?.displayName;
  }

  String? getUserID() {
    User? user = _auth.currentUser;
    return user?.uid;
  }

  int xp = 0;

  Future<void> fetchUsers() async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    String? currentUserUid = getUserID();

    try {
      QuerySnapshot snapshot = await users.get();

      for (var doc in snapshot.docs) {
        String uid = doc.id;
        Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;

        if (uid == currentUserUid) {
          // This user document matches the current user
          // You can access the user data and do something with it
          setState(() {
            xp = userData['xp'] ?? 0;
          });

          // Example: Use the latitude and longitude data
          // SomeFunctionToUseLocation(latitude, longitude);
        }
      }
    } catch (error) {
      print("Failed to fetch users: $error");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  void giftPopUp(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:  Center(
            child: Text(
              'Gift XP to your friend'.tr(),
              style: TextStyle(
                color: AppColors.textBlack,
                fontSize: 19,
                fontFamily: 'SFProText',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 20,
              ),
              SvgPicture.asset(
                AppIcons.twogift,
                width: 80,
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: xpController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  hintStyle: const TextStyle(color: CupertinoColors.systemGrey),
                  labelText: 'XP'.tr(),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide:
                        const BorderSide(color: AppColors.blue, width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                        color: AppColors.widgetColorB, width: 0.4),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            CustomButton(
              text: 'Send Gift'.tr(),
              onPressed: () {
                if (int.parse(xpController.text) > xp) {
                  QuickAlert.show(
                    context: context,
                    type: QuickAlertType.error,
                    confirmBtnColor: AppColors.mainBlue,
                    onConfirmBtnTap: () {
                      xpController.clear();
                      Navigator.pop(context);
                    },
                    title: 'Oops...'.tr(),
                    text: 'Sorry, you have only $xp xp.',
                  );
                } else {
                  onSendMessage1(context, xpController.text);
                }
              },
            )
          ],
        );
      },
    );
  }

  void onSendMessage1(BuildContext context, String xpValue) async {
    if (xpValue.isNotEmpty) {
      Map<String, dynamic> messages = {
        "sendby": _auth.currentUser!.uid,
        "message": '$xpValue XP.',
        "receiver": widget.receiverID,
        "receiverdevicetoken": widget.receiverDeviceToken,
        "type": "text",
        "time": FieldValue.serverTimestamp(),
      };

      xpController.clear();
      await _firestore
          .collection('chatroom')
          .doc(widget.chatRoomId)
          .collection('chats')
          .add(messages);
      XpFirestoreServices().subtractXp(
        receiverID: widget.receiverID,
        increment: false,
        increment2: true,
        xp: int.parse(xpValue),
        reason2: "Gifted by ${_auth.currentUser!.displayName}",
        reason: "Gifted to ${widget.name}",
      );
      Navigator.pop(context);
    } else {
      print("Enter Some Text");
    }
  }

  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void onSendMessage() async {
    if (_message.text.isNotEmpty) {
      Map<String, dynamic> messages = {
        "sendby": _auth.currentUser!.uid,
        "message": _message.text,
        "receiver": widget.receiverID,
        "receiverdevicetoken": widget.receiverDeviceToken,
        "type": "text",
        "time": FieldValue.serverTimestamp(),
      };

      _message.clear();
      await _firestore
          .collection('chatroom')
          .doc(widget.chatRoomId)
          .collection('chats')
          .add(messages);
    } else {
      print("Enter Some Text");
    }
  }

  Widget messages(Size size, Map<String, dynamic> map, BuildContext context) {
    String? senderName =
        map['sendby'] == _auth.currentUser!.uid ? "You".tr() : widget.name;

    String messageText = map['message'];

    // Check if the message contains "XP"
    if (messageText.contains("XP")) {
      // If the message contains "XP", customize the message text
      // Example: "You sent 7 XP" or "Dipesh Gurung sent you 7 XP"
      messageText = "🎁 $senderName sent $messageText"; // Modify as needed
    }

    return Container(
      width: size.width,
      alignment: map['sendby'] == _auth.currentUser!.uid
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
              topRight: Radius.circular(8),
              topLeft: Radius.circular(8),
              bottomRight: Radius.circular(8)),
          color: map['sendby'] == _auth.currentUser!.uid
              ? AppColors.mainBlue // Color for current user's messages
              : CupertinoColors.lightBackgroundGray,
        ),
        child: Text(
          messageText,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: map['sendby'] == _auth.currentUser!.uid
                ? AppColors.white // Color for current user's messages
                : AppColors.textBlack,
          ),
        ),
      ),
    );
  }

  void fresh() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('name', widget.name);
    prefs.setString('chatRoomId', widget.chatRoomId);
    prefs.setString('photoURL', widget.photoURL);
    prefs.setString('receiverDeviceToken', widget.receiverDeviceToken);
    prefs.setString('receiverID', widget.receiverID);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: Row(
            children: [
              InkWell(
                child: const Icon(Icons.arrow_back),
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                      (route) => false);
                  context.read<IndexProvider>().setSelectedIndex(4);
                },
              ),
              Container(
                width: 5,
              ),
              widget.photoURL.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 7.0, top: 8),
                      child: CircleAvatar(
                        child: Container(
                          decoration: BoxDecoration(
                              color: AppColors.mainBlue,
                              borderRadius: BorderRadius.circular(80)),
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(bottom: 11.0, top: 11),
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(
                          widget.photoURL.toString(),
                        ),
                      ),
                    ),
            ],
          ),
        ),
        surfaceTintColor: Colors.transparent,
        shadowColor: CupertinoColors.extraLightBackgroundGray,
        elevation: 2,
        title: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Text(widget.name.toString()),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('chatroom')
                  .doc(widget.chatRoomId)
                  .collection('chats')
                  .orderBy("time", descending: false)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                debugPrint(
                    "Snapshot received: ${snapshot.data?.docs}, chat room id: ${widget.chatRoomId}");
                if (snapshot.data != null) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    // Scroll to the end of the list when new messages are received
                    _scrollController.animateTo(
                      _scrollController.position.maxScrollExtent,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  });

                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> map = snapshot.data!.docs[index]
                          .data() as Map<String, dynamic>;
                      return Column(
                        children: [
                          messages(size, map, context),
                          StreamBuilder<QuerySnapshot>(
                            stream: _firestore
                                .collection('chatroom')
                                .doc(widget.chatRoomId)
                                .collection('chats')
                                .where("receiverdevicetoken",
                                    isEqualTo: widget.receiverDeviceToken)
                                .orderBy('time', descending: true)
                                .limit(1)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.active) {
                                if (snapshot.hasData &&
                                    snapshot.data!.docs.isNotEmpty) {
                                  Map<String, dynamic> latestMessageData =
                                      snapshot.data!.docs.first.data()
                                          as Map<String, dynamic>;
                                  fresh();
                                  var data1 = {
                                    'to': widget.receiverDeviceToken,
                                    'priority': 'high',
                                    'notification': {
                                      'title': "Habit Tracker",
                                      'body':
                                          '${_auth.currentUser!.displayName}: ${latestMessageData['message']}'
                                    },
                                    'data': {'type': 'free'}
                                  };
                                  http.post(
                                    Uri.parse(
                                        'https://fcm.googleapis.com/fcm/send'),
                                    body: jsonEncode(data1),
                                    headers: {
                                      'Content-Type':
                                          'application/json; charset=UTF-8',
                                      'Authorization':
                                          'key=AAAAclKtwpw:APA91bE40rUSq6qXigGzh_3Y6D4mtkr1vjbkZt2_7HDJMzYWB9r53AXdxnWeOue5ZEwSXb_xQnhtJjh3y5AnkApfWJPmicHaIUdbJ2LDs47EhcBQQmk0FhN8sy_vW-b1AEgVxva7lu0n'
                                    },
                                  );
                                }
                              }
                              return Container();
                            },
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              color: CupertinoColors.lightBackgroundGray,
              child: Row(
                children: [
                  const SizedBox(
                    width: 15,
                  ),
                  InkWell(
                    onTap: () {
                      giftPopUp(context);
                    },
                    child: SvgPicture.asset(
                      AppIcons.gift,
                      width: 30,
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: TextField(
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                      controller: _message,
                      decoration:  InputDecoration(
                          hintText: "Write message...".tr(),
                          hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 40,
                      width: 40,
                      child: FloatingActionButton(
                        shape: const CircleBorder(),
                        onPressed: () {
                          onSendMessage();
                        },
                        backgroundColor: AppColors.blue,
                        elevation: 0,
                        child: SvgPicture.asset(
                          AppIcons.sendIcon,
                          width: 18,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ShowImage extends StatelessWidget {
  final String imageUrl;

  const ShowImage({required this.imageUrl, super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        color: Colors.black,
        child: Image.network(imageUrl),
      ),
    );
  }
}
