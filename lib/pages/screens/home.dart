import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habit_tracker/location/current_location.dart';
import 'package:habit_tracker/pages/screens/customize%20character/pickCharacter.dart';
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sleep Time',
          style: headingStyle,
        ),
        SizedBox(
          height: 10.h,
        ),
        Container(
          width: 180.w,
          height: 90.h,
          decoration: ShapeDecoration(
            gradient: const LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: [
                Color(0xFF007566),
                Color(0xFF47EFDA),
              ],
            ),
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
                      Icons.mode_night,
                      color: Colors.white,
                      size: 18.sp,
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      '23:00',
                      style: TextStyle(
                        color: Colors.white,
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
                      Icons.light_mode,
                      color: Colors.white,
                      size: 20.sp,
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      '06:00',
                      style: TextStyle(
                        color: Colors.white,
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Screen Time',
          style: headingStyle,
        ),
        SizedBox(
          height: 10.h,
        ),
        Container(
          width: 180.w,
          height: 90.h,
          decoration: ShapeDecoration(
            gradient: const LinearGradient(
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
              colors: [
                Color(0xFF0F32ED),
                Color(0xFF5FDCCC),
              ],
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '6h 14m',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40.sp,
                        fontFamily: 'SFProText',
                        fontWeight: FontWeight.w600,
                        height: 0,
                      ),
                    ),
                    Row(
                      children: [
                        SvgPicture.asset(
                          AppIcons.status,
                          color: Colors.white.withOpacity(0.75),
                          height: 12.h,
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        Text(
                          '12% from last week',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.75),
                            fontSize: 12.sp,
                            fontFamily: 'SFProText',
                            fontWeight: FontWeight.w400,
                            height: 0,
                          ),
                        ),
                      ],
                    )
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Workout',
          style: headingStyle,
        ),
        SizedBox(
          height: 10.h,
        ),
        Container(
          width: 180.w,
          height: 100.h,
          decoration: ShapeDecoration(
            gradient: const LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: [
                Color.fromARGB(255, 4, 87, 76),
                Color(0xFF00D0B5),
              ],
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Joined at',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontFamily: 'SFProText',
                            fontWeight: FontWeight.w500,
                            height: 0,
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Text(
                          '06:00',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.sp,
                            fontFamily: 'SFProText',
                            fontWeight: FontWeight.w800,
                            height: 0,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Left at',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontFamily: 'SFProText',
                            fontWeight: FontWeight.w500,
                            height: 0,
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Text(
                          '06:00',
                          style: TextStyle(
                            color: Colors.white,
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
                SizedBox(
                  height: 8.h,
                ),
                Row(
                  children: [
                    SvgPicture.asset(
                      AppIcons.status,
                      color: Colors.white.withOpacity(0.75),
                      height: 12.h,
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    Text(
                      '12% from last week',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.75),
                        fontSize: 12.sp,
                        fontFamily: 'SFProText',
                        fontWeight: FontWeight.w400,
                        height: 0,
                      ),
                    ),
                  ],
                )
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Focused Time',
          style: headingStyle,
        ),
        SizedBox(
          height: 10.h,
        ),
        Stack(
          children: [
            Container(
              width: 180.w,
              height: 100.h,
              decoration: ShapeDecoration(
                gradient: const LinearGradient(
                  begin: Alignment(-0.97, -0.22),
                  end: Alignment(0.97, 0.22),
                  colors: [
                    Color(0x5E0028FF),
                    Color(0xFF2AC5B1),
                  ],
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Focus Timer',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10.sp,
                            fontFamily: 'SFProText',
                            fontWeight: FontWeight.w600,
                            height: 0,
                          ),
                        ),
                        Text(
                          '00:47:39',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28.sp,
                            fontFamily: 'SFProText',
                            fontWeight: FontWeight.w800,
                            height: 0,
                          ),
                        ),
                        SizedBox(
                          height: 3.h,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 5.w),
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(width: 1.w, color: Colors.white),
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
                                  color: Colors.white,
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
              ),
            ),
            Positioned(
              top: 0,
              bottom: 0,
              right: 0,
              child: SvgPicture.asset(
                AppIcons.timer,
                height: 100.h,
              ),
            ),
          ],
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
                  color: AppColors.black,
                  height: 35.h,
                  width: 35.w,
                )),
          ),
          Container(
            height: 40.h,
            decoration: BoxDecoration(
              color: AppColors.mainBlue,
              borderRadius: BorderRadius.all(Radius.circular(16.r)),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Row(
                children: [
                  SvgPicture.asset(
                    AppIcons.xp,
                    height: 20.h,
                    width: 20.w,
                  ),
                  SizedBox(
                    width: 5.w,
                  ),
                  Text(
                    '1452 XP',
                    style: TextStyle(
                      fontFamily: 'SFProText',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.white,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
