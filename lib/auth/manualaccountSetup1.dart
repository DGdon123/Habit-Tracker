import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:carp_background_location/carp_background_location.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart' as img;
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:day_night_time_picker/lib/daynight_timepicker.dart';
import 'package:day_night_time_picker/lib/state/time.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:habit_tracker/auth/repositories/gymtime_model.dart';
import 'package:habit_tracker/auth/repositories/new_gymtime_model.dart';
import 'package:habit_tracker/auth/repositories/user_repository.dart';
import 'package:habit_tracker/location/current_location.dart';
import 'package:habit_tracker/pages/home_page.dart';
import 'package:habit_tracker/pages/screens/customize%20character/pickCharacter.dart';
import 'package:habit_tracker/provider/dob_provider.dart';
import 'package:habit_tracker/provider/goals_provider.dart';
import 'package:habit_tracker/provider/location_provider.dart';
import 'package:habit_tracker/utils/colors.dart';
import 'package:habit_tracker/utils/icons.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:habit_tracker/utils/styles.dart';
import 'package:hive/hive.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:roundcheckbox/roundcheckbox.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/local_storage_services.dart';
import '../services/user_firestore_services.dart';

class ManualAccountSetup1 extends StatefulWidget {
  final String? username;
  final String? email;
  final String? photoURL;
  final String? uid;

  const ManualAccountSetup1(
      {super.key, this.username, this.email, this.photoURL, this.uid});
  @override
  State<ManualAccountSetup1> createState() => _AccountSetupState();
}

class _AccountSetupState extends State<ManualAccountSetup1> {
  late final PageController _pageController;
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _pageController.addListener(() {
      setState(() {
        currentPage = _pageController.page!.round();
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  bool hello = false;
  final bool _isUploading = false;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserRepository>(context);
    final dob = Provider.of<SelectedDateProvider>(context, listen: false);

    var dobis = dob.selectedDate ?? DateTime.now();
    var dateString = dobis.toString().split(' ')[0]; // Extract date part
    log(dateString); // Log only the date part

    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.arrow_back_rounded,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            );
          },
        ),
        title: Text(
          "Create Account".tr(),
          style: TextStyle(
              fontFamily: 'SFProText',
              fontSize: 22.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textBlack),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (int page) {
                setState(() {
                  currentPage = page;
                });
              },
              children: const [
                PickCharacterPage(),
                SetUpGoals(),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        2, // Replace with the total number of pages
                        (index) => Container(
                          margin: EdgeInsets.symmetric(horizontal: 4.0.w),
                          width: currentPage == index
                              ? 15.w
                              : 10.w, // Adjust size as needed
                          height: currentPage == index
                              ? 15.h
                              : 10.h, // Adjust size as needed

                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: currentPage == index
                                  ? AppColors.buttonYellow // Active page color
                                  : AppColors
                                      .secondaryColor // Inactive page color
                              ),
                        ),
                      ),
                    )
                  ],
                ),
                GestureDetector(
                  onTap: () async {
                    if (currentPage < _pageController.page!.round()) {
                      // You are going back to a previous page
                      _pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      // You are going forward to the next page
                      if (currentPage < 1) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        if (currentPage == 1) {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          String token =
                              prefs.getString('device_token').toString();

                          final goalProvider = Provider.of<GoalsProvider>(
                              context,
                              listen: false);
                          var sleep = goalProvider.goals;
                          var screen = goalProvider.goals1;
                          var focus = goalProvider.goals2;
                          var workout = goalProvider.goals3;
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) =>  AlertDialog(
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  CircularProgressIndicator(
                                    color: AppColors.mainBlue,
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'Please wait, your account is creating...'.tr(),
                                  ),
                                ],
                              ),
                            ),
                          );
                          // Check if lat and longi are not null before using them

                          await UserFireStoreServices().manualaddUser(
                            sleep: sleep,
                            screen: screen,
                            focus: focus,
                            workout: workout,
                            devicetoken: token,
                            uid: widget.uid?.toString() ??
                                "", // Check for null and provide a default value
                            email: widget.email?.toString() ??
                                "", // Check for null and provide a default value
                            name: widget.username?.toString() ??
                                "", // Check for null and provide a default value
                            photoUrl: widget.photoURL?.toString() ??
                                "", // Check for null and provide a default value
                          );
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomePage(),
                            ),
                          );
                        }
                      }
                    }
                  },
                  child: Row(
                    children: [
                      Text(
                        currentPage == 1 ? 'Finish'.tr() : 'Next'.tr(),
                        style: TextStyle(
                          color: AppColors.buttonYellow,
                          fontFamily: 'SFProText',
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(
                        height: 28.h,
                        width: 28.w,
                        child: SvgPicture.asset(
                          AppIcons.forward,
                          color: AppColors.buttonYellow,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20.h,
          )
        ],
      ),
    );
  }
}


