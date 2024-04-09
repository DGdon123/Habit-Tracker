import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:habit_tracker/utils/colors.dart';
import 'package:habit_tracker/utils/icons.dart';

class WorkoutData extends StatelessWidget {
  final String outTime;
  final String inTime;
  const WorkoutData({super.key, required this.outTime, required this.inTime});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
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
              inTime,
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
              outTime,
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
    );
  }
}
