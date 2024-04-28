import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:habit_tracker/auth/repositories/gymtime_model.dart';
import 'package:habit_tracker/auth/repositories/new_gymtime_model.dart';
import 'package:habit_tracker/auth/widgets/gym_in_time.dart';
import 'package:habit_tracker/config/env.dart';
import 'package:habit_tracker/location/current_location.dart';
import 'package:habit_tracker/main.dart';
import 'package:habit_tracker/pages/screens/customize%20character/pickCharacter.dart';
import 'package:habit_tracker/pages/screens/friends.dart';
import 'package:habit_tracker/pages/screens/widgets/workout_data.dart';
import 'package:habit_tracker/pages/usage_page/usage_page.dart';
import 'package:habit_tracker/provider/index_provider.dart';
import 'package:habit_tracker/provider/location_provider.dart';
import 'package:habit_tracker/services/device_screen_time_services.dart';
import 'package:habit_tracker/services/goals_services.dart';
import 'package:habit_tracker/services/gym_firestore_services.dart';
import 'package:habit_tracker/services/local_storage_services.dart';
import 'package:habit_tracker/services/sleep_firestore_services.dart';
import 'package:habit_tracker/utils/colors.dart';
import 'package:habit_tracker/utils/icons.dart';
import 'package:habit_tracker/utils/images.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextStyle headingStyle = TextStyle(
    fontFamily: 'SFProText',
    fontWeight: FontWeight.w600,
    fontSize: 14.sp,
    color: Colors.black.withOpacity(0.65),
  );
  final FirebaseAuth _auth = FirebaseAuth.instance;
  int focus = 0;
  int screen = 0;
  int sleep = 0;
  int workout = 0;
  int xp = 0;
  String? getUserID() {
    User? user = _auth.currentUser;
    return user?.uid;
  }
  double lat=0;
  double longii=0;

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
            xp = userData['xp'] ?? 0;
            lat = userData['latitude'] ?? 0;
            longii = userData['longitude'] ?? 0;
          });

          // Example: Use the latitude and longitude data
          // SomeFunctionToUseLocation(latitude, longitude);
        }
      }
    } catch (error) {
      print("Failed to fetch users: $error");
    }
  }

  String added = "";
  String day = "";

  Future<void> fetchUsers4() async {
    CollectionReference users = FirebaseFirestore.instance.collection('goals');
    String? currentUserUid = getUserID();

    try {
      QuerySnapshot snapshot = await users
          .doc(currentUserUid)
          .collection('screen')
          .get(); // Use get() instead of snapshots() to fetch a single query snapshot

      for (var doc in snapshot.docs) {
        Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;

        // This user document matches the current user
        // You can access the user data and do something with it
        setState(() {
          added = userData['addedAt'] ?? "";
          day = userData['day'] ?? "";
        });
        logger.d(userData);
        logger.d("Day: $day");
        logger.d("Added: $added");

        // Example: Use the latitude and longitude data
        // SomeFunctionToUseLocation(latitude, longitude);
      }
    } catch (error) {
      print("Failed to fetch users: $error");
    }
  }

 
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Column(
        children: [
          const SizedBox(
            height: 5,
          ),
          appbar(),
          // character
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Image.asset(
                    AppImages.characterFull,
                    height: 450.h,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        wakeSleepTime(),
                        screenTime(),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        workoutTime(),
                        focusTime(),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }

  Column wakeSleepTime() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Wake up      Sleep   '.tr(),
          style: headingStyle,
        ),
        SizedBox(
          height: 5.h,
        ),
        GestureDetector(
          onTap: () {
            context.read<IndexProvider>().setSelectedIndex(0);
          },
          child: Container(
            width: 180.w,
            height: 100.h,
            decoration: ShapeDecoration(
              color: AppColors.widgetColorV,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 22.w),
              child: StreamBuilder<QuerySnapshot>(
                  stream: SleepFireStoreServices().listenToTodayAddedSleepTime,
                  builder: (context, snapshot) {
                    debugPrint("Snapshot: ${snapshot.data?.docs.length}");

                    var snapshotLength = snapshot.data?.docs.length;

                    // we got data
                    if (snapshot.hasData &&
                        snapshot.connectionState == ConnectionState.active &&
                        snapshotLength != 0) {
                      var doc = snapshot.data!.docs[0];

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.light_mode,
                                color: Colors.yellow.shade600,
                                size: 34.sp,
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              Text(
                                doc.get("wakeTime"),
                                style: TextStyle(
                                  color: AppColors.black,
                                  fontSize: 20.sp,
                                  fontFamily: 'SFProText',
                                  fontWeight: FontWeight.w800,
                                  height: 0,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.dark_mode_rounded,
                                color: Colors.yellow.shade600,
                                size: 30.sp,
                              ),
                              SizedBox(
                                height: 12.h,
                              ),
                              Text(
                                doc.get("sleepTime"),
                                style: TextStyle(
                                  color: AppColors.black,
                                  fontSize: 20.sp,
                                  fontFamily: 'SFProText',
                                  fontWeight: FontWeight.w800,
                                  height: 0,
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    } else if (snapshotLength == 0) {
                      return Center(
                          child: Text("Add your sleep and wake time.".tr()));
                    } else if (snapshot.hasError) {
                      return Text('Something went wrong'.tr());
                    }
                    return const SizedBox();
                  }),
            ),
          ),
        ),
      ],
    );
  }

  int lastAddedDay = 0;

