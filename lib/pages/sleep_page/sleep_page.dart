import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_date_range_picker/custom_date_range_picker.dart';
import 'package:day_night_time_picker/lib/state/time.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habit_tracker/pages/home_page.dart';
import 'package:habit_tracker/pages/screens/sleep%20wakeup/sleepTime.dart';
import 'package:habit_tracker/pages/sleep_page/widgets/bar_graph.dart';
import 'package:habit_tracker/pages/sleep_page/widgets/custom_bar_chart.dart';
import 'package:habit_tracker/pages/sleep_page/widgets/sleep_wake_display_card.dart';
import 'package:habit_tracker/services/sleep_firestore_services.dart';
import 'package:habit_tracker/utils/colors.dart';
import 'package:habit_tracker/utils/icons.dart';
import 'package:habit_tracker/utils/text_styles.dart';
import 'package:intl/intl.dart';

import 'widgets/start_end_date_picker.dart';

class SleepPage extends StatefulWidget {
  const SleepPage({super.key});

  @override
  State<SleepPage> createState() => SleepPageState();
}

class SleepPageState extends State<SleepPage> {
  DateTime today = DateTime.now();
  DateTime? startDate;
  DateTime? endDate;

  int currentYear = DateTime.now().year;

  @override
  Widget build(BuildContext context) {
    DateTime sevenDaysAgo = today.subtract(Duration(days: 7));

    String formattedToday = DateFormat('MMM d').format(today);
    String formattedSevenDaysAgo = DateFormat('MMM d').format(sevenDaysAgo);

    String dateRange = '$formattedSevenDaysAgo - $formattedToday';

    return SafeArea(
      top: false,
      child: Scaffold(
        body: Container(
          margin: EdgeInsets.only(
              top: kIsWeb
                  ? 35.h
                  : Platform.isIOS
                      ? 50.h
                      : 35.h),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomePage()));
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
                        "Sleep Time",
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
              SizedBox(
                height: 30.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Sleep Time',
                        style: TextStyles().titleStyle,
                      ),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return SleepTime(); // Use the custom dialog
                            },
                          );
                        },
                        child: Container(
                            width: 40.h,
                            height: 40.w,
                            alignment: Alignment.center,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    width: 1, color: Color(0xFFEAECF0)),
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                            ),
                            child: SvgPicture.asset(
                              AppIcons.plus,
                              height: 24.h,
                            )),
                      ),
                    ]),
              ),
              SizedBox(
                height: 20.h,
              ),
              StreamBuilder<QuerySnapshot>(
                  stream: SleepFireStoreServices().listenToTodayAddedSleepTime,
                  builder: (context, snapshot) {
                    debugPrint("Snapshot: ${snapshot.data?.docs.length}");

                    var snapshotLength = snapshot.data?.docs.length;

                    // we got data
                    if (snapshot.hasData &&
                        snapshot.connectionState == ConnectionState.active &&
                        snapshotLength != 0) {
                      var doc = snapshot.data!.docs[0];
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SleepWakeDisplayCard(
                                title: 'Sleep Time',
                                bgColor: const Color(0xFF000C7C),
                                time: doc.get("sleepTime")),
                            SleepWakeDisplayCard(
                                title: 'Wake Time',
                                bgColor: const Color(0xFF7C0068),
                                time: doc.get("wakeTime")),
                          ],
                        ),
                      );
                    } else if (snapshotLength == 0) {
                      return const Text("Add your sleep time");
                    } else if (snapshot.hasError) {
                      return const Text('Something went wrong');
                    }
                    return const CircularProgressIndicator();
                  }),
              SizedBox(
                height: 30.h,
              ),

              // date range picker
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              '${startDate != null ? DateFormat("MMM dd").format(startDate!) : dateRange} - ${endDate != null ? DateFormat("MMM dd").format(endDate!) : ''}',
                              style: TextStyles().subtitleStyle,
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            GestureDetector(
                                onTap: () async {
                                  var res = await showDialog<dynamic>(
                                      context: context,
                                      builder: (_) {
                                        return StartEndDatePicker(
                                          firstDate: DateTime(2024, 3, 1),
                                        );
                                      });
                                },
                                child: SvgPicture.asset(AppIcons.dropdown)),
                          ],
                        ),
                        Text(
                          '${currentYear}',
                          style: TextStyles()
                              .secondaryTextStyle(14.sp, FontWeight.w400),
                        )
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '7H',
                          style: TextStyles().subtitleStyle,
                        ),
                        Text(
                          'Avg sleep time',
                          style: TextStyles()
                              .secondaryTextStyle(14.sp, FontWeight.w400),
                        )
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: 40.h,
              ),

              const BarGraph(),
            ],
          ),
        ),
      ),
    );
  }
}
