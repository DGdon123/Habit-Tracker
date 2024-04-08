import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habit_tracker/utils/buttons.dart';
import 'package:habit_tracker/utils/colors.dart';
import 'package:habit_tracker/utils/icons.dart';
import 'package:hive/hive.dart';

class ChatRoom extends StatefulWidget {
  String? name;
  ChatRoom({super.key, this.name});

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

TextEditingController _textEditingController = TextEditingController();



void giftPopUp(BuildContext context) {
  final _xpController = TextEditingController();

  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text(
              'Gift XP to your friend',
              style: TextStyle(
                color: AppColors.textBlack,
                fontSize: 19.sp,
                fontFamily: 'SFProText',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 20,
              ),
              SvgPicture.asset(
                AppIcons.twogift,
                width: 80.w,
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(

                controller: _xpController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                    hintStyle: TextStyle(

                      color: CupertinoColors.systemGrey,
                    ),
                    labelText: 'XP',
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide:

                            BorderSide(color: AppColors.blue, width: 1)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(

                            color: AppColors.widgetColorB, width: 0.4))),
              ),
            ],
          ),
          actions: [CustomButton(text: 'Send Gift', onPressed: () {})],
        );
      });
}

class _ChatRoomState extends State<ChatRoom> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        shadowColor: CupertinoColors.extraLightBackgroundGray,
        elevation: 2,
        title: Text(widget.name.toString()),
      ),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: CircleAvatar(
                        radius: 14.w,
                        backgroundColor: CupertinoColors.systemGrey,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: Container(
                            // width: 150,
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                                color: CupertinoColors.lightBackgroundGray,
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(8),
                                    topLeft: Radius.circular(8),
                                    bottomRight: Radius.circular(8))),
                            child: Text(
                              'How are you',
                              style: TextStyle(
                                color: AppColors.textBlack,
                                fontSize: 16.sp,
                                fontFamily: 'SFProText',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 12),
                          child: Text(
                            '14:59',
                            style: TextStyle(color: CupertinoColors.systemGrey),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: Container(
                            // width: 150,
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                                color: AppColors.mainBlue,
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(8),
                                    topLeft: Radius.circular(8),
                                    bottomLeft: Radius.circular(8))),
                            child: Text(
                              'I am fine you?',
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 16.sp,
                                fontFamily: 'SFProText',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        const Text(
                          '15:00',
                          style: TextStyle(color: CupertinoColors.systemGrey),
                        ),
                      ],
                    ),
                    CircleAvatar(
                      radius: 14.w,
                      backgroundColor: AppColors.widgetColorB,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              color: CupertinoColors.lightBackgroundGray,
              child: Row(
                children: [
                  const SizedBox(
                    width: 15,
                  ),
                  GestureDetector(
                    onTap: () {
                      return giftPopUp(context);
                    },
                    child: SvgPicture.asset(
                      AppIcons.gift,
                      width: 30,
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: TextField(
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                      controller: _textEditingController,
                      decoration: const InputDecoration(
                          hintText: "Write message...",
                          hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 40,
                      width: 40,
                      child: FloatingActionButton(
                          shape: const CircleBorder(),
                          onPressed: () {},
                          backgroundColor: AppColors.blue,
                          elevation: 0,
                          child: SvgPicture.asset(
                            AppIcons.sendIcon,
                            width: 18,
                          )),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
