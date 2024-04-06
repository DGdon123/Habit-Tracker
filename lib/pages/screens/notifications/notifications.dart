import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:habit_tracker/main.dart';
import 'package:habit_tracker/pages/screens/settings/settings.dart';
import 'package:habit_tracker/utils/colors.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? getUserID() {
    User? user = _auth.currentUser;
    return user?.uid;
  }

  Future<List<DocumentSnapshot>> fetchUsers() async {
    CollectionReference users =
        FirebaseFirestore.instance.collection('notifications');

    String? userID = getUserID(); // Get the current user's ID
    List<DocumentSnapshot> documents = [];

    try {
      QuerySnapshot snapshot =
          await users.where('receiverID', isEqualTo: userID).get();
      if (snapshot.docs.isNotEmpty) {
        documents = snapshot.docs;
      } else {
        print('No data found for the current user');
      }
    } catch (error) {
      print("Failed to fetch users: $error");
    }

    return documents;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SettingsPage()),
                        (route) => false,
                      );
                    },
                    child: SizedBox(
                      height: 28.h,
                      width: 28.w,
                      child: const Icon(Icons.arrow_back),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "Notifications".tr(),
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                          color: AppColors.black.withOpacity(0.5),
                        ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              Expanded(
                child: FutureBuilder<List<DocumentSnapshot>>(
                  future: fetchUsers(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      return ListView.builder(
                        itemCount: snapshot.data?.length ?? 0,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> userData = snapshot.data?[index]
                              .data() as Map<String, dynamic>;
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(right: 8.0),
                                  child: Icon(
                                    Icons.circle,
                                    size: 10,
                                  ),
                                ),
                                Text(
                                  userData['message'] ?? '',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
