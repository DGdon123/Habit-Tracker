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
import 'package:habit_tracker/pages/sleep_page/widgets/sleep_wake_display_card.dart';
import 'package:habit_tracker/services/sleep_firestore_services.dart';
import 'package:habit_tracker/utils/colors.dart';
import 'package:habit_tracker/utils/icons.dart';
import 'package:intl/intl.dart';

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

// title style
  TextStyle titleStyle = TextStyle(
    color: AppColors.textBlack,
    fontSize: 24.sp,
    fontFamily: 'SFProText',
    fontWeight: FontWeight.w600,
  );

  // subtitle style
  TextStyle subtitleStyle = TextStyle(
    color: AppColors.textBlack,
    fontSize: 16.sp,
    fontFamily: 'SFProText',
    fontWeight: FontWeight.w500,
  );

  // secondary

  TextStyle secondaryTextStyle(double fontSize, FontWeight fontWeight) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: Colors.black.withOpacity(0.75),
      fontFamily: 'SFProText',
    );
  }

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
                        style: titleStyle,
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
                              style: subtitleStyle,
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            GestureDetector(
                                onTap: () {
                                  showCustomDateRangePicker(
                                    fontFamily: "SFProText",
                                    context,
                                    dismissible: true,
                                    minimumDate: DateTime.now()
                                        .subtract(const Duration(days: 30)),
                                    maximumDate: DateTime.now()
                                        .add(const Duration(days: 30)),
                                    endDate: endDate,
                                    startDate: startDate,
                                    backgroundColor: Colors.white,
                                    primaryColor: AppColors.primaryColor,
                                    onApplyClick: (start, end) {
                                      setState(() {
                                        endDate = end;
                                        startDate = start;
                                      });
                                    },
                                    onCancelClick: () {
                                      setState(() {
                                        endDate = null;
                                        startDate = null;
                                      });
                                    },
                                  );
                                },
                                child: SvgPicture.asset(AppIcons.dropdown)),
                          ],
                        ),
                        Text(
                          '${currentYear}',
                          style: secondaryTextStyle(14.sp, FontWeight.w400),
                        )
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '7H',
                          style: subtitleStyle,
                        ),
                        Text(
                          'Avg sleep time',
                          style: secondaryTextStyle(14.sp, FontWeight.w400),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 40.h,
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Container(
                  height: 300,
                  child: BarChart(
                    BarChartData(
                      borderData: FlBorderData(
                          border: Border(
                        top: BorderSide.none,
                        left: BorderSide.none,
                        right: BorderSide.none,
                        bottom: BorderSide(
                          color: Color(0xFFD0D0D0),
                          width: 1.w,
                        ),
                      )),
                      gridData: FlGridData(
                        drawHorizontalLine: true,
                        drawVerticalLine: false,
                      ),
                      maxY: 10,
                      barGroups: barChartGroups,
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              return Text(value.toInt().toString(),
                                  style: secondaryTextStyle(
                                      16.sp, FontWeight.w600));
                            },
                          ),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: getTitles,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

List<BarChartGroupData> barChartGroups = [
  BarChartGroupData(x: 0, barRods: [
    BarChartRodData(
      width: 10.w,
      toY: 0,
      fromY: 5, // Use the same data from the pie chart (adjust as needed)
      color: Color(0xFF4E00FF),
    ),
  ]),
  BarChartGroupData(x: 1, barRods: [
    BarChartRodData(
      width: 10.w,
      toY: 0,
      fromY: 7, // Use the same data from the pie chart (adjust as needed)
      color: Color(0xFF4E00FF),
    ),
  ]),
  BarChartGroupData(x: 2, barRods: [
    BarChartRodData(
      width: 10.w,
      toY: 0,
      fromY: 9, // Use the same data from the pie chart (adjust as needed)
      color: Color(0xFF4E00FF),
    ),
  ]),
  BarChartGroupData(x: 3, barRods: [
    BarChartRodData(
      width: 10.w,
      toY: 0,
      fromY: 5, // Use the same data from the pie chart (adjust as needed)
      color: Color(0xFF4E00FF),
    ),
  ]),
  BarChartGroupData(x: 4, barRods: [
    BarChartRodData(
      width: 10.w,
      toY: 0,
      fromY: 8, // Use the same data from the pie chart (adjust as needed)
      color: Color(0xFF4E00FF),
    ),
  ]),
  BarChartGroupData(x: 5, barRods: [
    BarChartRodData(
      width: 10.w,
      toY: 0,
      fromY: 7, // Use the same data from the pie chart (adjust as needed)
      color: Color(0xFF4E00FF),
    ),
  ]),
  BarChartGroupData(x: 6, barRods: [
    BarChartRodData(
      width: 10.w,
      toY: 0,
      fromY: 3, // Use the same data from the pie chart (adjust as needed)
      color: Color(0xFF4E00FF),
    ),
  ]),
];

Widget getTitles(double value, TitleMeta meta) {
  final style = TextStyle(
    color: Colors.black.withOpacity(0.75),
    fontSize: 14.sp,
    fontFamily: 'SFProText',
    fontWeight: FontWeight.w400,
  );
  String text;
  switch (value.toInt()) {
    case 0:
      text = 'Sun';
      break;
    case 1:
      text = 'Mon';
      break;
    case 2:
      text = 'Tue';
      break;
    case 3:
      text = 'Wed';
      break;
    case 4:
      text = 'Thu';
      break;
    case 5:
      text = 'Fri';
      break;
    case 6:
      text = 'Sat';
      break;
    default:
      text = '';
      break;
  }
  return SideTitleWidget(
    axisSide: meta.axisSide,
    space: 4,
    child: Text(text, style: style),
  );
}
