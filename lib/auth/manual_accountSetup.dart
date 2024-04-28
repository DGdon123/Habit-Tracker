import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;

import 'package:geolocator/geolocator.dart' as img;
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:day_night_time_picker/lib/daynight_timepicker.dart';
import 'package:day_night_time_picker/lib/state/time.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:habit_tracker/auth/repositories/gymtime_model.dart';
import 'package:habit_tracker/auth/repositories/new_gymtime_model.dart';
import 'package:habit_tracker/auth/repositories/user_repository.dart';
import 'package:habit_tracker/auth/widgets/gym_in_time.dart';
import 'package:habit_tracker/auth/widgets/gym_out_time.dart';
import 'package:habit_tracker/config/env.dart';
import 'package:habit_tracker/location/current_location.dart';
import 'package:habit_tracker/pages/screens/customize%20character/pickCharacter.dart';
import 'package:habit_tracker/provider/dob_provider.dart';
import 'package:habit_tracker/provider/goals_provider.dart';
import 'package:habit_tracker/provider/location_provider.dart';
import 'package:habit_tracker/services/local_storage_services.dart';
import 'package:habit_tracker/utils/colors.dart';
import 'package:habit_tracker/utils/icons.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:habit_tracker/utils/styles.dart';
import 'package:hive/hive.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:roundcheckbox/roundcheckbox.dart';

class ManualAccountSetup extends StatefulWidget {
  final String? username;
  final String? email;
  final String? password;
  const ManualAccountSetup(
      {super.key, this.username, this.email, this.password});
  @override
  State<ManualAccountSetup> createState() => _AccountSetupState();
}

class _AccountSetupState extends State<ManualAccountSetup> {
  late final PageController _pageController;
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _pageController.addListener(() {
      setState(() {
        currentPage = _pageController.page!.round();
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  bool hello = false;
  final bool _isUploading = false;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserRepository>(context);
    final dob = Provider.of<SelectedDateProvider>(context, listen: false);

    var dobis = dob.selectedDate ?? DateTime.now();
    var dateString = dobis.toString().split(' ')[0]; // Extract date part
    log(dateString); // Log only the date part

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
          "Create Account".tr(),
          style: TextStyle(
              fontFamily: 'SFProText',
              fontSize: 22.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textBlack),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (int page) {
                setState(() {
                  currentPage = page;
                });
              },
              children: const [
                PickCharacterPage(),
                SetUpGoals(),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        2, // Replace with the total number of pages
                        (index) => Container(
                          margin: EdgeInsets.symmetric(horizontal: 4.0.w),
                          width: currentPage == index
                              ? 15.w
                              : 10.w, // Adjust size as needed
                          height: currentPage == index
                              ? 15.h
                              : 10.h, // Adjust size as needed

                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: currentPage == index
                                  ? AppColors.buttonYellow // Active page color
                                  : AppColors
                                      .secondaryColor // Inactive page color
                              ),
                        ),
                      ),
                    )
                  ],
                ),
                GestureDetector(
                  onTap: () async {
                    if (currentPage < _pageController.page!.round()) {
                      // You are going back to a previous page
                      _pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      // You are going forward to the next page
                      if (currentPage < 1) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        if (currentPage == 1) {
                          final goalProvider = Provider.of<GoalsProvider>(
                              context,
                              listen: false);
                          var sleep = goalProvider.goals;
                          var screen = goalProvider.goals1;
                          var focus = goalProvider.goals2;
                          var workout = goalProvider.goals3;

                          await user.manualsignUp(
                              context,
                              widget.username.toString(),
                              dateString,
                              widget.email.toString(),
                              widget.password.toString(),
                              sleep,
                              screen,
                              focus,
                              workout);
                        }
                      }
                    }
                  },
                  child: Row(
                    children: [
                      Text(
                        currentPage == 1 ? 'Finish'.tr() : 'Next'.tr(),
                        style: TextStyle(
                          color: AppColors.buttonYellow,
                          fontFamily: 'SFProText',
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(
                        height: 28.h,
                        width: 28.w,
                        child: SvgPicture.asset(
                          AppIcons.forward,
                          color: AppColors.buttonYellow,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20.h,
          )
        ],
      ),
    );
  }
}

class AccountSetupSetName extends StatefulWidget {
  final String? username;
  final String? email;
  final String? password;
  const AccountSetupSetName(
      {super.key, this.username, this.email, this.password});