// Define a method to check if it's a new day
  bool isNewDay(int currentDay) {
    return lastAddedDay != currentDay;
  }

  Future<void> addEntryAndCheckScreenTime(
    int hours,
    int minutes,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Update SharedPreferences with the current day and date
    await prefs.setInt('screenhours', hours);
    await prefs.setInt('screenminutes', minutes);
  }

 

  Column screenTime() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Screen Time'.tr(),
          style: headingStyle,
        ),
        SizedBox(
          height: 5.h,
        ),
        Container(
          width: 180.w,
          height: 100.h,
          decoration: ShapeDecoration(
            color: AppColors.widgetColorR,
           
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  AppIcons.phone,
                  width: 50,
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
  mainAxisAlignment: MainAxisAlignment.center,
  crossAxisAlignment: CrossAxisAlignment.end,
  children: [
    FutureBuilder<Map<String, dynamic>>(
      future: DeviceScreenTimeServices().getUsageStats(),
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox();
        } else if (snapshot.hasError) {
          return Text("Error".tr());
        }

        var duration = snapshot.data!["usage"];
        if (duration != null && duration is Duration) {
          var hours = duration.inHours % 60;
          var minutes = duration.inMinutes % 60;

          // Check if it's a new day before adding new screen time
          addEntryAndCheckScreenTime(hours, minutes);

          return Text(
            '$hours:$minutes h',
            style: TextStyle(
              color: AppColors.black,
              fontSize: 24.sp,
              fontFamily: 'SFProText',
              fontWeight: FontWeight.w800,
              height: 0,
            ),
          );
        } else {
          // Handle the case where duration is null or not a Duration
          print('Invalid duration data retrieved from snapshot');
          return Text(
            '0:0 h',
            style: TextStyle(
              color: AppColors.black,
              fontSize: 24.sp,
              fontFamily: 'SFProText',
              fontWeight: FontWeight.w800,
              height: 0,
            ),
          );
        }
      },
    ),
  ],
),

              ],
            ),
          ),
        ),
      ],
    );
  }
 @override
  void initState() {
    getLastLocationTime();
    getLastLocationTime1();
    fetchUsers();
    fetchUsers4();
    fetchUsers7();
  fetchUsers2();
  fetchUsers3();
    updatePieChartSections();
    super.initState();
  }
  String _location='Obtaining Address';
  

