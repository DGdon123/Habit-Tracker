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

  TextStyle secondaryTextStyle(double fontSize, FontWeight fontWeight) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: Colors.black.withOpacity(0.75),
      fontFamily: 'SFProText',
    );
  }
}
