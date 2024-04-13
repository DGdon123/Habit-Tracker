import 'dart:developer';

import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:habit_tracker/pages/sleep_page/utils.dart';
import 'package:habit_tracker/services/goals_services.dart';
import 'package:habit_tracker/services/gym_firestore_services.dart';
import 'package:habit_tracker/services/sleep_firestore_services.dart';
import 'package:habit_tracker/services/xp_firestore_services.dart';
import 'package:habit_tracker/utils/colors.dart';
import 'package:habit_tracker/utils/styles.dart';
import 'package:provider/provider.dart';

class GymOutTime extends StatefulWidget {
  final Time inTime;
  const GymOutTime({super.key, required this.inTime});

  @override
  State<GymOutTime> createState() => _GymOutTimeState();
}

class _GymOutTimeState extends State<GymOutTime> {
  final Time _gymOutTime = Time(hour: 06, minute: 30, second: 20);
  bool iosStyle = true;

  void gymTimeSet(Time newTime) async {
   
    await GymFirestoreServices()
        .upload(inTime: widget.inTime, outTime: newTime);
    await GoalServices()
        .addNewGymTime(inTime: widget.inTime, outTime: newTime, );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      alignment: Alignment.center,
      elevation: 0,
      backgroundColor: const Color.fromRGBO(255, 0, 0, 0),

      // Render inline widget
      content: Container(
        height: 550.h,
        width: 350.w,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(16.r)),
        child: Column(
          children: [
            SizedBox(
              height: 10.h,
            ),
            Row(
              children: [
                SizedBox(
                  width: 5.w,
                ),
                Text(
                  'Gym Out Time'.tr(),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24.sp,
                    fontFamily: 'SFProText',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10.h,
            ),
            SizedBox(
              child: showPicker(
                onCancel: () {
                  Navigator.pop(context);
                },
                dialogInsetPadding:
                    EdgeInsets.symmetric(horizontal: 0.w, vertical: 0.h),
                unselectedColor: const Color.fromRGBO(0, 0, 0, 0.75),
                hourLabel: 'Hour'.tr(),
                minuteLabel: 'Minutes'.tr(),
                // width: 350.w,
                // height: 470.h,
                // wheelHeight: 300.h,

                cancelStyle: TextStyle(
                  color: const Color.fromARGB(255, 255, 0, 0).withOpacity(0.75),
                  fontSize: 16.sp,
                  fontFamily: 'SFProText',
                  fontWeight: FontWeight.w500,
                ),
                okText: 'Save'.tr(),
                okStyle: TextStyle(
                  color: AppColors.mainBlue,
                  fontSize: 16.sp,
                  fontFamily: 'SFProText',
                  fontWeight: FontWeight.w500,
                ),
                isInlinePicker: true,
                elevation: 0,
                value: _gymOutTime,
                onChange: gymTimeSet,
                minuteInterval: TimePickerInterval.FIVE,
                iosStylePicker: iosStyle,
                minHour: 0,
                maxHour: 21,
                is24HrFormat: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
