import 'dart:developer';
import 'dart:io';
import 'dart:math' as re;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:habit_tracker/pages/chat_room/chat_room.dart';
import 'package:habit_tracker/pages/home_page.dart';
import 'package:habit_tracker/provider/index_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationServices {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationPlugin =
      FlutterLocalNotificationsPlugin();

  void requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: true,
        criticalAlert: true,
        provisional: true,
        sound: true);
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      log('user granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      log('user granted provisional permission');
    } else {
      log('user denied permission');
    }
  }

  void initLocalNotifications(
      BuildContext context, RemoteMessage message) async {
    var androidInitializationSettings =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitializationSettings = const DarwinInitializationSettings();
    var initializationSetting = InitializationSettings(
        android: androidInitializationSettings, iOS: iosInitializationSettings);
    await _flutterLocalNotificationPlugin.initialize(initializationSetting,
        onDidReceiveNotificationResponse: (payload) {
      handleMessage(context, message);
    });
  }

  void firebaseinit(BuildContext context) {
    FirebaseMessaging.onMessage.listen((message) {
      if (kDebugMode) {
        log(message.notification!.title.toString());
        log(message.notification!.body.toString());
        log(message.data.toString());
        log(message.data["type"]);
      }
      if (Platform.isAndroid) {
        initLocalNotifications(context, message);
        showNotification(message);
      } else {
        showNotification(message);
      }
    });
  }

  Future<void> setupInteractMeassage(BuildContext context) async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      handleMessage(context, initialMessage);
    }
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      handleMessage(context, event);
    });
  }

  Future<void> showNotification(RemoteMessage message) async {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
        re.Random.secure().nextInt(100000).toString(),
        'High Importance Notifications',
        importance: Importance.max);

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
            channel.id.toString(), channel.name.toString(),
            channelDescription: 'your channel description',
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
            ticker: 'ticker');

    const DarwinNotificationDetails darwinNotificationDeatils =
        DarwinNotificationDetails(
            presentAlert: true, presentBadge: true, presentSound: true);
    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: darwinNotificationDeatils);

    Future.delayed(Duration.zero, () {
      _flutterLocalNotificationPlugin.show(
          8,
          message.notification!.title.toString(),
          message.notification!.body.toString(),
          notificationDetails);
    });
  }

  Future<String?> getDeviceToken() async {
    String? token = await messaging.getToken();
    return token;
  }

  void isTokenRefresh() async {
    messaging.onTokenRefresh.listen((event) {
      event.toString();
      log('refresh');
    });
  }

  Future<void> handleMessage(
      BuildContext context, RemoteMessage message) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String name = prefs.getString('name').toString();
    String chatRoomId = prefs.getString('chatRoomId').toString();
    String photoURL = prefs.getString('photoURL').toString();
    String receiverDeviceToken =
        prefs.getString('receiverDeviceToken').toString();
    String receiverID = prefs.getString('receiverID').toString();
    log(name);
    log(chatRoomId);
    log(photoURL);
    log(receiverDeviceToken);
    log(receiverID);
    if (message.data["type"] == "msg") {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
          (route) => false);
      context.read<IndexProvider>().setSelectedIndex(4);
    } else if (message.data["type"] == "free") {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ChatRoom(
                  receiverDeviceToken: receiverDeviceToken,
                  chatRoomId: chatRoomId,
                  receiverID: receiverID,
                  photoURL: photoURL,
                  name: name)));
    }
  }
}
