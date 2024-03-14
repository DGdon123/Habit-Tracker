import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:habit_tracker/utils/colors.dart';

class AppTextFieldStyles {
  static InputDecoration standardInputDecoration({
    String? hintText,
    String? labelText,
    TextInputType? keyboardType,
    TextStyle? textStyle,
  }) {
    return InputDecoration(
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: AppColors.seperatorColor,
          width: 2.w, // Change the width as needed
        ),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: AppColors.seperatorColor,
          width: 2.w, // Change the width as needed
        ),
      ),
      floatingLabelStyle: TextStyle(
          color: AppColors.black,
          fontFamily: 'SFProText',
          fontSize: 16.sp,
          fontWeight: FontWeight.w400),
      border: const UnderlineInputBorder(
        borderSide: BorderSide(
            color: AppColors.seperatorColor), // Adjust the color as needed
      ),
      labelText: labelText ?? 'Enter text',
      hintText: hintText ?? 'Hint text',
      labelStyle: TextStyle(
          color: AppColors.black,
          fontFamily: 'SFProText',
          fontSize: 16.sp,
          fontWeight: FontWeight.w500),
      hintStyle: TextStyle(
          color: AppColors.hintColor,
          fontFamily: 'SFProText',
          fontSize: 18.sp,
          fontWeight: FontWeight.w500),
    );
  }

  // Add more TextField styles as needed
}
