import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationFirebaseServices {
  final messaging = FirebaseMessaging.instance;

  Future<void> requestPermission() async {
    final settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    debugPrint('Permission granted: ${settings.authorizationStatus}');

    // It requests a registration token for sending messages to users from your App server or other trusted server environment.
    String? token = await messaging.getToken();

    debugPrint("Token: $token");
  }

  void listenForMessage() {
    FirebaseMessaging.onMessage.listen((event) {
      debugPrint("Message event received: ${event.toMap()}");
    });
  }

  Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    debugPrint("Background message: $message");
  }
}
