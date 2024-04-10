import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:habit_tracker/auth/accountSetup.dart';
import 'package:habit_tracker/auth/accountSetup1.dart';
import 'package:habit_tracker/auth/forgot_password.dart';
import 'package:habit_tracker/pages/home_page.dart';
import 'package:habit_tracker/pages/profile_page/widgets/friends_list_view.dart';
import 'package:habit_tracker/pages/profile_page/widgets/received_friend_request.dart';

import 'package:habit_tracker/pages/friend_searched_page/friend_searched_page.dart';

import 'package:habit_tracker/pages/screens/settings/settings.dart';
import 'package:habit_tracker/provider/index_provider.dart';
import 'package:habit_tracker/services/user_firestore_services.dart';
import 'package:habit_tracker/services/xp_firestore_services.dart';
import 'package:habit_tracker/utils/buttons.dart';
import 'package:habit_tracker/utils/colors.dart';
import 'package:habit_tracker/utils/icons.dart';
import 'package:habit_tracker/utils/images.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

import 'widgets/friends_list_view.dart';
import 'widgets/received_friend_request.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final List<Widget> _pages = [
    const ActivityPage(),
    const FriendsPageTab(),
  ];
  String? getUsername() {
    User? user = _auth.currentUser;
    return user?.displayName;
  }

  String? getUserID() {
    User? user = _auth.currentUser;
    return user?.uid;
  }

  int focus = 0;
  int screen = 0;
  int sleep = 0;
  int workout = 0;
  int xp = 0;

  Future<void> fetchUsers() async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    String? currentUserUid = getUserID();

    try {
      QuerySnapshot snapshot = await users.get();

      for (var doc in snapshot.docs) {
        String uid = doc.id;
        Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;

        if (uid == currentUserUid) {
          // This user document matches the current user
          // You can access the user data and do something with it
          setState(() {
            focus = userData['focusTime'];
            screen = userData['screenTime'];
            sleep = userData['sleepGoals'];
            xp = userData['xp'] ?? 0;
            workout = userData['workoutFrequency'];
          });

          // Example: Use the latitude and longitude data
          // SomeFunctionToUseLocation(latitude, longitude);
        }
      }
    } catch (error) {
      print("Failed to fetch users: $error");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        body: DefaultTabController(
          length: 2,
          child: Container(
            margin: EdgeInsets.only(top: Platform.isIOS ? 50.h : 35.h),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          "Profile".tr(),
                          style: TextStyle(
                              fontFamily: 'SFProText',
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w900,
                              color: AppColors.textBlack),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30.h),
                topBar(),
                SizedBox(
                  height: 30.h,
                ),
                midBar(),
                SizedBox(height: 30.h),
                tabBar(),
                SizedBox(height: 20.h),
                Container(
                  decoration: const ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 1,
                        strokeAlign: BorderSide.strokeAlignCenter,
                        color: Color(0xFFD0D0D0),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    child: TabBarView(
                      children: _pages,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding midBar() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "Goals",
                style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'SfProText'),
              ),
              const Spacer(),
              GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditGoals(
                                  sleep: sleep,
                                  workout: workout,
                                  focus: focus,
                                  screen: screen,
                                )));
                  },
                  child: const Icon(Icons.edit))
            ],
          ),
          SizedBox(
            height: 10.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: MediaQuery.sizeOf(context).width * 0.46,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: AppColors.widgetColorV,
                    borderRadius: BorderRadius.circular(8)),
                child: Row(
                  children: [
                    Icon(
                      Icons.dark_mode_rounded,
                      color: Colors.yellow.shade600,
                      size: 30.sp,
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Text(
                      "Sleep Time: ",
                      style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'SfProText'),
                    ),
                    Text(
                      "$sleep hrs",
                      style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'SfProText'),
                    )
                  ],
                ),
              ),
              Container(
                width: MediaQuery.sizeOf(context).width * 0.46,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: AppColors.widgetColorR,
                    borderRadius: BorderRadius.circular(8)),
                child: Row(
                  children: [
                    Image.asset(
                      AppIcons.phone,
                      width: 30.sp,
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Text(
                      "Screentime: ",
                      style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'SfProText'),
                    ),
                    Text(
                      "$screen hrs",
                      style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'SfProText'),
                    )
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: MediaQuery.sizeOf(context).width * 0.46,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: AppColors.widgetColorB,
                    borderRadius: BorderRadius.circular(8)),
                child: Row(
                  children: [
                    Image.asset(
                      AppIcons.workout,
                      width: 30.sp,
                      color: AppColors.lightBlack,
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Text(
                      "Workout: ",
                      style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'SfProText'),
                    ),
                    Text(
                      "$workout days",
                      style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'SfProText'),
                    )
                  ],
                ),
              ),
              Container(
                width: MediaQuery.sizeOf(context).width * 0.46,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: AppColors.widgetColorG,
                    borderRadius: BorderRadius.circular(8)),
                child: Row(
                  children: [
                    Image.asset(
                      AppIcons.foucsed,
                      width: 30.sp,
                      color: AppColors.lightBlack,
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Text(
                      "Focus Time: ",
                      style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'SfProText'),
                    ),
                    Text(
                      "$focus hrs",
                      style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'SfProText'),
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Padding tabBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.r),
          color: const Color.fromARGB(255, 236, 251, 249),
        ),
        child: TabBar(
          splashBorderRadius: BorderRadius.circular(100.r),
          labelPadding: EdgeInsets.zero,
          dividerHeight: 0,
          padding: EdgeInsets.symmetric(horizontal: 0.w),
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorWeight: 0,
          indicator: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(100.r)),
          unselectedLabelColor: const Color(0xFF686873),
          labelStyle: TextStyle(
            color: Colors.black,
            fontSize: 14.sp,
            fontFamily: 'SFProText',
            fontWeight: FontWeight.w600,
          ),
          tabs: [
            Tab(text: 'Activity'.tr()),
            Tab(text: 'Friends'.tr()),
          ],
        ),
      ),
    );
  }

  Padding topBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Column(
                children: [
                  Image.asset(
                    AppImages.profileavatar,
                    height: 70.h,
                    width: 70.w,
                  ),
                ],
              ),
              SizedBox(
                width: 10.w,
              ),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  getUsername() ?? 'User Name'.tr(),
                  style: TextStyle(
                    color: AppColors.textBlack,
                    fontSize: 20.sp,
                    fontFamily: 'SFProText',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  height: 5.h,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  decoration: ShapeDecoration(
                    color: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r)),
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        AppIcons.xp,
                      ),
                      Text(
                        '$xp XP',
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.75),
                          fontSize: 14.sp,
                          fontFamily: 'SFProText',
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
                  ),
                )
              ]),
            ],
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SettingsPage()));
            },
            child: Container(
                width: 48.h,
                height: 48.w,
                alignment: Alignment.center,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 1, color: Color(0xFFEAECF0)),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                ),
                child: SvgPicture.asset(
                  AppIcons.setting,
                  height: 24.h,
                )),
          ),
        ],
      ),
    );
  }
}

