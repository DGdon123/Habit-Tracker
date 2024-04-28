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
import 'package:jovial_svg/jovial_svg.dart';
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

  SMINumber? noseNumber;
  SMINumber? beardAndHatNumber;
  SMINumber? bodyColorNumber;
  SMINumber? shoesNumber;
  SMINumber? clothingNumber;
  SMINumber? mouthNumber;
  SMINumber? eyeNumber;
  SMINumber? eyebrowsNumber;
  SMINumber? accNumber;
  SMINumber? hairNumber;

  Map<String, List<String>> files = {
    "female-hairstyle": [
      "Layer 58",
      "Layer 153",
      "Layer 197",
      "Layer 203",
      "Layer 207",
      "Layer 210"
    ],
    "female-eyebrow": ["Asset 45", "Asset 46", "Asset 47", "Asset 29"],
    "female-eye": [
      "Asset 49",
      "Asset 50",
      "Layer 265",
      "Layer 266",
      "Layer 267"
    ],
    "female-hat": ["Layer 155", "Layer 314"],
    "female-mouth": ["Asset 56", "Image 34", "Layer 226", "Layer 327"],
    "female-shoes": [
      "Layer 74",
      "Layer 79",
      "Layer 105",
      "Layer 115",
      "Layer 121",
      "Layer 186",
      "Layer 189",
    ],

    // male
    "male-shoes": [
      "Layer 23",
      "Layer 117",
      "Layer 156",
      "Layer 186",
      "Layer 277",
      "Layer 282",
      "Layer 284"
    ],
    'male-glasses': ["Layer 200", "Layer 201"],
    "male-hairstyle": [
      "Layer 83",
      "Layer 189",
      "Layer 191",
      "Layer 192",
      "Layer 193",
      "Layer 194",
      "Layer 195"
    ],
  };

  var character = "";

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

          character = widget.filePath.contains("character") ? "male" : "female";

          log("Character: $character");

          var controller =
              StateMachineController.fromArtboard(artboard, machineCode);

          if (controller != null) {
            artboard.addController(controller);

            controller.inputs.forEach((element) {
              log("Element: $element, ${element.name}, ${element.runtimeType}");

              // adding as per name, without this it wont change the value
              if (element.name == "clothing") {
                num = element as SMINumber;
              } else if (element.name == "hair") {
                hairNumber = element as SMINumber;
              } else if (element.name == "shoes") {
                shoesNumber = element as SMINumber;
              } else if (element.name == "eye") {
                eyeNumber = element as SMINumber;
              } else if (element.name == "eyebrows") {
                eyebrowsNumber = element as SMINumber;
              } else if (element.name == "mouth") {
                mouthNumber = element as SMINumber;
              } else if (element.name == "clothing") {
                clothingNumber = element as SMINumber;
              } else if (element.name == "bodyColor") {
                bodyColorNumber = element as SMINumber;
              } else if (element.name == "beardAndHat") {
                beardAndHatNumber = element as SMINumber;
              } else if (element.name == "nose") {
                noseNumber = element as SMINumber;
              } else if (element.name == "acc") {
                accNumber = element as SMINumber;
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

  String selectedAppIcon = AppIcons.hairstyle;
  String selectedIconName = "hairstyle";

  @override
  Widget build(BuildContext context) {
    hairNumber!.change(0.01);

    // 2nd: 0.5
    //
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
                                      selectedAppIcon = path;
                                    });
                                    selectedIconName =
                                        path.split("/").last.split(".").first;

                                    log("Selected icon name; $selectedIconName");
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20.w, vertical: 15.h),
                                    decoration: BoxDecoration(
                                      color: path == selectedAppIcon
                                          ? Colors.grey
                                          : Colors.white,
                                      border: Border(
                                        bottom: BorderSide(
                                            width: 1.w,
                                            color: const Color(0xFFD0D0D0)),
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
                              for (var path
                                  in files["$character-$selectedIconName"]!)
                                GestureDetector(
                                  onTap: () {
                                    log("clicked ${path.split(" ").last}, selectedIcon name: $selectedIconName");

                                    if (selectedIconName == "clothing") {
                                      num?.change(
                                          double.parse(path.split(" ").last));
                                    } else if (selectedIconName ==
                                        "hairstyle") {
                                      hairNumber?.change(
                                          double.parse(path.split(" ").last));
                                    } else if (selectedIconName == "shoes") {
                                      shoesNumber?.change(
                                          double.parse(path.split(" ").last));
                                    } else if (selectedIconName == "eye") {
                                      eyeNumber?.change(
                                          double.parse(path.split(" ").last));
                                    } else if (selectedIconName == "eyebrows") {
                                      eyebrowsNumber?.change(
                                          double.parse(path.split(" ").last));
                                    } else if (selectedIconName == "mouth") {
                                      mouthNumber?.change(
                                          double.parse(path.split(" ").last));
                                    } else if (selectedIconName == "clothing") {
                                      clothingNumber?.change(
                                          double.parse(path.split(" ").last));
                                    } else if (selectedIconName ==
                                        "bodyColor") {
                                      bodyColorNumber?.change(
                                          double.parse(path.split(" ").last));
                                    } else if (selectedIconName ==
                                        "beardAndHat") {
                                      beardAndHatNumber?.change(
                                          double.parse(path.split(" ").last));
                                    } else if (selectedIconName == "nose") {
                                      noseNumber?.change(
                                          double.parse(path.split(" ").last));
                                    } else if (selectedIconName == "acc") {
                                      accNumber?.change(
                                          double.parse(path.split(" ").last));
                                    }
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 2.w, vertical: 6.h),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                            width: 1.w,
                                            color: Color(0xFFD0D0D0)),
                                      ),
                                    ),
                                    child: FutureBuilder<ScalableImage>(
                                      future: ScalableImage.fromSvgAsset(
                                          rootBundle,
                                          "assets/$character/$selectedIconName/$path.svg"),
                                      builder: (context, snapshot) {
                                        log("File path: ${"assets/$character/$selectedIconName/$path.svg"}");
                                        if (snapshot.hasData) {
                                          return SizedBox(
                                            height: 72.h,
                                            width: 72.w,
                                            child: ScalableImageWidget(
                                                si: snapshot.data!),
                                          );
                                        }
                                        return const SizedBox();
                                      },
                                    ),
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
