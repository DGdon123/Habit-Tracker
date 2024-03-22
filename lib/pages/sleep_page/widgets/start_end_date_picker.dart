import 'dart:developer';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';

class StartEndDatePicker extends StatefulWidget {
  final DateTime firstDate; // first date from the entered moods
  const StartEndDatePicker({super.key, required this.firstDate});

  @override
  State<StartEndDatePicker> createState() => _StartEndDatePickerState();
}

class _StartEndDatePickerState extends State<StartEndDatePicker> {
  var startText = "Start Date";
  var endText = "End Date";

  Map<String, DateTime> startEndTimes = {};

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
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
            backgroundColor: Colors.red.shade600,
          ),
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Colors.blue,
            disabledBackgroundColor: Colors.grey,
          ),
          onPressed: (startText.contains("Date") || endText.contains("Date"))
              ? null
              : () {
                  if (startText == endText) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content:
                            Text("Start date and end date cannot be the same."),
                      ),
                    );
                  } else {
                    Navigator.pop<Map<String, DateTime>>(
                        context, startEndTimes);
                  }
                },
          child: const Text('OK'),
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
          border: Border.all(),
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
                Text(text),
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
