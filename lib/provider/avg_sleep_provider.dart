import 'package:flutter/material.dart';

class AvgSleepProvider with ChangeNotifier {
  String avgTime = "0";

  void setAvgTime(double avgTime) {
    debugPrint("Avg time: ${avgTime.toStringAsFixed(1)}");
    this.avgTime = avgTime.toStringAsFixed(1);
    notifyListeners();
  }
}
