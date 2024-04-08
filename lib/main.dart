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
import 'package:habit_tracker/provider/goals_provider.dart';
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
      ChangeNotifierProvider(create: (_) => GoalsProvider()),
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
    if (currentTime.difference(recordedTime).inHours >= 24) {
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
    if (currentTime.difference(recordedTime).inHours >= 24) {
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

  String? getUsername() {
    User? user = _auth.currentUser;
    return user?.uid;
  }

  NotificationServices notificationServices = NotificationServices();

  @override
  void initState() {
    super.initState();

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
