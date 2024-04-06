import 'package:flutter/material.dart';

class GoalsProvider with ChangeNotifier {
  int _sleepgoals = 0; // Initial value for the image path

  int get goals => _sleepgoals;

  int setSelectedIndex(int newIndex) {
    _sleepgoals = newIndex;
    notifyListeners();
    return _sleepgoals;
  }

  int _screentime = 0; // Initial value for the image path

  int get goals1 => _screentime;

  int setSelectedIndex1(int newIndex) {
    _screentime = newIndex;
    notifyListeners();
    return _screentime;
  }

  int _focustime = 0; // Initial value for the image path

  int get goals2 => _focustime;

  int setSelectedIndex2(int newIndex) {
    _focustime = newIndex;
    notifyListeners();
    return _focustime;
  }

  int _workouttime = 0; // Initial value for the image path

  int get goals3 => _focustime;

  int setSelectedIndex3(int newIndex) {
    _workouttime = newIndex;
    notifyListeners();
    return _workouttime;
  }
}
