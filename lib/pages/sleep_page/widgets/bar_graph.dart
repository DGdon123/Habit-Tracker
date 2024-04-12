import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:habit_tracker/pages/sleep_page/utils.dart';
import 'package:habit_tracker/provider/avg_sleep_provider.dart';
import 'package:habit_tracker/provider/start_end_date_provider.dart';
import 'package:habit_tracker/services/sleep_firestore_services.dart';
import 'package:habit_tracker/utils/text_styles.dart';
import 'package:provider/provider.dart';

class BarGraph extends StatelessWidget {
  BarGraph({super.key});

  double highestDifference = 0.0;
  double sleepSum = 0.0;

  @override
  Widget build(BuildContext context) {
    var startEndProvider = context.watch<StartEndDateProvider>();
    return Padding(
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

            return SizedBox(
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
                              style: TextStyles()
                                  .secondaryTextStyle(16.sp, FontWeight.w600));
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
            );
          }),
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