  @override
  State<AccountSetupSetName> createState() => _AccountSetupSetNameState();
}

class _AccountSetupSetNameState extends State<AccountSetupSetName> {
  LatLng? currentLocation;

  LatLng?
      selectedMarkerLocation; // Added variable to store the extra marker's location
  bool searching = false;
  String? currentAddress;

  bool isLocationLoaded = false;
  List<String> _places = [];
  final FocusNode _searchFocusNode = FocusNode();
  final TextEditingController _textEditingController = TextEditingController();

  final TextEditingController _textEditingController2 = TextEditingController();
  final TextEditingController _textEditingController3 = TextEditingController();

  Future<void> searchPlacesInNepal() async {
    final query = _textEditingController.text;
    final url =
        'https://api.mapbox.com/geocoding/v5/mapbox.places/$query.json?access_token=pk.eyJ1IjoiZGdkb24tMTIzIiwiYSI6ImNsbGFlandwcjFxNGMzcm8xbGJjNTY4bmgifQ.dGSMw7Ai7BpXWW4qQRcLgA';

    try {
      final response = await http.get(Uri.parse(url));
      final data = jsonDecode(response.body);

      final features = data['features'] as List<dynamic>;
      final places = <String>[];

      if (features.isNotEmpty) {
        for (final feature in features) {
          final placeName = feature['place_name'] as String;

          // Extract coordinates
          final coordinates =
              feature['geometry']['coordinates'] as List<dynamic>;
          final latitude = coordinates[1] as double;
          final longitude = coordinates[0] as double;

          // Format into a string "Place Name|Latitude|Longitude"
          final formattedPlace = '$placeName|$latitude|$longitude';
          places.add(formattedPlace);
        }
      } else {
        places.add('No results found');
      }

      setState(() => _places = places);
    } catch (e) {
      print('Failed to get search results from Mapbox: $e');
    }
  }
bool hello = false;
  @override
  Widget build(BuildContext context) {
    final locProvider = Provider.of<LocationProvider>(context, listen: false);
    final user = Provider.of<UserRepository>(context);
    final dob = Provider.of<SelectedDateProvider>(context, listen: false);

    final lat = locProvider.latitude;
    final longi = locProvider.longitude;
    var dobis = dob.selectedDate ?? DateTime.now();
    var dateString = dobis.toString().split(' ')[0]; // Extract date part
    log(dateString);
    return Scaffold(
        body: Stack(
      children: [
        FlutterLocationPicker(
            selectLocationButtonText: hello || _textEditingController.text.isEmpty ?  "Location Selected".tr() : "Set Gym Location".tr(),
            searchbarInputFocusBorderp: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.mainBlue, width: 0.164.w),
            ),
            searchBarHintText: "Loading Location".tr(),
            loadingWidget: SizedBox(
              height: 2.4.h,
              width: 4.6.w,
              child: const CircularProgressIndicator.adaptive(
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.primaryColor, // Set your desired color here
                ),
                backgroundColor: AppColors.mainBlue,
              ),
            ),
           selectLocationButtonStyle: ButtonStyle(
              overlayColor: MaterialStateProperty.all(hello || _textEditingController.text.isEmpty? CupertinoColors.systemGreen: AppColors.primaryColor),
              backgroundColor: MaterialStateProperty.all(hello || _textEditingController.text.isEmpty? CupertinoColors.systemGreen: AppColors.primaryColor),
            ),
            locationButtonBackgroundColor: AppColors.primaryColor,
            zoomButtonsBackgroundColor: AppColors.primaryColor,
            zoomButtonsColor: AppColors.mainBlue,
            locationButtonsColor: AppColors.mainBlue,
            contributorBadgeForOSMColor: AppColors.mainBlue,
            contributorBadgeForOSMTextColor: AppColors.mainBlue,
            initZoom: 22,
            minZoomLevel: 5,
            maxZoomLevel: 18,
            trackMyPosition: true,
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            searchBarBackgroundColor: Colors.white,
            selectedLocationButtonTextstyle:  TextStyle(
              fontSize: 18,
              color:hello  || _textEditingController.text.isEmpty? CupertinoColors.white:AppColors.mainBlue,
              letterSpacing: 0.25,
            ),
            mapLanguage: 'en',
            onError: (e) => print(e),
            selectLocationButtonLeadingIcon: hello|| _textEditingController.text.isEmpty? Container():
            const Icon(
              Icons.check,
              color: AppColors.mainBlue,
            ),
            onPicked: (pickedData) async {
              if (_textEditingController.text != '') {
                try {
                  final latitude = double.parse(_textEditingController2.text);
                  final longitude = double.parse(_textEditingController3.text);
                  setState(() {
                    locProvider.setLatitude(latitude);
                    locProvider.setLongitude(longitude);
                  });

                  log(latitude.toString());
                  log(longitude.toString());
                } catch (e) {
                  log('Error parsing latitude/longitude: $e');
                }
              } else {
                try {
                  final latitude = pickedData.latLong.latitude;
                  final longitude = pickedData.latLong.longitude;
                  final current = pickedData.address;
                  setState(() {
                    locProvider.setLatitude(latitude);
                    locProvider.setLongitude(longitude);
                  });
                  log(latitude.toString());
                  log(longitude.toString());
                } catch (e) {
                  log('Error parsing latitude/longitude: $e');
                }
              }
            }),
        Positioned(
          top: 88,
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Container(
              alignment: Alignment.center,
              width: 406.w,
              child: TextFormField(
                cursorColor: AppColors.mainBlue,
                maxLines: 1,
                controller: _textEditingController,
                focusNode: _searchFocusNode,
                onEditingComplete: () {
                  setState(() {
                    searching = false;
                    _searchFocusNode.unfocus();
                  });
                },
                style: const TextStyle(fontSize: 12),
                textInputAction: TextInputAction.done,
                onChanged: (value) => searchPlacesInNepal(),
                onTap: () {
                  setState(() {
                    searching = true;
                  });
                },
                decoration: InputDecoration(
                  suffixIcon: GestureDetector(
                    onTap: () {
                      _textEditingController.clear();
                    },
                    child: const Icon(
                      Icons.clear_outlined,
                      size: 20,
                      color: CupertinoColors.darkBackgroundGray,
                    ),
                  ),
                  prefixIcon: const Icon(
                    Icons.location_on_rounded,
                    color: AppColors.mainBlue,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 10.0),
                  focusedErrorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          width: 0.8,
                          color: AppColors.primaryColor,
                          style: BorderStyle.solid),
                      borderRadius: BorderRadius.circular(5)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          width: 0.8,
                          color: AppColors.primaryColor,
                          style: BorderStyle.solid),
                      borderRadius: BorderRadius.circular(5)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          width: 0.8,
                          color: AppColors.primaryColor,
                          style: BorderStyle.solid),
                      borderRadius: BorderRadius.circular(5)),
                  disabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          width: 0.8,
                          color: AppColors.primaryColor,
                          style: BorderStyle.solid),
                      borderRadius: BorderRadius.circular(5)),
                  border: InputBorder.none,
                  fillColor: const Color(0xffF9F9FC),
                  filled: true,
                  hintText: "Search Your Gym Location".tr(),
                  hintStyle: const TextStyle(fontSize: 12, letterSpacing: 0.35),
                ),
              ),
            ),
          ),
        ),
        searching
            ? Positioned(
                top: 145,
                child: Container(
                  width: 406.w,
                  height: 250.2.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _places.length,
                    itemBuilder: (context, index) {
                      if (index >= 0 && index < _places.length) {
                        final placeInfo = _places[index];
                        final placeParts = placeInfo.split('|');

                        if (placeParts.length >= 3) {
                          final placeName = placeParts[0];
                          final latitude = placeParts[1];
                          final longitude = placeParts[2];

                          return ListTile(
                            title: Text(placeName),
                            onTap: () {
                              _textEditingController.text = placeName;
                              _textEditingController2.text = latitude;
                              _textEditingController3.text = longitude;
                             

                              setState(() {
                                _places = []; // Clear search results
                                 locProvider.setLatitude(double.parse(latitude));
                              locProvider.setLongitude(double.parse(longitude));
                              });
                            },
                          );
                        }
                      }
                      return const SizedBox(); // Return an empty widget if data is invalid
                    },
                  ),
                ),
              )
            : Container()
      ],
    ));
  }
}


