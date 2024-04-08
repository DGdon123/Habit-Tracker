import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageServices {
  // Check if the app is launched for the first time
  Future<bool> isAppLaunchedFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool status = prefs.getBool('isAppLaunchedFirstTime') ?? true;
    return status;
  }

  // Set the app launched first time flag
  Future<void> setIsAppLaunchedFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isAppLaunchedFirstTime', false);
  }

  // Check if automatic selection is set
  Future<bool> isAutomaticSelected() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool status = prefs.getBool('isAutomaticSelected') ?? false;
    return status;
  }

  // Set automatic selection
  Future<void> setAutomatic(bool selected) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isAutomaticSelected', selected);
  }
}
