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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Consumer<StartEndDateProvider>(
          builder: (context, startEndProvider, _) {
        return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
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

              Future.delayed(Duration.zero, () {
                Provider.of<AvgSleepProvider>(context, listen: false)
                    .setAvgTime(sleepSum);
              });

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
                    barGroups: getBarChartGroups(snapshot.data!.docs),
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
                      bottomTitles: const AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: getTitles,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            });
      }),
    );
  }
}

/// bar graph data
List<BarChartGroupData> getBarChartGroups(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs) {
  List<BarChartGroupData> barChartGroups = [];

  for (var doc in docs) {
// geeting the day from the date
    var day = int.parse(doc.get("addedAt").split("-")[2]);

    // Add BarChartGroupData with value 10 if the date is contained in docs, otherwise add 0
    barChartGroups.add(
      BarChartGroupData(x: day, barRods: [
        BarChartRodData(
          width: 10,
          toY: double.parse(doc.get("difference")),
          color: Color(0xFF004AAD),
        ),
      ]),
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
