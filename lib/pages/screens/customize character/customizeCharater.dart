import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habit_tracker/utils/colors.dart';
import 'package:habit_tracker/utils/icons.dart';
import 'package:habit_tracker/utils/images.dart';

class CustomizeCharacter extends StatefulWidget {
  const CustomizeCharacter({super.key});

  @override
  State<CustomizeCharacter> createState() => _CustomizeCharacterState();
}

class _CustomizeCharacterState extends State<CustomizeCharacter> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        body: Container(
          margin: EdgeInsets.only(top: kIsWeb ? 35.h :Platform.isIOS ? 50.h : 30),
          child: Column(
            children: [
              topBar(),
              SizedBox(
                height:kIsWeb ? 20.h : Platform.isIOS ? 5.h : 20.h,
              ),
              Expanded(
                child: ListView(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(30.r),
                                topRight: Radius.circular(30.r),
                              ),
                              border: Border(
                                left: BorderSide.none,
                                top: BorderSide(
                                    width: 1.w, color: Color(0xFFD0D0D0)),
                                right: BorderSide(
                                    width: 1.w, color: Color(0xFFD0D0D0)),
                                bottom: BorderSide(
                                    width: 1.w, color: Color(0xFFD0D0D0)),
                              )),
                          child: Column(
                            children: [
                              // eye
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20.w, vertical: 15.h),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        width: 1.w, color: Color(0xFFD0D0D0)),
                                  ),
                                ),
                                child: SvgPicture.asset(
                                  AppIcons.eye,
                                  height: 30.h,
                                ),
                              ),
                              // eyebrow
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20.w, vertical: 15.h),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor,
                                  border: Border(
                                    bottom: BorderSide(
                                        width: 1.w, color: Color(0xFFD0D0D0)),
                                  ),
                                ),
                                child: SvgPicture.asset(
                                  AppIcons.eyebrow,
                                  height: 30.h,
                                ),
                              ),
                              // nose
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20.w, vertical: 15.h),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        width: 1.w, color: Color(0xFFD0D0D0)),
                                  ),
                                ),
                                child: SvgPicture.asset(
                                  AppIcons.nose,
                                  height: 30.h,
                                ),
                              ),

                              // hairstyle
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20.w, vertical: 15.h),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        width: 1.w, color: Color(0xFFD0D0D0)),
                                  ),
                                ),
                                child: SvgPicture.asset(
                                  AppIcons.hairstyle,
                                  height: 30.h,
                                ),
                              ),

                              // glasses
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20.w, vertical: 15.h),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        width: 1.w, color: Color(0xFFD0D0D0)),
                                  ),
                                ),
                                child: SvgPicture.asset(
                                  AppIcons.glasses,
                                  height: 30.h,
                                ),
                              ),

                              // mouth
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20.w, vertical: 15.h),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        width: 1.w, color: Color(0xFFD0D0D0)),
                                  ),
                                ),
                                child: SvgPicture.asset(
                                  AppIcons.mouth,
                                  height: 30.h,
                                ),
                              ),

                              // people
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20.w, vertical: 15.h),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        width: 1.w, color: Color(0xFFD0D0D0)),
                                  ),
                                ),
                                child: SvgPicture.asset(
                                  AppIcons.people,
                                  height: 30.h,
                                ),
                              ),
                              // shoes
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20.w, vertical: 15.h),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        width: 1.w, color: Color(0xFFD0D0D0)),
                                  ),
                                ),
                                child: SvgPicture.asset(
                                  AppIcons.shoes,
                                  height: 30.h,
                                ),
                              ),

                              // mustache

                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20.w, vertical: 15.h),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        width: 1.w, color: Color(0xFFD0D0D0)),
                                  ),
                                ),
                                child: SvgPicture.asset(
                                  AppIcons.mustache,
                                  height: 30.h,
                                ),
                              ),
                              // tshirt
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20.w, vertical: 15.h),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        width: 1.w, color: Color(0xFFD0D0D0)),
                                  ),
                                ),
                                child: SvgPicture.asset(
                                  AppIcons.tshirt,
                                  height: 30.h,
                                ),
                              ),
                              // pant

                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20.w, vertical: 15.h),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        width: 1.w, color: Color(0xFFD0D0D0)),
                                  ),
                                ),
                                child: SvgPicture.asset(
                                  AppIcons.pant,
                                  height: 30.h,
                                ),
                              ),
                              // lipstick
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20.w, vertical: 15.h),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        width: 1.w, color: Color(0xFFD0D0D0)),
                                  ),
                                ),
                                child: SvgPicture.asset(
                                  AppIcons.lipstick,
                                  height: 30.h,
                                ),
                              ),

                              // headband

                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20.w, vertical: 15.h),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        width: 1.w, color: Color(0xFFD0D0D0)),
                                  ),
                                ),
                                child: SvgPicture.asset(
                                  AppIcons.headband,
                                  height: 30.h,
                                ),
                              ),
                              // beard
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20.w, vertical: 15.h),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        width: 1.w, color: Color(0xFFD0D0D0)),
                                  ),
                                ),
                                child: SvgPicture.asset(
                                  AppIcons.beard,
                                  height: 30.h,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // next section

                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(30.r),
                                topRight: Radius.circular(30.r),
                              ),
                              border: Border(
                                left: BorderSide.none,
                                top: BorderSide(
                                    width: 1.w, color: Color(0xFFD0D0D0)),
                                right: BorderSide(
                                    width: 1.w, color: Color(0xFFD0D0D0)),
                                bottom: BorderSide(
                                    width: 1.w, color: Color(0xFFD0D0D0)),
                              )),
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.w, vertical: 15.h),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        width: 1.w, color: Color(0xFFD0D0D0)),
                                  ),
                                ),
                                child: Image.asset(
                                  "assets/images/eyebrow.png",
                                  height: 20.h,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.w, vertical: 15.h),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        width: 1.w, color: Color(0xFFD0D0D0)),
                                  ),
                                ),
                                child: Image.asset(
                                  "assets/images/eyebrow.png",
                                  height: 20.h,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.w, vertical: 15.h),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        width: 1.w, color: Color(0xFFD0D0D0)),
                                  ),
                                ),
                                child: Image.asset(
                                  "assets/images/eyebrow.png",
                                  height: 20.h,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.w, vertical: 15.h),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        width: 1.w, color: Color(0xFFD0D0D0)),
                                  ),
                                ),
                                child: Image.asset(
                                  "assets/images/eyebrow.png",
                                  height: 20.h,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.w, vertical: 15.h),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        width: 1.w, color: Color(0xFFD0D0D0)),
                                  ),
                                ),
                                child: Image.asset(
                                  "assets/images/eyebrow.png",
                                  height: 20.h,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.w, vertical: 15.h),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        width: 1.w, color: Color(0xFFD0D0D0)),
                                  ),
                                ),
                                child: Image.asset(
                                  "assets/images/eyebrow.png",
                                  height: 20.h,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.w, vertical: 15.h),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        width: 1.w, color: Color(0xFFD0D0D0)),
                                  ),
                                ),
                                child: Image.asset(
                                  "assets/images/eyebrow.png",
                                  height: 20.h,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.w, vertical: 15.h),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        width: 1.w, color: Color(0xFFD0D0D0)),
                                  ),
                                ),
                                child: Image.asset(
                                  "assets/images/eyebrow.png",
                                  height: 20.h,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.w, vertical: 15.h),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        width: 1.w, color: Color(0xFFD0D0D0)),
                                  ),
                                ),
                                child: Image.asset(
                                  "assets/images/eyebrow.png",
                                  height: 20.h,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.w, vertical: 15.h),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        width: 1.w, color: Color(0xFFD0D0D0)),
                                  ),
                                ),
                                child: Image.asset(
                                  "assets/images/eyebrow.png",
                                  height: 20.h,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.w, vertical: 15.h),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        width: 1.w, color: Color(0xFFD0D0D0)),
                                  ),
                                ),
                                child: Image.asset(
                                  "assets/images/eyebrow.png",
                                  height: 20.h,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.w, vertical: 15.h),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        width: 1.w, color: Color(0xFFD0D0D0)),
                                  ),
                                ),
                                child: Image.asset(
                                  "assets/images/eyebrow.png",
                                  height: 20.h,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.w, vertical: 15.h),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        width: 1.w, color: Color(0xFFD0D0D0)),
                                  ),
                                ),
                                child: Image.asset(
                                  "assets/images/eyebrow.png",
                                  height: 20.h,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.w, vertical: 15.h),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        width: 0.w, color: Color(0xFFD0D0D0)),
                                  ),
                                ),
                                child: Image.asset(
                                  "assets/images/eyebrow.png",
                                  height: 20.h,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 40.w,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Image.asset(
                              AppImages.characterFull,
                              height: 450.h,
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10.w, vertical: 5.h),
                                  decoration: ShapeDecoration(
                                    color: AppColors.primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(100.r),
                                        topRight: Radius.circular(8.r),
                                        bottomLeft: Radius.circular(100.r),
                                        bottomRight: Radius.circular(8.r),
                                      ),
                                    ),
                                  ),
                                  child: SvgPicture.asset(
                                    AppIcons.undo,
                                    color: Colors.black.withOpacity(0.75),
                                  ),
                                ),
                                SizedBox(
                                  width: 5.w,
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10.w, vertical: 5.h),
                                  decoration: ShapeDecoration(
                                    color: AppColors.primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(8.r),
                                        topRight: Radius.circular(100.r),
                                        bottomLeft: Radius.circular(8.r),
                                        bottomRight: Radius.circular(100.r),
                                      ),
                                    ),
                                  ),
                                  child: SvgPicture.asset(
                                    AppIcons.redo,
                                    color: Colors.black.withOpacity(0.75),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Padding topBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              height: 40.h,
              width: 40.w,
              alignment: Alignment.center,
              decoration: ShapeDecoration(
                  color: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100.r),
                  )),
              child: SvgPicture.asset(
                AppIcons.cross,
                height: 20.h,
                color: Colors.black.withOpacity(0.75),
              ),
            ),
          ),
          Container(
            height: 40.h,
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            decoration: ShapeDecoration(
              color: AppColors.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            child: Text(
              'Save',
              style: TextStyle(
                color: AppColors.textBlack,
                fontSize: 18.sp,
                fontFamily: 'SFProText',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