class FriendsPageTab extends StatefulWidget {
  const FriendsPageTab({super.key});

  @override
  State<FriendsPageTab> createState() => _FriendsPageTabState();
}

class _FriendsPageTabState extends State<FriendsPageTab> {
  String searchText = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor.withOpacity(0.15),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
            child: Row(
              children: [
                // searching friends based on their name
                Expanded(
                    child: TextField(
                  cursorColor: AppColors.mainColor,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      focusColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: CupertinoColors.systemGrey,
                      ),
                      hintStyle: const TextStyle(
                        color: CupertinoColors.systemGrey,
                      ),
                      hintText: 'Search Friends',
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                              color: AppColors.blue, width: 1)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                              color: AppColors.widgetColorB, width: 0.4))),
                  onChanged: (value) {
                    setState(() {
                      searchText = value;
                    });
                  },
                )),
                SizedBox(
                  width: 20.w,
                ),
                GestureDetector(
                  onTap: searchText.isEmpty
                      ? null
                      : () async {
                          final users = await UserFireStoreServices()
                              .searchUserByUserName(searchText);

                          if (users.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("User not found")));
                            return;
                          }

                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => FriendSearchedPage(
                                    searchResults: users,
                                  )));
                        },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              blurRadius: .2,
                              offset: const Offset(0.0, 0.5),
                              color: Colors.black.withOpacity(0.5))
                        ],
                        color: AppColors.mainColor,
                        borderRadius: BorderRadius.circular(12)),
                    child: Center(
                        child: Text(
                      'Search',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontFamily: 'SFProText'),
                    )),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 5.h,
          ),
          const ReceivedFriendRequest(),
          SizedBox(height: 5.h),
          const Expanded(child: FriendsListView()),
        ],
      ),
    );
  }
}

