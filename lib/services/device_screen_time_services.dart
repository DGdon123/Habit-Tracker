import 'package:app_usage/app_usage.dart';
import 'package:flutter/cupertino.dart';

class DeviceScreenTimeServices {
  Future<void> getUsageStats() async {
    try {
      DateTime endDate = DateTime.now();
      DateTime startDate =
          DateTime(endDate.year, endDate.month, endDate.day - 1);
      List<AppUsageInfo> infoList =
          await AppUsage().getAppUsage(startDate, endDate);

      debugPrint("Info list: ${infoList.length}");

      var currentDuration = Duration.zero;

      for (var info in infoList) {
        currentDuration += info.usage;

        debugPrint("App Name: ${info.appName}, ${info.usage}");
      }

      debugPrint("Total Duration: ${currentDuration.inHours}");
    } on AppUsageException catch (exception) {
      debugPrint(exception.toString());
    }
  }
}
