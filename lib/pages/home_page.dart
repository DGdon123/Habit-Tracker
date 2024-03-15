import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habit_tracker/pages/screens/focus.dart';
import 'package:habit_tracker/pages/screens/friends.dart';
import 'package:habit_tracker/pages/screens/home.dart';
import 'package:habit_tracker/pages/screens/profile.dart';

import 'package:habit_tracker/pages/screens/stats.dart';
import 'package:habit_tracker/pages/sleep_page/sleep_page.dart';
import 'package:habit_tracker/utils/colors.dart';
import 'package:habit_tracker/utils/icons.dart';
import 'package:habit_tracker/utils/images.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _currentIndex = 2;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
      ),
      child: Scaffold(
        body: _getPage(_currentIndex),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Container(
          height: 90.h,
          width: 90.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: AppColors.mainBlue,
          ),
          child: FloatingActionButton(
            elevation: 10,
            shape: CircleBorder(),
            backgroundColor: AppColors.mainBlue,
            child: SvgPicture.asset(AppIcons.focus, height: 50.h),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FocusPage(),
                ),
              );
            },
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          notchMargin: 8,
          clipBehavior: Clip.none,
          color: Color.fromARGB(255, 242, 247, 255),
          padding: EdgeInsets.zero,
          height: 80.h,
          shape: CircularNotchedRectangle(),
          child: BottomNavigationBar(
            iconSize: 28.h,
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            selectedItemColor: AppColors.mainBlue,
            selectedLabelStyle: TextStyle(
              color: AppColors.mainBlue,
              fontSize: 12.sp,
              fontFamily: 'SF Pro Text',
              fontWeight: FontWeight.w400,
              height: 0,
            ),
            unselectedItemColor: Colors.black,
            unselectedLabelStyle: TextStyle(
              color: Colors.black,
              fontSize: 12.sp,
              fontFamily: 'SF Pro Text',
              fontWeight: FontWeight.w400,
              height: 0,
            ),
            backgroundColor: Color.fromARGB(0, 255, 0, 0),
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            items: [
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  AppIcons.friends,
                  height: 20.h,
                  color: _currentIndex == 0
                      ? AppColors.mainBlue
                      : const Color.fromARGB(255, 0, 0, 0),
                ),
                label: 'Friends',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  AppIcons.stats,
                  height: 20.h,
                  color: _currentIndex == 1
                      ? AppColors.mainBlue
                      : const Color.fromARGB(255, 0, 0, 0),
                ),
                label: 'Stats',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.person,
                  color: Colors.transparent,
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  AppIcons.sleep,
                  height: 20.h,
                  color: _currentIndex == 3
                      ? AppColors.mainBlue
                      : const Color.fromARGB(255, 0, 0, 0),
                ),
                label: 'Sleep',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.person_outline,
                  size: 20.h,
                  color: _currentIndex == 4
                      ? AppColors.mainBlue
                      : const Color.fromARGB(255, 0, 0, 0),
                ),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return FriendsPage();
      case 1:
        return StatsPage();
      case 2:
        return Home();
      case 3:
        return SleepPage();
      case 4:
        return ProfilePage();
      default:
        return Center(child: Text('Unknown Page'));
    }
  }
}
