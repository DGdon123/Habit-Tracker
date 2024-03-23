import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habit_tracker/pages/screens/focus.dart';
import 'package:habit_tracker/pages/screens/home.dart';
import 'package:habit_tracker/pages/screens/profile.dart';
import 'package:habit_tracker/pages/screens/sleep.dart';
import 'package:habit_tracker/pages/screens/stats.dart';
import 'package:habit_tracker/utils/colors.dart';
import 'package:habit_tracker/utils/icons.dart';

class HomePage extends StatefulWidget {
  int? initialIndex;
  HomePage({this.initialIndex, super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int? _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex ?? 2;
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
      ),
      child: Scaffold(
        body: _getPage(_currentIndex!),
        bottomNavigationBar: Stack(
          alignment: Alignment.center,
          children: [
            BottomAppBar(
              surfaceTintColor: Colors.transparent,
              elevation: 0,
              notchMargin: 8,
              clipBehavior: Clip.none,
              color: const Color.fromARGB(255, 242, 247, 255),
              padding: EdgeInsets.zero,
              height: 70,
              shape: const CircularNotchedRectangle(),
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
                backgroundColor: const Color(0xfbf1f4ff),
                currentIndex: _currentIndex!,
                onTap: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                items: [
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      AppIcons.sleep,
                      height: 20.h,
                      color: _currentIndex == 0
                          ? AppColors.mainBlue
                          : const Color.fromARGB(255, 0, 0, 0),
                    ),
                    label: 'Sleep',
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
                  const BottomNavigationBarItem(
                    icon: Icon(
                      Icons.home,
                      color: Colors.transparent,
                    ),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      AppIcons.timer,
                      height: 20.h,
                      color: _currentIndex == 3
                          ? AppColors.mainBlue
                          : const Color.fromARGB(255, 0, 0, 0),
                    ),
                    label: 'Timer',
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
            GestureDetector(
                onTap: () {
                  setState(() {
                    _currentIndex = 2;
                  });
                },
                child: Image.asset(
                  AppIcons.home,
                  width: 50,
                  color: _currentIndex == 2
                      ? AppColors.mainBlue
                      : AppColors.black.withOpacity(0.5),
                )),
          ],
        ),
      ),
    );
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return const SleepPage();
      case 1:
        return const StatsPage();
      case 2:
        return const Home();
      case 3:
        return const FocusPage();
      case 4:
        return const ProfilePage();
      default:
        return const Center(child: Text('Unknown Page'));
    }
  }
}
