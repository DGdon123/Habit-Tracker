import 'package:app_usage/app_usage.dart';
import 'package:flutter/cupertino.dart';

class DeviceScreenTimeServices {
  Future<Duration> getUsageStats() async {
    try {
      DateTime endDate = DateTime.now();
      DateTime startDate = endDate.subtract(Duration(hours: 1));
      List<AppUsageInfo> infoList =
          await AppUsage().getAppUsage(startDate, endDate);

      debugPrint("Start Date: $startDate, End Date: $endDate");

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
