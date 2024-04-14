import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:habit_tracker/utils/buttons.dart';
import 'package:habit_tracker/utils/colors.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRViewscreen extends StatefulWidget {
  const QRViewscreen({
    super.key,
  });

  @override
  State<QRViewscreen> createState() => _WorkoutTrackTypeState();
}

class _WorkoutTrackTypeState extends State<QRViewscreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? getUserID() {
    User? user = _auth.currentUser;
    return user?.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.arrow_back_rounded,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            );
          },
        ),
        title: Text(
          "Generate QR Code".tr(),
          style: TextStyle(
              fontFamily: 'SFProText',
              fontSize: 22.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textBlack),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  colors: [
                    AppColors.white,
                    AppColors.white,
                    Colors.white,
                  ],
                ),
              ),
              child: QrImageView(
                data: getUserID().toString(),
                version: QrVersions.auto,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
