import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habit_tracker/pages/home_page.dart';
import 'package:habit_tracker/provider/index_provider.dart';
import 'package:habit_tracker/services/xp_firestore_services.dart';
import 'package:habit_tracker/utils/colors.dart';
import 'package:habit_tracker/utils/icons.dart';
import 'package:habit_tracker/utils/images.dart';
import 'package:hive/hive.dart';
import 'package:audioplayers/audioplayers.dart' as de;
import 'package:provider/provider.dart';

class FocusTimerComplete extends StatefulWidget {
  int? minute;
  int? hour;
  int? seconds;
  String? label;
  int? xp;

  FocusTimerComplete(
      {super.key, this.xp, this.label, this.hour, this.minute, this.seconds});

  @override
  State<FocusTimerComplete> createState() => _PickCharacterPageState();
}

class _PickCharacterPageState extends State<FocusTimerComplete> {
  de.AudioPlayer audioPlayer = de.AudioPlayer();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          audioPlayer.stop();
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const HomePage()),
                              (route) => false);
                          context.read<IndexProvider>().setSelectedIndex(3);
                        },
                        child: SizedBox(
                          height: 28,
                          width: 28,
                          child: SvgPicture.asset(
                            AppIcons.back,
                          ),
                        ),
                      ),
                      const Spacer()
                    ],
                  ),
                ),
                SizedBox(
                  height: 30.h,
                ),
                Text(
                  'Good Job!'.tr(),
                  style: TextStyle(
                      fontFamily: 'SfProText',
                      fontSize: 65.sp,
                      fontWeight: FontWeight.w600),
                ),
                Image.asset(
                  AppImages.characterFull,
                  height: 450.h,
                ),
                SizedBox(
                  height: 40.h,
                ),
                if (widget.hour != 0 &&
                    widget.minute != 0 &&
                    widget.seconds != 0)
                  Text(
                    '${widget.hour} hour ${widget.minute} min ${widget.seconds} sec',
                    style: TextStyle(
                        fontFamily: 'SfProText',
                        fontSize: 35.sp,
                        fontWeight: FontWeight.w400),
                  )
                else if (widget.hour == 0 &&
                    widget.minute != 0 &&
                    widget.seconds != 0)
                  Text(
                    '${widget.minute} min ${widget.seconds} sec',
                    style: TextStyle(
                        fontFamily: 'SfProText',
                        fontSize: 35.sp,
                        fontWeight: FontWeight.w400),
                  ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
                  decoration: BoxDecoration(
                      color: AppColors.widgetColorG,
                      borderRadius: BorderRadius.circular(12)),
                  child: Text(
                    '+${widget.xp} XP',
                    style: TextStyle(
                        fontFamily: 'SfProText',
                        fontSize: 35.sp,
                        fontWeight: FontWeight.w600),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
