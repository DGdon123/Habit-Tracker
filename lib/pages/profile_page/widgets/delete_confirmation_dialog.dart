import 'dart:developer';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker/services/friend_firestore_services.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  final VoidCallback onTap;
  const DeleteConfirmationDialog({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title:  Text('Confirm Deletion'.tr()),
      content: const Text('Are you sure you want to delete?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: TextButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
          ),
          child:  Text('Cancel'.tr()),
        ),
        TextButton(
          onPressed: () {
            onTap();
            Navigator.pop(context);
          },
          style: TextButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          child:  Text('Delete'.tr()),
        ),
      ],
    );
  }
}
