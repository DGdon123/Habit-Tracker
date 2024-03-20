import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'colors.dart';

class TextStyles {
  TextStyle sleepTimeSmallStyle = TextStyle(
    color: AppColors.white,
    fontSize: 14.sp,
    fontFamily: 'SFProText',
    fontWeight: FontWeight.w500,
  );

  TextStyle sleepTimeBigStyle = TextStyle(
    color: AppColors.white,
    fontSize: 22.sp,
    fontFamily: 'SFProText',
    fontWeight: FontWeight.w800,
  );

  // title style
  TextStyle titleStyle = TextStyle(
    color: AppColors.textBlack,
    fontSize: 24.sp,
    fontFamily: 'SFProText',
    fontWeight: FontWeight.w600,
  );

  // subtitle style
  TextStyle subtitleStyle = TextStyle(
    color: AppColors.textBlack,
    fontSize: 16.sp,
    fontFamily: 'SFProText',
    fontWeight: FontWeight.w500,
  );

  // secondary

  TextStyle secondaryTextStyle(double fontSize, FontWeight fontWeight) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: Colors.black.withOpacity(0.75),
      fontFamily: 'SFProText',
    );
  }
}
