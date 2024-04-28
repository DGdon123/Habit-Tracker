import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habit_tracker/pages/home_page.dart';
import 'package:habit_tracker/pages/profile_page/widgets/friends_list_view.dart';
import 'package:habit_tracker/utils/colors.dart';
import 'package:habit_tracker/utils/icons.dart';
import 'package:habit_tracker/utils/images.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

  @override
  State<FriendsPage> createState() => FriendsPageState();
}

class FriendsPageState extends State<FriendsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Container(
        margin: EdgeInsets.only(
            top: kIsWeb
                ? 35.h
                : Platform.isIOS
                    ? 50.h
                    : 35.h),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomePage()));
                    },
                    child: SizedBox(
                      height: 28.h,
                      width: 28.w,
                      child: SvgPicture.asset(
                        AppIcons.back,
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      "Friends".tr(),
                      style: TextStyle(
                          fontFamily: 'SFProText',
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textBlack),
                    ),
                  ),
                  SizedBox(
                    height: 28.h,
                    width: 28.w,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30.h,
            ),
             const Expanded(child: FriendsListView()),
          ],
        ),
      ),
    );
  }

  
}