Future<void> _onLocation(bg.Location location) async {

    
    
       if (lat != null && longii != null) {
        distance = calculateDistance(
          lat,
          longii,
          location.coords.latitude,
          location.coords.longitude,
        );
      }

      logger.d("adsasd" + distance.toString());
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

double latitude = 0;
  double longitude = 0;
  double distance = 0;
  // Function to calculate distance between two sets of latitude and longitude
  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2);
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
        setState(() {
          
        });
        bg.BackgroundGeolocation.start();

  
        }
    });
}

 void stop() async {
 

    await LocalStorageServices().setAutomatic(false);

    log("setting automatic to false Home.dart");

    bg.BackgroundGeolocation.stop();
  }


  Future<void> _onMotionChange(bg.Location location) async {
     if (lat != null && longii != null) {
        distance = calculateDistance(
          lat,
          longii,
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
  // workout time
  String? dateString;
  String timeString = "00:00:00";
  String? dateString1;

  String timeString1 = "00:00:00";
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
         var  dateTimeString;
        setState(() {
          dateString = lastDataModel.date;
          timeString = lastDataModel.time!;
            dateTimeString = '$dateString $timeString';
        logger.d('DataModel1: $dateTimeString');
        });

        
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
          var  dateTimeString;
        setState(() {
          dateString1 = lastDataModel.date;
          timeString1 = lastDataModel.time!;
            dateTimeString = '$dateString $timeString';
        logger.d('DataModel2: $dateTimeString');
        });
       
        return DateTime.parse(dateTimeString);
      }
      // Close the Hive box
      await box.close();
    } catch (error) {
      print('Failed to retrieve last location time: $error');
    }
    return null;
  }

 bool hello = false;

  Future<void> fetchUsers7() async {
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
            hello = userData['isAutomatic'] ?? false;
          });

          // Example: Use the latitude and longitude data
          // SomeFunctionToUseLocation(latitude, longitude);
        }
      }
    } catch (error) {
      print("Failed to fetch users: $error");
    }
  }
  Column workoutTime() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Today\'s Workout'.tr(),
          style: headingStyle,
        ),
        SizedBox(
          height: 5.h,
        ),
           hello == false ?
                  Column(
                    children: [FutureBuilder<void>(
      future: setupBackgroundGeolocation(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // You can return a loading indicator or placeholder here
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // Handle error case
          return Text('Error: ${snapshot.error}');
        } else {
          // Future completed successfully, you can proceed with your UI
          return Container(
            
            // Add other widgets inside the Container if needed
          );
        }
      },
    ),
                      Container(
                                width: 180.w,
                                height: 100.h,
                                decoration: ShapeDecoration(
                                  color: AppColors.widgetColorB,
                                  // gradient: LinearGradient(
                                  //   begin: Alignment.bottomLeft,
                                  //   end: Alignment.topRight,
                                  //   colors: [
                                  //     Color.fromARGB(255, 4, 87, 76),
                                  //     Color(0xFF00D0B5),
                                  //   ],
                                  // ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.r),
                                  ),
                                ),
                                child:  StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                          stream: GymFirestoreServices().listenToTodayGymTime,
                          builder: (_, snapshot) {
                            if (snapshot.hasData &&
                                snapshot.data!.docs.isNotEmpty) {
                              var doc = snapshot.data!.docs[0];
                              return WorkoutData(
                                inTime: doc.get("InTime"),
                                outTime: doc.get("OutTime"),
                              );
                            } else if (snapshot.hasData &&
                                snapshot.data!.docs.isEmpty) {
                              return GestureDetector(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (_) {
                                        return GymInTime();
                                      });
                                },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                                  child: Center(
                                    child:
                                        Text("Click to add today's workout.".tr()),
                                  ),
                                ),
                              );
                            } else if (snapshot.hasError) {
                              return Text("Error".tr());
                            }
                            return const SizedBox();
                          })),
                    ],
                  ):
                
                 Container(
          width: 180.w,
          height: 100.h,
          decoration: ShapeDecoration(
            color: AppColors.widgetColorB,
            // gradient: LinearGradient(
            //   begin: Alignment.bottomLeft,
            //   end: Alignment.topRight,
            //   colors: [
            //     Color.fromARGB(255, 4, 87, 76),
            //     Color(0xFF00D0B5),
            //   ],
            // ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
            ),
          ),
          child:   Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              AppIcons.workout,
                              width: 45,
                              color: AppColors.lightBlack,
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  timeString.toString(),
                                  style: TextStyle(
                                    color: AppColors.black,
                                    fontSize: 19.sp,
                                    fontFamily: 'SFProText',
                                    fontWeight: FontWeight.w800,
                                    height: 0,
                                  ),
                                ),
                                Text(
                                  'to'.tr(),
                                  style: TextStyle(
                                    color: AppColors.black.withOpacity(0.7),
                                    fontSize: 16.sp,
                                    fontFamily: 'SFProText',
                                    fontWeight: FontWeight.w800,
                                    height: 0,
                                  ),
                                ),
                                Text(
                                  timeString1.toString(),
                                  style: TextStyle(
                                    color: AppColors.black,
                                    fontSize: 19.sp,
                                    fontFamily: 'SFProText',
                                    fontWeight: FontWeight.w800,
                                    height: 0,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  )),
                
       
      ],
    );
  }

  // focus time widget

  Column focusTime() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Focused Time'.tr(),
          style: headingStyle,
        ),
        SizedBox(
          height: 5.h,
        ),
        Container(
          width: 180.w,
          height: 100.h,
          decoration: ShapeDecoration(
            color: AppColors.widgetColorG,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 0,
                bottom: 0,
                right: 0,
                child: SvgPicture.asset(
                  AppIcons.timer,
                  height: 80.h,
                  color: Colors.white.withOpacity(0.3),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          AppIcons.foucsed,
                          width: 40,
                          color: AppColors.lightBlack,
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '$totalHours:$totalMinutes h',
                              style: TextStyle(
                                color: AppColors.black,
                                fontSize: 28.sp,
                                fontFamily: 'SFProText',
                                fontWeight: FontWeight.w800,
                                height: 0,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Map<String, dynamic> userLabels = {};
  Map<String, dynamic> userLabels2 = {};
  List<Map<String, dynamic>> dataList = [];
  List<Map<String, dynamic>> dataList2 = [];
  Future<Map<String, dynamic>> fetchUsers3() async {
    CollectionReference users =
        FirebaseFirestore.instance.collection('stopwatch');

    String? userID = getUserID(); // Get the current user's ID
    // Initialize a list to hold the Text widgets

    if (userID != null) {
      try {
        QuerySnapshot snapshot =
            await users.where('ID', isEqualTo: userID).get();
        if (snapshot.docs.isNotEmpty) {
          for (var doc in snapshot.docs) {
            var data = doc.data()
                as Map<String, dynamic>; // Cast data to Map<String, dynamic>
            dataList.add(data); // Add user data to the list
          }
          userLabels['data'] = dataList;
          userLabels['data'].forEach((labelData) {
            int hours = labelData['Hours'];
            int minutes = labelData['Minutes'];

            totalHours += hours; // Accumulate hours
            totalMinutes += minutes; // Accumulate minutes
          });
        } else {
          print('No data found for the current user');
        }
      } catch (error) {
        print("Failed to fetch users: $error");
      }
    } else {
      print('User ID is null');
    }

    return userLabels; // Return the list of Text widgets
  }

  Future<Map<String, dynamic>> fetchUsers2() async {
    CollectionReference users =
        FirebaseFirestore.instance.collection('focus_timer');

    String? userID = getUserID(); // Get the current user's ID
    // Initialize a list to hold the Text widgets

    if (userID != null) {
      try {
        QuerySnapshot snapshot =
            await users.where('ID', isEqualTo: userID).get();
        if (snapshot.docs.isNotEmpty) {
          for (var doc in snapshot.docs) {
            var data = doc.data()
                as Map<String, dynamic>; // Cast data to Map<String, dynamic>
            dataList2.add(data); // Add user data to the list
          }
          userLabels2['data'] = dataList2;
          userLabels2['data'].forEach((labelData) {
            int hours = labelData['Hours'];
            int minutes = labelData['Minutes'];

            totalHours += hours; // Accumulate hours
            totalMinutes += minutes; // Accumulate minutes
          });
        } else {
          print('No data found for the current user');
        }
      } catch (error) {
        print("Failed to fetch users: $error");
      }
    } else {
      print('User ID is null');
    }

    return userLabels2; // Return the list of Text widgets
  }

  List<Map<String, dynamic>> labelDataList = [];
  Map<String, int> labelValues = {};
  Map<String, int> labelValues1 = {};
  int totalHours = 0;
  int totalMinutes = 0;

  Future<void> updatePieChartSections() async {
    // Fetch user labels from both sources

    // Update the state with the total hours and minutes
    // Convert excess minutes to hours
    totalHours += totalMinutes ~/ 60;
    totalMinutes %= 60;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('focusHours', totalHours);
    prefs.setInt('focusMinutes', totalMinutes);
    // Update the state with the total hours and minutes
    setState(() {});
  }

  Padding appbar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FriendsPage(),
                    ),
                  );
                },
                child: Container(
                    height: 50.h,
                    width: 50.w,
                    decoration: BoxDecoration(
                      color: AppColors.mainColor,
                      borderRadius: BorderRadius.all(Radius.circular(16.r)),
                    ),
                    alignment: Alignment.center,
                    child: SvgPicture.asset(
                      AppIcons.friends,
                      color: Colors.white,
                      height: 25.h,
                      width: 25.w,
                    )),
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const PickCharacterPage();
                      },
                    ),
                  );
                },
                child: Container(
                    height: 50.h,
                    width: 50.w,
                    decoration: BoxDecoration(
                      color: AppColors.mainColor,
                      borderRadius: BorderRadius.all(Radius.circular(16.r)),
                    ),
                    alignment: Alignment.center,
                    child: SvgPicture.asset(
                      AppIcons.customize,
                      color: Colors.white,
                      height: 35.h,
                      width: 35.w,
                    )),
              ),
            ],
          ),
         /* TextButton(
            onPressed: () async {
              await FirebaseAuth.instance.currentUser!.sendEmailVerification();
            },
            child: Text("Usage".tr()),
          ),*/
          Container(
            margin: const EdgeInsets.only(top: 10),
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 100,
                  width: 100,
                  child: Image.asset(AppIcons.xpbar),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 45),
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    width: 60,
                    child: Text(
                      '$xp',
                      style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontFamily: 'SFProText',
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w900,
                        color: AppColors.black,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 57),
                  child: Text(
                    'XP',
                    style: TextStyle(
                      fontFamily: 'SFProText',
                      fontSize: 23.sp,
                      fontWeight: FontWeight.normal,
                      color: AppColors.black,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
