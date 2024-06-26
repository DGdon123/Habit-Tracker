import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_date_range_picker/custom_date_range_picker.dart';
import 'package:day_night_time_picker/lib/state/time.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habit_tracker/pages/home_page.dart';
import 'package:habit_tracker/pages/screens/sleep%20wakeup/sleepTime.dart';
import 'package:habit_tracker/pages/sleep_page/widgets/bar_graph.dart';
import 'package:habit_tracker/pages/sleep_page/widgets/custom_bar_chart.dart';
import 'package:habit_tracker/pages/sleep_page/widgets/sleep_details.dart';
import 'package:habit_tracker/pages/sleep_page/widgets/sleep_wake_display_card.dart';
import 'package:habit_tracker/provider/avg_sleep_provider.dart';
import 'package:habit_tracker/provider/start_end_date_provider.dart';
import 'package:habit_tracker/services/sleep_firestore_services.dart';
import 'package:habit_tracker/utils/colors.dart';
import 'package:habit_tracker/utils/icons.dart';
import 'package:habit_tracker/utils/text_styles.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'widgets/start_end_date_picker.dart';

class SleepPage extends StatefulWidget {
  const SleepPage({super.key});

  @override
  State<SleepPage> createState() => SleepPageState();
}

class SleepPageState extends State<SleepPage> {
  @override
  Widget build(BuildContext context) {
    debugPrint("INside sleep");
    return SafeArea(
      top: false,
      child: Scaffold(
        body: Container(
          margin: EdgeInsets.only(
              top: kIsWeb
                  ? 35.h
                  : Platform.isIOS
                      ? 50.h
                      : 35.h),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(
                        "Sleep Time".tr(),
                        style: TextStyle(
                            fontFamily: 'SFProText',
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w900,
                            color: AppColors.textBlack),
                      ),
                    ),
                    SizedBox(
                      height: 28.h,
                      width: 28.w,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Sleep Time'.tr(),
                        style: TextStyles().titleStyle,
                      ),
                      StreamBuilder<QuerySnapshot>(
                          stream: SleepFireStoreServices()
                              .listenToTodayAddedSleepTime,
                          builder: (_, snapshot) {
                            if (snapshot.connectionState ==
                                    ConnectionState.waiting ||
                                snapshot.hasError) {
                              return SizedBox();
                            }

                            var docs = snapshot.data?.docs ?? [];

                            return GestureDetector(
                              onTap: docs.isNotEmpty
                                  ? null
                                  : () {
                                      debugPrint("Tapped");
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return SleepTime(); // Use the custom dialog
                                        },
                                      );
                                    },
                              child: Container(
                                  width: 40.h,
                                  height: 40.w,
                                  alignment: Alignment.center,
                                  decoration: ShapeDecoration(
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      side: const BorderSide(
                                          width: 1, color: Color(0xFFEAECF0)),
                                      borderRadius: BorderRadius.circular(16.r),
                                    ),
                                  ),
                                  child: SvgPicture.asset(
                                    AppIcons.plus,
                                    height: 24.h,
                                  )),
                            );
                          }),
                    ]),
              ),
              SizedBox(
                height: 20.h,
              ),
              StreamBuilder<QuerySnapshot>(
                  stream: SleepFireStoreServices().listenToTodayAddedSleepTime,
                  builder: (context, snapshot) {
                    debugPrint("Snapshot: ${snapshot.data?.docs.length}");

                    var snapshotLength = snapshot.data?.docs.length;

                    // we got data
                    if (snapshot.hasData &&
                        snapshot.connectionState == ConnectionState.active &&
                        snapshotLength != 0) {
                      var doc = snapshot.data!.docs[0];
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SleepWakeDisplayCard(
                                title: 'Sleep Time'.tr(),
                                bgColor: const Color(0xFF004AAD),
                                time: doc.get("sleepTime")),
                            SizedBox(
                              width: 4.w,
                            ),
                            SleepWakeDisplayCard(
                                title: 'Wake Time'.tr(),
                                bgColor: const Color(0xFFFFDE59),
                                time: doc.get("wakeTime")),
                          ],
                        ),
                      );
                    } else if (snapshotLength == 0) {
                      return Text("Add your sleep time".tr());
                    } else if (snapshot.hasError) {
                      return Text('Something went wrong'.tr());
                    }
                    return const CircularProgressIndicator();
                  }),
              SizedBox(
                height: 30.h,
              ),
              const SleepDetails(),
            ],
          ),
        ),
      ),
    );
  }
}
