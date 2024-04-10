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
}
