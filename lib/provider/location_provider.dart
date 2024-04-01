import 'package:flutter/material.dart';

class LocationProvider with ChangeNotifier {
  double? _latitude;
  double? _longitude;

  double? get latitude => _latitude;
  double? get longitude => _longitude;

  void setLatitude(double newLatitude) {
    _latitude = newLatitude;
    notifyListeners();
  }

  void setLongitude(double newLongitude) {
    _longitude = newLongitude;
    notifyListeners();
  }
}
