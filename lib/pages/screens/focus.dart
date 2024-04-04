import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habit_tracker/pages/home_page.dart';
import 'package:habit_tracker/pages/screens/focusTimer/focusMain.dart';
import 'package:habit_tracker/pages/screens/focusTimer/stopwatch.dart';
import 'package:habit_tracker/provider/index_provider.dart';
import 'package:habit_tracker/utils/colors.dart';
import 'package:habit_tracker/utils/icons.dart';
import 'package:habit_tracker/utils/images.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import '../../main.dart';

class ActivityBox extends StatefulWidget {
  final String img;
  final String title;
  final bool initiallySelected;
  final void Function(bool isSelected) onPressed;

  const ActivityBox({
    super.key,
    required this.img,
    required this.title,
    this.initiallySelected = false,
    required this.onPressed,
  });

  @override
  _ActivityBoxState createState() => _ActivityBoxState();
}

class _ActivityBoxState extends State<ActivityBox> {
  late bool isSelected;
  TextStyle presetStyle = TextStyle(
    color: AppColors.textBlack,
    fontSize: 14.sp,
    fontFamily: 'SFProText',
    fontWeight: FontWeight.w500,
  );

  TextStyle presetStyle2 = TextStyle(
    color: AppColors.textBlack,
    fontSize: 12.sp,
    fontFamily: 'SFProText',
    fontWeight: FontWeight.w400,
  );

  TextStyle labelStyle = TextStyle(
    color: const Color(0xFF040415),
    fontSize: 18.sp,
    fontFamily: 'SFProText',
    fontWeight: FontWeight.w600,
  );

