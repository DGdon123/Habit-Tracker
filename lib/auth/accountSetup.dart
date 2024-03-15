import 'dart:developer';
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
import 'package:habit_tracker/auth/repositories/user_repository.dart';
import 'package:habit_tracker/pages/home_page.dart';
import 'package:habit_tracker/provider/dob_provider.dart';
import 'package:habit_tracker/utils/colors.dart';
import 'package:habit_tracker/utils/icons.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:habit_tracker/utils/styles.dart';
import 'package:provider/provider.dart';

class AccountSetup extends StatefulWidget {
  final String? username;
  final String? email;
  final String? password;
  const AccountSetup({super.key, this.username, this.email, this.password});
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

  bool hello = false;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserRepository>(context);
    final dob = Provider.of<SelectedDateProvider>(context, listen: false);
    final dobis = dob.selectedDate;
    log(dobis.toString());
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
          "Create Account",
          style: TextStyle(
              fontFamily: 'SFProText',
              fontSize: 22.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textBlack),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: kIsWeb
                ? 35
                : Platform.isIOS
                    ? 50
                    : 35,
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (int page) {
                setState(() {
                  currentPage = page;
                });
              },
              children: const [
                AccountSetupBirthdate(),
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
                        1, // Replace with the total number of pages
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
                    if (currentPage == 0 &&
                        user.status != Status.Authenticating) {
                      // Set the user status to Authenticating to show the loading indicator
                      Status.Authenticating;

                      // Perform the sign-up operation
                      await user.signUp(
                        context,
                        widget.username.toString(),
                        dobis.toString(),
                        widget.email.toString(),
                        widget.password.toString(),
                      );
                    }
                  },
                  child: Row(
                    children: [
                      Text(
                        'Finish',
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
  final TextEditingController _controller = TextEditingController();

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
              color: const Color.fromARGB(255, 51, 51, 51),
            ),
            decoration: InputDecoration(
              hintText: "Your Name",
              hintStyle: TextStyle(
                fontFamily: 'SFProText',
                fontSize: 24.sp,
                fontWeight: FontWeight.w500,
                color: const Color.fromARGB(255, 51, 51, 51),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: const Color.fromARGB(255, 51, 51, 51),
                  width: 2.w, // Change the width as needed
                ),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: const Color.fromARGB(255, 51, 51, 51),
                  width: 2.w, // Change the width as needed
                ),
              ),
              border: UnderlineInputBorder(
                borderSide: BorderSide(
                  width: 2.w,
                  color: const Color.fromARGB(255, 51, 51, 51),
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
                            color: const Color.fromARGB(255, 51, 51, 51),
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
  const AccountSetupBirthdate({super.key});

  @override
  State<AccountSetupBirthdate> createState() => _AccountSetupBirthdateState();
}

class _AccountSetupBirthdateState extends State<AccountSetupBirthdate> {
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    final dobProvider =
        Provider.of<SelectedDateProvider>(context, listen: false);
    final dob = dobProvider.selectedDate;
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Column(
        children: [
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
            child: DatePickerWidget(
              // default is not looping
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
                dobProvider.setSelectedDate(_selectedDate!);
              },
              pickerTheme: DateTimePickerTheme(
                backgroundColor: Colors.transparent,
                showTitle: true,
                itemTextStyle: TextStyle(
                    fontFamily: 'SFProText',
                    fontWeight: FontWeight.w600,
                    color: const Color.fromARGB(255, 0, 0, 0),
                    fontSize: 25.sp),
                dividerColor: const Color.fromARGB(255, 0, 0, 0),
              ),
            ),
          ),
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
          hourLabel: 'Hour',
          minuteLabel: 'Minutes',
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
          hourLabel: 'Hour',
          minuteLabel: 'Minutes',
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
