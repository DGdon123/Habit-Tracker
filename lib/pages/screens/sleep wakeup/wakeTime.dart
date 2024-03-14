import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:habit_tracker/utils/colors.dart';
import 'package:habit_tracker/utils/styles.dart';

class WakeTime extends StatefulWidget {
  @override
  State<WakeTime> createState() => _WakeTimeState();
}

class _WakeTimeState extends State<WakeTime> {
  Time _timeWake = Time(hour: 06, minute: 30, second: 20);
  bool iosStyle = true;

  void sleepTimeSet(Time newTime) {
    setState(() {
      _timeWake = newTime;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      alignment: Alignment.center,
      elevation: 0,
      backgroundColor: Color.fromRGBO(255, 0, 0, 0),

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
                  'Wake Time',
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
                unselectedColor: Color.fromRGBO(0, 0, 0, 0.75),
                hourLabel: 'Hour',
                minuteLabel: 'Minutes',
                // width: 350.w,
                // height: 470.h,
                // wheelHeight: 300.h,
                hideButtons: true,
                cancelStyle: TextStyle(
                  color: Color.fromARGB(255, 255, 0, 0).withOpacity(0.75),
                  fontSize: 16.sp,
                  fontFamily: 'SFProText',
                  fontWeight: FontWeight.w500,
                ),
                okText: 'Save',
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
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
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
                        "Save",
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