  TextStyle labelStyle2 = TextStyle(
    color: Colors.black.withOpacity(0.75),
    fontSize: 18.sp,
    fontFamily: 'SFProText',
    fontWeight: FontWeight.w400,
  );
  @override
  void initState() {
    super.initState();
    isSelected = widget.initiallySelected;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          isSelected = !isSelected;
          widget.onPressed(isSelected);
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color.fromARGB(255, 131, 224, 81)
                    : const Color(0xffc9eeb5),
                borderRadius: BorderRadius.circular(15),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 50,
                    child: Image.asset(
                      widget.img,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Text(
                    widget.title,
                    style: presetStyle,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FocusPage extends StatefulWidget {
  const FocusPage({super.key});

  @override
  State<FocusPage> createState() => FocusPageState();
}

class FocusPageState extends State<FocusPage> {
  Time _time = Time(hour: 00, minute: 25, second: 59);
  bool iosStyle = true;
  final PageController _pageController = PageController(
    initialPage: 0,
  );
  int selectionType = 0;

  int animationStage = -1;
  void onTimeChanged(Time newTime) {
    setState(() {
      _time = newTime;
    });
  }

  void _updateLabelText() {
    setState(() {
      labelText = labelText;
    });
  }

  @override
  void initState() {
    super.initState();
    // Initialize the page controller

    // Fetch users and update pages when data is received
    fetchUsers().then((userWidgets) {
      setState(() {
        // Insert the fetched user widgets at the beginning of the pages list
        pages.insertAll(0, userWidgets);
      });
    });

    // Add listeners

    // Define initial pages (if needed)
    // Add initial pages or load data from storage
    // Here, we are using your existing code
    List<Widget> initialPages = [
      ActivityBox(
        img: AppImages.read,
        title: "Read".tr(),
        initiallySelected: false,
        onPressed: (isSelected) {
          setState(() {
            labelText = isSelected ? "Read".tr() : "Unknown".tr();
          });
        },
      ),
      ActivityBox(
        img: AppImages.walk,
        title: "Walk".tr(),
        initiallySelected: false,
        onPressed: (isSelected) {
          setState(() {
            labelText = isSelected ? "Walk".tr() : "Unknown".tr();
          });
        },
      ),
      ActivityBox(
        img: AppImages.meditate,
        title: "Meditate".tr(),
        initiallySelected: false,
        onPressed: (isSelected) {
          setState(() {
            labelText = isSelected ? "Meditate".tr() : "Unknown".tr();
          });
        },
      ),
      ActivityBox(
        img: AppImages.add,
        title: "Add New".tr(),
        initiallySelected: false,
        onPressed: (isSelected) {
          setState(() {
            labelText = isSelected ? "Add New".tr() : "Unknown".tr();
          });
          if (isSelected) {
            _showAddNewDialog(context);
          }
        },
      ),
    ];

    // Merge initial pages with fetched user data
    pages.insertAll(0, initialPages);
  }

  String labelText = "No Label".tr();

  String? getUserName() {
    User? user = _auth.currentUser;
    return user?.displayName;
  }

// Default icon
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? getUserID() {
    User? user = _auth.currentUser;
    return user?.uid;
  }

  bool select = false;
  Future<List<Widget>> fetchUsers() async {
    CollectionReference users =
        FirebaseFirestore.instance.collection('focus_timer_card');
    List<Widget> userWidgets = [];

    String? userID = getUserID(); // Get the current user's ID

    if (userID != null) {
      try {
        QuerySnapshot snapshot =
            await users.where('ID', isEqualTo: userID).get();
        if (snapshot.docs.isNotEmpty) {
          for (var doc in snapshot.docs) {
            var id = doc.id; // Get the document ID
            var data = doc.data()
                as Map<String, dynamic>; // Cast data to Map<String, dynamic>

            var label = data['Label']; // Access other fields as needed
            var hours = data['Hours'];
            var minutes = data['Minutes'];
            var seconds = data['Seconds'];

            logger.d('$id => $label');
            logger.d('Hours: $hours, Minutes: $minutes, Seconds: $seconds');

            // Create a widget to display the fetched data
            var userWidget = ActivityBox(
              img: AppImages.other,
              title: label,
              initiallySelected: false,
              onPressed: (isSelected) {
                setState(() {
                  labelText = isSelected ? label : "Unknown".tr();
                });
              },
            );

            userWidgets.add(userWidget);
          }
        } else {
          logger.d('No data found for the current user');
        }
      } catch (error) {
        print("Failed to fetch users: $error");
      }
    } else {
      logger.d('User ID is null');
    }

    return userWidgets;
  }

  Future<void> addUser(String label, int hours, int minutes, int seconds) {
    CollectionReference users =
        FirebaseFirestore.instance.collection('focus_timer_card');

    return users
        .add({
          'Label': label,
          'Hours': hours,
          'Minutes': minutes,
          'Seconds': seconds,
          'ID': getUserID(),
          'Name': getUserName(),
          'Timestamp': FieldValue.serverTimestamp(),
        })
        .then((value) => print("User added successfully!"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  int hour = 0;
  int minute = 0;
  int second = 0;
  int hour1 = 0;
  int minute1 = 0;
  int second1 = 0;
  // Function to show the add new dialog
  String label = '';
  int hours3 = 0;
  int minutes3 = 0;
  int seconds3 = 0;
  List<Widget> pages = [];

  void _showAddNewDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            'Add New Timer'.tr(),
            style: TextStyle(
              color: const Color(0xFF040415),
              fontSize: 18.sp,
              fontFamily: 'SFProText',
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  setState(() {
                    label = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Label'.tr(),
                  hintStyle: TextStyle(
                    color: Colors.black.withOpacity(0.75),
                    fontSize: 18.sp,
                    fontFamily: 'SFProText',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    hours3 = int.parse(value);
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Hours'.tr(),
                  hintStyle: TextStyle(
                    color: Colors.black.withOpacity(0.75),
                    fontSize: 18.sp,
                    fontFamily: 'SFProText',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    minutes3 = int.parse(value);
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Minutes'.tr(),
                  hintStyle: TextStyle(
                    color: Colors.black.withOpacity(0.75),
                    fontSize: 18.sp,
                    fontFamily: 'SFProText',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    seconds3 = int.parse(value);
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Seconds'.tr(),
                  hintStyle: TextStyle(
                    color: Colors.black.withOpacity(0.75),
                    fontSize: 18.sp,
                    fontFamily: 'SFProText',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              // Input field for label
            ],
          ),
          actions: [
            // Button to save the input data
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                addUser(label, hours3, minutes3, seconds3);
                if (label.isEmpty) {
                  QuickAlert.show(
                    context: context,
                    type: QuickAlertType.error,
                    confirmBtnColor: AppColors.mainBlue,
                    title: 'Error...'.tr(),
                    text: 'Please, fill up all the fields!'.tr(),
                  );
                } else {
                  addUser(label, hours3, minutes3, seconds3);

                  context.read<IndexProvider>().setSelectedIndex(3);
                }
              },
              child: Text(
                'Save'.tr(),
                style: const TextStyle(
                  color: AppColors.mainBlue,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  TextStyle presetStyle = TextStyle(
    color: AppColors.textBlack,
    fontSize: 14.sp,
    fontFamily: 'SFProText',
    fontWeight: FontWeight.w500,
  );

  TextStyle presetStyle2 = TextStyle(
    color: AppColors.textBlack,
    fontSize: 12.sp,
    fontFamily: 'SFProText',
    fontWeight: FontWeight.w400,
  );

  TextStyle labelStyle = TextStyle(
    color: const Color(0xFF040415),
    fontSize: 18.sp,
    fontFamily: 'SFProText',
    fontWeight: FontWeight.w600,
  );

  TextStyle labelStyle2 = TextStyle(
    color: Colors.black.withOpacity(0.75),
    fontSize: 18.sp,
    fontFamily: 'SFProText',
    fontWeight: FontWeight.w400,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfbf1f5fe),
      body: Container(
        margin: EdgeInsets.only(
            top: kIsWeb
                ? 35.h
                : Platform.isIOS
                    ? 50.h
                    : 35.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Center(
                      child: Text(
                        "Focus Timer".tr(),
                        style: TextStyle(
                            fontFamily: 'SFProText',
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w900,
                            color: AppColors.textBlack),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        setState(() {
                          selectionType = selectionType == 0 ? 1 : 0;
                          animationStage = 0;
                        });

                        await Future.delayed(const Duration(milliseconds: 200));

                        setState(() {
                          animationStage = -1;
                        });
                      },
                      child: Container(
                        width: 85,
                        height: 40,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 8.0),
                        decoration: BoxDecoration(
                          color: const Color(0xfbe2e6eb), // Button color
                          borderRadius:
                              BorderRadius.circular(20.0), // Rounded border
                        ),
                        child: IntrinsicHeight(
                          child: Stack(
                            alignment: Alignment.centerLeft,
                            children: [
                              Container(
                                height: 22,
                              ),
                              AnimatedPositioned(
                                  duration: Duration(
                                      milliseconds: animationStage == 0 &&
                                              selectionType == 0
                                          ? 100
                                          : 400),
                                  top: animationStage == 0 && selectionType == 0
                                      ? -30
                                      : 0,
                                  left: 0,
                                  curve: Curves.easeInOutBack,
                                  child: SvgPicture.asset(
                                    AppIcons.timer,
                                    height: 22,
                                    color: selectionType == 0
                                        ? AppColors.mainBlue
                                        : AppColors.black,
                                  )),
                              const Center(
                                child: VerticalDivider(
                                  color: Colors.grey,
                                  thickness: 2,
                                ),
                              ),
                              AnimatedPositioned(
                                  right: 0,
                                  top: animationStage == 0 && selectionType == 1
                                      ? -30
                                      : 0,
                                  curve: Curves.easeInOutBack,
                                  duration: Duration(
                                      milliseconds:
                                          animationStage == 0 ? 100 : 400),
                                  child: SvgPicture.asset(
                                    AppIcons.timer3,
                                    height: 23,
                                    color: selectionType == 1
                                        ? AppColors.mainBlue
                                        : AppColors.black,
                                  )),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 75,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    SizedBox(
                      height: 100.h,
                      width: MediaQuery.of(context).size.width - 40,
                      child: PageView(
                          controller: _pageController,
                          scrollDirection: Axis.horizontal,
                          children: pages),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: selectionType == 0 ? 40 : 132,
              ),
              if (selectionType == 0)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // Hours
                    _buildPicker(
                      itemCount: 24,
                      selectedItem: 0,
                      onSelectedItemChanged: (value) {
                        setState(() {
                          hour = value;
                          //_selectedHour = value;
                        });
                      },
                    ),
                    const Text(
                      ':',
                      style: TextStyle(fontSize: 32),
                    ),
                    // Minutes
                    _buildPicker(
                      itemCount: 60,
                      selectedItem: 0,
                      onSelectedItemChanged: (value) {
                        setState(() {
                          minute = value;
                          //_selectedMinute = value;
                        });
                      },
                    ),
                    const Text(
                      ':',
                      style: TextStyle(fontSize: 32),
                    ),
                    // Seconds
                    _buildPicker(
                      itemCount: 60,
                      selectedItem: 0,
                      onSelectedItemChanged: (value) {
                        setState(() {
                          second = value;
                          //  _selectedSecond = value;
                        });
                      },
                    ),
                  ],
                ),
              if (selectionType == 1)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "00".tr(),
                      style: TextStyle(fontSize: 50, letterSpacing: -0.5),
                    ),
                    SizedBox(
                      width: 23,
                    ),
                    Text(
                      ':',
                      style: TextStyle(fontSize: 32, height: -0.2),
                    ),
                    SizedBox(
                      width: 22,
                    ),
                    Text(
                      "00".tr(),
                      style: TextStyle(fontSize: 50, letterSpacing: -0.5),
                    ),
                    SizedBox(
                      width: 22,
                    ),
                    Text(
                      ':',
                      style: TextStyle(fontSize: 32, height: -0.2),
                    ),
                    SizedBox(
                      width: 23,
                    ),
                    Text(
                      "00".tr(),
                      style: TextStyle(fontSize: 50, letterSpacing: -0.5),
                    ),
                  ],
                ),
              SizedBox(
                height: selectionType == 0 ? 70 : 156,
              ),
              InkWell(
                onTap: () {
                  if (labelText == "No Label".tr()) {
                    QuickAlert.show(
                      context: context,
                      confirmBtnColor: AppColors.mainBlue,
                      type: QuickAlertType.error,
                      title: 'Error...'.tr(),
                      text: 'Please, select your timer box!'.tr(),
                    );
                  } else {
                    selectionType == 0
                        ? Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FocusMainScreen(
                                      label: labelText,
                                      hour: hour,
                                      minute: minute,
                                      second: second,
                                    )))
                        : Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StopWatchScreen(
                                label: labelText,
                                hour: hour,
                                minute: minute,
                                second: second,
                              ),
                            ),
                          );
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black, // Border color
                      width: 0.5, // Border width
                    ),
                    color: Colors.white, // Button color
                    borderRadius: BorderRadius.circular(20.0), // Rounded border
                  ),
                  child: Text(
                    "${"Start".tr()} ${selectionType == 0 ? 'Timer'.tr() : 'Stopwatch'.tr()}",
                    style: const TextStyle(
                      color: AppColors.lightBlack,
                      fontSize: 20.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Define _selectedIndex variable

  Widget _buildPicker({
    required int itemCount,
    required int selectedItem,
    required void Function(int) onSelectedItemChanged,
  }) {
    return SizedBox(
      width: 100.0,
      height: 250.0,
      child: CupertinoPicker(
        selectionOverlay: Container(),
        itemExtent: 52,
        diameterRatio: 1,
        backgroundColor: Colors.transparent,
        scrollController:
            FixedExtentScrollController(initialItem: selectedItem),
        onSelectedItemChanged: onSelectedItemChanged,
        children: List<Widget>.generate(itemCount, (index) {
          return Center(
            child: Text(
              index.toString().padLeft(2, '0'),
              style: const TextStyle(fontSize: 50),
            ),
          );
        }),
      ),
    );
  }

  Container seperator() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1, color: Color(0xFFD0D0D0)),
        ),
      ),
    );
  }

  Padding labelTimer(
      TextStyle labelStyle, BuildContext context, TextStyle labelStyle2) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 1, color: Color(0xFFD0D0D0)),
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Label'.tr(),
                    style: labelStyle,
                  ),
                  GestureDetector(
                    onTap: () async {
                      String? enteredText = await _showTextInputDialog(context);
                      if (enteredText != null && enteredText.isNotEmpty) {
                        setState(() {
                          labelText = enteredText;
                        });
                      }
                    },
                    child: Row(
                      children: [
                        Text(
                          labelText,
                          style: labelStyle2,
                        ),
                        Icon(
                          Icons.chevron_right,
                          size: 18.h,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            seperator(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'When Timer Ends'.tr(),
                    style: labelStyle,
                  ),
                  Row(
                    children: [
                      Text(
                        'Ting Tong'.tr(),
                        style: labelStyle2,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String?> _showTextInputDialog(BuildContext context) async {
    TextEditingController textController = TextEditingController();

    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            'Enter Label'.tr(),
            style: TextStyle(
              color: const Color(0xFF040415),
              fontSize: 18.sp,
              fontFamily: 'SFProText',
              fontWeight: FontWeight.w600,
            ),
          ),
          content: TextField(
            controller: textController,
            onChanged: (value) {
              // You can add any additional logic here
            },
            decoration: InputDecoration(
              hintText: 'Label'.tr(),
              hintStyle: TextStyle(
                color: Colors.black.withOpacity(0.75),
                fontSize: 18.sp,
                fontFamily: 'SFProText',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child:  Text('Cancel'.tr()),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(textController.text);
              },
              child:  Text(
                'OK'.tr(),
                style: TextStyle(
                  color: AppColors.mainBlue,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
