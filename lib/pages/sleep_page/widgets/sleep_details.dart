import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habit_tracker/provider/avg_sleep_provider.dart';
import 'package:habit_tracker/provider/start_end_date_provider.dart';
import 'package:habit_tracker/utils/icons.dart';
import 'package:habit_tracker/utils/text_styles.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'bar_graph.dart';
import 'start_end_date_picker.dart';

class SleepDetails extends StatefulWidget {
  const SleepDetails({super.key});

  @override
  State<SleepDetails> createState() => _SleepDetailsState();
}

class _SleepDetailsState extends State<SleepDetails> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // date range picker
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () async {
                      await showDialog<Map<String, dynamic>>(
                          context: context,
                          builder: (_) {
                            return StartEndDatePicker(
                              firstDate: DateTime(2024, 3, 1),
                            );
                          }).then((value) {
                        if (value == null) return;
                        if (value.isEmpty) return;
                        context.read<StartEndDateProvider>().setStartDate(
                            startDate: value["startDate"],
                            endDate: value["endDate"]);
                      });
                    },
                    child: Row(
                      children: [
                        // date filtering
                        Consumer<StartEndDateProvider>(
                          builder: (context, startEndDateProvider, child) {
                            var startDate = startEndDateProvider.startDate;
                            var endDate = startEndDateProvider.endDate;
                            debugPrint(
                                "StartDate: $startDate, EndDate: $endDate");
                            return Text(
                              '${DateFormat("MMM dd").format(startDate)} - ${DateFormat("MMM dd").format(endDate)}',
                              style: TextStyles().subtitleStyle,
                            );
                          },
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        SvgPicture.asset(AppIcons.dropdown),
                      ],
                    ),
                  ),
                  Text(
                    '${DateTime.now().year}',
                    style:
                        TextStyles().secondaryTextStyle(14.sp, FontWeight.w400),
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Consumer<AvgSleepProvider>(builder: (_, avgSleep, __) {
                    return Text(
                      "${avgSleep.avgTime}H",
                      style: TextStyles().subtitleStyle,
                    );
                  }),
                  Text(
                    'Avg sleep time',
                    style:
                        TextStyles().secondaryTextStyle(14.sp, FontWeight.w400),
                  )
                ],
              ),
            ],
          ),
        ),

        SizedBox(
          height: 40.h,
        ),

        BarGraph(),
      ],
    );
  }
}
