import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:habit_tracker/pages/screens/sleep%20wakeup/wakeTime.dart';
import 'package:habit_tracker/utils/colors.dart';

class SleepTime extends StatefulWidget {
  @override
  State<SleepTime> createState() => _SleepTimeState();
}

class _SleepTimeState extends State<SleepTime> {
  Time _time = Time(hour: 20, minute: 30);
  bool iosStyle = true;

  void onTimeChanged(Time newTime) {
    setState(() {
      _time = newTime;
    });
    Navigator.pop(context);
    debugPrint("Sleep time: $newTime");
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      alignment: Alignment.center,
      elevation: 0,
      backgroundColor: Color.fromRGBO(255, 0, 0, 0),

      // Render inline widget
      content: Container(
        width: 350.w,
        height: 550.h,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(16.r)),
        child: Column(
          children: [
            SizedBox(
              height: 10.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Sleep Time',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24.sp,
                      fontFamily: 'SFProText',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            SizedBox(
              child: showPicker(
                showCancelButton: false,
                onCancel: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return WakeTime(); // Use the custom dialog
                    },
                  );
                },
                themeData: ThemeData(
                  fontFamily: 'SFProText',
                ),
                dialogInsetPadding:
                    EdgeInsets.symmetric(horizontal: 0.w, vertical: 0.h),
                unselectedColor: Color.fromRGBO(0, 0, 0, 0.75),
                hourLabel: 'Hour',
                minuteLabel: 'Minutes',
                // wheelHeight: 300.h,
                hideButtons: false,
                cancelStyle: TextStyle(
                  color: Color.fromARGB(255, 255, 0, 0).withOpacity(0.75),
                  fontSize: 16.sp,
                  fontFamily: 'SFProText',
                  fontWeight: FontWeight.w500,
                ),

                okText: 'Save',
                isInlinePicker: true,
                elevation: 0,
                value: _time,
                onChange: onTimeChanged,
                isOnChangeValueMode: false,

                minuteInterval: TimePickerInterval.FIVE,
                iosStylePicker: iosStyle,

                is24HrFormat: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
