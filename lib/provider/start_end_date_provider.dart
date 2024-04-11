import 'dart:developer';

import 'package:flutter/material.dart';

class StartEndDateProvider with ChangeNotifier {
  DateTime endDate = DateTime.now();
  DateTime startDate = DateTime.now().subtract(const Duration(days: 7));

  void setDate({required DateTime startDate, required DateTime endDate}) {
    this.startDate = startDate;
    this.endDate = endDate;

    log("Start date: $startDate, End date: $endDate");

    notifyListeners();
  }

  // return List<String> of date between start and end date
  List<String> findDateRange() {
    List<String> dateList = [];
    for (var i = startDate;
        i.isBefore(endDate.add(const Duration(days: 1)));
        i = i.add(const Duration(days: 1))) {
      dateList.add(i.toString().substring(0, 10));
    }
    return dateList;
  }

  // returns the day between start and end date
  List<String> findDayRange() {
    List<String> dayList = [];
    for (var i = startDate;
        i.isBefore(endDate.add(Duration(days: 1)));
        i = i.add(Duration(days: 1))) {
      dayList.add(i.day.toString());
    }

    return dayList;
  }
}
