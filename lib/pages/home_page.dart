import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habit_tracker/pages/screens/focus.dart';
import 'package:habit_tracker/pages/screens/home.dart';
import 'package:habit_tracker/pages/screens/stats.dart';
import 'package:habit_tracker/pages/sleep_page/sleep_page.dart';
import 'package:habit_tracker/provider/index_provider.dart';
import 'package:habit_tracker/utils/colors.dart';
import 'package:habit_tracker/utils/icons.dart';
import 'package:provider/provider.dart';

import 'profile_page/profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
      ),
      child: Scaffold(
        body: _getPage(),
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
                backgroundColor: AppColors.mainColor,
                currentIndex: context.watch<IndexProvider>().selectedIndex,
                onTap: (index) {
                  context.read<IndexProvider>().setSelectedIndex(index);
                  debugPrint("Index: $index");
                },
                items: [
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      AppIcons.sleep,
                      height: 20.h,
                      color: context.watch<IndexProvider>().selectedIndex == 0
                          ? AppColors.highLightColor
                          : Colors.white,
                    ),
                    label: 'Sleep'.tr(),
                  ),
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(AppIcons.stats,
                        height: 20.h,
                        color: context.watch<IndexProvider>().selectedIndex == 1
                            ? AppColors.highLightColor
                            : Colors.white),
                    label: 'Stats'.tr(),
                  ),
                  const BottomNavigationBarItem(
                    icon: Icon(
                      Icons.home,
                      color: Colors.transparent,
                    ),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(AppIcons.timer,
                        height: 20.h,
                        color: context.watch<IndexProvider>().selectedIndex == 3
                            ? AppColors.highLightColor
                            : Colors.white),
                    label: 'Timer'.tr(),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.person_outline,
                      size: 20.h,
                      color: context.watch<IndexProvider>().selectedIndex == 4
                          ? AppColors.highLightColor
                          : Colors.white,
                    ),
                    label: 'Profile'.tr(),
                  ),
                ],
              ),
            ),
            GestureDetector(
                onTap: () {
                  context.read<IndexProvider>().setSelectedIndex(2);
                },
                child: Image.asset(
                  AppIcons.home,
                  width: 50,
                  color: context.watch<IndexProvider>().selectedIndex == 2
                      ? AppColors.highLightColor
                      : AppColors.black.withOpacity(0.5),
                )),
          ],
        ),
      ),
    );
  }

  Widget _getPage() {
    switch (context.watch<IndexProvider>().selectedIndex) {
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
        return Center(child: Text('Unknown Page'.tr()));
    }
  }
}