class ActivityPage extends StatelessWidget {
  const ActivityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor.withOpacity(0.15),
      body: Column(
        children: [
          SizedBox(
            height: 5.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Activity of this week'.tr(),
                  style: TextStyle(
                    color: const Color(0xFF040415),
                    fontSize: 16.sp,
                    fontFamily: 'SFProText',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SvgPicture.asset(
                  AppIcons.dropdown,
                )
              ],
            ),
          ),
       Expanded(
  child: StreamBuilder<QuerySnapshot>(
    stream: XpFirestoreServices().listenForXpAdded(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else if (snapshot.hasError) {
        return const Center(
          child: Text('Something went wrong'),
        );
      } else if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
        return const Center(
          child: Text('No data found'),
        );
      }

      final xpDocs = snapshot.data!.docs;

      // Sort documents by timestamp in descending order
      xpDocs.sort((a, b) {
        var timeA = a.get("timestamp").millisecondsSinceEpoch;
        var timeB = b.get("timestamp").millisecondsSinceEpoch;
        return timeB.compareTo(timeA);
      });

      debugPrint('xpDocs: ${xpDocs.length}');
      
      // Display the latest XP first
      return ListView.builder(
        itemCount: xpDocs.length,
        itemBuilder: (context, index) {
          final xp = xpDocs[index];
          var date = DateTime.fromMillisecondsSinceEpoch(
              xp.get("timestamp").millisecondsSinceEpoch);
          return AchievmentsContainer(
            increment: xp.get("increment"),
            reason: xp.get("reason"),
            xp: xp.get("xp").toString(),
            uploadedDate: date,
          );
        },
      );
    },
  ),
)

        ],
      ),
    );
  }
}

Widget AchievmentsContainer({
  required String reason,
  required String xp,
  required bool increment,
  required DateTime uploadedDate,
}) {
  var now = DateTime.now();
  var todayDate = DateTime(now.year, now.month, now.day);

  debugPrint('todayDate: $todayDate, uploadedDate: $uploadedDate');

  var todayDateString = "${todayDate.year}-${todayDate.month}-${todayDate.day}";
  var uploadedDateString =
      "${uploadedDate.year}-${uploadedDate.month}-${uploadedDate.day}";

  var dateRemark = uploadedDateString == todayDateString
      ? 'Today'
      : '${uploadedDate.year}-${uploadedDate.month}-${uploadedDate.day}';

  var uploadedTime = "${uploadedDate.hour}:${uploadedDate.minute}";

  return Container(
    margin: EdgeInsets.only(bottom: 10.h, right: 20.w, left: 20.w),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$xp XP $reason',
                  style: TextStyle(
                    color: const Color(0xFF040415),
                    fontSize: 16.sp,
                    fontFamily: 'SFProText',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '$dateRemark, $uploadedTime',
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
        increment
            ? GestureDetector(
                onTap: () {},
                child: const Icon(
                  Icons.arrow_upward_rounded,
                  color: CupertinoColors.systemGreen,
                ))
            : GestureDetector(
                onTap: () {},
                child: const Icon(
                  Icons.arrow_downward_rounded,
                  color: CupertinoColors.destructiveRed,
                ))
      ],
    ),
  );
}

class EditGoals extends StatefulWidget {
  final int sleep;
  final int screen;
  final int focus;
  final int workout;
  const EditGoals(
      {required this.sleep,
      required this.screen,
      required this.focus,
      required this.workout,
      super.key});

  @override
  State<EditGoals> createState() => _EditGoalsState();
}

