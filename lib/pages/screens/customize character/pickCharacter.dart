import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habit_tracker/pages/screens/customize%20character/customizeCharater.dart';
import 'package:habit_tracker/utils/colors.dart';
import 'package:habit_tracker/utils/icons.dart';
import 'package:habit_tracker/utils/images.dart';
import 'package:rive/rive.dart';

class PickCharacterPage extends StatefulWidget {
  const PickCharacterPage({super.key});

  @override
  State<PickCharacterPage> createState() => _PickCharacterPageState();
}

class _PickCharacterPageState extends State<PickCharacterPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        body: Container(
          margin: EdgeInsets.only(
              top: kIsWeb
                  ? 35.h
                  : Platform.isIOS
                      ? 50.h
                      : 25.h),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          "Pick Avatar".tr(),
                          style: TextStyle(
                              fontFamily: 'SFProText',
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w900,
                              color: AppColors.textBlack),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CustomizeCharacter(
                            filePath: "assets/character.riv",
                          ),
                        ),
                      );
                    },
                    splashColor: AppColors.primaryColor,
                    focusColor: AppColors.primaryColor,
                    child: Container(
                      height: 350.h,
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                              width: 1,
                              color: AppColors.black.withOpacity(0.3)),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      child: const RiveAnimation.asset(
                        "assets/character.riv",
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CustomizeCharacter(
                            filePath: "assets/female.riv",
                          ),
                        ),
                      );
                    },
                    splashColor: AppColors.primaryColor,
                    focusColor: AppColors.primaryColor,
                    child: Container(
                      height: 350.h,
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                              width: 1,
                              color: AppColors.black.withOpacity(0.5)),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      child: const RiveAnimation.asset(
                        "assets/female.riv",
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
