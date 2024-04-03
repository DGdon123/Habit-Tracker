import 'package:app_usage/app_usage.dart';
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
                return const Text("No data");
              }

              List<AppUsageInfo> usageList =
                  data["usageList"] as List<AppUsageInfo>;

              if (usageList.isEmpty) {
                return const Text("No data");
              } else {
                return Column(
                  children: [
                    Text("Start Date: ${data["startDate"]}"),
                    Text("End Date: ${data["endDate"]}"),
                    Expanded(
                      child: ListView.builder(
                          itemCount: usageList.length,
                          itemBuilder: (_, index) {
                            AppUsageInfo info = usageList[index];
                            return ListTile(
                              title: Text(info.appName),
                              subtitle: Column(
                                children: [
                                  Text("Duration: ${info.usage}"),
                                  Text("Start Date: ${info.startDate}"),
                                  Text("End Date: ${info.endDate}"),
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
