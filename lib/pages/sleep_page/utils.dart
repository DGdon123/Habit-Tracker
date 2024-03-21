import 'package:flutter/material.dart';

class SleepPageUtils {
  /// returns a list of dates between the start and end date
  List<String> findLast7Days() {
    DateTime endDate = DateTime.now();
    DateTime startDate = endDate
        .subtract(Duration(days: 6)); // Subtract 6 days to get 7 days total

    List<String> dateList = [];
    for (var i = startDate;
        i.isBefore(endDate.add(Duration(days: 1)));
        i = i.add(Duration(days: 1))) {
      dateList.add(i.toString().substring(0, 10));
    }

    return dateList;
  }

  /// returns a list of days between the start and end date
  List<String> findDayRange(String startDateStr, String endDateStr) {
    DateTime startDate = DateTime.parse(startDateStr);
    DateTime endDate = DateTime.parse(endDateStr);

    List<String> dayList = [];
    for (var i = startDate;
        i.isBefore(endDate.add(Duration(days: 1)));
        i = i.add(Duration(days: 1))) {
      dayList.add(i.day.toString());
    }

    return dayList;
  }

  String roundHourAndMinute(int differenceInMinutes) {
    int roundedHour = differenceInMinutes ~/ 60;
    int roundedMinute;

    if (differenceInMinutes % 60 <= 15) {
      roundedMinute = 0;
    } else if (differenceInMinutes % 60 <= 30) {
      roundedMinute = 25;
    } else if (differenceInMinutes % 60 <= 45) {
      roundedMinute = 50;
    } else {
      roundedHour += 1;
      roundedMinute = 0;
    }

    return '$roundedHour.$roundedMinute';
  }
}
