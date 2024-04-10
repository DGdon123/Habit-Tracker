import 'dart:developer';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:habit_tracker/utils/colors.dart';

class StartEndDatePicker extends StatefulWidget {
  final DateTime firstDate; // first date from the entered moods
  const StartEndDatePicker({super.key, required this.firstDate});

  @override
  State<StartEndDatePicker> createState() => _StartEndDatePickerState();
}

class _StartEndDatePickerState extends State<StartEndDatePicker> {
  var startText = "Start Date".tr();
  var endText = "End Date".tr();

  Map<String, DateTime> startEndTimes = {};

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Filter Date',
        style: TextStyle(
            fontFamily: 'SfProText',
            color: Colors.black,
            letterSpacing: 0.5,
            fontWeight: FontWeight.w500),
      ),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          DatePicker(
              text: startText,
              onClick: () async {
                var res = await ShowDatePicker().selectStartDate(
                  context,
                  widget.firstDate,
                );
                if (res != null) {
                  startEndTimes["startDate"] = res;
                  setState(() {
                    startText = "${res.year}-${res.month}-${res.day}";
                  });
                }
              }),
          SizedBox(
            width: 20.w,
          ),
          DatePicker(
              text: endText,
              onClick: () async {
                var res = await ShowDatePicker().selectEndDate(
                  context,
                  widget.firstDate,
                );
                if (res != null) {
                  startEndTimes["endDate"] =
                      DateTime(res.year, res.month, res.day, 23, 59, 59, 999);
                  log(startEndTimes["endDate"].toString());
                  setState(() {
                    endText = "${res.year}-${res.month}-${res.day}";
                  });
                }
              }),
        ],
      ),
      actions: <Widget>[
        TextButton(
          style: TextButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
            backgroundColor: CupertinoColors.destructiveRed,
          ),
          onPressed: () => Navigator.pop<Map>(context, {}),
          child: Text(
            'Cancel'.tr(),
            style: TextStyle(
                fontFamily: 'SfProText',
                color: Colors.white,
                fontWeight: FontWeight.w500),
          ),
        ),
        TextButton(
          style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7)),
              backgroundColor: AppColors.widgetColorB,
              disabledBackgroundColor: AppColors.buttonColorG),
          onPressed: (startText.contains("Date".tr()) ||
                  endText.contains("Date".tr()))
              ? null
              : () {
                  if (startText == endText) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            "Start date and end date cannot be the same.".tr()),
                      ),
                    );
                  } else {
                    Navigator.pop<Map<String, DateTime>>(
                        context, startEndTimes);
                  }
                },
          child: Text(
            'OK'.tr(),
            style: TextStyle(
                fontFamily: 'SfProText',
                color: Colors.black,
                fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}

class DatePicker extends StatelessWidget {
  final String text;
  final VoidCallback onClick;
  const DatePicker({super.key, required this.text, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Ink(
        decoration: BoxDecoration(
          color: AppColors.widgetColorG,
          border: Border.all(width: .1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onClick,
          child: Container(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                const Icon(Icons.calendar_today),
                const SizedBox(width: 4),
                Text(
                  text,
                  style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ShowDatePicker {
  Future<DateTime?> selectStartDate(
      BuildContext context, DateTime firstDate) async {
    final DateTime? date = await showDialog(
        context: context,
        builder: (_) {
          return Dialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 16),
            child: CalendarDatePicker2WithActionButtons(
              onCancelTapped: () {
                Navigator.of(context).pop(null);
              },
              onValueChanged: (datetime) {
                Navigator.of(context).pop(datetime.first);
              },
              config: CalendarDatePicker2WithActionButtonsConfig(
                calendarType: CalendarDatePicker2Type.single,
                disableModePicker: true,
                firstDate: firstDate,
                lastDate: DateTime.now(),
              ),
              value: [DateTime.now()],
            ),
          );
        });
    return date;
  }

  Future<DateTime?> selectEndDate(
      BuildContext context, DateTime firstDate) async {
    final DateTime? date = await showDialog(
        context: context,
        builder: (_) {
          return Dialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 16),
            child: CalendarDatePicker2WithActionButtons(
              onCancelTapped: () {
                Navigator.of(context).pop(null);
              },
              onValueChanged: (datetime) {
                Navigator.of(context).pop(datetime.first);
              },
              config: CalendarDatePicker2WithActionButtonsConfig(
                calendarType: CalendarDatePicker2Type.single,
                disableModePicker: true,
                firstDate: firstDate,
                lastDate: DateTime.now(),
              ),
              value: [DateTime.now()],
            ),
          );
        });
    return date;
  }
}
