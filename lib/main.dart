import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:background_fetch/background_fetch.dart';
import 'package:carp_background_location/carp_background_location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart' as pre;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:habit_tracker/auth/login_page.dart';
import 'package:habit_tracker/auth/repositories/new_gymtime_model.dart';
import 'package:habit_tracker/onboarding/onboardingScreen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart' as img;
import 'package:habit_tracker/pages/home_page.dart';
import 'package:habit_tracker/provider/avg_sleep_provider.dart';
import 'package:habit_tracker/provider/dob_provider.dart';
import 'package:habit_tracker/provider/flag_provider.dart';
import 'package:habit_tracker/services/notification_services.dart';
import 'package:http/http.dart' as http;
import 'package:habit_tracker/pages/auth_onboarding_deciding_screen.dart';
import 'package:habit_tracker/provider/index_provider.dart';
import 'package:habit_tracker/provider/location_provider.dart';
import 'package:habit_tracker/provider/start_end_date_provider.dart';

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import 'package:provider/provider.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth/repositories/gymtime_model.dart';
import 'auth/repositories/user_repository.dart';

var logger = Logger(
  printer: PrettyPrinter(),
);
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await EasyLocalization.ensureInitialized();
  await pre.Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  Directory directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  Hive.registerAdapter(DataModelAdapter());
  Hive.registerAdapter(DataModel1Adapter());
  await Hive.openBox<DataModel>('hive_box');
  await Hive.openBox<DataModel1>('hive_box1');
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => UserRepository.instance()),
      ChangeNotifierProvider(create: (_) => SelectedDateProvider()),
      ChangeNotifierProvider(create: (_) => FlagImageProvider()),
      ChangeNotifierProvider(create: (_) => StartEndDateProvider()),
      ChangeNotifierProvider(create: (_) => LocationProvider()),
      ChangeNotifierProvider(create: (_) => StartEndDateProvider()),
      ChangeNotifierProvider(create: (_) => AvgSleepProvider()),
      ChangeNotifierProvider(create: (_) => IndexProvider()),
    ],
    child: EasyLocalization(
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('de', 'DE'),
        Locale('zh', 'CN')
      ],
      path: 'assets/translations', // Path to your translation files
      fallbackLocale: const Locale('en', 'US'), // Default language
      child: const MyApp(),
    ),
  ));
  initBackgroundFetch();
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await pre.Firebase.initializeApp();
  log(message.notification!.title.toString());
  log(message.notification!.body.toString());
  log(message.data.toString());
}

@pragma('vm:entry-point')
void initBackgroundFetch() {
  BackgroundFetch.configure(
    BackgroundFetchConfig(
        minimumFetchInterval: 15,
        stopOnTerminate: false,
        enableHeadless: true,
        requiresBatteryNotLow: false,
        requiresCharging: false,
        requiresStorageNotLow: false,
        requiresDeviceIdle: false,
        requiredNetworkType: NetworkType.ANY),
    (String taskId) async {
      log(taskId);
      // Perform background task
      await checkAndUploadData();
      BackgroundFetch.finish(taskId);
    },
  );
}

Future<void> checkAndUploadData() async {
  await uploadDataModelFromBox('hive_box');
  await uploadDataModelFromBox1('hive_box1');
}

Future<void> uploadDataModelFromBox(String boxName) async {
  var boxDataModel = await Hive.openBox<DataModel>(boxName);

  if (boxDataModel.isEmpty) {
    await boxDataModel.close();
    return;
  }

  var dataModel = boxDataModel.getAt(boxDataModel.length - 1);

  if (dataModel != null) {
    DateTime currentTime = DateTime.now();
    DateTime recordedTime =
        DateTime.parse('${dataModel.date} ${dataModel.time}');

    // Check if 24 hours have passed
    if (currentTime.difference(recordedTime).inSeconds >= 5) {
      try {
        await uploadDataToFirebase(dataModel);
        await boxDataModel.clear();
      } catch (error) {
        print("Failed to upload data to Firebase: $error");
      }
    }
  }
}

