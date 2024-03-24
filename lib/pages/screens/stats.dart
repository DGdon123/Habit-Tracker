import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
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
  bool select = false;
  Future<Map<String, dynamic>> fetchUsers() async {
    CollectionReference users =
        FirebaseFirestore.instance.collection('stopwatch');

    String? userID = getUserID(); // Get the current user's ID
    // Initialize a list to hold the Text widgets

    if (userID != null) {
      try {
        QuerySnapshot snapshot =
            await users.where('ID', isEqualTo: userID).get();
        if (snapshot.docs.isNotEmpty) {
          for (var doc in snapshot.docs) {
            var data = doc.data()
                as Map<String, dynamic>; // Cast data to Map<String, dynamic>

            // Iterate through each field in the data and create a Text widget for each field
            userLabels.addAll(data);
            logger.d(userLabels);
          }
        } else {
          print('No data found for the current user');
        }
      } catch (error) {
        print("Failed to fetch users: $error");
      }
    } else {
      print('User ID is null');
    }

    return userLabels; // Return the list of Text widgets
  }

  Future<Map<String, dynamic>> fetchUsers2() async {
    CollectionReference users =
        FirebaseFirestore.instance.collection('focus_timer');

    String? userID = getUserID(); // Get the current user's ID
    // Initialize a list to hold the Text widgets

    if (userID != null) {
      try {
        QuerySnapshot snapshot =
            await users.where('ID', isEqualTo: userID).get();
        if (snapshot.docs.isNotEmpty) {
          for (var doc in snapshot.docs) {
            var data = doc.data()
                as Map<String, dynamic>; // Cast data to Map<String, dynamic>

            // Iterate through each field in the data and create a Text widget for each field

            userLabels2.addAll(
                data); // Create a Text widget for the field and add it to the list

            logger.d(userLabels2);
          }
        } else {
          print('No data found for the current user');
        }
      } catch (error) {
        print("Failed to fetch users: $error");
      }
    } else {
      print('User ID is null');
    }

    return userLabels2; // Return the list of Text widgets
  }

  Padding piechartIndicator() {
    // Call updatePieChartSections to fetch user labels and update the pieChartSections list
    updatePieChartSections();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
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
                      section.title,
                      style: secondaryStyle,
                    ),
                    SizedBox(width: 10.w),
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

  List<PieChartSectionData> pieChartSections = [];

  Future<void> updatePieChartSections() async {
    // Fetch user labels

    // Iterate over user labels and create PieChartSectionData objects
    userLabels.forEach((key, value) {
      // Skip keys that are not labels

      // Extract the label value
      String label = value['Label'].toString();
      logger.d(label);
      // Create a PieChartSectionData object for each label
      PieChartSectionData section = PieChartSectionData(
        color: getRandomColor(), // Get a random color for the section
        value: 30, // Set the value to 0 initially
        title: label, // Set the label as the title
        radius: 150,
        titleStyle: TextStyle(
          color: Colors.white,
          fontSize: 10.sp,
          fontFamily: 'SFProText',
          fontWeight: FontWeight.w600,
          height: 0.20,
        ),
      );

      // Add the section to the pieChartSections list
      pieChartSections.add(section);
    });
  }

  Color getRandomColor() {
    // Generate a random color
    return Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
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
                        "Statistics",
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
              SizedBox(height: 70.h),
              piechartIndicator(),
              SizedBox(height: 50.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Divider(thickness: 1.h, color: const Color(0xFFD0D0D0)),
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
                          'hours',
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
                          maxY: 14,
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
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            bottomTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 100.h),
              // Hours on the left side
            ]),
          ),
        ),
      ),
    );
  }

  List<BarChartGroupData> barChartGroups = [
    BarChartGroupData(x: 0, barRods: [
      BarChartRodData(
        borderRadius: BorderRadius.circular(100.r),
        width: 40.w,
        toY: 0,
        fromY: 3, // Use the same data from the pie chart (adjust as needed)
        color: Colors.blue,
      ),
    ]),
    BarChartGroupData(x: 1, barRods: [
      BarChartRodData(
        borderRadius: BorderRadius.circular(100.r),
        width: 40.w,
        toY: 0,
        fromY: 7, // Use the same data from the pie chart (adjust as needed)
        color: Colors.green,
      ),
    ]),
    BarChartGroupData(x: 2, barRods: [
      BarChartRodData(
        borderRadius: BorderRadius.circular(100.r),
        width: 40.w,
        toY: 0,
        fromY: 12, // Use the same data from the pie chart (adjust as needed)
        color: Colors.red,
      ),
    ]),
    BarChartGroupData(x: 3, barRods: [
      BarChartRodData(
        borderRadius: BorderRadius.circular(100.r),
        width: 40.w,
        toY: 0,
        fromY: 5, // Use the same data from the pie chart (adjust as needed)
        color: Colors.pink,
      ),
    ]),
  ];

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
            onTap: () {
              showCustomDateRangePicker(
                fontFamily: "SFProText",
                context,
                dismissible: true,
                minimumDate: DateTime.now().subtract(const Duration(days: 30)),
                maximumDate: DateTime.now().add(const Duration(days: 30)),
                endDate: endDate,
                startDate: startDate,
                backgroundColor: Colors.white,
                primaryColor: AppColors.black,
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

  Padding statusDetails() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Completion rate',
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
                'Points Earned',
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
                'Skipped',
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
                'Completed',
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
                'Best Streak',
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
                'Failed',
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
              'All Habits',
              style: TextStyle(
                color: AppColors.black,
                fontSize: 20.sp,
                fontFamily: 'SFProText',
                fontWeight: FontWeight.w600,
                height: 0,
              ),
            ),
            Text(
              'Summary',
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
