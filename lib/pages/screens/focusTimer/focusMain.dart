// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import 'package:habit_tracker/utils/colors.dart';
import 'package:habit_tracker/utils/icons.dart';
import 'package:habit_tracker/utils/images.dart';

class FocusMainScreen extends StatefulWidget {
  final int? hour;
  final int? minute;
  final int? second;
  const FocusMainScreen({
    super.key,
    this.hour,
    this.minute,
    this.second,
  });

  @override
  State<FocusMainScreen> createState() => _FocusMainScreenState();
}

class _FocusMainScreenState extends State<FocusMainScreen> {
  final _isHours = true;
  bool started = false;
  double _progressValue = 1.0;

  int milli = 0;
  late StopWatchTimer _stopWatchTimer;

  @override
  void initState() {
    super.initState();
    time(); // Call time() function to calculate milli

    _stopWatchTimer = StopWatchTimer(
      mode: StopWatchMode.countDown,
      presetMillisecond: milli,
      onChange: (value) {
        int remainingMilliseconds = value;
        // Calculate remaining progress value
        _progressValue = remainingMilliseconds / milli;
        setState(() {});
      },
      onChangeRawSecond: (value) => print('onChangeRawSecond $value'),
      onChangeRawMinute: (value) => print('onChangeRawMinute $value'),
      onStopped: () {
        print('onStopped');
      },
      onEnded: () {
        print('onEnded');
      },
    );

    _stopWatchTimer.rawTime.listen((value) =>
        print('rawTime $value ${StopWatchTimer.getDisplayTime(value)}'));

    _stopWatchTimer.minuteTime.listen((value) => print('minuteTime $value'));
    _stopWatchTimer.secondTime.listen((value) => print('secondTime $value'));
    _stopWatchTimer.records.listen((value) => print('records $value'));
    _stopWatchTimer.fetchStopped
        .listen((value) => print('stopped from stream'));
    _stopWatchTimer.fetchEnded.listen((value) => print('ended from stream'));

    /// Can be set preset time. This case is "00:01.23".
    // _stopWatchTimer.setPresetTime(mSec: 1234);
  }

  void time() {
    int hoursInMillis = (widget.hour ?? 0) * 60 * 60 * 1000;
    int minutesInMillis = (widget.minute ?? 0) * 60 * 1000;
    int secondsInMillis = (widget.second ?? 0) * 1000;
    log(widget.second.toString());
    milli = hoursInMillis + minutesInMillis + secondsInMillis;
  }

  @override
  void dispose() async {
    super.dispose();
    await _stopWatchTimer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        body: Container(
          child: ListView(
            children: [
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
              const SizedBox(
                height: 10,
              ),
              Image.asset(
                AppImages.characterFull,
                height: 450.h,
              ),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 300.w,
                    height: 50.h,
                    child: LinearProgressIndicator(
                      value: _progressValue,
                      backgroundColor: const Color(0x7FD9D9D9),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.primaryColor),
                    ),
                  ),
                  SizedBox(
                    width: 5.w,
                  ),
                  Text(
                    '${(_progressValue * 100).toStringAsFixed(0)}%',
                    style: TextStyle(
                      color: AppColors.textBlack,
                      fontSize: 24.sp,
                      fontFamily: 'SFProText',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20.h,
              ),
              StreamBuilder<int>(
                stream: _stopWatchTimer.rawTime,
                initialData: _stopWatchTimer.rawTime.value,
                builder: (context, snap) {
                  final value = snap.data!;
                  final displayTime = StopWatchTimer.getDisplayTime(value,
                      hours: _isHours, milliSecond: false);
                  return Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  displayTime,
                                  style: TextStyle(
                                    color: AppColors.textBlack,
                                    fontSize: 65.sp,
                                    fontFamily: 'SFProText',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 50.w),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    'HOURS',
                                    style: TextStyle(
                                      color: Colors.black.withOpacity(0.5),
                                      fontSize: 14.sp,
                                      fontFamily: 'SFProText',
                                      fontWeight: FontWeight.w400,
                                      height: 0.10,
                                    ),
                                  ),
                                  Text(
                                    'MINUTES',
                                    style: TextStyle(
                                      color: Colors.black.withOpacity(0.5),
                                      fontSize: 14.sp,
                                      fontFamily: 'SFProText',
                                      fontWeight: FontWeight.w400,
                                      height: 0.10,
                                    ),
                                  ),
                                  Text(
                                    'SECONDS',
                                    style: TextStyle(
                                      color: Colors.black.withOpacity(0.5),
                                      fontSize: 14.sp,
                                      fontFamily: 'SFProText',
                                      fontWeight: FontWeight.w400,
                                      height: 0.10,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),

              /// Button
              ///
              ///
              SizedBox(
                height: 50.h,
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 50.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (_stopWatchTimer.isRunning) {
                          _stopWatchTimer.onStopTimer();
                          setState(() {
                            started = false;
                          });
                        } else {
                          _stopWatchTimer.onStartTimer();
                          setState(() {
                            started = true;
                          });
                        }
                      },
                      child: Container(
                        width: 70.h,
                        height: 70.w,
                        decoration: ShapeDecoration(
                          color: const Color(0xFF00FFDE),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(1000.r),
                          ),
                        ),
                        child: started
                            ? Icon(
                                Icons.pause,
                                size: 40.h,
                                color: Colors.white,
                              )
                            : Icon(
                                Icons.play_arrow,
                                size: 40.h,
                                color: Colors.white,
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