Future<void> uploadDataModelFromBox1(String boxName) async {
  var boxDataModel = await Hive.openBox<DataModel1>(boxName);

  if (boxDataModel.isEmpty) {
    await boxDataModel.close();
    return;
  }

  var dataModel = boxDataModel.getAt(boxDataModel.length - 1);

  if (dataModel != null) {
    DateTime currentTime = DateTime.now();
    DateTime recordedTime =
        DateTime.parse('${dataModel.date} ${dataModel.time}');

    // Check if 24 hours have passed
    if (currentTime.difference(recordedTime).inSeconds >= 5) {
      try {
        await uploadDataToFirebase1(dataModel);
        await boxDataModel.clear();
      } catch (error) {
        print("Failed to upload data to Firebase: $error");
      }
    }
  }
}

final FirebaseAuth _auth = FirebaseAuth.instance;

String? getUserID() {
  User? user = _auth.currentUser;
  return user?.uid;
}

String? getUserName() {
  User? user = _auth.currentUser;
  return user?.displayName;
}

// Function to upload data to Firebase
Future<void> uploadDataToFirebase(DataModel dataModel) async {
  CollectionReference users =
      FirebaseFirestore.instance.collection('gym_in_time');
  await users.add({
    'ID': getUserID(),
    'Name': getUserName(),
    'Time': dataModel.time,
    'Date': dataModel.date,
  });
}

