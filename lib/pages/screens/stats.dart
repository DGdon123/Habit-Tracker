import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habit_tracker/main.dart';
import 'package:habit_tracker/pages/home_page.dart';
import 'package:habit_tracker/utils/colors.dart';
import 'package:habit_tracker/utils/icons.dart';
import 'package:habit_tracker/utils/images.dart';

import 'package:custom_date_range_picker/custom_date_range_picker.dart';
import 'package:intl/intl.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => StatsPageState();
}

class StatsPageState extends State<StatsPage> {
  DateTime? startDate;
  DateTime? endDate;
  DateTime today = DateTime.now();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? getUserID() {
    User? user = _auth.currentUser;
    return user?.uid;
  }

  Map<String, dynamic> userLabels = {};
  Map<String, dynamic> userLabels2 = {};
  List<Map<String, dynamic>> dataList = [];
  List<Map<String, dynamic>> dataList2 = [];
  bool select = false;

  Padding piechartIndicator() {
    // Call updatePieChartSections to fetch user labels and update the pieChartSections list

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Column(
        children: pieChartSections
            .map((section) => Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 10.h,
                      height: 10.h,
                      decoration: BoxDecoration(
                        color: section.color,
                        borderRadius: BorderRadius.all(
                          Radius.circular(100.r),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      '${section.title} :',
                      style: secondaryStyle,
                    ),
                    SizedBox(width: 5.w),
                    Text(
                      '${section.value}%',
                      style: statusStyle(AppColors.textBlack),
                    ),
                  ],
                ))
            .toList(),
      ),
    );
  }

  double? maxY;
  int? maxValue;
  List<BarChartGroupData> barChartGroups = [];
  List<PieChartSectionData> pieChartSections = [];
  List<Map<String, dynamic>> labelDataList =
      []; // Create a map to aggregate values for each unique label
  // Create a map to aggregate values for each unique label
  Map<String, double> labelValues = {};
  Map<String, double> labelValues1 = {};
  Future<void> updatePieChartSections(
      DateTime? startDate, DateTime? endDate) async {
    // Clear existing data
    labelValues.clear();
    labelValues1.clear();
    labelDataList.clear();
    pieChartSections.clear();
    barChartGroups.clear();

    // Fetch user labels from both sources
    Map<String, dynamic> labels1 = await fetchUsers();
    Map<String, dynamic> labels2 = await fetchUsers2();

    // Iterate over user labels from the first source and aggregate values for each label
    if (labels1.isNotEmpty) {
      labels1['data'].forEach((labelData) {
        DateTime timestamp =
            DateTime.parse(labelData['addedAt']); // Parse timestamp
        if (startDate == null ||
            endDate == null ||
            (timestamp.isAfter(startDate) && timestamp.isBefore(endDate))) {
          String label = labelData['Label'].toString();
          int hours = labelData['Hours'];
          int minutes = labelData['Minutes'];
          int seconds = labelData['Seconds'];
          int totalSeconds = hours;
          double value = 0.5; // Set the default value
          labelValues[label] = (labelValues[label] ?? 0) + value;
          labelValues1[label] =
              (labelValues1[label] ?? 0) + totalSeconds.toInt();
          labelDataList.add({
            'Label': label,
            'Hours': hours,
            'Minutes': minutes,
            'Seconds': seconds,
          });
        }
      });
    }

    // Iterate over user labels from the second source and aggregate values for each label
    if (labels2.isNotEmpty) {
      labels2['data'].forEach((labelData) {
        DateTime timestamp =
            DateTime.parse(labelData['addedAt']); // Parse timestamp
        if (startDate == null ||
            endDate == null ||
            (timestamp.isAfter(startDate) && timestamp.isBefore(endDate))) {
          String label = labelData['Label'].toString();
          int hours = labelData['Hours'];
          int minutes = labelData['Minutes'];
          int seconds = labelData['Seconds'];
          int totalSeconds = hours;
          double value = 0.5; // Set the default value
          labelValues[label] = (labelValues[label] ?? 0) + value;
          labelValues1[label] =
              (labelValues1[label] ?? 0) + totalSeconds.toInt();
          labelDataList.add({
            'Label': label,
            'Hours': hours,
            'Minutes': minutes,
            'Seconds': seconds,
          });
        }
      });
    }

    // Create PieChartSectionData objects based on the aggregated values
    labelValues.forEach((label, value) {
      PieChartSectionData section = PieChartSectionData(
        color: getColorForLabel(label),
        value: value.toDouble(), // Set the aggregated value
        title: label,
        radius: 150,
        titleStyle: TextStyle(
          color: Colors.white,
          fontSize: 13.sp,
          fontFamily: 'SFProText',
          fontWeight: FontWeight.w600,
        ),
      );
      setState(() {
        pieChartSections.add(section);
      });
    });

// Create BarChartGroupData objects based on the aggregated values
    barChartGroups = labelValues1.entries.map((entry) {
      String label = entry.key;
      double value = entry.value;
      logger.d(value);
      return BarChartGroupData(x: value.toInt(), barRods: [
        BarChartRodData(
          borderRadius: BorderRadius.circular(100.r),
          width: 40.w,
          toY: value.toDouble(),
          fromY: 0, // Use the aggregated value
          color: getColorForLabel(label),
        ),
      ]);
    }).toList();
    maxValue = labelValues1.values
        .fold<int?>(0, (prev, value) => value > (prev)! ? value as int? : prev);

// Calculate maxY by adding a constant offset to the maximum value
    maxY = maxValue!.toDouble() + 4;
  }

  Future<Map<String, dynamic>> fetchUsers() async {
    CollectionReference users =
        FirebaseFirestore.instance.collection('stopwatch');

    String? userID = getUserID(); // Get the current user's ID
    dataList.clear(); // Clear dataList before fetching new data

    if (userID != null) {
      try {
        QuerySnapshot snapshot =
            await users.where('ID', isEqualTo: userID).get();
        if (snapshot.docs.isNotEmpty) {
          for (var doc in snapshot.docs) {
            var data = doc.data() as Map<String, dynamic>;
            // Parse the "addedAt" field into DateTime
            DateTime addedAt = DateTime.parse(data['addedAt']);
            // Check if the addedAt date is within the selected date range
            if ((startDate == null || addedAt.isAfter(startDate!)) &&
                (endDate == null ||
                    addedAt.isBefore(endDate!.add(const Duration(days: 1))))) {
              dataList.add(data);
            }
          }
          userLabels['data'] = dataList;
          logger.d(userLabels);
        } else {
          print('No data found for the current user');
        }
      } catch (error) {
        print("Failed to fetch users: $error");
      }
    } else {
      print('User ID is null');
    }

    return userLabels;
  }

  Future<Map<String, dynamic>> fetchUsers2() async {
    CollectionReference users =
        FirebaseFirestore.instance.collection('focus_timer');

    String? userID = getUserID(); // Get the current user's ID
    dataList2.clear(); // Clear dataList2 before fetching new data

    if (userID != null) {
      try {
        QuerySnapshot snapshot =
            await users.where('ID', isEqualTo: userID).get();
        if (snapshot.docs.isNotEmpty) {
          for (var doc in snapshot.docs) {
            var data = doc.data() as Map<String, dynamic>;
            // Parse the "addedAt" field into DateTime
            DateTime addedAt = DateTime.parse(data['addedAt']);
            // Check if the addedAt date is within the selected date range
            if ((startDate == null || addedAt.isAfter(startDate!)) &&
                (endDate == null ||
                    addedAt.isBefore(endDate!.add(const Duration(days: 1))))) {
              dataList2.add(data);
            }
          }
          userLabels2['data'] = dataList2;
          logger.d(userLabels2);
        } else {
          print('No data found for the current user');
        }
      } catch (error) {
        print("Failed to fetch users: $error");
      }
    } else {
      print('User ID is null');
    }

    return userLabels2;
  }

  DateTime? selectedStartDate;
  DateTime? selectedEndDate;

  Padding datePicker(String formattedDate, BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${startDate != null ? DateFormat("MMM dd").format(startDate!) : formattedDate} - ${endDate != null ? DateFormat("MMM dd").format(endDate!) : ''}',
                style: secondaryStyle,
              ),
            ],
          ),
          GestureDetector(
            onTap: () async {
              showCustomDateRangePicker(
                fontFamily: "SFProText",
                context,
                dismissible: true,
                minimumDate: DateTime.now().subtract(const Duration(days: 30)),
                maximumDate: DateTime.now().add(const Duration(days: 30)),
                endDate: endDate,
                startDate: startDate,
                backgroundColor: Colors.white,
                primaryColor: Colors.black,
                onApplyClick: (start, end) {
                  setState(() {
                    endDate = end;
                    startDate = start;
                  });
                  updatePieChartSections(selectedStartDate,
                      selectedEndDate); // Update charts when date range changes
                },
                onCancelClick: () {
                  setState(() {
                    endDate = null;
                    startDate = null;
                  });
                  updatePieChartSections(selectedStartDate,
                      selectedEndDate); // Update charts when date range changes
                },
              );

              // Filter selectable dates based on the timestamp from Firebase
              for (var data in userLabels['data']) {
                DateTime timestamp = DateTime.fromMillisecondsSinceEpoch(
                    data['Timestamp'].seconds * 1000);
                if (startDate != null && endDate != null) {
                  if (startDate!.isBefore(timestamp) &&
                      endDate!.isAfter(timestamp)) {
                    // If the timestamp falls within the selected date range
                    if (selectedStartDate == null ||
                        selectedStartDate!.isAfter(timestamp)) {
                      selectedStartDate = timestamp;
                    }
                    if (selectedEndDate == null ||
                        selectedEndDate!.isBefore(timestamp)) {
                      selectedEndDate = timestamp;
                    }
                  }
                }
              }

              // Update the selected start and end dates
              setState(() {
                startDate = selectedStartDate;
                endDate = selectedEndDate;
              });
            },
            child: Container(
                width: 40.h,
                height: 40.w,
                alignment: Alignment.center,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 1, color: Color(0xFFEAECF0)),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                ),
                child: SvgPicture.asset(
                  AppIcons.dropdown,
                  height: 24.h,
                )),
          ),
        ],
      ),
    );
  }

  Color getRandomColor() {
    // Generate a random color
    return Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
  }

  Color getColorForLabel(String label) {
    // Generate a hash for the label
    int hashCode = label.hashCode.abs();

    // Use the hash to seed the random number generator
    Random random = Random(hashCode);

    // Generate random values for red, green, and blue channels
    int red = random.nextInt(256);
    int green = random.nextInt(256);
    int blue = random.nextInt(256);

    // Construct and return the color using the generated values
    return Color.fromRGBO(red, green, blue, 1.0);
  }

  TextStyle statusStyle(Color textColor) {
    return TextStyle(
      color: textColor,
      fontSize: 18.sp,
      fontFamily: 'SFProText',
      fontWeight: FontWeight.w500,
    );
  }

  TextStyle secondaryStyle = TextStyle(
    color: const Color(0xFF686873),
    fontSize: 14.sp,
    fontFamily: 'SFProText',
    fontWeight: FontWeight.w400,
  );

  TextStyle subtitleStyle = TextStyle(
    color: Colors.black.withOpacity(0.75),
    fontSize: 14.sp,
    fontFamily: 'SFProText',
    fontWeight: FontWeight.w500,
  );
  @override
  void initState() {
    super.initState();
    fetchUsers();
    fetchUsers2();
    updatePieChartSections(selectedStartDate, selectedEndDate);
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('dd MMMM yyyy').format(today);
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
          child: SingleChildScrollView(
            child: Column(children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(
                        "Statistics".tr(),
                        style: TextStyle(
                            fontFamily: 'SFProText',
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w900,
                            color: AppColors.textBlack),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: topHabitSummary(),
              ),
              SizedBox(
                height: 30.h,
              ),
              statusDetails(),
              SizedBox(
                height: 30.h,
              ),
              datePicker(formattedDate, context),
              SizedBox(
                height: 50.h,
              ),
              labelValues.isNotEmpty
                  ? Column(
                      children: [
                        SizedBox(
                          height: 300.h,
                          width: 300.w,
                          child: PieChart(
                            PieChartData(
                              sections: pieChartSections,
                              borderData: FlBorderData(show: false),
                              centerSpaceRadius: 0,
                              sectionsSpace: 0,
                              centerSpaceColor: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(height: 50.h),
                        piechartIndicator(),
                        SizedBox(height: 30.h),
                      ],
                    )
                  : Container(child:  Text("No Data Found".tr())),
              labelValues1.isNotEmpty
                  ? Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Divider(
                              thickness: 1.h, color: const Color(0xFFD0D0D0)),
                        ),
                        Column(
                          children: [
                            SizedBox(
                              height: 20.h,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              child: Row(
                                children: [
                                  Text(
                                    'hours'.tr(),
                                    style: TextStyle(
                                      color: const Color(0xFF686873),
                                      fontSize: 16.sp,
                                      fontFamily: 'SFProText',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 30.h,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              child: SizedBox(
                                height: 150,
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
                                    maxY: maxY,
                                    barGroups: barChartGroups,
                                    titlesData: FlTitlesData(
                                      leftTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: true,
                                          getTitlesWidget: (value, meta) {
                                            return Text(
                                              value.toInt().toString(),
                                              style: TextStyle(
                                                color: const Color(0xFF686873),
                                                fontSize: 14.sp,
                                                fontFamily: 'SFProText',
                                                fontWeight: FontWeight.w600,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      rightTitles: const AxisTitles(
                                        sideTitles:
                                            SideTitles(showTitles: false),
                                      ),
                                      topTitles: const AxisTitles(
                                        sideTitles:
                                            SideTitles(showTitles: false),
                                      ),
                                      bottomTitles: const AxisTitles(
                                        sideTitles:
                                            SideTitles(showTitles: false),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  : Container(),

              SizedBox(height: 100.h),
              // Hours on the left side
            ]),
          ),
        ),
      ),
    );
  }

  Padding statusDetails() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Completion rate'.tr(),
                style: subtitleStyle,
              ),
              SizedBox(
                height: 5.h,
              ),
              Text(
                '%98',
                style: statusStyle(AppColors.completed),
              ),
              SizedBox(height: 15.h),
              Text(
                'Points Earned'.tr(),
                style: subtitleStyle,
              ),
              SizedBox(
                height: 5.h,
              ),
              Text(
                '98',
                style: statusStyle(AppColors.textBlack),
              ),
              SizedBox(height: 15.h),
              Text(
                'Skipped'.tr(),
                style: subtitleStyle,
              ),
              SizedBox(
                height: 5.h,
              ),
              Text(
                '7',
                style: statusStyle(AppColors.textBlack),
              ),
            ],
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Completed'.tr(),
                style: subtitleStyle,
              ),
              SizedBox(
                height: 5.h,
              ),
              Text(
                '69',
                style: statusStyle(AppColors.completed),
              ),
              SizedBox(height: 15.h),
              Text(
                'Best Streak'.tr(),
                style: subtitleStyle,
              ),
              SizedBox(
                height: 5.h,
              ),
              Text(
                '34',
                style: statusStyle(AppColors.textBlack),
              ),
              SizedBox(height: 15.h),
              Text(
                'Failed'.tr(),
                style: subtitleStyle,
              ),
              SizedBox(
                height: 5.h,
              ),
              Text(
                '3',
                style: statusStyle(AppColors.failed),
              ),
            ],
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Row topHabitSummary() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Container(
            height: 40.h,
            width: 40.w,
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Image.asset(
              AppImages.emoji,
              height: 24.h,
            ),
          ),
        ),
        SizedBox(
          width: 10.w,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'All Habits'.tr(),
              style: TextStyle(
                color: AppColors.black,
                fontSize: 20.sp,
                fontFamily: 'SFProText',
                fontWeight: FontWeight.w600,
                height: 0,
              ),
            ),
            Text(
              'Summary'.tr(),
              style: TextStyle(
                color: const Color(0xFF9B9BA1),
                fontSize: 14.sp,
                fontFamily: 'SFProText',
                fontWeight: FontWeight.w400,
                height: 0,
              ),
            ),
          ],
        )
      ],
    );
  }
}
