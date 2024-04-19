import 'dart:developer';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habit_tracker/utils/colors.dart';
import 'package:habit_tracker/utils/icons.dart';
import 'package:habit_tracker/utils/images.dart';
import 'package:rive/rive.dart';

class CustomizeCharacter extends StatefulWidget {
  final String filePath;
  const CustomizeCharacter({super.key, required this.filePath});

  @override
  State<CustomizeCharacter> createState() => _CustomizeCharacterState();
}

class _CustomizeCharacterState extends State<CustomizeCharacter> {
  Artboard? riveArtboard;
  SMINumber? num;

  @override
  void initState() {
    super.initState();
    rootBundle.load(widget.filePath).then(
      (data) async {
        try {
          final file = RiveFile.import(data);
          final artboard = file.mainArtboard;

          var machineCode = widget.filePath.contains("character")
              ? 'State Machine 2'
              : 'State Machine 1';

          var controller =
              StateMachineController.fromArtboard(artboard, machineCode);

          log("Controller: $controller");

          if (controller != null) {
            artboard.addController(controller);

            controller.inputs.forEach((element) {
              // log("Element: $element, ${element.name}, ${element.runtimeType}");

              // adding as per name, without this it wont change the value
              if (element.name == "clothing") {
                num = element as SMINumber;
              }
            });
          }
          setState(() => riveArtboard = artboard);
        } catch (e) {
          print(e);
        }
      },
    );
  }

  List<String> iconsPath = [
    AppIcons.eye,
    AppIcons.eyebrow,
    AppIcons.nose,
    AppIcons.hairstyle,
    AppIcons.glasses,
    AppIcons.mouth,
    AppIcons.people,
    AppIcons.shoes,
    AppIcons.mustache,
    AppIcons.tshirt,
    AppIcons.pant,
    AppIcons.lipstick,
    AppIcons.headband,
    AppIcons.beard,
  ];

  String selectedIconPath = AppIcons.eye; // for selected icon path

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          margin: EdgeInsets.only(
              top: kIsWeb
                  ? 35.h
                  : Platform.isIOS
                      ? 50.h
                      : 30),
          child: Column(
            children: [
              topBar(),
              SizedBox(
                height: kIsWeb
                    ? 20.h
                    : Platform.isIOS
                        ? 5.h
                        : 20.h,
              ),
              Expanded(
                child: ListView(
                  children: [
                    // TextField(
                    //   onChanged: (value) {
                    //     num?.change(double.parse(value));
                    //   },
                    // ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(30.r),
                                topRight: Radius.circular(30.r),
                              ),
                              border: Border(
                                left: BorderSide.none,
                                top: BorderSide(
                                    width: 1.w, color: Color(0xFFD0D0D0)),
                                right: BorderSide(
                                    width: 1.w, color: Color(0xFFD0D0D0)),
                                bottom: BorderSide(
                                    width: 1.w, color: Color(0xFFD0D0D0)),
                              )),
                          child: Column(
                            children: [
                              for (var path in iconsPath)
                                GestureDetector(
                                  onTap: () {
                                    log("clicked");
                                    setState(() {
                                      selectedIconPath = path;
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20.w, vertical: 15.h),
                                    decoration: BoxDecoration(
                                      color: path == selectedIconPath
                                          ? Colors.grey
                                          : Colors.white,
                                      border: Border(
                                        bottom: BorderSide(
                                            width: 1.w,
                                            color: Color(0xFFD0D0D0)),
                                      ),
                                    ),
                                    child: SvgPicture.asset(
                                      path,
                                      height: 30.h,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),

                        // adjacent section
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(30.r),
                                topRight: Radius.circular(30.r),
                              ),
                              border: Border(
                                left: BorderSide.none,
                                top: BorderSide(
                                    width: 1.w, color: Color(0xFFD0D0D0)),
                                right: BorderSide(
                                    width: 1.w, color: Color(0xFFD0D0D0)),
                                bottom: BorderSide(
                                    width: 1.w, color: Color(0xFFD0D0D0)),
                              )),
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.w, vertical: 15.h),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        width: 1.w, color: Color(0xFFD0D0D0)),
                                  ),
                                ),
                                child: SvgPicture.asset(
                                  selectedIconPath,
                                  height: 30.h,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 4.w,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SizedBox(
                              width: 240.w,
                              height: 520.h,
                              child: Rive(
                                artboard: riveArtboard!,
                              ),
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10.w, vertical: 5.h),
                                  decoration: ShapeDecoration(
                                    color: AppColors.primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(100.r),
                                        topRight: Radius.circular(8.r),
                                        bottomLeft: Radius.circular(100.r),
                                        bottomRight: Radius.circular(8.r),
                                      ),
                                    ),
                                  ),
                                  child: SvgPicture.asset(
                                    AppIcons.undo,
                                    color: Colors.black.withOpacity(0.75),
                                  ),
                                ),
                                SizedBox(
                                  width: 5.w,
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10.w, vertical: 5.h),
                                  decoration: ShapeDecoration(
                                    color: AppColors.primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(8.r),
                                        topRight: Radius.circular(100.r),
                                        bottomLeft: Radius.circular(8.r),
                                        bottomRight: Radius.circular(100.r),
                                      ),
                                    ),
                                  ),
                                  child: SvgPicture.asset(
                                    AppIcons.redo,
                                    color: Colors.black.withOpacity(0.75),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Padding topBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              height: 40.h,
              width: 40.w,
              alignment: Alignment.center,
              decoration: ShapeDecoration(
                  color: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100.r),
                  )),
              child: SvgPicture.asset(
                AppIcons.cross,
                height: 20.h,
                color: Colors.black.withOpacity(0.75),
              ),
            ),
          ),
          Container(
            height: 40.h,
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            decoration: ShapeDecoration(
              color: AppColors.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            child: Text(
              'Save'.tr(),
              style: TextStyle(
                color: AppColors.textBlack,
                fontSize: 18.sp,
                fontFamily: 'SFProText',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
