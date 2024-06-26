import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:habit_tracker/pages/sleep_page/utils.dart';
import 'package:habit_tracker/services/goals_services.dart';
import 'package:habit_tracker/services/sleep_firestore_services.dart';
import 'package:habit_tracker/services/xp_firestore_services.dart';
import 'package:habit_tracker/utils/colors.dart';
import 'package:habit_tracker/utils/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WakeTime extends StatefulWidget {
  final Time sleepTime;
  const WakeTime({super.key, required this.sleepTime});
  @override
  State<WakeTime> createState() => _WakeTimeState();
}

class _WakeTimeState extends State<WakeTime> {
  Time _timeWake = Time(hour: 06, minute: 30, second: 20);
  bool iosStyle = true;
  int screenhours = 0;
  int screenminutes = 0;
  int focushours = 0;
  int focusminutes = 0;
  void sleepTimeSet(Time newTime) async {
    _timeWake = newTime;

    var startTime =
        DateTime(2024, 1, 1, widget.sleepTime.hour, widget.sleepTime.minute);
    var endTime = DateTime(2024, 1, 2, _timeWake.hour, _timeWake.minute);

    var difference = endTime.difference(startTime);

    await SleepFireStoreServices().addNewSleepTime(
      sleepTime:
          '${widget.sleepTime.hour}:${widget.sleepTime.minute.toString().padLeft(2, '0')}',
      wakeTime:
          '${_timeWake.hour}:${_timeWake.minute.toString().padLeft(2, '0')}',
      difference: SleepPageUtils().roundHourAndMinute(difference.inMinutes),
    );

    await XpFirestoreServices().addXp(
        xp: difference.inHours,
        reason: 'Earned from Sleep Wake Time',
        increment: true);

    // Add sleep time to GoalServices for the specific day
    await GoalServices().addNewSleepTime(
      sleepTime:
          '${widget.sleepTime.hour}:${widget.sleepTime.minute.toString().padLeft(2, '0')}',
      wakeTime:
          '${_timeWake.hour}:${_timeWake.minute.toString().padLeft(2, '0')}',
      difference: SleepPageUtils().roundHourAndMinute(difference.inMinutes),
    );

    SharedPreferences prefs = await SharedPreferences.getInstance();

    screenhours = prefs.getInt('screenhours')!.toInt();
    screenminutes = prefs.getInt('screenminutes')!.toInt();
    focushours = prefs.getInt('focusHours')!.toInt();
    focusminutes = prefs.getInt('focusMinutes')!.toInt();

    log(screenhours.toString());
    log(focushours.toString());
    await GoalServices().addNewScreenTime(
      minutes: screenminutes,
      hours: screenhours,
    );
    await GoalServices().addNewFocusTime(
      minutes: focusminutes,
      hours: focushours,
    );
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
                  'Wake Time'.tr(),
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
                value: _timeWake,
                onChange: sleepTimeSet,
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
