import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habit_tracker/pages/home_page.dart';
import 'package:habit_tracker/pages/profile_page/widgets/friends_list_view.dart';
import 'package:habit_tracker/pages/profile_page/widgets/received_friend_request.dart';
import 'package:habit_tracker/pages/screens/settings/settings.dart';
import 'package:habit_tracker/services/user_firestore_services.dart';
import 'package:habit_tracker/utils/colors.dart';
import 'package:habit_tracker/utils/icons.dart';
import 'package:habit_tracker/utils/images.dart';

import '../friend_searched_page/friend_searched_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? getUsername() {
    User? user = _auth.currentUser;
    return user?.displayName;
  }

  final List<Widget> _pages = [
    const ActivityPage(),
    const FriendsPageTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        body: DefaultTabController(
          length: 2,
          child: Container(
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          "Profile",
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
                  height: 30.h,
                ),
                topBar(),
                SizedBox(
                  height: 30.h,
                ),
                tabBar(),
                SizedBox(
                  height: 20.h,
                ),
                Container(
                  decoration: const ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 1,
                        strokeAlign: BorderSide.strokeAlignCenter,
                        color: Color(0xFFD0D0D0),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    child: TabBarView(
                      children: _pages,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding tabBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.r),
          color: const Color.fromARGB(255, 236, 251, 249),
        ),
        child: TabBar(
          splashBorderRadius: BorderRadius.circular(100.r),
          labelPadding: EdgeInsets.zero,
          dividerHeight: 0,
          padding: EdgeInsets.symmetric(horizontal: 0.w),
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorWeight: 0,
          indicator: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(100.r)),
          unselectedLabelColor: const Color(0xFF686873),
          labelStyle: TextStyle(
            color: Colors.black,
            fontSize: 14.sp,
            fontFamily: 'SFProText',
            fontWeight: FontWeight.w600,
          ),
          tabs: const [
            Tab(text: 'Activity'),
            Tab(text: 'Friends'),
          ],
        ),
      ),
    );
  }

  Padding topBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Column(
                children: [
                  Image.asset(
                    AppImages.profileavatar,
                    height: 70.h,
                    width: 70.w,
                  ),
                ],
              ),
              SizedBox(
                width: 10.w,
              ),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  getUsername() ?? 'User Name',
                  style: TextStyle(
                    color: AppColors.textBlack,
                    fontSize: 20.sp,
                    fontFamily: 'SFProText',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  height: 5.h,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  decoration: ShapeDecoration(
                    color: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r)),
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        AppIcons.xp,
                      ),
                      Text(
                        '1452 XP',
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.75),
                          fontSize: 14.sp,
                          fontFamily: 'SFProText',
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
                  ),
                )
              ]),
            ],
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SettingsPage()));
            },
            child: Container(
                width: 48.h,
                height: 48.w,
                alignment: Alignment.center,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 1, color: Color(0xFFEAECF0)),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                ),
                child: SvgPicture.asset(
                  AppIcons.setting,
                  height: 24.h,
                )),
          ),
        ],
      ),
    );
  }
}

class FriendsPageTab extends StatefulWidget {
  const FriendsPageTab({super.key});

  @override
  State<FriendsPageTab> createState() => _FriendsPageTabState();
}

class _FriendsPageTabState extends State<FriendsPageTab> {
  String searchText = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor.withOpacity(0.15),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
            child: Row(
              children: [
                // searching friends based on their name
                Expanded(
                    child: TextField(
                  cursorColor: AppColors.mainColor,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      focusColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(vertical: 10),
                      prefixIcon: Icon(
                        Icons.search,
                        color: CupertinoColors.systemGrey,
                      ),
                      hintStyle: TextStyle(
                        color: CupertinoColors.systemGrey,
                      ),
                      hintText: 'Search Friends',
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide:
                              BorderSide(color: AppColors.blue, width: 1)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(
                              color: AppColors.widgetColorB, width: 0.4))),
                  onChanged: (value) {
                    setState(() {
                      searchText = value;
                    });
                  },
                )),
                SizedBox(
                  width: 20.w,
                ),
                GestureDetector(
                  onTap: searchText.isEmpty
                      ? null
                      : () async {
                          final users = await UserFireStoreServices()
                              .searchUserByUserName(searchText);

                          if (users.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("User not found")));
                            return;
                          }

                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => FriendSearchedPage(
                                    searchResults: users,
                                  )));
                        },
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              blurRadius: .2,
                              offset: Offset(0.0, 0.5),
                              color: Colors.black.withOpacity(0.5))
                        ],
                        color: AppColors.mainColor,
                        borderRadius: BorderRadius.circular(12)),
                    child: Center(
                        child: Text(
                      'Search',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontFamily: 'SFProText'),
                    )),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 5.h,
          ),
          const ReceivedFriendRequest(),
          SizedBox(
            height: 5.h,
          ),
          Expanded(child: FriendsListView()),
        ],
      ),
    );
  }
}

class ActivityPage extends StatelessWidget {
  const ActivityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor.withOpacity(0.15),
      body: Column(
        children: [
          SizedBox(
            height: 5.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Activity of this week',
                  style: TextStyle(
                    color: const Color(0xFF040415),
                    fontSize: 16.sp,
                    fontFamily: 'SFProText',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SvgPicture.asset(
                  AppIcons.dropdown,
                )
              ],
            ),
          ),
          SizedBox(
            height: 5.h,
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              itemCount: 15, // Number of items you want to repeat
              itemBuilder: (BuildContext context, int index) {
                return AchievmentsContainer(); // Your container widget
              },
            ),
          ),
        ],
      ),
    );
  }
}

Widget AchievmentsContainer() {
  return Container(
    margin: EdgeInsets.only(bottom: 10.h),
    padding: const EdgeInsets.all(16),
    decoration: ShapeDecoration(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        side: const BorderSide(width: 1, color: Color(0xFFEAECF0)),
        borderRadius: BorderRadius.circular(16.r),
      ),
      shadows: const [
        BoxShadow(
          color: Color(0x0F222C5C),
          blurRadius: 68,
          offset: Offset(58, 26),
          spreadRadius: 0,
        ),
      ],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '129 XP Earned',
                  style: TextStyle(
                    color: const Color(0xFF040415),
                    fontSize: 16.sp,
                    fontFamily: 'SFProText',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Today, 12:30',
                  style: TextStyle(
                    color: const Color(0xFF9B9BA1),
                    fontSize: 14.sp,
                    fontFamily: 'SF Pro Text',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            )
          ],
        ),
        GestureDetector(
          onTap: () {},
          child: SvgPicture.asset(
            AppIcons.achievmentsarrow,
            height: 32.h,
          ),
        ),
      ],
    ),
  );
}
