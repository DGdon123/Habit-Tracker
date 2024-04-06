import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habit_tracker/utils/colors.dart';
import 'package:habit_tracker/utils/icons.dart';

class ChatRoom extends StatefulWidget {
  const ChatRoom({super.key});

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

TextEditingController _textEditingController = TextEditingController();
void giftPop(){
  
}

class _ChatRoomState extends State<ChatRoom> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        shadowColor: CupertinoColors.extraLightBackgroundGray,
        elevation: 2,
        title: Text('Prakhyat Gurung'),
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
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
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
                        Padding(
                          padding: const EdgeInsets.only(left: 12),
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
                    Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: Container(
                            // width: 150,
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
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
                        Text(
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
                  SvgPicture.asset(
                    AppIcons.gift,
                    width: 35,
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: TextField(
                      style: TextStyle(
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
                    child: FloatingActionButton(
                      shape: const CircleBorder(),
                      onPressed: () {},
                      backgroundColor: AppColors.mainBlue,
                      elevation: 0,
                      child: const Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 18,
                      ),
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

