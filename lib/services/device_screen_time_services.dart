import 'package:app_usage/app_usage.dart';
import 'package:flutter/cupertino.dart';

class DeviceScreenTimeServices {
  Future<Duration> getUsageStats() async {
    try {
      DateTime now = DateTime.now();
      DateTime endDate = DateTime.now();
      DateTime startDate =
          DateTime(endDate.year, endDate.month, now.day, 0, 0, 0, 0, 0);

      debugPrint("Start Date: $startDate, End Date: $endDate");

      List<AppUsageInfo> infoList =
          await AppUsage().getAppUsage(startDate, endDate);

      Duration usageDuration = const Duration();

      for (var info in infoList) {
        usageDuration += info.usage;
        debugPrint("App: ${info.packageName}, Usage: ${info.usage}");
      }

      debugPrint("Total Usage: $usageDuration");
      return usageDuration;
    } catch (exception) {
      debugPrint(exception.toString());
      return const Duration();
    }
  }
}
