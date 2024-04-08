import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habit_tracker/pages/profile_page/widgets/delete_confirmation_dialog.dart';
import 'package:habit_tracker/services/friend_firestore_services.dart';
import 'package:habit_tracker/utils/icons.dart';
import 'package:habit_tracker/utils/images.dart';

class FriendContainer extends StatelessWidget {
  final String name;
  final String uid;
  final String photoUrl;
  final void Function() onPressed;
  const FriendContainer(
      {super.key,
      required this.name,
      required this.uid,
      required this.onPressed,
      required this.photoUrl});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        margin: EdgeInsets.only(bottom: 10.h),
        padding: const EdgeInsets.all(16),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 1, color: Color(0xFFEAECF0)),
            borderRadius: BorderRadius.circular(16.r),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x0F222C5C),
              blurRadius: 68,
              offset: Offset(58, 26),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Column(
                  children: [
                    photoUrl.isEmpty
                        ? CircleAvatar(
                            child: Text(name[0]),
                          )
                        : CircleAvatar(
                            backgroundImage: NetworkImage(photoUrl),
                          ),
                  ],
                ),
                SizedBox(
                  width: 10.w,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        color: const Color(0xFF040415),
                        fontSize: 16.sp,
                        fontFamily: 'SFProText',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '912 XP',
                      style: TextStyle(
                        color: const Color(0xFF9B9BA1),
                        fontSize: 14.sp,
                        fontFamily: 'SF Pro Text',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                )
              ],
            ),
            GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (_) => DeleteConfirmationDialog(
                          onTap: () {
                            FriendFirestoreServices()
                                .removeAddedFriend(friendID: uid);
                          },
                        ));
              },
              child: SvgPicture.asset(
                AppIcons.unfriend,
                height: 32.h,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