// Function to upload data to Firebase
Future<void> uploadDataToFirebase1(DataModel1 dataModel) async {
  CollectionReference users =
      FirebaseFirestore.instance.collection('gym_out_time');
  await users.add({
    'ID': getUserID(),
    'Name': getUserName(),
    'Time': dataModel.time,
    'Date': dataModel.date,
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return ScreenUtilInit(
        designSize: const Size(430, 932),
        minTextAdapt: true,
        splitScreenMode: true,
        // Use builder only if you need to use library outside ScreenUtilInit context
        builder: (_, child) {
          return MaterialApp(
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            debugShowCheckedModeBanner: false,
            home: const HomePage1(),
          );
        });
  }
}

class HomePage1 extends StatefulWidget {
  const HomePage1({super.key});

  @override
  State<HomePage1> createState() => _OnBoardingScreenState();
}

enum LocationStatus { UNKNOWN, INITIALIZED, RUNNING, STOPPED }

class _OnBoardingScreenState extends State<HomePage1> {
  bool isChecked = false;
  bool isChecked1 = false;
  bool isChecked2 = false;
  TextEditingController emailController = TextEditingController();
  final TextEditingController _textEditingController = TextEditingController();
  final TextEditingController _textEditingController1 = TextEditingController();
  List<String> _places = [];
  img.Position? _currentPosition;
  String? _errorMessage;
  final String _location = "None";
  String logStr = '';
  LocationDto? _lastLocation;
  StreamSubscription<LocationDto>? locationSubscription;
  LocationStatus _status = LocationStatus.UNKNOWN;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? getUsername() {
    User? user = _auth.currentUser;
    return user?.uid;
  }

  double latitude = 0;
  double longitude = 0;
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  Future<void> fetchUsers() async {
    String? currentUserUid = getUsername();

    try {
      QuerySnapshot snapshot =
          await userCollection.where('uid', isEqualTo: currentUserUid).get();

      if (snapshot.docs.isNotEmpty) {
        // If the snapshot is not empty, proceed with accessing user data
        for (var doc in snapshot.docs) {
          Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;

          // This user document matches the current user
          // You can access the user data and do something with it
        latitude = userData['latitude'] ;
      longitude = userData['longitude'];

          // If latitude and longitude are not null, log them or perform further actions
          log('Latitude: $latitude, Longitude: $longitude');
          // Example: Use the latitude and longitude data
          // SomeFunctionToUseLocation(latitude, longitude);
                }
      } else {
        // Handle case where no documents match the current user UID
        log('No user data found for the current user');
      }
    } catch (error) {
      // Handle any potential errors
      log("Failed to fetch users: $error");
    }
  }

  NotificationServices notificationServices = NotificationServices();

  @override
  void initState() {
    super.initState();
    LocationManager().interval = 60;
    LocationManager().distanceFilter = 0;
    LocationManager().notificationTitle = 'Tracking Your Location'.tr();
    LocationManager().notificationMsg =
        'Habit Tracker is tracking your location'.tr();
    LocationManager().notificationBigMsg =
        'Habit Tracker is tracking your location'.tr();
    _status = LocationStatus.INITIALIZED;
    start();
    _getCurrentLocation();
    fetchUsers();
    notificationServices.requestNotificationPermission();
    notificationServices.firebaseinit(context);
    // notificationServices.setupInteractMeassage(context);
    // notificationServices.isTokenRefresh();
    notificationServices.getDeviceToken().then((value) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('device_token', value!);
      log('device_token');
      log(value);
    });
  }

  void getCurrentLocation() async =>
      onData(await LocationManager().getCurrentLocation());

  void onData(LocationDto location) {
    print('>> $location');
    setState(() {
      _lastLocation = location;
    });
  }

  /// Is "location always" permission granted?
  Future<bool> isLocationAlwaysGranted() async =>
      await Permission.locationAlways.isGranted;

  /// Tries to ask for "location always" permissions from the user.
  /// Returns `true` if successful, `false` otherwise.
  Future<bool> askForLocationAlwaysPermission() async {
    bool granted = await Permission.locationAlways.isGranted;
    PermissionStatus? granted2; // Added.
    if (!granted) {
      granted2 = await Permission.location.request(); // Added.
      if (granted2 == PermissionStatus.granted) {
        granted = await Permission.locationAlways.request() ==
            PermissionStatus.granted;
      }
    }

    return granted;
  }

  void start() async {
    // ask for location permissions, if not already granted
    if (!await isLocationAlwaysGranted()) {
      await askForLocationAlwaysPermission();
    }

    locationSubscription?.cancel();
    locationSubscription = LocationManager().locationStream.listen(onData);
    await LocationManager().start();
    setState(() {
      _status = LocationStatus.RUNNING;
      locationWidget();
    });
  }

  void stop() {
    locationSubscription?.cancel();
    LocationManager().stop();
    setState(() {
      _status = LocationStatus.STOPPED;
      getLastLocationTime();
      getLastLocationTime1();
    });
  }

  Widget stopButton() => SizedBox(
        width: double.maxFinite,
        child: ElevatedButton(
          onPressed: stop,
          child: Text('STOP'.tr()),
        ),
      );

  Widget startButton() => SizedBox(
        width: double.maxFinite,
        child: ElevatedButton(
          onPressed: start,
          child: Text('START'.tr()),
        ),
      );

  Widget statusText() =>
      Text("${"Status:".tr()} ${_status.toString().split('.').last}");

  Widget currentLocationButton() => SizedBox(
        width: double.maxFinite,
        child: ElevatedButton(
          onPressed: getCurrentLocation,
          child: Text('CURRENT LOCATION'.tr()),
        ),
      );

  @override
  void dispose() => super.dispose();

  Future<void> _getCurrentLocation() async {
    try {
      img.Position? position = await _determinePosition();
      setState(() {
        _currentPosition = position;
        _errorMessage = null;
        _getLocationDetails(position.latitude, position.longitude);
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  String? currentAddress;
  Future<img.Position> _determinePosition() async {
    bool serviceEnabled;
    img.LocationPermission permission;

    serviceEnabled = await img.Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw 'Location services are disabled.';
    }

    permission = await img.Geolocator.checkPermission();
    if (permission == img.LocationPermission.denied) {
      permission = await img.Geolocator.requestPermission();
      if (permission == img.LocationPermission.denied) {
        throw 'Location permissions are denied';
      }
    }

    if (permission == img.LocationPermission.deniedForever) {
      throw 'Location permissions are permanently denied, we cannot request permissions.';
    }

    return await img.Geolocator.getCurrentPosition();
  }

  Future<void> _getLocationDetails(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          _currentPosition!.latitude, _currentPosition!.longitude);
      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks[0];

        String thoroughfare = placemark.thoroughfare ?? '';
        String locality = placemark.locality ?? '';
        String administrativeArea = placemark.administrativeArea ?? '';

        currentAddress = '$thoroughfare, $locality, $administrativeArea';
      }
      setState(() {});
    } catch (e) {
      print('Failed to get location details: $e');
    }
  }

  double distance = 0;
  Future<void> searchPlacesWorldwide() async {
    final query = _textEditingController.text;
    final url =
        'https://api.mapbox.com/geocoding/v5/mapbox.places/$query.json?access_token=pk.eyJ1IjoiZGdkb24tMTIzIiwiYSI6ImNsbGFlandwcjFxNGMzcm8xbGJjNTY4bmgifQ.dGSMw7Ai7BpXWW4qQRcLgA';

    try {
      final response = await http.get(Uri.parse(url));
      final data = jsonDecode(response.body);

      final features = data['features'] as List<dynamic>;
      final places = <String>[];

      for (final feature in features) {
        final placeName = feature['place_name'] as String;
        places.add(placeName);
      }

      if (places.isEmpty) {
        places.add('No results found'.tr());
      }

      setState(() => _places = places);
    } catch (e) {
      print('Failed to get search results from Mapbox: $e');
    }
  }

  // Function to calculate distance between two sets of latitude and longitude
  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2);
  }

  // locationWidget function to add data to Hive
  Future<Widget> locationWidget() async {
    if (_lastLocation == null) {
      return Text("No location yet".tr());
    } else {
      distance = calculateDistance(
        latitude,
        longitude,
        _lastLocation!.latitude,
        _lastLocation!.longitude,
      );
      log(distance.toString());
      if (distance <= 300) {
        // Open the Hive box where user location times are stored
        var box = await Hive.openBox<DataModel>('hive_box');

        // Create a DataModel instance with current date and time
        var currentDate = DateTime.now().toString().split(' ')[0];
        var currentTime = _lastLocation!.time.toString();
        DateTime time =
            DateTime.fromMillisecondsSinceEpoch(_lastLocation!.time ~/ 1);

// Format the DateTime object to a desired string format
        String formattedTime = DateFormat('HH:mm:ss').format(time);
        DataModel dataModel = DataModel(date: currentDate, time: formattedTime);

        // Add the dataModel instance to the Hive box
        await box.add(dataModel);

        await box.close();
      }
      if (distance > 300) {
        // Open the Hive box where user location times are stored
        var box = await Hive.openBox<DataModel1>('hive_box1');

        // Create a DataModel instance with current date and time
        var currentDate = DateTime.now().toString().split(' ')[0];
        var currentTime = _lastLocation!.time.toString();
        DateTime time =
            DateTime.fromMillisecondsSinceEpoch(_lastLocation!.time ~/ 1);

// Format the DateTime object to a desired string format
        String formattedTime = DateFormat('HH:mm:ss').format(time);
        DataModel1 dataModel1 =
            DataModel1(date: currentDate, time: formattedTime);

        // Add the dataModel instance to the Hive box
        await box.add(dataModel1);

        await box.close();
      }
      return Column(
        children: <Widget>[
          Text(
            '${_lastLocation!.latitude}, ${_lastLocation!.longitude}',
          ),
          const Text('@'),
          Text(
            '${DateTime.fromMillisecondsSinceEpoch(_lastLocation!.time ~/ 1)}',
          ),
        ],
      );
    }
  }

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

  @override
  Widget build(BuildContext context) {
    return Consumer<UserRepository>(
      builder: (context, user, _) {
        switch (user.status) {
          case Status.Uninitialized:
            return const OnBoardingScreen();
          case Status.Unauthenticated:
            return const LoginScreen();
          case Status.Authenticating:
            return const LoginScreen();
          case Status.Authenticating1:
            return const LoginScreen();
          case Status.Authenticated:
            return const HomePage();
        }
      },
    );
  }
}