class AccountSetupSleeptime extends StatefulWidget {
  const AccountSetupSleeptime({super.key});

  @override
  State<AccountSetupSleeptime> createState() => _AccountSetupSleeptimeState();
}

class _AccountSetupSleeptimeState extends State<AccountSetupSleeptime> {
  Time _time = Time(hour: 08, minute: 30, second: 20);
  bool iosStyle = true;

  void onTimeChanged(Time newTime) {
    setState(() {
      _time = newTime;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 50.h,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
            children: [
              Text(
                'What’s your wake up\ntime?',
                style: AppTextStyles.accountSetup,
              ),
            ],
          ),
        ),
        SizedBox(
          height: 50.h,
        ),

        // Render inline widget
        showPicker(
          unselectedColor: const Color.fromRGBO(0, 0, 0, 0.75),
          hourLabel: 'Hour'.tr(),
          minuteLabel: 'Minutes'.tr(),
          wheelHeight: 200.h,
          hideButtons: true,
          dialogInsetPadding: const EdgeInsets.all(0),
          isInlinePicker: true,
          elevation: 0,
          value: _time,
          onChange: onTimeChanged,
          minuteInterval: TimePickerInterval.FIVE,
          iosStylePicker: iosStyle,
          minHour: 9,
          maxHour: 21,
          is24HrFormat: false,
        ),
      ],
    );
  }
}

