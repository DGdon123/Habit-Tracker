import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:habit_tracker/utils/colors.dart';

class AppTextStyles {
  static TextStyle loginSignupText = TextStyle(
    fontFamily: 'SFProText',
    fontSize: 36.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.textBlack,
  );

  // Add more text styles as needed
  static TextStyle secondaryLogin = TextStyle(
      fontFamily: 'SFProText',
      fontSize: 16.sp,
      fontWeight: FontWeight.w500,
      color: Color.fromRGBO(0, 0, 0, 0.75));

  // Add more text styles as needed
  static TextStyle accountSetup = TextStyle(
    fontFamily: 'SFProText',
    fontSize: 32.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.textBlack,
  );
}
