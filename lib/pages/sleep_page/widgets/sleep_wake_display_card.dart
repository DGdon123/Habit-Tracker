import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:habit_tracker/utils/text_styles.dart';

class SleepWakeDisplayCard extends StatelessWidget {
  final Color bgColor;
  final String time;
  final String title;

  const SleepWakeDisplayCard(
      {super.key,
      required this.bgColor,
      required this.time,
      required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width * 0.45,
      padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 20.h),
      decoration: ShapeDecoration(
        color: bgColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyles().sleepTimeSmallStyle,
          ),
          SizedBox(
            height: 5.h,
          ),
          Text(
            time,
            style: TextStyles().sleepTimeBigStyle,
          )
        ],
      ),
    );
  }
}
