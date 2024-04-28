import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habit_tracker/auth/repositories/user_repository.dart';
import 'package:habit_tracker/main.dart';
import 'package:habit_tracker/pages/chat_room/chat_room.dart';
import 'package:habit_tracker/pages/home_page.dart';
import 'package:habit_tracker/pages/screens/language/language.dart';
import 'package:habit_tracker/pages/screens/notifications/notifications.dart';
import 'package:habit_tracker/pages/screens/settings/goal_completetion_screen.dart';
import 'package:habit_tracker/utils/colors.dart';
import 'package:habit_tracker/utils/icons.dart';
import 'package:habit_tracker/utils/images.dart';
import 'package:provider/provider.dart';

import '../../../provider/index_provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? getUsername() {
    User? user = _auth.currentUser;
    return user?.displayName;
  }

  TextStyle settingsTextStyle = TextStyle(
    color: AppColors.textBlack,
    fontSize: 16.sp,
    fontFamily: 'SFProText',
    fontWeight: FontWeight.w600,
    height: 0.10,
  );
  int focus = 0;
  int screen = 0;
  int sleep = 0;
  int workout = 0;
  int xp = 0;
  int screenhours = 0;
  int screenminutes = 0;

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
            focus = userData['focusTime'];
            screen = userData['screenTime'];
            sleep = userData['sleepGoals'];
            xp = userData['xp'] ?? 0;
            workout = userData['workoutFrequency'];
          });

          // Example: Use the latitude and longitude data
          // SomeFunctionToUseLocation(latitude, longitude);
        }
      }
    } catch (error) {
      print("Failed to fetch users: $error");
    }
  }

  List<Map<String, dynamic>> dataList = [];
  Map<String, dynamic> userLabels = {};

  Future<Map<String, dynamic>> fetchUsers4() async {
    CollectionReference users = FirebaseFirestore.instance.collection('goals');
    String? currentUserUid = getUserID();

    try {
      QuerySnapshot snapshot = await users
          .doc(currentUserUid)
          .collection('screen')
          .get(); // Use get() instead of snapshots() to fetch a single query snapshot

      for (var doc in snapshot.docs) {
        Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;
        dataList.add(userData);
      }
      userLabels['data'] = dataList;
      logger.d(userLabels);
      userLabels['data'].forEach((labelData) {
        int hours = labelData['hours'];
        int minutes = labelData['minutes'];

        screenhours += hours; // Accumulate hours
        screenminutes += minutes; // Accumulate minutes
      });

      // Update the state with the total hours and minutes
      setState(() {
        screenhours += screenminutes ~/ 60;
        screenminutes %= 60;
      });
      logger.d(screenhours);
      logger.d(screenminutes);
      // This user document matches the current user
      // You can access the user data and do something with it
    } catch (error) {
      print("Failed to fetch users: $error");
    }
    return userLabels; // Return the list of Text widgets
  }

  int focushours = 0;
  int focusminutes = 0;
  List<Map<String, dynamic>> dataList1 = [];
  Map<String, dynamic> userLabels1 = {};
  Future<Map<String, dynamic>> fetchUsers5() async {
    CollectionReference users = FirebaseFirestore.instance.collection('goals');
    String? currentUserUid = getUserID();

    try {
      QuerySnapshot snapshot = await users
          .doc(currentUserUid)
          .collection('focustimer')
          .get(); // Use get() instead of snapshots() to fetch a single query snapshot

      for (var doc in snapshot.docs) {
        Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;
        dataList1.add(userData);
      }
      userLabels1['data'] = dataList1;
      logger.d(userLabels1);
      userLabels1['data'].forEach((labelData) {
        int hours = labelData['hours'];
        int minutes = labelData['minutes'];

        focushours += hours; // Accumulate hours
        focusminutes += minutes; // Accumulate minutes
      });

      // Update the state with the total hours and minutes
      setState(() {
        focushours += focusminutes ~/ 60;
        focusminutes %= 60;
      });
      logger.d(focushours);
      logger.d(focusminutes);
      // This user document matches the current user
      // You can access the user data and do something with it
    } catch (error) {
      print("Failed to fetch users: $error");
    }
    return userLabels1; // Return the list of Text widgets
  }

  String firstDate = "";
  String lastDate = "";
  CollectionReference goals = FirebaseFirestore.instance.collection('goals');
  double sleepprogress = 0;
  String sleephours = "0";
  String formattedDates = "";
  List<Map<String, dynamic>> dataList2 = [];
  Map<String, dynamic> userLabels2 = {};
  int sleep1 = 0;
  Future<Map<String, dynamic>> fetchUsers6() async {
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
            sleep1 = userData['sleepGoals'];
          });

          // Example: Use the latitude and longitude data
          // SomeFunctionToUseLocation(latitude, longitude);
        }
      }
    } catch (error) {
      print("Failed to fetch users: $error");
    }

    try {
      QuerySnapshot snapshot = await goals
          .doc(currentUserUid)
          .collection('sleep')
          .get(); // Use get() instead of snapshots() to fetch a single query snapshot

      // Initialize firstDate and lastDate to null
      String? firstDate;
      String? lastDate;

      for (var doc in snapshot.docs) {
        Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;
        dataList2.add(userData);

        // Extract addedAt from each document and update firstDate and lastDate accordingly
        String addedAt = userData['addedAt'];

        if (firstDate == null || addedAt.compareTo(firstDate) < 0) {
          firstDate = addedAt;
        }
        if (lastDate == null || addedAt.compareTo(lastDate) > 0) {
          lastDate = addedAt;
        }
      }

      // Now, calculate formattedDates
      if (firstDate != null && lastDate != null) {
        // Parse dates
        DateTime startDate = DateFormat("yyyy-MM-dd").parse(firstDate);
        DateTime endDate = DateFormat("yyyy-MM-dd").parse(lastDate);

        // Format dates
        // Format dates separately
        String formattedStartDate = DateFormat("MMMM dd").format(startDate);
        String formattedEndDate = DateFormat("dd, yyyy").format(endDate);

// Combine formatted dates with separator
        formattedDates = "$formattedStartDate - $formattedEndDate";

        // Update state with formattedDates
        setState(() {
          formattedDates = "$formattedStartDate-$formattedEndDate";
        });
      }

      logger.d(formattedDates);
      logger.d(userLabels2);

      int totalHours = 0;

      userLabels2['data'].forEach((labelData) {
        String hoursString = labelData['difference'];
        int hours =
            int.parse(hoursString.split('.')[0]); // Parse hours as integer
        totalHours += hours; // Accumulate hours
      });
    } catch (error) {
      print("Failed to fetch users: $error");
    }
    return userLabels2;
  }

  String intime = "0";
  String outtime = "0";
  List<Map<String, dynamic>> dataList3 = [];
  Map<String, dynamic> userLabels3 = {};

  Future<Map<String, dynamic>> fetchUsers7() async {
    CollectionReference users = FirebaseFirestore.instance.collection('goals');
    String? currentUserUid = getUserID();

    try {
      QuerySnapshot snapshot = await users
          .doc(currentUserUid)
          .collection('workout')
          .get(); // Use get() instead of snapshots() to fetch a single query snapshot

      for (var doc in snapshot.docs) {
        Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;
        dataList3.add(userData);
      }
      userLabels3['data'] = dataList3;
      logger.d(userLabels3);

      // This user document matches the current user
      // You can access the user data and do something with it
    } catch (error) {
      print("Failed to fetch users: $error");
    }
    return userLabels2; // Return the list of Text widgets
  }

  int totalXP = 0;
  List<Map<String, dynamic>> xpList = [];
  Map<String, dynamic> xpLabels = {};

  Future<void> xpGet() async {
    CollectionReference users = FirebaseFirestore.instance.collection('xp');

    try {
      QuerySnapshot snapshot = await users.get();
      for (var doc in snapshot.docs) {
        Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;
        xpList.add(userData);
      }
      xpLabels['data'] = xpList;

      for (var xpData in xpLabels['data']) {
        if (xpData['userID'] == _auth.currentUser?.uid &&
            xpData['reason'] == "Earned from Sleep Wake Time") {
          setState(() {
            totalXP += xpData['xp'] as int;
          });
        }
      }
      logger.d(xpLabels['data']);
      logger.d(totalXP);

      // Example: Use the latitude and longitude data
    } catch (error) {
      print("Failed to fetch users: $error");
    }
  }

  @override
  void initState() {
    // fetchUsers();
    // fetchUsers4();
    // fetchUsers5();
    fetchUsers6();
    // fetchUsers7();
    // xpGet();
    super.initState();
  }

  String? getPhoto() {
    User? user = _auth.currentUser;
    return user?.photoURL;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: Container(
          margin: EdgeInsets.only(
              top: kIsWeb
                  ? 35.h
                  : Platform.isIOS
                      ? 50.h
                      : 35.h),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => const HomePage())),
                            (route) => false);
                      },
                      child: SizedBox(
                        height: 28.h,
                        width: 28.w,
                        child: SvgPicture.asset(
                          AppIcons.back,
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        "Settings".tr(),
                        style: TextStyle(
                            fontFamily: 'SFProText',
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w900,
                            color: AppColors.textBlack),
                      ),
                    ),
                    SizedBox(
                      height: 28.h,
                      width: 28.w,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 0.w, vertical: 15.h),
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side:
                          const BorderSide(width: 1, color: Color(0xFFD0D0D0)),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                getPhoto() == null ||
                                        getPhoto().toString() ==
                                            "No host specified in URI file:///null"
                                    ? Image.asset(
                                        AppImages.profileavatar,
                                        height: 70.h,
                                        width: 70.w,
                                      )
                                    : SizedBox(
                                        height: 70.h,
                                        width: 70.w,
                                        child: CircleAvatar(
                                            radius: 35.0,
                                            backgroundImage: NetworkImage(
                                                getPhoto().toString())),
                                      ),
                                Text(
                                  getUsername() ?? 'User Name'.tr(),
                                  style: TextStyle(
                                    color: AppColors.textBlack,
                                    fontSize: 20.sp,
                                    fontFamily: 'SFProText',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 48.h,
                                  height: 48.w,
                                  alignment: Alignment.center,
                                  decoration: ShapeDecoration(
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      side: const BorderSide(
                                          width: 1, color: Color(0xFFEAECF0)),
                                      borderRadius: BorderRadius.circular(16.r),
                                    ),
                                  ),
                                  child: Image.asset(
                                    AppImages.fitbit,
                                    height: 30.h,
                                  ),
                                ),
                                SizedBox(
                                  width: 10.w,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    
                                  },
                                  child: Container(
                                    width: 48.h,
                                    height: 48.w,
                                    alignment: Alignment.center,
                                    decoration: ShapeDecoration(
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        side: const BorderSide(
                                            width: 1, color: Color(0xFFEAECF0)),
                                        borderRadius:
                                            BorderRadius.circular(16.r),
                                      ),
                                    ),
                                    child: Image.asset(
                                      AppImages.googlefit,
                                      height: 30.h,
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      seperator(),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const LanguageSelection()));
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 20.h, horizontal: 10.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    AppIcons.language,
                                    height: 24.h,
                                  ),
                                  SizedBox(
                                    width: 8.w,
                                  ),
                                  Text(
                                    'Language'.tr(),
                                    style: settingsTextStyle,
                                  )
                                ],
                              ),
                              Icon(
                                Icons.chevron_right,
                                size: 24.h,
                                color: const Color.fromARGB(255, 104, 104, 115),
                              )
                            ],
                          ),
                        ),
                      ),
                      seperator(),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 20.h, horizontal: 10.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  AppIcons.security,
                                  height: 26.h,
                                ),
                                SizedBox(
                                  width: 8.w,
                                ),
                                Text(
                                  'Security'.tr(),
                                  style: settingsTextStyle,
                                )
                              ],
                            ),
                            Icon(
                              Icons.chevron_right,
                              size: 24.h,
                              color: const Color.fromARGB(255, 104, 104, 115),
                            )
                          ],
                        ),
                      ),
                      seperator(),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const NotificationsPage()));
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 20.h, horizontal: 10.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    AppIcons.notification,
                                    height: 26.h,
                                  ),
                                  SizedBox(
                                    width: 8.w,
                                  ),
                                  Text(
                                    'Notifications'.tr(),
                                    style: settingsTextStyle,
                                  )
                                ],
                              ),
                              Icon(
                                Icons.chevron_right,
                                size: 24.h,
                                color: const Color.fromARGB(255, 104, 104, 115),
                              )
                            ],
                          ),
                        ),
                      ),
                      seperator(),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 20.h, horizontal: 10.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  AppIcons.sound,
                                  height: 26.h,
                                ),
                                SizedBox(
                                  width: 8.w,
                                ),
                                Text(
                                  'Sounds'.tr(),
                                  style: settingsTextStyle,
                                )
                              ],
                            ),
                            Container(
                              width: 48.w,
                              height: 28.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100.r),
                                color: AppColors.primaryColor,
                              ),
                              child: Stack(
                                children: [
                                  Positioned(
                                    right: 0.5,
                                    top: 0,
                                    bottom: 0,
                                    child: Center(
                                      child: Container(
                                        width: 21,
                                        height: 21,
                                        decoration: const ShapeDecoration(
                                          color: Colors.white,
                                          shape: OvalBorder(),
                                          shadows: [
                                            BoxShadow(
                                              color: Color(0x330B2B51),
                                              blurRadius: 6,
                                              offset: Offset(0, 3),
                                              spreadRadius: 0,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 15.h),
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side:
                          const BorderSide(width: 1, color: Color(0xFFD0D0D0)),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 20.h, horizontal: 10.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  AppIcons.star,
                                  height: 24.h,
                                ),
                                SizedBox(
                                  width: 8.w,
                                ),
                                Text(
                                  'Rate App'.tr(),
                                  style: settingsTextStyle,
                                )
                              ],
                            ),
                            Icon(
                              Icons.chevron_right,
                              size: 24.h,
                              color: const Color.fromARGB(255, 104, 104, 115),
                            )
                          ],
                        ),
                      ),
                      seperator(),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 20.h, horizontal: 10.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  AppIcons.share,
                                  height: 26.h,
                                ),
                                SizedBox(
                                  width: 8.w,
                                ),
                                Text(
                                  'Share with Friends'.tr(),
                                  style: settingsTextStyle,
                                )
                              ],
                            ),
                            Icon(
                              Icons.chevron_right,
                              size: 24.h,
                              color: const Color.fromARGB(255, 104, 104, 115),
                            )
                          ],
                        ),
                      ),
                      seperator(),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 20.h, horizontal: 10.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  AppIcons.about,
                                  height: 26.h,
                                ),
                                SizedBox(
                                  width: 8.w,
                                ),
                                Text(
                                  'About Us'.tr(),
                                  style: settingsTextStyle,
                                )
                              ],
                            ),
                            Icon(
                              Icons.chevron_right,
                              size: 24.h,
                              color: const Color.fromARGB(255, 104, 104, 115),
                            )
                          ],
                        ),
                      ),
                      seperator(),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 20.h, horizontal: 10.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  AppIcons.support,
                                  height: 26.h,
                                ),
                                SizedBox(
                                  width: 8.w,
                                ),
                                Text(
                                  'Support'.tr(),
                                  style: settingsTextStyle,
                                )
                              ],
                            ),
                            Icon(
                              Icons.chevron_right,
                              size: 24.h,
                              color: const Color.fromARGB(255, 104, 104, 115),
                            )
                          ],
                        ),
                      ),
                      seperator(),
                      InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(
                                  'Are You Sure You Want to Sign Out?'.tr(),
                                  style: const TextStyle(
                                      height: 1.3,
                                      fontFamily: 'SFProText',
                                      fontSize: 15),
                                ),
                                titleTextStyle: const TextStyle(
                                    fontSize: 18, color: Color(0xff222222)),
                                actions: <Widget>[
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(
                                          false); // Close the dialog and return false
                                    },
                                    child: Text(
                                      'No'.tr(),
                                      style:
                                          const TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      // Perform sign out action
                                      await Provider.of<UserRepository>(context,
                                              listen: false)
                                          .signOut(context);
                                    },
                                    child: Text(
                                      'Yes'.tr(),
                                      style: const TextStyle(
                                          color: AppColors.mainBlue),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 20.h, horizontal: 10.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    AppIcons.logout,
                                    height: 26.h,
                                  ),
                                  SizedBox(
                                    width: 8.w,
                                  ),
                                  Text(
                                    'Sign Out'.tr(),
                                    style: settingsTextStyle,
                                  )
                                ],
                              ),
                              Icon(
                                Icons.chevron_right,
                                size: 24.h,
                                color: const Color.fromARGB(255, 104, 104, 115),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Container seperator() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1, color: Color(0xFFD0D0D0)),
        ),
      ),
    );
  }
}