class AccountSetupSleeptime extends StatefulWidget {
  const AccountSetupSleeptime({super.key});

  @override
  State<AccountSetupSleeptime> createState() => _AccountSetupSleeptimeState();
}

class _AccountSetupSleeptimeState extends State<AccountSetupSleeptime> {
  Time _time = Time(hour: 08, minute: 30, second: 20);
  bool iosStyle = true;

  void onTimeChanged(Time newTime) {
    setState(() {
      _time = newTime;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 50.h,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
            children: [
              Text(
                'What’s your wake up\ntime?',
                style: AppTextStyles.accountSetup,
              ),
            ],
          ),
        ),
        SizedBox(
          height: 50.h,
        ),

        // Render inline widget
        showPicker(
          unselectedColor: const Color.fromRGBO(0, 0, 0, 0.75),
          hourLabel: 'Hour'.tr(),
          minuteLabel: 'Minutes'.tr(),
          wheelHeight: 200.h,
          hideButtons: true,
          dialogInsetPadding: const EdgeInsets.all(0),
          isInlinePicker: true,
          elevation: 0,
          value: _time,
          onChange: onTimeChanged,
          minuteInterval: TimePickerInterval.FIVE,
          iosStylePicker: iosStyle,
          minHour: 9,
          maxHour: 21,
          is24HrFormat: false,
        ),
      ],
    );
  }
}

class AccountSetupWaketime extends StatefulWidget {
  const AccountSetupWaketime({super.key});

  @override
  State<AccountSetupWaketime> createState() => _AccountSetupWaketimeState();
}

class _AccountSetupWaketimeState extends State<AccountSetupWaketime> {
  Time _time = Time(hour: 08, minute: 30, second: 20);
  bool iosStyle = true;

  void onTimeChanged(Time newTime) {
    setState(() {
      _time = newTime;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 50.h,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
            children: [
              Text(
                'What’s your sleep \ntime?',
                style: AppTextStyles.accountSetup,
              ),
            ],
          ),
        ),
        SizedBox(
          height: 50.h,
        ),

        // Render inline widget
        showPicker(
          unselectedColor: const Color.fromRGBO(0, 0, 0, 0.75),
          hourLabel: 'Hour'.tr(),
          minuteLabel: 'Minutes'.tr(),
          wheelHeight: 200.h,
          hideButtons: true,
          dialogInsetPadding: const EdgeInsets.all(0),
          isInlinePicker: true,
          elevation: 0,
          value: _time,
          onChange: onTimeChanged,
          minuteInterval: TimePickerInterval.FIVE,
          iosStylePicker: iosStyle,
          minHour: 9,
          maxHour: 21,
          is24HrFormat: false,
        ),
      ],
    );
  }
}

class SetUpGoals extends StatefulWidget {
  const SetUpGoals({super.key});

  @override
  State<SetUpGoals> createState() => _SetUpGoalsState();
}

int sleepTime = 0;
int screenTime = 0;
int workoutFrequency = 0;
int focusTime = 0;

