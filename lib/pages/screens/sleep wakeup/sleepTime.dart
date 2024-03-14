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
  Time _time = Time(hour: 20, minute: 30, second: 20);
  bool iosStyle = true;

  void onTimeChanged(Time newTime) {
    setState(() {
      _time = newTime;
    });
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
                  // Text(
                  //   '${_time.hour}:${_time.minute}',
                  // ),
                ],
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            SizedBox(
              child: showPicker(
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
                hideButtons: true,
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
                onChangeDateTime: (DateTime dateTime) {
                  int hour = dateTime.hour;
                  int minute = dateTime.minute;
                  print(hour);
                  print(minute);
                },
                minuteInterval: TimePickerInterval.FIVE,
                iosStylePicker: iosStyle,
                minHour: 0,
                maxHour: 21,
                is24HrFormat: false,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return WakeTime(); // Use the custom dialog
                        },
                      );
                    },
                    child: Container(
                      decoration: ShapeDecoration(
                        color: Color(0xFF00FFDE),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(1000),
                        ),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.w),
                      child: Text(
                        "Next",
                        style: TextStyle(
                          color: AppColors.textBlack,
                          fontSize: 18.sp,
                          fontFamily: 'SFProText',
                          fontWeight: FontWeight.w500,
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
    );
  }
}
