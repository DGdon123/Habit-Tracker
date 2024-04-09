import 'dart:developer';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart' as de;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habit_tracker/main.dart';
import 'package:habit_tracker/pages/home_page.dart';
import 'package:habit_tracker/services/xp_firestore_services.dart';
import 'package:habit_tracker/utils/colors.dart';
import 'package:habit_tracker/utils/icons.dart';
import 'package:habit_tracker/utils/images.dart';
import 'package:habit_tracker/widgets/tooltip.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:quickalert/quickalert.dart';

class StopWatchScreen extends StatefulWidget {
  int? hour;
  int? minute;
  String? label;
  int? second;
  StopWatchScreen({this.hour, this.label, this.minute, this.second, super.key});

  @override
  State<StopWatchScreen> createState() => _FocusMainScreenState();
}

class _FocusMainScreenState extends State<StopWatchScreen> {
  final _isHours = true;
  de.AudioPlayer audioPlayer = de.AudioPlayer();

  bool started = false;
  double _progressValue = 1;
  bool showHeadphoneOptions = false;
  int milli = 0;
  late StopWatchTimer _stopWatchTimer;
  @override
  void initState() {
    super.initState();
    log(widget.label.toString());
    time(); // Call time() function to calculate milli

    // Initialize and start the stopwatch timer
    _stopWatchTimer = StopWatchTimer(
      mode: StopWatchMode.countUp,
      presetMillisecond: 0,
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

    /// Can be set preset time. This case is "00:01.23".
    // _stopWatchTimer.setPresetTime(mSec: 1234);
  }

  int hours = 0;
  int minutes = 0;
  int seconds = 0;

  void time() {
    int hoursInMillis = (widget.hour ?? 0) * 60 * 60 * 1000;
    int minutesInMillis = (widget.minute ?? 0) * 60 * 1000;
    int secondsInMillis = (widget.second ?? 0) * 1000;
    log(widget.second.toString());
    milli = hoursInMillis + minutesInMillis + secondsInMillis;
  }

  Future<void> playMusic(de.Source filename) async {
    // Stop any currently playing music

    // Calculate the total duration in seconds

    // Play the specified music file at the specified position
    await audioPlayer.play(filename,
        volume: 100, mode: de.PlayerMode.mediaPlayer);
    audioPlayer.setReleaseMode(de.ReleaseMode.loop);
    // Indicate that the music playback has started
    print('Music playback started');
  }

  @override
  void dispose() async {
    super.dispose();
    await _stopWatchTimer.dispose();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? getUserID() {
    User? user = _auth.currentUser;
    return user?.uid;
  }

  String? getUserName() {
    User? user = _auth.currentUser;
    return user?.displayName;
  }

// Get individual components of the current date (year, month, day)

  Future<void> addUser(int hours, int minutes, int seconds) {
    CollectionReference users =
        FirebaseFirestore.instance.collection('stopwatch');
    logger.d(hours);
    logger.d(minutes);
    logger.d(seconds);

    return users
        .add({
          'Label': widget.label ?? 'Meditate',
          'Hours': hours,
          'Minutes': minutes,
          'Seconds': seconds,
          'ID': getUserID(),
          'Name': getUserName(),
          'Timestamp': FieldValue.serverTimestamp(),
        })
        .then((value) => print("User added successfully!"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 45),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (started == false) {
                                audioPlayer.stop();
                                Navigator.pop(context);
                              } else {
                                QuickAlert.show(
                                  context: context,
                                  confirmBtnColor: AppColors.mainBlue,
                                  type: QuickAlertType.error,
                                  title: 'Error...'.tr(),
                                  text: 'Please stop the timer!'.tr(),
                                );
                              }
                            },
                            child: SizedBox(
                              height: 28,
                              width: 28,
                              child: SvgPicture.asset(
                                AppIcons.back,
                              ),
                            ),
                          ),
                          Center(
                            child: Text(
                              "Stopwatch".tr(),
                              style: TextStyle(
                                  fontFamily: 'SFProText',
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.textBlack),
                            ),
                          ),
                          GestureDetector(
                              onTap: () {
                                setState(() {
                                  showHeadphoneOptions = !showHeadphoneOptions;
                                });
                              },
                              child: Image.asset(
                                AppIcons.headphone,
                                width: 35,
                              ))
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Image.asset(
                      AppImages.characterFull,
                      height: 350,
                    ),
                    const SizedBox(height: 20),

                    StreamBuilder<int>(
                      stream: _stopWatchTimer.rawTime,
                      initialData: _stopWatchTimer.rawTime.value,
                      builder: (context, snap) {
                        final value = snap.data!;
                        hours = int.parse(
                            StopWatchTimer.getDisplayTimeHours(value));
                        minutes = int.parse(
                            StopWatchTimer.getDisplayTimeMinute(value));
                        seconds = int.parse(
                            StopWatchTimer.getDisplayTimeSecond(value));
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
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 50.w),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                          'HOURS'.tr(),
                                          style: TextStyle(
                                            color:
                                                Colors.black.withOpacity(0.5),
                                            fontSize: 14.sp,
                                            fontFamily: 'SFProText',
                                            fontWeight: FontWeight.w400,
                                            height: 0.10,
                                          ),
                                        ),
                                        Text(
                                          'MINUTES'.tr(),
                                          style: TextStyle(
                                            color:
                                                Colors.black.withOpacity(0.5),
                                            fontSize: 14.sp,
                                            fontFamily: 'SFProText',
                                            fontWeight: FontWeight.w400,
                                            height: 0.10,
                                          ),
                                        ),
                                        Text(
                                          'SECONDS'.tr(),
                                          style: TextStyle(
                                            color:
                                                Colors.black.withOpacity(0.5),
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

                    const SizedBox(
                      height: 35,
                    ),

                    /// Button
                    ///
                    ///
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 290,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  if (started == false) {
                                    debugPrint(
                                        "Close tapped $hours, $minutes, $seconds");

                                    audioPlayer.stop();

                                    if (hours != 0 || minutes != 0) {
                                      debugPrint("adding to firestore");
                                      XpFirestoreServices()
                                          .addXp(
                                              increment: true,
                                              xp: (hours * 60) + minutes,
                                              reason: "Earned from Stopwatch")
                                          .then((value) =>
                                              Navigator.pop(context));
                                      return;
                                    }
                                    Navigator.pop(context);
                                  } else {
                                    QuickAlert.show(
                                      context: context,
                                      confirmBtnColor: AppColors.mainBlue,
                                      type: QuickAlertType.error,
                                      title: 'Error...'.tr(),
                                      text: 'Please stop the timer!'.tr(),
                                    );
                                  }
                                },
                                child: const Icon(
                                  Icons.cancel_outlined,
                                  size: 65,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  if (_stopWatchTimer.isRunning) {
                                    _stopWatchTimer.onStopTimer();
                                    setState(() {
                                      started = false;
                                      addUser(hours, minutes, seconds);
                                      if (hours != 0 || minutes != 0) {
                                        var xp = hours * 60 + minutes;
                                        XpFirestoreServices().addXp(
                                            increment: true,
                                            xp: xp,
                                            reason: "Earned from Stopwatch");
                                      }
                                    });
                                  } else {
                                    _stopWatchTimer.onStartTimer();
                                    setState(() {
                                      started = true;
                                    });
                                  }
                                },
                                child: Container(
                                    color: Colors.transparent,
                                    child: Icon(
                                      started
                                          ? Icons.pause_circle_outline_rounded
                                          : Icons.play_circle_outline,
                                      size: 65,
                                    )),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (showHeadphoneOptions)
              Positioned(
                right: 10,
                top: 75,
                child: TriangleTooltip(
                  backgroundColor: Colors.white,
                  options: [
                    TooltipOption(
                        icon: AppIcons.lofi,
                        label: 'Lofi'.tr(),
                        onPressed: () {
                          playMusic(de.AssetSource('lofi.mp3'));
                        }),
                    TooltipOption(
                        icon: AppIcons.paino,
                        label: 'Piano'.tr(),
                        onPressed: () {
                          playMusic(de.AssetSource('piano.mp3'));
                        }),
                    TooltipOption(
                        icon: AppIcons.jazz,
                        label: 'Jazz'.tr(),
                        onPressed: () {
                          playMusic(de.AssetSource('jazz.mp3'));
                        }),
                    TooltipOption(
                        icon: AppIcons.zen,
                        label: 'Zen'.tr(),
                        onPressed: () {
                          playMusic(de.AssetSource('zen.mp3'));
                        }),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
