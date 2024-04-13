import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';

class HealthAppServices {
  Future<void> connect() async {
    // configure the health plugin before use.
    Health().configure(useHealthConnectIfAvailable: true);

    // define the types to get
    var types = [
      HealthDataType.SLEEP_AWAKE,
      HealthDataType.SLEEP_ASLEEP,
      HealthDataType.SLEEP_IN_BED,
      HealthDataType.SLEEP_DEEP,
      HealthDataType.SLEEP_REM,
    ];

    var permissions  = [HealthDataAccess.READ, HealthDataAccess.READ,HealthDataAccess.READ, HealthDataAccess.READ,HealthDataAccess.READ  ];

    // requesting access to the data types before reading them
    bool requested = await Health().requestAuthorization(types, permissions: permissions);

    var now = DateTime.now();

    // fetch health data from the last 24 hours
    List<HealthDataPoint> healthData = await Health().getHealthDataFromTypes(
        types: types,
        startTime: now.subtract(const Duration(days: 5)),
        endTime: now);

    log("Health data length: ${healthData.length}");

    for (var data in healthData) {
      log("Data: $data");
    }
  }
}