class AccountSetupWaketime extends StatefulWidget {
  const AccountSetupWaketime({super.key});

  @override
  State<AccountSetupWaketime> createState() => _AccountSetupWaketimeState();
}

class _AccountSetupWaketimeState extends State<AccountSetupWaketime> {
  Time _time = Time(hour: 08, minute: 30, second: 20);
  bool iosStyle = true;

  void onTimeChanged(Time newTime) {
    setState(() {
      _time = newTime;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 50.h,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
            children: [
              Text(
                'What’s your sleep \ntime?',
                style: AppTextStyles.accountSetup,
              ),
            ],
          ),
        ),
        SizedBox(
          height: 50.h,
        ),

        // Render inline widget
        showPicker(
          unselectedColor: const Color.fromRGBO(0, 0, 0, 0.75),
          hourLabel: 'Hour'.tr(),
          minuteLabel: 'Minutes'.tr(),
          wheelHeight: 200.h,
          hideButtons: true,
          dialogInsetPadding: const EdgeInsets.all(0),
          isInlinePicker: true,
          elevation: 0,
          value: _time,
          onChange: onTimeChanged,
          minuteInterval: TimePickerInterval.FIVE,
          iosStylePicker: iosStyle,
          minHour: 9,
          maxHour: 21,
          is24HrFormat: false,
        ),
      ],
    );
  }
}

class SetUpGoals extends StatefulWidget {
  const SetUpGoals({super.key});

  @override
  State<SetUpGoals> createState() => _SetUpGoalsState();
}

int sleepTime = 0;
int screenTime = 0;
int workoutFrequency = 0;
int focusTime = 0;

