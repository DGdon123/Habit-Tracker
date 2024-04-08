import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:habit_tracker/services/gym_firestore_services.dart';

class StartEndTimePicker extends StatefulWidget {
  const StartEndTimePicker({super.key});

  @override
  State<StartEndTimePicker> createState() => _StartEndTimePickerState();
}

class _StartEndTimePickerState extends State<StartEndTimePicker> {
  var startText = "Gym in time";
  var endText = "Gym out time";

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
                var res = await showTimePicker(
                    context: context, initialTime: TimeOfDay.now());
                debugPrint(res.toString());

                if (res == null) return;

                setState(() {
                  startText = res.format(context);
                });
              }),
          DatePicker(
              text: endText,
              onClick: () async {
                var res = await showTimePicker(
                    context: context, initialTime: TimeOfDay.now());

                if (res == null) return;

                setState(() {
                  endText = res.format(context);
                });
              }),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
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
                    GymFirestoreServices()
                        .upload(startText, endText)
                        .then((value) {
                      Navigator.pop(context);
                    }).onError((error, stackTrace) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                "Failed to upload data to Firebase: $error")),
                      );
                    });
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
