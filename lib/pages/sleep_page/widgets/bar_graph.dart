import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:habit_tracker/utils/text_styles.dart';

class BarGraph extends StatelessWidget {
  const BarGraph({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                        style: TextStyles().secondaryTextStyle(
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
