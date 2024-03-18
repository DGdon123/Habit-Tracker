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

class FocusPage extends StatefulWidget {
  const FocusPage({super.key});

  @override
  State<FocusPage> createState() => FocusPageState();
}

class FocusPageState extends State<FocusPage> {
  Time _time = Time(hour: 00, minute: 25, second: 59);
  bool iosStyle = true;
  final PageController _pageController = PageController(
    viewportFraction: 0.8,
    initialPage: 0,
  );

  String labelText = "Read";

  void onTimeChanged(Time newTime) {
    setState(() {
      _time = newTime;
    });
  }

  int hour = 0;
  int minute = 0;
  int second = 0;

  @override
  Widget build(BuildContext context) {
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
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: Container(
          margin: EdgeInsets.only(
              top: kIsWeb
                  ? 35.h
                  : Platform.isIOS
                      ? 50.h
                      : 35.h),
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
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
                        "Focus Timer",
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
              Stack(
                children: [
                  Padding(
                    padding:
                        EdgeInsets.only(right: 10.w, top: 10.w, bottom: 30.h),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
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
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => FocusMainScreen(
                                                hour: hour,
                                                minute: minute,
                                                second: second,
                                              )));
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
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Row(
                        children: [
                          SizedBox(
                            height: 100.h,
                            width: 200.w,
                            child: PageView(
                              controller: _pageController,
                              scrollDirection: Axis.horizontal,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            color: const Color(0xFFFCDCD3),
                                            borderRadius:
                                                BorderRadius.circular(10.r)),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 27.w, vertical: 20.w),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
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
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
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
                                Container(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 3),
                                  child: Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            color: const Color(0xFFCFFFE5),
                                            borderRadius:
                                                BorderRadius.circular(10.r)),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20.w, vertical: 20.w),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
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
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
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
                                // meditate
                                Container(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 3),
                                  child: Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            color: const Color(0xFFD5ECE0),
                                            borderRadius:
                                                BorderRadius.circular(10.r)),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20.w, vertical: 20.w),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
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
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
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
                                Container(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 3),
                                  child: Column(
                                    children: [
                                      Container(
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: AppColors.primaryColor,
                                            borderRadius:
                                                BorderRadius.circular(10.r),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20.w,
                                                vertical: 28.h),
                                            child: Row(
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
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
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
                      Icon(
                        Icons.chevron_right,
                        size: 18.h,
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
