import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habit_tracker/location/current_location.dart';
import 'package:habit_tracker/pages/screens/customize%20character/pickCharacter.dart';
import 'package:habit_tracker/pages/screens/friends.dart';
import 'package:habit_tracker/services/device_screen_time_services.dart';
import 'package:habit_tracker/utils/colors.dart';
import 'package:habit_tracker/utils/icons.dart';
import 'package:habit_tracker/utils/images.dart';

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
                        sleepTime(),
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
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }

  Column sleepTime() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Wake up      Sleep   ',
          style: headingStyle,
        ),
        SizedBox(
          height: 5.h,
        ),
        Container(
          width: 180.w,
          height: 100.h,
          decoration: ShapeDecoration(
            color: const Color(0xfbd4bcdf),
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.light_mode,
                      color: AppColors.lightBlack,
                      size: 34.sp,
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      '06:00',
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
                      color: AppColors.lightBlack,
                      size: 30.sp,
                    ),
                    SizedBox(
                      height: 12.h,
                    ),
                    Text(
                      '23:00',
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
          'Screen Time',
          style: headingStyle,
        ),
        SizedBox(
          height: 5.h,
        ),
        Container(
          width: 180.w,
          height: 100.h,
          decoration: ShapeDecoration(
            color: const Color(0xfbf6c9ce),
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
                    Text(
                      '3:00 h',
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: 28.sp,
                        fontFamily: 'SFProText',
                        fontWeight: FontWeight.w800,
                        height: 0,
                      ),
                    ),
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
            color: const Color(0xfbafdcde),
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
          child: Padding(
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
                          '16:00',
                          style: TextStyle(
                            color: AppColors.black,
                            fontSize: 23.sp,
                            fontFamily: 'SFProText',
                            fontWeight: FontWeight.w800,
                            height: 0,
                          ),
                        ),
                        Text(
                          'to',
                          style: TextStyle(
                            color: AppColors.black.withOpacity(0.7),
                            fontSize: 16.sp,
                            fontFamily: 'SFProText',
                            fontWeight: FontWeight.w800,
                            height: 0,
                          ),
                        ),
                        Text(
                          '18:00',
                          style: TextStyle(
                            color: AppColors.black,
                            fontSize: 23.sp,
                            fontFamily: 'SFProText',
                            fontWeight: FontWeight.w800,
                            height: 0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
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
          'Focused Time',
          style: headingStyle,
        ),
        SizedBox(
          height: 5.h,
        ),
        Container(
          width: 180.w,
          height: 100.h,
          decoration: ShapeDecoration(
            color: const Color(0xfbc9eeb5),
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
                                    'Start Now',
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
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(16.r)),
                    ),
                    alignment: Alignment.center,
                    child: SvgPicture.asset(
                      AppIcons.friends,
                      color: Colors.black,
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
                      builder: (context) => const CurrentLocation(),
                    ),
                  );
                },
                child: Container(
                    height: 50.h,
                    width: 50.w,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(16.r)),
                    ),
                    alignment: Alignment.center,
                    child: SvgPicture.asset(
                      AppIcons.customize,
                      color: Colors.black,
                      height: 35.h,
                      width: 35.w,
                    )),
              ),
            ],
          ),
          TextButton(
              onPressed: () async {
                final duration =
                    await DeviceScreenTimeServices().getUsageStats();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("Total duration: $duration"),
                ));
              },
              child: const Text("Usage")),
          Container(
            margin: const EdgeInsets.only(top: 10),
            child: Stack(
              alignment: Alignment.center,
              children: [
                SvgPicture.asset(
                  AppIcons.mainxp,
                  height: 34,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 38),
                  child: Text(
                    '1450',
                    style: TextStyle(
                      fontFamily: 'SFProText',
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w900,
                      color: AppColors.white,
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
