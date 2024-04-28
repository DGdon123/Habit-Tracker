import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:habit_tracker/auth/automatic_accountSetup.dart';
import 'package:habit_tracker/auth/automaticaccountSetup1.dart';
import 'package:habit_tracker/auth/manual_accountSetup.dart';
import 'package:habit_tracker/auth/manualaccountSetup1.dart';
import 'package:habit_tracker/auth/repositories/gymtime_model.dart';
import 'package:habit_tracker/auth/repositories/new_gymtime_model.dart';
import 'package:habit_tracker/location/current_location.dart';
import 'package:habit_tracker/provider/location_provider.dart';
import 'package:habit_tracker/services/local_storage_services.dart';
import 'package:habit_tracker/utils/buttons.dart';
import 'package:habit_tracker/utils/colors.dart';
import 'package:hive/hive.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:roundcheckbox/roundcheckbox.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;

import '../config/env.dart';
class NormalWorkoutSetUp extends StatefulWidget {
  final String? username;
  final String? email;
  final String? password;

  const NormalWorkoutSetUp({
    super.key,
    this.username,
    this.email,
    this.password,
  });

  @override
  State<NormalWorkoutSetUp> createState() => _WorkoutTrackTypeState();
}

bool isManualSelected = false;
bool isAutomaticSelected = false;

class _WorkoutTrackTypeState extends State<NormalWorkoutSetUp> {
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

  double latitude = 0;
  double longitude = 0;
  double distance = 0;
  // Function to calculate distance between two sets of latitude and longitude
  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2);
  }

 void stop() async {
  
    await LocalStorageServices().setAutomatic(false);

    log("setting automatic to false Home.dart");

    bg.BackgroundGeolocation.stop();
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
      body: Padding(
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
                setState(()  {
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
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: CustomButton(
          text: 'CONTINUE'.tr(),
          onPressed: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            bool? hello = prefs.getBool('isAutomaticSelected');
            if (hello == false) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (_) => ManualAccountSetup(
                            email: widget.email,
                            password: widget.password,
                            username: widget.username,
                          )),
                  (route) => false);
            } else {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (_) => AccountSetup(
                            email: widget.email,
                            password: widget.password,
                            username: widget.username,
                          )),
                  (route) => false);
            }

            // Add your button click logic here
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
