import 'package:flutter/material.dart';

class SelectedDateProvider with ChangeNotifier {
  DateTime? _selectedDate;

  DateTime? get selectedDate => _selectedDate;

  void setSelectedDate(DateTime newDate) {
    _selectedDate = newDate;
    notifyListeners();
  }
}
