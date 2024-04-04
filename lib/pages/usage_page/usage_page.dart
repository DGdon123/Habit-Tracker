import 'package:app_usage/app_usage.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker/services/device_screen_time_services.dart';

class UsagePage extends StatelessWidget {
  const UsagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<Map<String, dynamic>>(
          future: DeviceScreenTimeServices().getUsageStats(),
          builder: (_, snapshot) {
            if (snapshot.hasData) {
              Map<String, dynamic> data = snapshot.data!;

              if (data.isEmpty) {
                return Text("No data".tr());
              }

              List<AppUsageInfo> usageList =
                  data["usageList"] as List<AppUsageInfo>;

              if (usageList.isEmpty) {
                return Text("No data".tr());
              } else {
                return Column(
                  children: [
                    Text("${"Start Date:".tr()} ${data["startDate"]}"),
                    Text("${"End Date:".tr()} ${data["endDate"]}"),
                    Expanded(
                      child: ListView.builder(
                          itemCount: usageList.length,
                          itemBuilder: (_, index) {
                            AppUsageInfo info = usageList[index];
                            return ListTile(
                              title: Text(info.appName),
                              subtitle: Column(
                                children: [
                                  Text("${"Duration".tr()}: ${info.usage}"),
                                  Text("${"Start Date:".tr()} ${info.startDate}"),
                                  Text("${"End Date:".tr()} ${info.endDate}"),
                                ],
                              ),
                            );
                          }),
                    ),
                  ],
                );
              }
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