class _SetUpGoalsState extends State<SetUpGoals> {
  @override
  Widget build(BuildContext context) {
    final goalProvider = Provider.of<GoalsProvider>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 14.h,
            ),
            Center(
              child: Text(
                'Set Up Goals'.tr(),
                style: TextStyle(
                    fontFamily: 'SFProText',
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textBlack),
              ),
            ),
            SizedBox(
              height: 25.h,
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: AppColors.widgetColorV,
                  borderRadius: BorderRadius.circular(12)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                    child: Text(
                      '${'Set Sleep Goals'.tr()}:',
                      style: TextStyle(
                          fontFamily: 'SFProText',
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textBlack),
                    ),
                  ),
                  _buildPicker(
                    itemCount: 13,
                    selectedItem: 0,
                    onSelectedItemChanged: (value) {
                      setState(() {
                        sleepTime = value;
                        goalProvider.setSelectedIndex(sleepTime);
                        //_selectedMinute = value;
                      });
                    },
                  ),
                  Text(
                    'hours per Day'.tr(),
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
                  Flexible(
                    child: Text(
                      '${'Set Screentime'.tr()}:',
                      style: TextStyle(
                          fontFamily: 'SFProText',
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textBlack),
                    ),
                  ),
                  _buildPicker(
                    itemCount: 25,
                    selectedItem: 0,
                    onSelectedItemChanged: (value) {
                      setState(() {
                        screenTime = value;
                        goalProvider.setSelectedIndex1(screenTime);
                        //_selectedMinute = value;
                      });
                    },
                  ),
                  Text(
                    'hours per Day'.tr(),
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
                  Flexible(
                    child: Text(
                      '${'Set Focus Time'.tr()}:',
                      style: TextStyle(
                          fontFamily: 'SFProText',
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textBlack),
                    ),
                  ),
                  _buildPicker(
                    itemCount: 13,
                    selectedItem: 0,
                    onSelectedItemChanged: (value) {
                      setState(() {
                        focusTime = value;
                        goalProvider.setSelectedIndex2(focusTime);
                        //_selectedMinute = value;
                      });
                    },
                  ),
                  Text(
                    'hours per Day'.tr(),
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
                  Flexible(
                    child: Text(
                      '${'Set Workout Frequency'.tr()}:',
                      style: TextStyle(
                          fontFamily: 'SFProText',
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textBlack),
                    ),
                  ),
                  _buildPicker(
                    itemCount: 8,
                    selectedItem: 0,
                    onSelectedItemChanged: (value) {
                      setState(() {
                        workoutFrequency = value;
                        goalProvider.setSelectedIndex3(workoutFrequency);
                        //_selectedMinute = value;
                      });
                    },
                  ),
                  Text(
                    'days per Week'.tr(),
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
          ],
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

class WorkoutTrackType extends StatefulWidget {
  const WorkoutTrackType({super.key});

  @override
  State<WorkoutTrackType> createState() => _WorkoutTrackTypeState();
}

bool isManualSelected = false;
bool isAutomaticSelected = false;

class _WorkoutTrackTypeState extends State<WorkoutTrackType> {
  String logStr = '';

  String _location='Obtaining Address';


  Future<void> _onLocation(bg.Location location) async {
     final locProvider = Provider.of<LocationProvider>(context, listen: false);
      var lat = locProvider.latitude;
      var longi = locProvider.longitude;
       if (lat != null && longi != null) {
        distance = calculateDistance(
          lat,
          longi,
          location.coords.latitude,
          location.coords.longitude,
        );
      }

      log(distance.toString());
       if (distance <= 300) {
  // Open the Hive box where user location times are stored
  var box = await Hive.openBox<DataModel>('hive_box');

   // Create a DataModel instance with current date and time
  var currentDate = DateTime.now().toString().split(' ')[0];
  var currentTime = DateTime.now(); // Get the current date and time // Parse the timestamp string to DateTime

   String formattedTime = DateFormat('HH:mm:ss').format(currentTime);
  DataModel dataModel = DataModel(date: currentDate, time: formattedTime);

  // Add the dataModel instance to the Hive box
  await box.add(dataModel);

  // Close the Hive box
  await box.close();
}

      if (distance > 300) {
        // Open the Hive box where user location times are stored
        var box = await Hive.openBox<DataModel1>('hive_box1');

          // Create a DataModel instance with current date and time
  var currentDate = DateTime.now().toString().split(' ')[0];
  var currentTime = DateTime.now(); // Get the current date and time // Parse the timestamp string to DateTime

   String formattedTime = DateFormat('HH:mm:ss').format(currentTime);
  DataModel1 dataModel1 = DataModel1(date: currentDate, time: formattedTime); // Parse the timestamp string to DateTime

  

        // Add the dataModel instance to the Hive box
        await box.add(dataModel1);

        await box.close();
      }
    log('[${bg.Event.LOCATION}] - $location');

    setState(() {
      _location = location.coords.latitude.toString() + location.coords.longitude.toString();
    });
  }


  Future<void> _onMotionChange(bg.Location location) async {
     final locProvider = Provider.of<LocationProvider>(context, listen: false);
      var lat = locProvider.latitude;
      var longi = locProvider.longitude;
       if (lat != null && longi != null) {
        distance = calculateDistance(
          lat,
          longi,
          location.coords.latitude,
          location.coords.longitude,
        );
      }

      log(distance.toString());
       if (distance <= 300) {
  // Open the Hive box where user location times are stored
  var box = await Hive.openBox<DataModel>('hive_box');

   // Create a DataModel instance with current date and time
  var currentDate = DateTime.now().toString().split(' ')[0];
  var currentTime = DateTime.now(); // Get the current date and time // Parse the timestamp string to DateTime

   String formattedTime = DateFormat('HH:mm:ss').format(currentTime);
  DataModel dataModel = DataModel(date: currentDate, time: formattedTime);

  // Add the dataModel instance to the Hive box
  await box.add(dataModel);

  // Close the Hive box
  await box.close();
}

      if (distance > 300) {
        // Open the Hive box where user location times are stored
        var box = await Hive.openBox<DataModel1>('hive_box1');

          // Create a DataModel instance with current date and time
  var currentDate = DateTime.now().toString().split(' ')[0];
  var currentTime = DateTime.now(); // Get the current date and time // Parse the timestamp string to DateTime

   String formattedTime = DateFormat('HH:mm:ss').format(currentTime);
  DataModel1 dataModel1 = DataModel1(date: currentDate, time: formattedTime); // Parse the timestamp string to DateTime

  

        // Add the dataModel instance to the Hive box
        await box.add(dataModel1);

        await box.close();
      }
    log('[${bg.Event.MOTIONCHANGE}] - $location');

     setState(() {
      _location = location.coords.latitude.toString() + location.coords.longitude.toString();
    });
  }

  
  void _onProviderChange(bg.ProviderChangeEvent event) async {
    log('[${bg.Event.PROVIDERCHANGE}] - $event');


    if ((event.status == bg.ProviderChangeEvent.AUTHORIZATION_STATUS_ALWAYS) && (event.accuracyAuthorization == bg.ProviderChangeEvent.ACCURACY_AUTHORIZATION_REDUCED)) {
      // Supply "Purpose" key from Info.plist as 1st argument.
      bg.BackgroundGeolocation.requestTemporaryFullAccuracy("DemoPurpose").then((int accuracyAuthorization) {
        if (accuracyAuthorization == bg.ProviderChangeEvent.ACCURACY_AUTHORIZATION_FULL) {
          print("[requestTemporaryFullAccuracy] GRANTED:  $accuracyAuthorization");
        } else {
          print("[requestTemporaryFullAccuracy] DENIED:  $accuracyAuthorization");
        }
      }).catchError((error) {
        print("[requestTemporaryFullAccuracy] FAILED TO SHOW DIALOG: $error");
      });
    }
  }

  Future<void> setupBackgroundGeolocation() async {
// Fired whenever a location is recorded
     bg.BackgroundGeolocation.onLocation(_onLocation,);
    bg.BackgroundGeolocation.onMotionChange(_onMotionChange);
  
    bg.BackgroundGeolocation.onProviderChange(_onProviderChange);

    ////
    // 2.  Configure the plugin
    //
     bg.TransistorAuthorizationToken token = await bg.TransistorAuthorizationToken.findOrCreate("orgname", "username", ENV.TRACKER_HOST);
    bg.BackgroundGeolocation.ready(bg.Config(
      transistorAuthorizationToken: token,
      notification: bg.Notification(title: "Tracking Your Location",text: 'Habit Tracker is tracking your location.'),
        reset: false,  stopTimeout: 5,
        // Geolocation options
        desiredAccuracy: bg.Config.DESIRED_ACCURACY_NAVIGATION,
        distanceFilter: 10.0,
        stopOnTerminate: false,
        startOnBoot: true,
        debug: true, // HTTP & Persistence
        autoSync: true,
        logLevel: bg.Config.LOG_LEVEL_VERBOSE
    )).then((bg.State state) async {
     if (!state.enabled) {
        ////
        // 3.  Start the plugin.
        //
         
        bg.BackgroundGeolocation.start();

  
        }
    });
  
}
  
 void stop() async {
      

    await LocalStorageServices().setAutomatic(false);

    log("setting automatic to false Home.dart");

    bg.BackgroundGeolocation.stop();
  }
  double latitude = 0;
  double longitude = 0;
  double distance = 0;
  // Function to calculate distance between two sets of latitude and longitude
  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2);
  }

 

  @override
  void dispose() => super.dispose();

  // getLastLocationTime function to retrieve data from Hive
  Future<DateTime?> getLastLocationTime() async {
    try {
      // Initialize Hive

      // Open the Hive box where user location times are stored
      var box = await Hive.openBox<DataModel>('hive_box');

      // Get the last added dataModel instance from the box
      DataModel? lastDataModel =
          box.isNotEmpty ? box.getAt(box.length - 1) : null;

      // Extract the date and time from the lastDataModel instance
      if (lastDataModel != null) {
        var dateString = lastDataModel.date;
        var timeString = lastDataModel.time;
        var dateTimeString = '$dateString $timeString';
        log('DataModel1: $dateTimeString');
        return DateTime.parse(dateTimeString);
      }
      // Close the Hive box
      await box.close();
    } catch (error) {
      print('Failed to retrieve last location time: $error');
    }
    return null;
  }

  Future<DateTime?> getLastLocationTime1() async {
    try {
      // Initialize Hive

      // Open the Hive box where user location times are stored
      var box = await Hive.openBox<DataModel1>('hive_box1');

      // Get the last added dataModel instance from the box
      DataModel1? lastDataModel =
          box.isNotEmpty ? box.getAt(box.length - 1) : null;

      // Extract the date and time from the lastDataModel instance
      if (lastDataModel != null) {
        var dateString = lastDataModel.date;
        var timeString = lastDataModel.time;
        var dateTimeString = '$dateString $timeString';
        log('DataModel2: $dateTimeString');
        return DateTime.parse(dateTimeString);
      }
      // Close the Hive box
      await box.close();
    } catch (error) {
      print('Failed to retrieve last location time: $error');
    }
    return null;
  }
CollectionReference userRef = FirebaseFirestore.instance.collection('users');var userID = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Text(
            'How do you want to track your workout?'.tr(),
            style: TextStyle(
                fontFamily: 'SFProText',
                fontSize: 22.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textBlack),
          ),
          const SizedBox(
            height: 12,
          ),
          GestureDetector(
            onTap: () async { 
                await LocalStorageServices().setAutomatic(true);
              setState(() {
                isAutomaticSelected = !isAutomaticSelected;
                isManualSelected = false;
                setupBackgroundGeolocation();
              });
            },
            child: Card(
              color: AppColors.mainColor,
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    RoundCheckBox(
                      checkedColor: AppColors.widgetColorR,
                      isChecked: isAutomaticSelected,
                      size: 27,
                      onTap: (selected) {
                        setState(() {
                          isAutomaticSelected = !isAutomaticSelected;
                          isManualSelected = false;
                        });
                      },
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(
                      'Automatic'.tr(),
                      style: TextStyle(
                          fontFamily: 'SFProText',
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textBlack),
                    )
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                isManualSelected = !isManualSelected;
                isAutomaticSelected = false;
                stop();
              });
              // isManualSelected
              //     ? showDialog(
              //         context: context,
              //         builder: (BuildContext context) {
              //           return GymInTime(); // Use the custom dialog
              //         },
              //       )
              //     : Container();
            },
            child: Card(
              elevation: 0,
              color: AppColors.mainColor,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    RoundCheckBox(
                      checkedColor: AppColors.widgetColorR,
                      isChecked: isManualSelected,
                      size: 27,
                      onTap: (selected) {
                        setState(() {
                          isManualSelected = !isManualSelected;
                          isAutomaticSelected = false;
                        });
                      },
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(
                      'Manual'.tr(),
                      style: TextStyle(
                          fontFamily: 'SFProText',
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textBlack),
                    )
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    ));
  }
}
