import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habit_tracker/provider/avg_sleep_provider.dart';
import 'package:habit_tracker/provider/start_end_date_provider.dart';
import 'package:habit_tracker/services/sleep_firestore_services.dart';
import 'package:habit_tracker/utils/icons.dart';
import 'package:habit_tracker/utils/text_styles.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'bar_graph.dart';
import 'start_end_date_picker.dart';

class SleepDetails extends StatefulWidget {
  const SleepDetails({super.key});

  @override
  State<SleepDetails> createState() => _SleepDetailsState();
}

class _SleepDetailsState extends State<SleepDetails> {
  double highestDifference = 0.0;
  double sleepSum = 0.0;

  @override
  Widget build(BuildContext context) {
    var startEndProvider = context.watch<StartEndDateProvider>();
    return Column(
      children: [
        // date range picker
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () async {
                      await showDialog<Map<String, dynamic>>(
                          context: context,
                          builder: (_) {
                            return StartEndDatePicker(
                              firstDate: DateTime(2024, 3, 1),
                            );
                          }).then((value) {
                        if (value == null) return;
                        if (value.isEmpty) return;

                        if (value.isNotEmpty) {
                          context.read<StartEndDateProvider>().setDate(
                              startDate: value["startDate"],
                              endDate: value["endDate"]);
                        }
                      });
                    },
                    child: Row(
                      children: [
                        // date filtering
                        Builder(
                          builder: (context) {
                            var startEndPicker =
                                context.watch<StartEndDateProvider>();

                            var startDate = startEndPicker.startDate;
                            var endDate = startEndPicker.endDate;

                            debugPrint(
                                "sleep details StartDate: $startDate, EndDate: $endDate");

                            return Text(
                              '${DateFormat("MMM dd").format(startDate)} - ${DateFormat("MMM dd").format(endDate)}',
                              style: TextStyles().subtitleStyle,
                            );
                          },
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        SvgPicture.asset(AppIcons.dropdown),
                      ],
                    ),
                  ),
                  Text(
                    '${DateTime.now().year}',
                    style:
                        TextStyles().secondaryTextStyle(14.sp, FontWeight.w400),
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "${context.watch<AvgSleepProvider>().avgTime}H",
                    style: TextStyles().subtitleStyle,
                  ),
                  Text(
                    'Avg sleep time'.tr(),
                    style:
                        TextStyles().secondaryTextStyle(14.sp, FontWeight.w400),
                  )
                ],
              ),
            ],
          ),
        ),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: SleepFireStoreServices().getSleepDataRange(
                  startDate: startEndProvider.startDate,
                  endDate: startEndProvider.endDate),
              builder: (context, snapshot) {
                debugPrint("Snapshot range: ${snapshot.data?.docs}");
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Something went wrong".tr()));
                } else if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
                  return Center(child: Text("No data found".tr()));
                }

                for (var doc in snapshot.data!.docs) {
                  if (double.parse(doc['difference']) > highestDifference) {
                    highestDifference = double.parse(doc['difference']);
                    sleepSum += double.parse(doc['difference']);
                  }
                }

                return Column(
                  children: [
                    SizedBox(height: 40.h),
                    SizedBox(
                      height: 300,
                      child: BarChart(
                        BarChartData(
                          borderData: FlBorderData(
                              border: Border(
                            top: BorderSide.none,
                            left: BorderSide.none,
                            right: BorderSide.none,
                            bottom: BorderSide(
                              color: const Color(0xFFD0D0D0),
                              width: 1.w,
                            ),
                          )),
                          gridData: const FlGridData(
                            drawHorizontalLine: true,
                            drawVerticalLine: false,
                          ),
                          maxY: highestDifference,
                          barGroups: getBarChartGroups(
                              docs: snapshot.data!.docs,
                              context: context,
                              dayRange: startEndProvider.findDayRange(),
                              startEndRange: startEndProvider.findDateRange()),
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  log("Value: $value");
                                  return Text("${value.round()}".toString(),
                                      style: TextStyles().secondaryTextStyle(
                                          16.sp, FontWeight.w600));
                                },
                              ),
                            ),
                            rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            topTitles: const AxisTitles(
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
                  ],
                );
              }),
        )
      ],
    );
  }

  /// bar graph data
  List<BarChartGroupData> getBarChartGroups({
    required List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
    required BuildContext context,
    required List<String> dayRange,
    required List<String> startEndRange,
  }) {
    List<BarChartGroupData> barChartGroups = [];

    // populating the bar chart data
    for (var date in startEndRange) {
      var day = date.split("-")[2];

      barChartGroups.add(
        BarChartGroupData(
          x: int.parse(day),
          barRods: [
            BarChartRodData(
              width: 10,
              toY: 0, // default 0
              color: Color(0xFF004AAD),
            ),
          ],
        ),
      );
    }

    context
        .watch<AvgSleepProvider>()
        .setAvgTime(sleepSum / barChartGroups.length);

    for (var doc in docs) {
      var day = doc['addedAt'].toString().split("-")[2];

      int index = dayRange.indexOf(day);
      barChartGroups[index] = BarChartGroupData(
        x: int.parse(day),
        barRods: [
          BarChartRodData(
            width: 10,
            toY: double.parse(doc['difference']),
            color: Color(0xFF004AAD),
          ),
        ],
      );
    }

    return barChartGroups;
  }

  Widget getTitles(double value, TitleMeta meta) {
    final style = TextStyle(
      color: Colors.black.withOpacity(0.75),
      fontSize: 14.sp,
      fontFamily: 'SFProText',
      fontWeight: FontWeight.w400,
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text("${value.round()}", style: style),
    );
  }
}
