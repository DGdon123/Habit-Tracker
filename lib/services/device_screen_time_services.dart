import 'dart:developer';

import 'package:app_usage/app_usage.dart';
import 'package:flutter/cupertino.dart';

class DeviceScreenTimeServices {
  Future<Map<String, dynamic>> getUsageStats() async {
    try {
      DateTime endDate = DateTime.now();
      DateTime startDate = endDate.subtract(const Duration(hours: 1));
      List<AppUsageInfo> infoList =
          await AppUsage().getAppUsage(startDate, endDate);

      debugPrint("Start Date: $startDate, End Date: $endDate");

      Duration usageDuration = const Duration();

      List<AppUsageInfo> usageList = [];

      for (var info in infoList) {
        usageDuration += info.usage;
        usageList.add(info);

        debugPrint("App: ${info.packageName}, Usage: ${info.usage}");
      }

      debugPrint("Total Usage: $usageDuration");
      return {
        "usage": usageDuration,
        "usageList": usageList,
        "startDate": startDate,
        "endDate": endDate,
      };
    } catch (exception) {
      debugPrint(exception.toString());
      return {};
    }
  }
}
