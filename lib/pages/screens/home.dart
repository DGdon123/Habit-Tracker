import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habit_tracker/auth/repositories/gymtime_model.dart';
import 'package:habit_tracker/auth/repositories/new_gymtime_model.dart';
import 'package:habit_tracker/auth/widgets/gym_in_time.dart';
import 'package:habit_tracker/location/current_location.dart';
import 'package:habit_tracker/pages/screens/customize%20character/pickCharacter.dart';
import 'package:habit_tracker/pages/screens/friends.dart';
import 'package:habit_tracker/pages/screens/widgets/start_end_time_picker.dart';
import 'package:habit_tracker/pages/sleep_page/widgets/sleep_wake_display_card.dart';
import 'package:habit_tracker/pages/sleep_page/widgets/start_end_date_picker.dart';
import 'package:habit_tracker/pages/usage_page/usage_page.dart';
import 'package:habit_tracker/provider/gym_time_provider.dart';
import 'package:habit_tracker/provider/index_provider.dart';
import 'package:habit_tracker/services/device_screen_time_services.dart';
import 'package:habit_tracker/services/local_storage_services.dart';
import 'package:habit_tracker/services/sleep_firestore_services.dart';
import 'package:habit_tracker/services/xp_firestore_services.dart';
import 'package:habit_tracker/utils/colors.dart';
import 'package:habit_tracker/utils/icons.dart';
import 'package:habit_tracker/utils/images.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import 'customize character/customizeCharater.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextStyle headingStyle = TextStyle(
    fontFamily: 'SFProText',
    fontWeight: FontWeight.w600,
    fontSize: 14.sp,
    color: Colors.black.withOpacity(0.65),
  );

  @override
  void initState() {
    getLastLocationTime();
    getLastLocationTime1();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Column(
        children: [
          const SizedBox(
            height: 5,
          ),
          appbar(),
          // character
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Image.asset(
                    AppImages.characterFull,
                    height: 450.h,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        wakeSleepTime(),
                        screenTime(),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        workoutTime(),
                        focusTime(),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }

  Column wakeSleepTime() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Wake up      Sleep   '.tr(),
          style: headingStyle,
        ),
        SizedBox(
          height: 5.h,
        ),
        GestureDetector(
          onTap: () {
            context.read<IndexProvider>().setSelectedIndex(0);
          },
          child: Container(
            width: 180.w,
            height: 100.h,
            decoration: ShapeDecoration(
              color: AppColors.widgetColorV,
              // gradient: LinearGradient(
              //   begin: Alignment.bottomLeft,
              //   end: Alignment.topRight,
              //   colors: [
              //     Color(0xFF007566),
              //     Color(0xFF47EFDA),
              //   ],
              // ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: StreamBuilder<QuerySnapshot>(
                  stream: SleepFireStoreServices().listenToTodayAddedSleepTime,
                  builder: (context, snapshot) {
                    debugPrint("Snapshot: ${snapshot.data?.docs.length}");

                    var snapshotLength = snapshot.data?.docs.length;

                    // we got data
                    if (snapshot.hasData &&
                        snapshot.connectionState == ConnectionState.active &&
                        snapshotLength != 0) {
                      var doc = snapshot.data!.docs[0];

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.light_mode,
                                color: Colors.yellow.shade600,
                                size: 34.sp,
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              Text(
                                doc.get("wakeTime"),
                                style: TextStyle(
                                  color: AppColors.black,
                                  fontSize: 20.sp,
                                  fontFamily: 'SFProText',
                                  fontWeight: FontWeight.w800,
                                  height: 0,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.dark_mode_rounded,
                                color: Colors.yellow.shade600,
                                size: 30.sp,
                              ),
                              SizedBox(
                                height: 12.h,
                              ),
                              Text(
                                doc.get("sleepTime"),
                                style: TextStyle(
                                  color: AppColors.black,
                                  fontSize: 20.sp,
                                  fontFamily: 'SFProText',
                                  fontWeight: FontWeight.w800,
                                  height: 0,
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    } else if (snapshotLength == 0) {
                      return Center(
                          child: Text("Add your sleep and wake time.".tr()));
                    } else if (snapshot.hasError) {
                      return Text('Something went wrong'.tr());
                    }
                    return const SizedBox();
                  }),
            ),
          ),
        ),
      ],
    );
  }

  // screen time widget

  Column screenTime() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Screen Time'.tr(),
          style: headingStyle,
        ),
        SizedBox(
          height: 5.h,
        ),
        Container(
          width: 180.w,
          height: 100.h,
          decoration: ShapeDecoration(
            color: AppColors.widgetColorR,
            // gradient: LinearGradient(
            //   begin: Alignment.bottomRight,
            //    end: Alignment.topLeft,
            //   colors: [
            //     Color(0xFF0F32ED),
            //     Color(0xFF5FDCCC),
            //   ],
            // ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  AppIcons.phone,
                  width: 40,
                  color: AppColors.lightBlack,
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    FutureBuilder<Map<String, dynamic>>(
                        future: DeviceScreenTimeServices().getUsageStats(),
                        builder: (_, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const SizedBox();
                          } else if (snapshot.hasError) {
                            return Text("Error".tr());
                          }

                          var duration = snapshot.data!["usage"] as Duration;

                          var hours = duration.inHours % 60;
                          var minutes = duration.inMinutes % 60;

                          return Text(
                            '$hours:$minutes h',
                            style: TextStyle(
                              color: AppColors.black,
                              fontSize: 24.sp,
                              fontFamily: 'SFProText',
                              fontWeight: FontWeight.w800,
                              height: 0,
                            ),
                          );
                        }),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // workout time
  String? dateString;
  String timeString = "00:00:00";
  String? dateString1;
  String timeString1 = "00:00:00";
  Future<DateTime?> getLastLocationTime() async {
    try {
      // Initialize Hive

      // Open the Hive box where user location times are stored
      var box = await Hive.openBox<DataModel>('hive_box');

      // Get the last added dataModel instance from the box
      DataModel? lastDataModel =
          box.isNotEmpty ? box.getAt(box.length - 1) : null;

      // Extract the date and time from the lastDataModel instance
      if (lastDataModel != null) {
        setState(() {
          dateString = lastDataModel.date;
          timeString = lastDataModel.time!;
        });

        var dateTimeString = '$dateString $timeString';
        log('DataModel1: $dateTimeString');
        return DateTime.parse(dateTimeString);
      }
      // Close the Hive box
      await box.close();
    } catch (error) {
      print('Failed to retrieve last location time: $error');
    }
    return null;
  }

  Future<DateTime?> getLastLocationTime1() async {
    try {
      // Initialize Hive

      // Open the Hive box where user location times are stored
      var box = await Hive.openBox<DataModel1>('hive_box1');

      // Get the last added dataModel instance from the box
      DataModel1? lastDataModel =
          box.isNotEmpty ? box.getAt(box.length - 1) : null;

      // Extract the date and time from the lastDataModel instance
      if (lastDataModel != null) {
        setState(() {
          dateString1 = lastDataModel.date;
          timeString1 = lastDataModel.time!;
        });

        var dateTimeString = '$dateString $timeString';
        log('DataModel2: $dateTimeString');
        return DateTime.parse(dateTimeString);
      }
      // Close the Hive box
      await box.close();
    } catch (error) {
      print('Failed to retrieve last location time: $error');
    }
    return null;
  }

  Column workoutTime() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Today\'s Workout',
          style: headingStyle,
        ),
        SizedBox(
          height: 5.h,
        ),
        Container(
          width: 180.w,
          height: 100.h,
          decoration: ShapeDecoration(
            color: AppColors.widgetColorB,
            // gradient: LinearGradient(
            //   begin: Alignment.bottomLeft,
            //   end: Alignment.topRight,
            //   colors: [
            //     Color.fromARGB(255, 4, 87, 76),
            //     Color(0xFF00D0B5),
            //   ],
            // ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
            ),
          ),
          child: FutureBuilder<bool>(
              future: LocalStorageServices().isAutomaticSelected(),
              builder: (_, data) {
                debugPrint("Data Home.dart: ${data.data}");

                if (data.hasData && data.data == false) {
                  return GestureDetector(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (_) {
                            return GymInTime();
                          });

                      var inTime = context.watch<GymTimeProvider>().gymInTime;
                      var outTime = context.watch<GymTimeProvider>().gymOutTime;

                      debugPrint("In Time: $inTime, Out Time: $outTime");
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Center(
                        child: Text("Click to add today's workout.".tr()),
                      ),
                    ),
                  );
                } else if (data.hasData && data.data == true) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              AppIcons.workout,
                              width: 45,
                              color: AppColors.lightBlack,
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  timeString.toString(),
                                  style: TextStyle(
                                    color: AppColors.black,
                                    fontSize: 19.sp,
                                    fontFamily: 'SFProText',
                                    fontWeight: FontWeight.w800,
                                    height: 0,
                                  ),
                                ),
                                Text(
                                  'to'.tr(),
                                  style: TextStyle(
                                    color: AppColors.black.withOpacity(0.7),
                                    fontSize: 16.sp,
                                    fontFamily: 'SFProText',
                                    fontWeight: FontWeight.w800,
                                    height: 0,
                                  ),
                                ),
                                Text(
                                  timeString1.toString(),
                                  style: TextStyle(
                                    color: AppColors.black,
                                    fontSize: 19.sp,
                                    fontFamily: 'SFProText',
                                    fontWeight: FontWeight.w800,
                                    height: 0,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox();
              }),
        ),
      ],
    );
  }

  // focus time widget

  Column focusTime() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Focused Time'.tr(),
          style: headingStyle,
        ),
        SizedBox(
          height: 5.h,
        ),
        Container(
          width: 180.w,
          height: 100.h,
          decoration: ShapeDecoration(
            color: AppColors.widgetColorG,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 0,
                bottom: 0,
                right: 0,
                child: SvgPicture.asset(
                  AppIcons.timer,
                  height: 80.h,
                  color: Colors.white.withOpacity(0.3),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          AppIcons.foucsed,
                          width: 40,
                          color: AppColors.lightBlack,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '4:39 h',
                              style: TextStyle(
                                color: AppColors.black,
                                fontSize: 28.sp,
                                fontFamily: 'SFProText',
                                fontWeight: FontWeight.w800,
                                height: 0,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10.w, vertical: 5.w),
                              decoration: ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      width: 1.w, color: AppColors.black),
                                  borderRadius: BorderRadius.circular(100.r),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Start Now'.tr(),
                                    style: TextStyle(
                                      color: AppColors.black,
                                      fontSize: 10.sp,
                                      fontFamily: 'SFProText',
                                      fontWeight: FontWeight.w600,
                                      height: 0,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Padding appbar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FriendsPage(),
                    ),
                  );
                },
                child: Container(
                    height: 50.h,
                    width: 50.w,
                    decoration: BoxDecoration(
                      color: AppColors.mainColor,
                      borderRadius: BorderRadius.all(Radius.circular(16.r)),
                    ),
                    alignment: Alignment.center,
                    child: SvgPicture.asset(
                      AppIcons.friends,
                      color: Colors.white,
                      height: 25.h,
                      width: 25.w,
                    )),
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const CurrentLocation();
                      },
                    ),
                  );
                },
                child: Container(
                    height: 50.h,
                    width: 50.w,
                    decoration: BoxDecoration(
                      color: AppColors.mainColor,
                      borderRadius: BorderRadius.all(Radius.circular(16.r)),
                    ),
                    alignment: Alignment.center,
                    child: SvgPicture.asset(
                      AppIcons.customize,
                      color: Colors.white,
                      height: 35.h,
                      width: 35.w,
                    )),
              ),
            ],
          ),
          TextButton(
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UsagePage(),
                  ),
                );
              },
              child: Text("Usage".tr())),
          Container(
            margin: const EdgeInsets.only(top: 10),
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 100,
                  width: 100,
                  child: Image.asset(AppIcons.xpbar),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 45),
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    width: 60,
                    child: Text(
                      '99000',
                      style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontFamily: 'SFProText',
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w900,
                        color: AppColors.black,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 57),
                  child: Text(
                    'XP',
                    style: TextStyle(
                      fontFamily: 'SFProText',
                      fontSize: 23.sp,
                      fontWeight: FontWeight.normal,
                      color: AppColors.black,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
