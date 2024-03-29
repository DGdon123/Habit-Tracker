import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:habit_tracker/pages/sleep_page/utils.dart';
import 'package:habit_tracker/provider/start_end_date_provider.dart';
import 'package:habit_tracker/services/sleep_firestore_services.dart';
import 'package:habit_tracker/utils/text_styles.dart';
import 'package:provider/provider.dart';

class BarGraph extends StatelessWidget {
  BarGraph({super.key});

  double highestDifference = 0.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: SleepFireStoreServices().getSleepDataRange(
              startDate: DateTime.now().subtract(Duration(days: 7)),
              endDate: DateTime.now()),
          builder: (context, snapshot) {
            debugPrint("Snapshot range: ${snapshot.data?.docs}");
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text("Something went wrong"));
            } else if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
              return const Center(child: Text("No data found"));
            }

            for (var doc in snapshot.data!.docs) {
              if (double.parse(doc['difference']) > highestDifference) {
                highestDifference = double.parse(doc['difference']);
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
                  gridData: FlGridData(
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
                          return Text(value.toInt().toString(),
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
          }),
    );
  }
}

List<BarChartGroupData> getBarChartGroups(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs) {
  List<BarChartGroupData> barChartGroups = [];

  var dateRange = SleepPageUtils().findLast7Days();

  for (int index = 0; index < dateRange.length; index++) {
    String date = dateRange[index];

    double difference = 0;

    // Check if the date is contained in the docs
    for (var doc in docs) {
      // Assuming doc contains a field named 'date' which stores the date in the format 'YYYY-MM-DD'
      if (doc['addedAt'] == date) {
        difference = double.parse(doc['difference']);
        break;
      }
    }

    debugPrint("Bar graph: $difference");

    // Add BarChartGroupData with value 10 if the date is contained in docs, otherwise add 0
    barChartGroups.add(
      BarChartGroupData(x: index, barRods: [
        BarChartRodData(
          width: 10,
          toY: difference,
          color: Color(0xFF4E00FF),
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

  var dayRange = SleepPageUtils().findDayRange();

  return SideTitleWidget(
    axisSide: meta.axisSide,
    space: 4,
    child: Text(dayRange[value.toInt()], style: style),
  );
}