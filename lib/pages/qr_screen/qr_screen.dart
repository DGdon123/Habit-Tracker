import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:habit_tracker/pages/home_page.dart';
import 'package:habit_tracker/pages/qr_screen/qr_view_screen.dart';
import 'package:habit_tracker/utils/buttons.dart';
import 'package:habit_tracker/utils/colors.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:habit_tracker/services/friend_firestore_services.dart';
import 'package:provider/provider.dart';

import '../../provider/index_provider.dart';

class QRscreen extends StatefulWidget {
  const QRscreen({
    super.key,
  });

  @override
  State<QRscreen> createState() => _WorkoutTrackTypeState();
}

class _WorkoutTrackTypeState extends State<QRscreen> {
  String _scanResult = 'No QR code scanned yet';
  Future<void> _scanQRCode() async {
    try {
      String scanResult = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.QR,
      );

      if (scanResult != '-1') {
        setState(() {
          _scanResult = scanResult;
          FriendFirestoreServices()
              .qracceptFriendRequest(senderID: _scanResult);
        });
      } else {
        print('User canceled the scan');
      }
    } catch (e) {
      print('Error while scanning QR code: $e');
    }
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
          "QR Code".tr(),
          style: TextStyle(
              fontFamily: 'SFProText',
              fontSize: 22.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textBlack),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 30.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 30.w,
            ),
            child: CustomButton(
              text: 'Generate QR Code'.tr(),
              onPressed: () async {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const QRViewscreen()));
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 20.h),
            child: CustomButton(
              text: 'Scan QR Code'.tr(),
              onPressed: () async {
                _scanQRCode();
                const snackBar = SnackBar(
  content: Text('Added Successfully!'),
);
            ScaffoldMessenger.of(context).showSnackBar(snackBar);

                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_)=>HomePage()), (route) => false);
                 context.read<IndexProvider>().setSelectedIndex(4);
              },
            ),
          ),
        ],
      ),
    );
  }
}