class _EditGoalsState extends State<EditGoals> {
  int sleep = 0;
  int screen = 0;
  int focus = 0;
  int workout = 0;
  var userID = FirebaseAuth.instance.currentUser!.uid;
  CollectionReference userRef = FirebaseFirestore.instance.collection('users');
  @override
  Widget build(BuildContext context) {
    //final goalProvider = Provider.of<GoalsProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Goals',
          style: TextStyle(
              fontFamily: 'SFProText',
              fontSize: 22.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textBlack),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 15.h,
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: AppColors.widgetColorV,
                    borderRadius: BorderRadius.circular(12)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Set Sleep Goals:',
                      style: TextStyle(
                          fontFamily: 'SFProText',
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textBlack),
                    ),
                    _buildPicker(
                      itemCount: 13,
                      selectedItem: widget
                          .sleep, // Pass the value of sleep as the initial selected item
                      onSelectedItemChanged: (value) {
                        setState(() {
                          sleep = value;
                          // goalProvider.setSelectedIndex(sleepTime);
                          //_selectedMinute = value;
                        });
                      },
                    ),
                    Text(
                      'hours per Day',
                      style: TextStyle(
                          fontFamily: 'SFProText',
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textBlack),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 14.h,
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: AppColors.widgetColorR,
                    borderRadius: BorderRadius.circular(12)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Set Screentime:',
                      style: TextStyle(
                          fontFamily: 'SFProText',
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textBlack),
                    ),
                    _buildPicker(
                      itemCount: 25,
                      selectedItem: widget.screen,
                      onSelectedItemChanged: (value) {
                        setState(() {
                          screen = value;
                          // screenTime = value;
                          // goalProvider.setSelectedIndex1(screenTime);
                          //_selectedMinute = value;
                        });
                      },
                    ),
                    Text(
                      'hours per Day',
                      style: TextStyle(
                          fontFamily: 'SFProText',
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textBlack),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 14.h,
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: AppColors.widgetColorG,
                    borderRadius: BorderRadius.circular(12)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Set Focus Time:',
                      style: TextStyle(
                          fontFamily: 'SFProText',
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textBlack),
                    ),
                    _buildPicker(
                      itemCount: 13,
                      selectedItem: widget.focus,
                      onSelectedItemChanged: (value) {
                        setState(() {
                          focus = value;
                          // focusTime = value;
                          // goalProvider.setSelectedIndex2(focusTime);
                          //_selectedMinute = value;
                        });
                      },
                    ),
                    Text(
                      'hours per Day',
                      style: TextStyle(
                          fontFamily: 'SFProText',
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textBlack),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 14.h,
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: AppColors.widgetColorB,
                    borderRadius: BorderRadius.circular(12)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Set Workout:        \nFrequency',
                      style: TextStyle(
                          fontFamily: 'SFProText',
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textBlack),
                    ),
                    _buildPicker(
                      itemCount: 8,
                      selectedItem: widget.workout,
                      onSelectedItemChanged: (value) {
                        setState(() {
                          workout = value;
                          // workoutFrequency = value;
                          //goalProvider.setSelectedIndex3(workoutFrequency);
                          //_selectedMinute = value;
                        });
                      },
                    ),
                    Text(
                      'days per Week',
                      style: TextStyle(
                          fontFamily: 'SFProText',
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textBlack),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 14.h,
              ),
              CustomButton(
                onPressed: () async {
                  await userRef.doc(userID).update({
                    'focusTime': focus,
                    'screenTime': screen,
                    'sleepGoals': sleep,
                    'workoutFrequency': workout
                  });
                  QuickAlert.show(
                    context: context,
                    type: QuickAlertType.success,
                    confirmBtnColor: AppColors.mainBlue,
                    onConfirmBtnTap: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomePage()),
                          (route) => false);
                      context.read<IndexProvider>().setSelectedIndex(4);
                    },
                    text: 'Goals Updated Successfully!',
                  );
                },
                text: 'Save',
              ),
              SizedBox(
                height: 14.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildPicker({
  required int itemCount,
  required int selectedItem,
  required void Function(int) onSelectedItemChanged,
}) {
  return SizedBox(
    width: 60.0,
    height: 120.0,
    child: CupertinoPicker(
      selectionOverlay: Container(),
      itemExtent: 52,
      diameterRatio: 1,
      backgroundColor: Colors.transparent,
      scrollController: FixedExtentScrollController(initialItem: selectedItem),
      onSelectedItemChanged: onSelectedItemChanged,
      children: List<Widget>.generate(itemCount, (index) {
        return Center(
          child: Text(
            index.toString().padLeft(2, '0'),
            style: const TextStyle(fontSize: 25),
          ),
        );
      }),
    ),
  );
}
