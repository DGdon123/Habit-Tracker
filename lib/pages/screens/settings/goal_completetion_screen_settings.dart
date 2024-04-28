import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dashed_circular_progress_bar/dashed_circular_progress_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:habit_tracker/main.dart';
import 'package:habit_tracker/pages/home_page.dart';
import 'package:habit_tracker/utils/colors.dart';

class GoalCompletionSettingsScreen extends StatefulWidget {
  const GoalCompletionSettingsScreen({super.key});

  @override
  State<GoalCompletionSettingsScreen> createState() => _GoalCompletionScreenState();
}

class _GoalCompletionScreenState extends State<GoalCompletionSettingsScreen> {
  String added = "";
  String day = "";
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? getUserID() {
    User? user = _auth.currentUser;
    return user?.uid;
  }

  int focus = 0;

  int workout = 0;
  int xp = 0;
  int screenhours = 0;
  int screenminutes = 0;

  String reason = "";
  int xpid = 0;
  int screen89 = 0;
  List<Map<String, dynamic>> dataList = [];
  Map<String, dynamic> userLabels = {};
  int remainingscreen = 0;
  String formattedDates2 = "";
  Future<Map<String, dynamic>> fetchUsers4() async {
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
            screen89 = userData['screenTime'];
          });

          // Example: Use the latitude and longitude data
          // SomeFunctionToUseLocation(latitude, longitude);
        }
      }
    } catch (error) {
      print("Failed to fetch users: $error");
    }
    String? firstDate;
    String? lastDate;
    try {
      QuerySnapshot snapshot = await goals
          .doc(currentUserUid)
          .collection('screen')
          .get(); // Use get() instead of snapshots() to fetch a single query snapshot

      for (var doc in snapshot.docs) {
        Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;
        dataList.add(userData);
        String addedAt = userData['addedAt'];

        if (firstDate == null || addedAt.compareTo(firstDate) < 0) {
          firstDate = addedAt;
        }
        if (lastDate == null || addedAt.compareTo(lastDate) > 0) {
          lastDate = addedAt;
        }
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
        screenprogress = double.parse(screenhours
            .toString()); // Convert sleephours to double if it's not already
        double totalExpectedSleep = screen89 *
            7; // Assuming 'sleep' represents the average daily sleep hours

        screenprogress = (screenprogress / totalExpectedSleep) * 100;
        remainingscreen = (totalExpectedSleep - screenhours).toInt();
      });
      // Now, calculate formattedDates
      if (firstDate != null && lastDate != null) {
        // Parse dates
        DateTime startDate = DateFormat("yyyy-MM-dd").parse(firstDate);
        DateTime endDate = DateFormat("yyyy-MM-dd").parse(lastDate);

        // Format dates
        // Format dates separately
        String formattedStartDate = DateFormat("MMMM dd").format(startDate);
        String formattedEndDate = DateFormat("dd, yyyy").format(endDate);

        // Update state with formattedDates
        setState(() {
          formattedDates2 = "$formattedStartDate-$formattedEndDate";
        });
      }
      logger.d(screenhours);
      logger.d(screenminutes);
      // This user document matches the current user
      // You can access the user data and do something with it
    } catch (error) {
      print("Failed to fetch users: $error");
    }
    return userLabels; // Return the list of Text widgets
  }

  CollectionReference goals = FirebaseFirestore.instance.collection('goals');
  int focushours = 0;
  double screenprogress = 0;
  int focusminutes = 0;
  double focusprogress = 0;
  int remainingfocus = 0;
  List<Map<String, dynamic>> dataList1 = [];
  Map<String, dynamic> userLabels1 = {};
  String formattedDates1 = "";
  Future<Map<String, dynamic>> fetchUsers5() async {
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
          });

          // Example: Use the latitude and longitude data
          // SomeFunctionToUseLocation(latitude, longitude);
        }
      }
    } catch (error) {
      print("Failed to fetch users: $error");
    }
    String? firstDate;
    String? lastDate;
    try {
      QuerySnapshot snapshot = await goals
          .doc(currentUserUid)
          .collection('focustimer')
          .get(); // Use get() instead of snapshots() to fetch a single query snapshot

      for (var doc in snapshot.docs) {
        Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;
        dataList1.add(userData);
        String addedAt = userData['addedAt'];

        if (firstDate == null || addedAt.compareTo(firstDate) < 0) {
          firstDate = addedAt;
        }
        if (lastDate == null || addedAt.compareTo(lastDate) > 0) {
          lastDate = addedAt;
        }
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
        focusprogress = double.parse(focushours
            .toString()); // Convert sleephours to double if it's not already
        double totalExpectedSleep = focus *
            7; // Assuming 'sleep' represents the average daily sleep hours

        focusprogress = (focusprogress / totalExpectedSleep) * 100;
        remainingfocus = (totalExpectedSleep - focushours).toInt();
      });
      // Now, calculate formattedDates
      if (firstDate != null && lastDate != null) {
        // Parse dates
        DateTime startDate = DateFormat("yyyy-MM-dd").parse(firstDate);
        DateTime endDate = DateFormat("yyyy-MM-dd").parse(lastDate);

        // Format dates
        // Format dates separately
        String formattedStartDate = DateFormat("MMMM dd").format(startDate);
        String formattedEndDate = DateFormat("dd, yyyy").format(endDate);

        // Update state with formattedDates
        setState(() {
          formattedDates1 = "$formattedStartDate-$formattedEndDate";
        });
      }
      logger.d(focushours);
      logger.d(focusminutes);
      // This user document matches the current user
      // You can access the user data and do something with it
    } catch (error) {
      print("Failed to fetch users: $error");
    }
    return userLabels1; // Return the list of Text widgets
  }

  double sleepprogress = 0;
  String sleephours = "0";
  double hello = 0;
  List<Map<String, dynamic>> dataList2 = [];
  Map<String, dynamic> userLabels2 = {};
  int sleep1 = 0;
  int remainingsleep = 0;
  String formattedDates = "";

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
      userLabels2['data'] = dataList2;
      logger.d(userLabels2);
      int totalHours = 0;

      userLabels2['data'].forEach((labelData) {
        setState(() {
          String hoursString = labelData['difference'];
          int hours =
              int.parse(hoursString.split('.')[0]); // Parse hours as integer
          totalHours += hours; // Accumulate hours
          hello = double.parse(totalHours
              .toString()); // Convert sleephours to double if it's not already
          sleephours = totalHours.toString();
          double totalExpectedSleep = sleep1 *
              7; // Assuming 'sleep' represents the average daily sleep hours

          sleepprogress = (hello / totalExpectedSleep) * 100;
          remainingsleep = (totalExpectedSleep - hello).toInt();
        });
      });

      // Now, calculate formattedDates
      if (firstDate != null && lastDate != null) {
        // Parse dates
        DateTime startDate = DateFormat("yyyy-MM-dd").parse(firstDate);
        DateTime endDate = DateFormat("yyyy-MM-dd").parse(lastDate);

        // Format dates
        // Format dates separately
        String formattedStartDate = DateFormat("MMMM dd").format(startDate);
        String formattedEndDate = DateFormat("dd, yyyy").format(endDate);

        // Update state with formattedDates
        setState(() {
          formattedDates = "$formattedStartDate-$formattedEndDate";
        });
      }
      logger.d(userLabels2);

      print(formattedDates);
      logger.d(sleephours);
      logger.d(sleepprogress);
      // This user document matches the current user
      // You can access the user data and do something with it
    } catch (error) {
      print("Failed to fetch users: $error");
    }
    return userLabels2; // Return the list of Text widgets
  }

  String intime = "0";
  String outtime = "0";
  List<Map<String, dynamic>> dataList3 = [];
  Map<String, dynamic> userLabels3 = {};
  int gymtotal = 0;
  double workoutprogress = 0;
  int remainingworkout = 0;
  String formattedDates3 = "";
  Future<Map<String, dynamic>> fetchUsers7() async {
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
            workout = userData['workoutFrequency'];
          });

          // Example: Use the latitude and longitude data
          // SomeFunctionToUseLocation(latitude, longitude);
        }
      }
    } catch (error) {
      print("Failed to fetch users: $error");
    }
    // Initialize firstDate and lastDate to null
    String? firstDate;
    String? lastDate;
    try {
      QuerySnapshot snapshot = await goals
          .doc(currentUserUid)
          .collection('workout')
          .get(); // Use get() instead of snapshots() to fetch a single query snapshot

      for (var doc in snapshot.docs) {
        Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;
        dataList3.add(userData);
        // Extract addedAt from each document and update firstDate and lastDate accordingly
        String addedAt = userData['addedAt'];

        if (firstDate == null || addedAt.compareTo(firstDate) < 0) {
          firstDate = addedAt;
        }
        if (lastDate == null || addedAt.compareTo(lastDate) > 0) {
          lastDate = addedAt;
        }
      }
      userLabels3['data'] = dataList3;
      logger.d(userLabels3);

      userLabels3['data'].forEach((labelData) {
        setState(() {
          int hoursString = labelData['frequency'];

          gymtotal += hoursString; // Accumulate hours
          // Convert sleephours to double if it's not already
          // Assuming 'sleep' represents the average daily sleep hours

          workoutprogress = (gymtotal / workout) * 100;
          remainingworkout = (workout - gymtotal);
        });
      });
      // Now, calculate formattedDates
      if (firstDate != null && lastDate != null) {
        // Parse dates
        DateTime startDate = DateFormat("yyyy-MM-dd").parse(firstDate);
        DateTime endDate = DateFormat("yyyy-MM-dd").parse(lastDate);

        // Format dates
        // Format dates separately
        String formattedStartDate = DateFormat("MMMM dd").format(startDate);
        String formattedEndDate = DateFormat("dd, yyyy").format(endDate);

        // Update state with formattedDates
        setState(() {
          formattedDates3 = "$formattedStartDate-$formattedEndDate";
        });
      }
      // This user document matches the current user
      // You can access the user data and do something with it
    } catch (error) {
      print("Failed to fetch users: $error");
    }
    return userLabels3; // Return the list of Text widgets
  }

  int totalXP = 0;
  int focusXP = 0;
  int workoutxp = 0;
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
        } else if (xpData['userID'] == _auth.currentUser?.uid &&
                xpData['reason'] == "Earned from Stopwatch" ||
            xpData['reason'] == "Earned from Focus Timer") {
          setState(() {
            focusXP += xpData['xp'] as int;
          });
        } else if (xpData['userID'] == _auth.currentUser?.uid &&
            xpData['reason'] == "Earned from Workout") {
          setState(() {
            workoutxp += xpData['xp'] as int;
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
    fetchUsers4();
    fetchUsers5();
    fetchUsers6();
    fetchUsers7();
    xpGet();
    super.initState();
  }

  final ValueNotifier<double> _valueNotifier = ValueNotifier(0);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: () async {
             
                // Navigate to the HomePage and remove all routes from the stack
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                  (route) => false,
                );
              },
            );
          },
        ),
        title: Text('Your Weekly Goals Summary'.tr(),
            style: TextStyle(
                color: Colors.black,
                fontFamily: 'SfProText',
                fontSize: 20.sp,
                fontWeight: FontWeight.w600)),
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.only(
          left: 12.0,
          right: 12,
        ),
        child: Column(
          children: [
            SizedBox(
              height: 5.h,
            ),
             Text(
              "Kindly note that your Weekly Goals Summary will be cleared upon pressing the back button. To retain the data, we suggest taking a screenshot of the screen.".tr(),
              textAlign: TextAlign.justify,
            ),
            SizedBox(
              height: 18.h,
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: AppColors.widgetColorV,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                        offset: const Offset(0, 0.5),
                        color: Colors.black.withOpacity(0.5))
                  ]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('Sleep Goals'.tr(),
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'SfProText',
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600)),
                      const Spacer(),
                      Text(formattedDates,
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'SfProText',
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600))
                    ],
                  ),
                  SizedBox(
                    height: 18.h,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        height: 100,
                        width: 100,
                        child: DashedCircularProgressBar.aspectRatio(
                          aspectRatio: 1, // width ÷ height
                          valueNotifier: _valueNotifier,
                          progress: sleepprogress,
                          startAngle: 225,
                          sweepAngle: 270,
                          foregroundColor: sleepprogress >= 70
                              ? CupertinoColors.systemGreen
                              : sleepprogress >= 40 && sleepprogress <= 70
                                  ? Colors.yellow
                                  : CupertinoColors.destructiveRed,
                          backgroundColor: const Color(0xffeeeeee),
                          foregroundStrokeWidth: 10,
                          backgroundStrokeWidth: 10,
                          animation: true,
                          seekSize: 6,
                          seekColor: const Color(0xffeeeeee),
                          child: Center(
                            child: ValueListenableBuilder(
                                valueListenable: _valueNotifier,
                                builder: (_, double value, __) => Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          '$sleephours/${sleep1 * 7} hrs',
                                          style: const TextStyle(
                                              fontFamily: "SfProText",
                                              color: Colors.black,
                                              fontWeight: FontWeight.w300,
                                              fontSize: 12),
                                        ),
                                        sleepprogress >= 70
                                            ?  Text(
                                                'Great!'.tr(),
                                                style: TextStyle(
                                                    color:
                                                        CupertinoColors.black,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 16),
                                              )
                                            : sleepprogress >= 40 &&
                                                    sleepprogress <= 70
                                                ?  Text(
                                                    'Good!'.tr(),
                                                    style: TextStyle(
                                                        color: CupertinoColors
                                                            .black,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 16),
                                                  )
                                                :  Text(
                                                    'Worst!'.tr(),
                                                    style: TextStyle(
                                                        color: CupertinoColors
                                                            .black,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 16),
                                                  ),
                                      ],
                                    )),
                          ),
                        ),
                      ),
                      const Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                              text: TextSpan(children: [
                            TextSpan(
                                text: 'Sleep Goal for the week'.tr(),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'SfProText',
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w400)),
                            TextSpan(
                                text: ': ${sleep1 * 7} hrs',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'SfProText',
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold)),
                          ])),
                          SizedBox(
                            height: 5.h,
                          ),
                          RichText(
                              text: TextSpan(children: [
                            TextSpan(
                                text: 'Sleep Hours Completed'.tr(),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'SfProText',
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w400)),
                            TextSpan(
                                text: ': $sleephours hrs',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'SfProText',
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold)),
                          ])),
                          SizedBox(
                            height: 5.h,
                          ),
                          RichText(
                              text: TextSpan(children: [
                            TextSpan(
                                text: 'Remaining Sleep Hours'.tr(),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'SfProText',
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w400)),
                            TextSpan(
                                text:
                                    ': ${remainingsleep < 0 ? 0 : remainingsleep} hrs',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'SfProText',
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold))
                          ])),
                          SizedBox(
                            height: 5.h,
                          ),
                          RichText(
                              text: TextSpan(children: [
                            TextSpan(
                                text: 'XP Collected'.tr(),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'SfProText',
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w400)),
                            TextSpan(
                                text: ': $totalXP',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'SfProText',
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold)),
                          ])),
                          SizedBox(
                            height: 5.h,
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 18.h,
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: AppColors.widgetColorR,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                        offset: const Offset(0, 0.5),
                        color: Colors.black.withOpacity(0.5))
                  ]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('Screentime'.tr(),
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'SfProText',
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600)),
                      const Spacer(),
                      Text(formattedDates2,
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'SfProText',
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600))
                    ],
                  ),
                  SizedBox(
                    height: 18.h,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        height: 100,
                        width: 100,
                        child: DashedCircularProgressBar.aspectRatio(
                          aspectRatio: 1, // width ÷ height
                          valueNotifier: _valueNotifier,
                          progress: screenprogress,
                          startAngle: 225,
                          sweepAngle: 270,
                          foregroundColor: screenprogress >= 70
                              ? CupertinoColors.systemGreen
                              : screenprogress >= 40 && screenprogress <= 70
                                  ? Colors.yellow
                                  : CupertinoColors.destructiveRed,
                          backgroundColor: const Color(0xffeeeeee),
                          foregroundStrokeWidth: 10,
                          backgroundStrokeWidth: 10,
                          animation: true,
                          seekSize: 6,
                          seekColor: const Color(0xffeeeeee),
                          child: Center(
                            child: ValueListenableBuilder(
                                valueListenable: _valueNotifier,
                                builder: (_, double value, __) => Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          '$screenhours/${screen89 * 7} hrs',
                                          style: const TextStyle(
                                              fontFamily: "SfProText",
                                              color: Colors.black,
                                              fontWeight: FontWeight.w300,
                                              fontSize: 12),
                                        ),
                                        screenprogress >= 70
                                            ?  Text(
                                                'Great!'.tr(),
                                                style: TextStyle(
                                                    color:
                                                        CupertinoColors.black,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 16),
                                              )
                                            : screenprogress >= 40 &&
                                                    screenprogress <= 70
                                                ?  Text(
                                                    'Good!'.tr(),
                                                    style: TextStyle(
                                                        color: CupertinoColors
                                                            .black,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 16),
                                                  )
                                                :  Text(
                                                    'Worst!'.tr(),
                                                    style: TextStyle(
                                                        color: CupertinoColors
                                                            .black,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 16),
                                                  ),
                                      ],
                                    )),
                          ),
                        ),
                      ),
                      const Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                              text: TextSpan(children: [
                            TextSpan(
                                text: 'Screentime for the Week'.tr(),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'SfProText',
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w400)),
                            TextSpan(
                                text: ': ${screen89 * 7} hrs',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'SfProText',
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold)),
                          ])),
                          SizedBox(
                            height: 5.h,
                          ),
                          RichText(
                              text: TextSpan(children: [
                            TextSpan(
                                text: 'Screentime Completed'.tr(),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'SfProText',
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w400)),
                            TextSpan(
                                text: ': $screenhours hrs',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'SfProText',
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold)),
                          ])),
                          SizedBox(
                            height: 5.h,
                          ),
                          RichText(
                              text: TextSpan(children: [
                            TextSpan(
                                text: 'Remaining Screentime'.tr(),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'SfProText',
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w400)),
                            TextSpan(
                                text:
                                    ': ${remainingscreen < 0 ? 0 : remainingscreen} hrs',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'SfProText',
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold)),
                          ])),
                          SizedBox(
                            height: 5.h,
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 18.h,
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: AppColors.widgetColorG,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                        offset: const Offset(0, 0.5),
                        color: Colors.black.withOpacity(0.5))
                  ]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('Focus Time'.tr(),
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'SfProText',
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600)),
                      const Spacer(),
                      Text(formattedDates1,
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'SfProText',
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600))
                    ],
                  ),
                  SizedBox(
                    height: 18.h,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        height: 100,
                        width: 100,
                        child: DashedCircularProgressBar.aspectRatio(
                          aspectRatio: 1, // width ÷ height
                          valueNotifier: _valueNotifier,
                          progress: focusprogress,
                          startAngle: 225,
                          sweepAngle: 270,
                          foregroundColor:   focusprogress >= 70
                              ? CupertinoColors.systemGreen
                              : focusprogress >= 40 && focusprogress <= 70
                                  ? Colors.yellow
                                  : CupertinoColors.destructiveRed,
                          backgroundColor: const Color(0xffeeeeee),
                          foregroundStrokeWidth: 10,
                          backgroundStrokeWidth: 10,
                          animation: true,
                          seekSize: 6,
                          seekColor: const Color(0xffeeeeee),
                          child: Center(
                            child: ValueListenableBuilder(
                                valueListenable: _valueNotifier,
                                builder: (_, double value, __) => Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          '$focushours/${focus * 7} hrs',
                                          style: const TextStyle(
                                              fontFamily: "SfProText",
                                              color: Colors.black,
                                              fontWeight: FontWeight.w300,
                                              fontSize: 12),
                                        ),
                                       
                                        focusprogress >= 70
                                            ?  Text(
                                                'Great!'.tr(),
                                                style: TextStyle(
                                                    color:
                                                        CupertinoColors.black,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 16),
                                              )
                                            : focusprogress >= 40 &&
                                                    focusprogress <= 70
                                                ?  Text(
                                                    'Good!'.tr(),
                                                    style: TextStyle(
                                                        color: CupertinoColors
                                                            .black,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 16),
                                                  )
                                                :  Text(
                                                    'Worst!'.tr(),
                                                    style: TextStyle(
                                                        color: CupertinoColors
                                                            .black,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 16),
                                                  ),
                                      ],
                                    )),
                          ),
                        ),
                      ),
                      const Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                              text: TextSpan(children: [
                            TextSpan(
                                text: 'Focus Goal for the Week'.tr(),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'SfProText',
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w400)),
                            TextSpan(
                                text: ': ${focus * 7} hrs',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'SfProText',
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold)),
                          ])),
                          SizedBox(
                            height: 5.h,
                          ),
                          RichText(
                              text: TextSpan(children: [
                            TextSpan(
                                text: 'Focus Hours Completed'.tr(),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'SfProText',
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w400)),
                            TextSpan(
                                text: ': $focushours hrs',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'SfProText',
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold)),
                          ])),
                          SizedBox(
                            height: 5.h,
                          ),
                          RichText(
                              text: TextSpan(children: [
                            TextSpan(
                                text: 'Remaining Focus Hours'.tr(),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'SfProText',
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w400)),
                            TextSpan(
                                text:
                                    ': ${remainingfocus < 0 ? 0 : remainingfocus} hrs',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'SfProText',
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold)),
                          ])),
                          SizedBox(
                            height: 5.h,
                          ),
                          RichText(
                              text: TextSpan(children: [
                            TextSpan(
                                text: 'XP Collected'.tr(),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'SfProText',
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w400)),
                            TextSpan(
                                text: ': $focusXP',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'SfProText',
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold)),
                          ])),
                          SizedBox(
                            height: 5.h,
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 18.h,
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: AppColors.widgetColorB,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                        offset: const Offset(0, 0.5),
                        color: Colors.black.withOpacity(0.5))
                  ]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('Workout Frequency'.tr(),
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'SfProText',
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600)),
                      const Spacer(),
                      Text(formattedDates3,
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'SfProText',
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600))
                    ],
                  ),
                  SizedBox(
                    height: 18.h,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        height: 100,
                        width: 100,
                        child: DashedCircularProgressBar.aspectRatio(
                          aspectRatio: 1, // width ÷ height
                          valueNotifier: _valueNotifier,
                          progress: workoutprogress,
                          startAngle: 225,
                          sweepAngle: 270,
                          foregroundColor: workoutprogress >= 70
                              ? CupertinoColors.systemGreen
                              : workoutprogress >= 40 && workoutprogress <= 70
                                  ? Colors.yellow
                                  : CupertinoColors.destructiveRed,
                          backgroundColor: const Color(0xffeeeeee),
                          foregroundStrokeWidth: 10,
                          backgroundStrokeWidth: 10,
                          animation: true,
                          seekSize: 6,
                          seekColor: const Color(0xffeeeeee),
                          child: Center(
                            child: ValueListenableBuilder(
                                valueListenable: _valueNotifier,
                                builder: (_, double value, __) => Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          '$gymtotal/$workout days',
                                          style: const TextStyle(
                                              fontFamily: "SfProText",
                                              color: Colors.black,
                                              fontWeight: FontWeight.w300,
                                              fontSize: 12),
                                        ),
                                        workoutprogress >= 70
                                            ?  Text(
                                                'Great!'.tr(),
                                                style: TextStyle(
                                                    color:
                                                        CupertinoColors.black,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 16),
                                              )
                                            : workoutprogress >= 40 &&
                                                    workoutprogress <= 70
                                                ?  Text(
                                                    'Good!'.tr(),
                                                    style: TextStyle(
                                                        color: CupertinoColors
                                                            .black,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 16),
                                                  )
                                                :  Text(
                                                    'Worst!'.tr(),
                                                    style: TextStyle(
                                                        color: CupertinoColors
                                                            .black,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 16),
                                                  ),
                                      ],
                                    )),
                          ),
                        ),
                      ),
                      const Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                              text: TextSpan(children: [
                            TextSpan(
                                text: 'Goal Workout Days'.tr(),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'SfProText',
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w400)),
                            TextSpan(
                                text: ': $workout days/week',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'SfProText',
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold)),
                          ])),
                          SizedBox(
                            height: 5.h,
                          ),
                          RichText(
                              text: TextSpan(children: [
                            TextSpan(
                                text: 'Completed Workout Days'.tr(),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'SfProText',
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w400)),
                            TextSpan(
                                text: ': $gymtotal days',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'SfProText',
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold)),
                          ])),
                          SizedBox(
                            height: 5.h,
                          ),
                          RichText(
                              text: TextSpan(children: [
                            TextSpan(
                                text: 'Remaining Days'.tr(),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'SfProText',
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w400)),
                            TextSpan(
                                text:
                                    ': ${remainingworkout < 0 ? 0 : remainingworkout}',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'SfProText',
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold)),
                          ])),
                          SizedBox(
                            height: 5.h,
                          ),
                          RichText(
                              text: TextSpan(children: [
                            TextSpan(
                                text: 'XP Collected'.tr(),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'SfProText',
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w400)),
                            TextSpan(
                                text: ': $workoutxp',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'SfProText',
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold)),
                          ])),
                          SizedBox(
                            height: 5.h,
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 18.h,
            ),
          ],
        ),
      )),
    );
  }
}
