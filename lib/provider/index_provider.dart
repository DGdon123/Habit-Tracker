import 'package:flutter/material.dart';

class IndexProvider with ChangeNotifier {
  int selectedIndex = 2;

  void setSelectedIndex(int newIndex) {
    selectedIndex = newIndex;
    notifyListeners();
  }
}
