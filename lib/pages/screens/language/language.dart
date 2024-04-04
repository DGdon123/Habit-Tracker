import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker/pages/screens/settings/settings.dart';
import 'package:habit_tracker/provider/flag_provider.dart';
import 'package:habit_tracker/utils/colors.dart';
import 'package:habit_tracker/utils/images.dart';
import 'package:provider/provider.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class LanguageSelection extends StatefulWidget {
  const LanguageSelection({super.key});
  @override
  State<LanguageSelection> createState() => _LanguageSelectionState();
}

class _LanguageSelectionState extends State<LanguageSelection> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? selectedLanguage;
  Locale _currentLocale = const Locale('en', 'US');
  @override
  void initState() {
    super.initState();
    selectedLanguage = getLanguage();
    if (selectedLanguage == null ||
        selectedLanguage!.isEmpty ||
        selectedLanguage != "English" ||
        selectedLanguage != "Chinese" ||
        selectedLanguage != "German") {
      selectedLanguage = "English";
    }
  }

  String? getLanguage() {
    User? user = _auth.currentUser;
    return user?.photoURL;
  }

  @override
  Widget build(BuildContext context) {
    log(selectedLanguage.toString());
    TextStyle settingsStyle = TextStyle(
      fontSize: 16.sp,
      fontWeight: FontWeight.bold,
      color: AppColors.black.withOpacity(0.5),
    );
    final flagImageProvider =
        Provider.of<FlagImageProvider>(context, listen: false);
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20.h,
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SettingsPage()),
                          (route) => false);
                    },
                    child: SizedBox(
                        height: 28.h,
                        width: 28.w,
                        child: const Icon(Icons.arrow_back)),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Change Language".tr(),
                    style: Theme.of(context).textTheme.displayLarge!.copyWith(
                        color: AppColors.black.withOpacity(0.5), fontSize: 24),
                  ),
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              ListTile(
                  leading: Image.asset(
                    AppImages.usa,
                    height: 25,
                  ),
                  title: Text(
                    'English'.tr(),
                    style: settingsStyle,
                  ),
                  trailing: selectedLanguage == 'English'.tr()
                      ? const Icon(Icons.check, color: AppColors.mainBlue)
                      : null,
                  onTap: () {
                    setState(() {
                      selectedLanguage = 'English'.tr();
                    });
                    const newLocale = Locale('en', 'US');
                    EasyLocalization.of(context)?.setLocale(newLocale);
                    setState(() {
                      _currentLocale = newLocale;
                    });
                    flagImageProvider.setImagePath(AppImages.usa);
                  }),
              const Divider(),
              ListTile(
                leading: Image.asset(
                  AppImages.china,
                  height: 25,
                ),
                title: Text(
                  'Chinese'.tr(),
                  style: settingsStyle,
                ),
                trailing: selectedLanguage == 'Chinese'.tr()
                    ? const Icon(Icons.check, color: AppColors.mainBlue)
                    : null,
                onTap: () {
                  setState(() {
                    selectedLanguage = 'Chinese'.tr();
                  });
                  const newLocale = Locale('zh', 'CN');
                  EasyLocalization.of(context)?.setLocale(newLocale);
                  setState(() {
                    _currentLocale = newLocale;
                  });
                  flagImageProvider.setImagePath(AppImages.china);
                },
              ),
              const Divider(),
              ListTile(
                leading: Image.asset(
                  AppImages.germany,
                  height: 25,
                ),
                title: Text(
                  'German'.tr(),
                  style: settingsStyle,
                ),
                trailing: selectedLanguage == 'German'.tr()
                    ? const Icon(Icons.check, color: AppColors.mainBlue)
                    : null,
                onTap: () {
                  setState(() {
                    selectedLanguage = 'German'.tr();
                  });
                  const newLocale = Locale('de', 'DE');
                  EasyLocalization.of(context)?.setLocale(newLocale);
                  setState(() {
                    _currentLocale = newLocale;
                  });
                  flagImageProvider.setImagePath(AppImages.germany);
                },
              ),
              const Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
