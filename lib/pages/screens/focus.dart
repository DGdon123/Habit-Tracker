import 'dart:developer';
import 'dart:io';

import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habit_tracker/pages/screens/focusTimer/focusMain.dart';
import 'package:habit_tracker/utils/colors.dart';
import 'package:habit_tracker/utils/icons.dart';
import 'package:habit_tracker/utils/images.dart';
import 'package:quickalert/quickalert.dart';

class FocusPage extends StatefulWidget {
  const FocusPage({super.key});

  @override
  State<FocusPage> createState() => FocusPageState();
}

class FocusPageState extends State<FocusPage> {
  Time _time = Time(hour: 00, minute: 25, second: 59);
  bool iosStyle = true;
  final PageController _pageController = PageController(
    viewportFraction: 0.82,
    initialPage: 0,
  );
  @override
  void initState() {
    super.initState();
    // Add initial pages or load data from storage
    pages = [
      InkWell(
        onTap: () {
          setState(() {
            labelText = "Read";
            hour1 = 0;
            minute1 = 20;
            second1 = 0;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 7),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: const Color(0xFFFCDCD3),
                    borderRadius: BorderRadius.circular(10.r)),
                padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 20.w),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          height: 30.h,
                          width: 30.w,
                          child: Image.asset(
                            AppImages.read,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Read',
                          style: presetStyle,
                        ),
                        Text(
                          '20min',
                          style: presetStyle2,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      InkWell(
        onTap: () {
          setState(() {
            labelText = "Walk";
            hour1 = 0;
            minute1 = 30;
            second1 = 0;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 7),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: const Color(0xFFCFFFE5),
                    borderRadius: BorderRadius.circular(10.r)),
                padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 20.w),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          height: 30.h,
                          width: 30.w,
                          child: Image.asset(
                            AppImages.walk,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Walk',
                          style: presetStyle,
                        ),
                        Text(
                          '30min',
                          style: presetStyle2,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      // meditate
      InkWell(
        onTap: () {
          setState(() {
            labelText = "Meditate";
            hour1 = 0;
            minute1 = 15;
            second1 = 0;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 7),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: const Color(0xFFD5ECE0),
                    borderRadius: BorderRadius.circular(10.r)),
                padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 20.w),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          height: 30.h,
                          width: 30.w,
                          child: Image.asset(
                            AppImages.meditate,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Meditate',
                          style: presetStyle,
                        ),
                        Text(
                          '15min',
                          style: presetStyle2,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ];
    // Add the "Add new" button at the end
  }

  String labelText = "No Label";

  void onTimeChanged(Time newTime) {
    setState(() {
      _time = newTime;
    });
  }

  // Default icon

  int hour = 0;
  int minute = 0;
  int second = 0;
  int hour1 = 0;
  int minute1 = 0;
  int second1 = 0;
  // Function to show the add new dialog
  String label = '';
  int hours3 = 0;
  int minutes3 = 0;
  int seconds3 = 0;
  List<Widget> pages = [];
  void _showAddNewDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            'Add New Timer',
            style: TextStyle(
              color: const Color(0xFF040415),
              fontSize: 18.sp,
              fontFamily: 'SFProText',
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  setState(() {
                    label = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Label',
                  hintStyle: TextStyle(
                    color: Colors.black.withOpacity(0.75),
                    fontSize: 18.sp,
                    fontFamily: 'SFProText',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    hours3 = int.parse(value);
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Hours',
                  hintStyle: TextStyle(
                    color: Colors.black.withOpacity(0.75),
                    fontSize: 18.sp,
                    fontFamily: 'SFProText',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    minutes3 = int.parse(value);
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Minutes',
                  hintStyle: TextStyle(
                    color: Colors.black.withOpacity(0.75),
                    fontSize: 18.sp,
                    fontFamily: 'SFProText',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    seconds3 = int.parse(value);
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Seconds',
                  hintStyle: TextStyle(
                    color: Colors.black.withOpacity(0.75),
                    fontSize: 18.sp,
                    fontFamily: 'SFProText',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              // Input field for label
            ],
          ),
          actions: [
            // Button to save the input data
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (label.isEmpty) {
                  QuickAlert.show(
                    context: context,
                    type: QuickAlertType.error,
                    confirmBtnColor: AppColors.mainBlue,
                    title: 'Error...',
                    text: 'Please, fill up all the fields!',
                  );
                } else {
                  Widget newPage = InkWell(
                    onTap: () {
                      setState(() {
                        labelText = label;
                        hour1 = hours3;
                        minute1 = minutes3;
                        second1 = seconds3;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7),
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: const Color(0xFFD5ECE0),
                                borderRadius: BorderRadius.circular(10.r)),
                            padding: EdgeInsets.symmetric(
                                horizontal: 40.w, vertical: 20.w),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    SizedBox(
                                      height: 30.h,
                                      width: 30.w,
                                      child: Image.asset(
                                        AppImages.other,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 5.w,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      label,
                                      style: presetStyle,
                                    ),
                                    Text(
                                      '$minutes3 min',
                                      style: presetStyle2,
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                  setState(() {
                    // Add the new page to the pages list
                    pages.add(newPage);
                    Navigator.pop(context);
                  });
                }
              },
              child: const Text(
                'Save',
                style: TextStyle(
                  color: AppColors.mainBlue,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  TextStyle presetStyle = TextStyle(
    color: AppColors.textBlack,
    fontSize: 14.sp,
    fontFamily: 'SFProText',
    fontWeight: FontWeight.w500,
  );

  TextStyle presetStyle2 = TextStyle(
    color: AppColors.textBlack,
    fontSize: 12.sp,
    fontFamily: 'SFProText',
    fontWeight: FontWeight.w400,
  );

  TextStyle labelStyle = TextStyle(
    color: const Color(0xFF040415),
    fontSize: 18.sp,
    fontFamily: 'SFProText',
    fontWeight: FontWeight.w600,
  );

  TextStyle labelStyle2 = TextStyle(
    color: Colors.black.withOpacity(0.75),
    fontSize: 18.sp,
    fontFamily: 'SFProText',
    fontWeight: FontWeight.w400,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Container(
        margin: EdgeInsets.only(
            top: kIsWeb
                ? 35.h
                : Platform.isIOS
                    ? 50.h
                    : 35.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(
                        "Focus Timer",
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
              Stack(
                children: [
                  Padding(
                    padding:
                        EdgeInsets.only(right: 10.w, top: 10.h, bottom: 25.h),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          height: 250.h,
                          child: showPicker(
                              context: context,
                              themeData: ThemeData(
                                fontFamily: 'SFProText',
                              ),
                              dialogInsetPadding: EdgeInsets.symmetric(
                                  horizontal: 0.w, vertical: 0.h),
                              unselectedColor:
                                  const Color.fromRGBO(0, 0, 0, 0.75),
                              hourLabel: 'Hour',
                              minuteLabel: 'Minute',
                              secondLabel: 'Second',
                              displayHeader: false,
                              showSecondSelector: true,
                              hideButtons: false,
                              okText: 'Start',
                              isInlinePicker: true,
                              elevation: 0,
                              value: _time,
                              onChange: onTimeChanged,
                              onChangeDateTime: (DateTime dateTime) {
                                hour = dateTime.hour;
                                minute = dateTime.minute;
                                second = dateTime.second;
                                print(hour);
                                print(minute);
                                log(second.toString());
                                setState(() {
                                  _time = Time(
                                      hour: hour,
                                      minute: minute,
                                      second: second);
                                  if (minute1 == 0) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                FocusMainScreen(
                                                  label: labelText,
                                                  hour: hour,
                                                  minute: minute,
                                                  second: second,
                                                )));
                                  } else {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                FocusMainScreen(
                                                  label: labelText,
                                                  hour: hour1,
                                                  minute: minute1,
                                                  second: second1,
                                                )));
                                  }
                                });
                                print(_time.toString());
                              },
                              minuteInterval: TimePickerInterval.FIVE,
                              iosStylePicker: iosStyle,
                              minHour: 00,
                              maxHour: 23,
                              is24HrFormat: true,
                              showCancelButton: false,
                              okStyle: TextStyle(
                                color: AppColors.textBlack,
                                fontSize: 18.sp,
                                fontFamily: 'SFProText',
                                fontWeight: FontWeight.w500,
                              ),
                              buttonsSpacing: 0,
                              buttonStyle: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        AppColors.primaryColor),
                              )),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 25.w, vertical: 0.h),
                          child: SizedBox(
                            height: 100.h,
                            width: 220.w,
                            child: PageView(
                              controller: _pageController,
                              scrollDirection: Axis.horizontal,
                              children: pages,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () {
                  _showAddNewDialog(context);
                },
                child: Column(
                  children: [
                    Container(
                        margin: const EdgeInsets.only(left: 48),
                        width: 120.w,
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                AppIcons.plus,
                                height: 24.h,
                              ),
                              Text(
                                'Add new',
                                style: presetStyle,
                              )
                            ],
                          ),
                        )),
                  ],
                ),
              ),
              SizedBox(
                height: 30.h,
              ),
              labelTimer(labelStyle, context, labelStyle2),
              SizedBox(
                height: 30.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          'Recents',
                          style: TextStyle(
                            color: AppColors.textBlack,
                            fontSize: 20.sp,
                            fontFamily: 'SFProText',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    seperator(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '5:12:04',
                              style: TextStyle(
                                color: AppColors.textBlack,
                                fontSize: 60.sp,
                                fontFamily: 'SFProText',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '5 hr, 12 min, 4 sec',
                              style: TextStyle(
                                color: AppColors.textBlack,
                                fontSize: 16.sp,
                                fontFamily: 'SFProText',
                                fontWeight: FontWeight.w400,
                                height: 0.08,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: 70.h,
                          height: 70.w,
                          decoration: ShapeDecoration(
                            color: const Color(0xFF00FFDE),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(1000.r),
                            ),
                          ),
                          child: Icon(
                            Icons.play_arrow,
                            size: 40.h,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    seperator(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Container seperator() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1, color: Color(0xFFD0D0D0)),
        ),
      ),
    );
  }

  Padding labelTimer(
      TextStyle labelStyle, BuildContext context, TextStyle labelStyle2) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 1, color: Color(0xFFD0D0D0)),
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Label',
                    style: labelStyle,
                  ),
                  GestureDetector(
                    onTap: () async {
                      String? enteredText = await _showTextInputDialog(context);
                      if (enteredText != null && enteredText.isNotEmpty) {
                        setState(() {
                          labelText = enteredText;
                        });
                      }
                    },
                    child: Row(
                      children: [
                        Text(
                          labelText,
                          style: labelStyle2,
                        ),
                        Icon(
                          Icons.chevron_right,
                          size: 18.h,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            seperator(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'When Timer Ends',
                    style: labelStyle,
                  ),
                  Row(
                    children: [
                      Text(
                        'Ting Tong',
                        style: labelStyle2,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String?> _showTextInputDialog(BuildContext context) async {
    TextEditingController textController = TextEditingController();

    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            'Enter Label',
            style: TextStyle(
              color: const Color(0xFF040415),
              fontSize: 18.sp,
              fontFamily: 'SFProText',
              fontWeight: FontWeight.w600,
            ),
          ),
          content: TextField(
            controller: textController,
            onChanged: (value) {
              // You can add any additional logic here
            },
            decoration: InputDecoration(
              hintText: 'Label',
              hintStyle: TextStyle(
                color: Colors.black.withOpacity(0.75),
                fontSize: 18.sp,
                fontFamily: 'SFProText',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(textController.text);
              },
              child: const Text(
                'OK',
                style: TextStyle(
                  color: AppColors.mainBlue,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