class _SetUpGoalsState extends State<SetUpGoals> {
  @override
  Widget build(BuildContext context) {
    final goalProvider = Provider.of<GoalsProvider>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 14.h,
            ),
            Center(
              child: Text(
                'Set Up Goals'.tr(),
                style: TextStyle(
                    fontFamily: 'SFProText',
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textBlack),
              ),
            ),
            SizedBox(
              height: 25.h,
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: AppColors.widgetColorV,
                  borderRadius: BorderRadius.circular(12)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                    child: Text(
                      '${'Set Sleep Goals'.tr()}:',
                      style: TextStyle(
                          fontFamily: 'SFProText',
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textBlack),
                    ),
                  ),
                  _buildPicker(
                    itemCount: 13,
                    selectedItem: 0,
                    onSelectedItemChanged: (value) {
                      setState(() {
                        sleepTime = value;
                        goalProvider.setSelectedIndex(sleepTime);
                        //_selectedMinute = value;
                      });
                    },
                  ),
                  Text(
                    'hours per Day'.tr(),
                    style: TextStyle(
                        fontFamily: 'SFProText',
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textBlack),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 14.h,
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: AppColors.widgetColorR,
                  borderRadius: BorderRadius.circular(12)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                    child: Text(
                      '${'Set Screentime'.tr()}:',
                      style: TextStyle(
                          fontFamily: 'SFProText',
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textBlack),
                    ),
                  ),
                  _buildPicker(
                    itemCount: 25,
                    selectedItem: 0,
                    onSelectedItemChanged: (value) {
                      setState(() {
                        screenTime = value;
                        goalProvider.setSelectedIndex1(screenTime);
                        //_selectedMinute = value;
                      });
                    },
                  ),
                  Text(
                    'hours per Day'.tr(),
                    style: TextStyle(
                        fontFamily: 'SFProText',
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textBlack),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 14.h,
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: AppColors.widgetColorG,
                  borderRadius: BorderRadius.circular(12)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                    child: Text(
                      '${'Set Focus Time'.tr()}:',
                      style: TextStyle(
                          fontFamily: 'SFProText',
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textBlack),
                    ),
                  ),
                  _buildPicker(
                    itemCount: 13,
                    selectedItem: 0,
                    onSelectedItemChanged: (value) {
                      setState(() {
                        focusTime = value;
                        goalProvider.setSelectedIndex2(focusTime);
                        //_selectedMinute = value;
                      });
                    },
                  ),
                  Text(
                    'hours per Day'.tr(),
                    style: TextStyle(
                        fontFamily: 'SFProText',
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textBlack),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 14.h,
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: AppColors.widgetColorB,
                  borderRadius: BorderRadius.circular(12)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                    child: Text(
                      '${'Set Workout Frequency'.tr()}:',
                      style: TextStyle(
                          fontFamily: 'SFProText',
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textBlack),
                    ),
                  ),
                  _buildPicker(
                    itemCount: 8,
                    selectedItem: 0,
                    onSelectedItemChanged: (value) {
                      setState(() {
                        workoutFrequency = value;
                        goalProvider.setSelectedIndex3(workoutFrequency);
                        //_selectedMinute = value;
                      });
                    },
                  ),
                  Text(
                    'days per Week'.tr(),
                    style: TextStyle(
                        fontFamily: 'SFProText',
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textBlack),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 14.h,
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildPicker({
  required int itemCount,
  required int selectedItem,
  required void Function(int) onSelectedItemChanged,
}) {
  return SizedBox(
    width: 60.0,
    height: 120.0,
    child: CupertinoPicker(
      selectionOverlay: Container(),
      itemExtent: 52,
      diameterRatio: 1,
      backgroundColor: Colors.transparent,
      scrollController: FixedExtentScrollController(initialItem: selectedItem),
      onSelectedItemChanged: onSelectedItemChanged,
      children: List<Widget>.generate(itemCount, (index) {
        return Center(
          child: Text(
            index.toString().padLeft(2, '0'),
            style: const TextStyle(fontSize: 25),
          ),
        );
      }),
    ),
  );
}
