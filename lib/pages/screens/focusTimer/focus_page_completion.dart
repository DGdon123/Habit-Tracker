import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:habit_tracker/utils/colors.dart';
import 'package:habit_tracker/utils/images.dart';
import 'package:hive/hive.dart';

class FocusTimerComplete extends StatelessWidget {
  const FocusTimerComplete({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            children: [
              SizedBox(
                height: 130.h,
              ),
              Text(
                'Good Job!',
                style: TextStyle(
                    fontFamily: 'SfProText',
                    fontSize: 65.sp,
                    fontWeight: FontWeight.w600),
              ),
              Image.asset(
                AppImages.characterFull,
                height: 450.h,
              ),
              SizedBox(
                height: 40.h,
              ),
              Text(
                '1 hour 24 min 5 sec',
                style: TextStyle(
                    fontFamily: 'SfProText',
                    fontSize: 35.sp,
                    fontWeight: FontWeight.w400),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 12),
                decoration: BoxDecoration(
                    color: AppColors.widgetColorG,
                    borderRadius: BorderRadius.circular(12)),
                child: Text(
                  '+10 XP',
                  style: TextStyle(
                      fontFamily: 'SfProText',
                      fontSize: 35.sp,
                      fontWeight: FontWeight.w600),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
