import 'dart:io';

import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:day_night_time_picker/lib/daynight_timepicker.dart';
import 'package:day_night_time_picker/lib/state/time.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habit_tracker/pages/home_page.dart';
import 'package:habit_tracker/utils/colors.dart';
import 'package:habit_tracker/utils/icons.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:habit_tracker/utils/styles.dart';

class AccountSetup extends StatefulWidget {
  const AccountSetup({super.key});

  @override
  State<AccountSetup> createState() => _AccountSetupState();
}

class _AccountSetupState extends State<AccountSetup> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Column(
        children: [
          SizedBox(height: kIsWeb ? 35 : Platform.isIOS ? 50 : 35,),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 28.h,
                  width: 28.w,
                  child: SvgPicture.asset(
                    AppIcons.back,
                  ),
                ),
                Spacer(),
                Center(
                  child: Text(
                    "Create Account",
                    style: TextStyle(
                        fontFamily: 'SFProText',
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textBlack),
                  ),
                ),
                Spacer(),
              ],
            ),
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (int page) {
                setState(() {
                  currentPage = page;
                });
              },
              children: [
                AccountSetupBirthdate(),
                AccountSetupSetName(),
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
                                  ? AppColors
                                      .buttonYellow // Active page color
                                  : AppColors
                                      .secondaryColor // Inactive page color
                              ),
                        ),
                      ),
                    )
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    // _pageController.nextPage(
                    //   duration: Duration(milliseconds: 300),
                    //   curve: Curves.easeInOut,
                    // );

                    if (currentPage < _pageController.page!.round()) {
                      // You are going back to a previous page
                      _pageController.previousPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      // You are going forward to the next page
                      if (currentPage < 1) {
                        _pageController.nextPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        if (currentPage == 1) {
                          Navigator.of(context).pushReplacement(
                            CupertinoPageRoute(
                              builder: (context) {
                                return HomePage();
                              },
                            ),
                          );
                        }
                      }
                    }
                  },
                  child: Row(
                    children: [
                      Text(
                        currentPage == 1 ? 'Finish' : 'Next',
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

class AccountSetupSetName extends StatefulWidget {
  const AccountSetupSetName({super.key});

  @override
  State<AccountSetupSetName> createState() => _AccountSetupSetNameState();
}

class _AccountSetupSetNameState extends State<AccountSetupSetName> {
  TextEditingController _controller = TextEditingController();

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
                'What’s your name?',
                style: AppTextStyles.accountSetup,
              ),
            ],
          ),
        ),
        SizedBox(
          height: 50.h,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: TextFormField(
            controller: _controller,
            style: TextStyle(
              fontFamily: 'SFProText',
              fontSize: 24.sp,
              fontWeight: FontWeight.w500,
              color: Color.fromARGB(255, 51, 51, 51),
            ),
            decoration: InputDecoration(
              hintText: "Your Name",
              hintStyle: TextStyle(
                fontFamily: 'SFProText',
                fontSize: 24.sp,
                fontWeight: FontWeight.w500,
                color: Color.fromARGB(255, 51, 51, 51),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Color.fromARGB(255, 51, 51, 51),
                  width: 2.w, // Change the width as needed
                ),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Color.fromARGB(255, 51, 51, 51),
                  width: 2.w, // Change the width as needed
                ),
              ),
              border: UnderlineInputBorder(
                borderSide: BorderSide(
                  width: 2.w,
                  color: Color.fromARGB(255, 51, 51, 51),
                ),
              ),
              suffixIcon: _controller.text.isNotEmpty
                  ? IconButton(
                      iconSize: 15,
                      icon: Container(
                        decoration: BoxDecoration(
                          color: AppColors.secondaryColor,
                          borderRadius: BorderRadius.circular(100.r),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(5.h),
                          child: Icon(
                            Icons.clear,
                            color: Color.fromARGB(255, 51, 51, 51),
                            size: 15.h,
                          ),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          _controller.clear();
                        });
                      },
                    )
                  : null,
            ),
          ),
        )
      ],
    );
  }
}

class AccountSetupBirthdate extends StatefulWidget {
  @override
  State<AccountSetupBirthdate> createState() => _AccountSetupBirthdateState();
}

class _AccountSetupBirthdateState extends State<AccountSetupBirthdate> {
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 50.h,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Text(
            'What’s your date of birth?',
            style: AppTextStyles.accountSetup,
            maxLines: 2,
          ),
        ),
        SizedBox(
          height: 50.h,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 40.w),
          child: DatePickerWidget(// default is not looping
             lastDate: DateTime(2020, 4, 4),
             initialDate: DateTime(1995, 4, 4), // DateTime(1994),
            dateFormat:
                // "MM-dd(E)",
                "MMMM/dd/yyyy",
            locale: DatePicker.localeFromString('en'),
            onChange: (DateTime newDate, _) {
              setState(() {
                _selectedDate = newDate;
              });
              print(_selectedDate);
            },
            pickerTheme: DateTimePickerTheme(
              backgroundColor: Colors.transparent,
              showTitle: true,
              itemTextStyle: TextStyle(
                  fontFamily: 'SFProText',
                  fontWeight: FontWeight.w600,
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 25.sp),
              dividerColor: const Color.fromARGB(255, 0, 0, 0),
            ),
          ),
        ),
      ],
    );
  }
}

class AccountSetupSleeptime extends StatefulWidget {
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
          unselectedColor: Color.fromRGBO(0, 0, 0, 0.75),
          hourLabel: 'Hour',
          minuteLabel: 'Minutes',
          wheelHeight: 200.h,
          hideButtons: true,
          dialogInsetPadding: EdgeInsets.all(0),
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
          unselectedColor: Color.fromRGBO(0, 0, 0, 0.75),
          hourLabel: 'Hour',
          minuteLabel: 'Minutes',
          wheelHeight: 200.h,
          hideButtons: true,
          dialogInsetPadding: EdgeInsets.all(0),
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
