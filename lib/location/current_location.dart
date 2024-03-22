import 'dart:convert';
import 'dart:isolate';
import 'dart:ui';
import 'package:background_locator_2/background_locator.dart';
import 'package:background_locator_2/location_dto.dart';
import 'package:background_locator_2/settings/android_settings.dart' as wwe;
import 'package:background_locator_2/settings/ios_settings.dart' as pre;
import 'package:background_locator_2/settings/locator_settings.dart';
import 'package:habit_tracker/location/location_callback_handler.dart';
import 'package:habit_tracker/location/location_service_repository.dart';
import 'package:habit_tracker/main.dart';
import 'package:http/http.dart' as http;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:habit_tracker/utils/colors.dart';
import 'package:habit_tracker/utils/textfields.dart';
import 'package:geolocator/geolocator.dart' as img;

import 'package:location_permissions/location_permissions.dart';
import 'file_manager.dart';

class CurrentLocation extends StatefulWidget {
  const CurrentLocation({super.key});

  @override
  State<CurrentLocation> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<CurrentLocation> {
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
  ReceivePort port = ReceivePort();
  String logStr = '';
  bool isRunning1 = false;
  LocationDto? lastLocation;

  Future<void> updateUI(dynamic data) async {
    final log = await FileManager.readLogFile();

    LocationDto? locationDto =
        (data != null) ? LocationDto.fromJson(data) : null;
    await _updateNotificationText(locationDto!);

    setState(() {
      if (data != null) {
        lastLocation = locationDto;
      }
      logStr = log;
    });
  }

  Future<void> _updateNotificationText(LocationDto data) async {
    await BackgroundLocator.updateNotificationText(
        title: "new location received",
        msg: "${DateTime.now()}",
        bigMsg: "${data.latitude}, ${data.longitude}");
  }

  Future<void> initPlatformState() async {
    print('Initializing...');

    logStr = await FileManager.readLogFile();
    print('Initialization done');
    final isRunning = await BackgroundLocator.isServiceRunning();
    setState(() {
      isRunning1 = isRunning;
    });
    print('Running ${isRunning1.toString()}');
  }

  @override
  void initState() {
    super.initState();

    _getCurrentLocation();
    _selectedTime = TimeOfDay.now();
    if (IsolateNameServer.lookupPortByName(
            LocationServiceRepository.isolateName) !=
        null) {
      IsolateNameServer.removePortNameMapping(
          LocationServiceRepository.isolateName);
    }

    IsolateNameServer.registerPortWithName(
        port.sendPort, LocationServiceRepository.isolateName);

    port.listen(
      (dynamic data) async {
        await updateUI(data);
        await BackgroundLocator.initialize();
      },
    );
    initPlatformState();
  }

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

  TimeOfDay? _selectedTime;
  Future<void> _selectTime(BuildContext context) async {
    final ThemeData theme = Theme.of(context);
    final initialTime = _selectedTime ?? TimeOfDay.now();
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            // Change the colors here
            primaryColor: AppColors.mainBlue, // Header background color

            colorScheme: const ColorScheme.light(
              primary: AppColors.mainBlue, // Selected day background color
              onPrimary: Colors.white, // Selected day text color
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

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
        places.add('No results found');
      }

      setState(() => _places = places);
    } catch (e) {
      print('Failed to get search results from Mapbox: $e');
    }
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    emailController.clear();
    super.dispose();
  }

  void onStop() async {
    await BackgroundLocator.unRegisterLocationUpdate();
    final isRunning = await BackgroundLocator.isServiceRunning();
    setState(() {
      isRunning1 = isRunning;
    });
  }

  void _onStart() async {
    if (await _checkLocationPermission()) {
      await _startLocator();
      final isRunning = await BackgroundLocator.isServiceRunning();

      setState(() {
        isRunning1 = isRunning;
        lastLocation = null;
      });
    } else {
      // show error
    }
  }

  Future<bool> _checkLocationPermission() async {
    final access = await LocationPermissions().checkPermissionStatus();
    switch (access) {
      case PermissionStatus.unknown:
      case PermissionStatus.denied:
      case PermissionStatus.restricted:
        final permission = await LocationPermissions().requestPermissions(
          permissionLevel: LocationPermissionLevel.locationAlways,
        );
        if (permission == PermissionStatus.granted) {
          logger.d(permission);
          return true;
        } else {
          logger.d(permission);
          return false;
        }

      case PermissionStatus.granted:
        return true;

      default:
        return false;
    }
  }

  Future<void> _startLocator() async {
    Map<String, dynamic> initData = {
      'countInit': 1
    }; // Initialize data for location update
    // Log the initialization data

    // Register location update with BackgroundLocator
    return await BackgroundLocator.registerLocationUpdate(
      LocationCallbackHandler.callback,
      // Specify init callback and data
      initCallback: LocationCallbackHandler.initCallback,
      initDataCallback: initData,
      // Specify dispose callback
      disposeCallback: LocationCallbackHandler.disposeCallback,
      // Configure iOS settings
      iosSettings: const pre.IOSSettings(
        accuracy: LocationAccuracy.NAVIGATION, // Specify accuracy
        distanceFilter: 0, // Specify distance filter
        stopWithTerminate: true, // Specify whether to stop with app termination
      ),
      // Disable auto stop
      autoStop: false,
      // Configure Android settings
      androidSettings: const wwe.AndroidSettings(
        accuracy: LocationAccuracy.NAVIGATION, // Specify accuracy
        interval: 5, // Specify interval for location updates
        distanceFilter: 0, // Specify distance filter
        client: wwe.LocationClient.google, // Specify location client
        // Configure Android notification settings
        androidNotificationSettings: wwe.AndroidNotificationSettings(
          notificationChannelName:
              'Location tracking', // Specify notification channel name
          notificationTitle:
              'Start Location Tracking', // Specify notification title
          notificationMsg: 'Track location in background',
          // Specify notification message
          notificationBigMsg:
              'Background location is on to keep the app up-to-date with your location. This is required for main features to work properly when the app is not running.', // Specify big notification message
          notificationIconColor: Colors.grey, // Specify notification icon color
          notificationTapCallback: LocationCallbackHandler
              .notificationCallback, // Specify notification tap callback
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final start = SizedBox(
      width: double.maxFinite,
      child: ElevatedButton(
        child: const Text('Start'),
        onPressed: () {
          _onStart();
        },
      ),
    );
    final stop = SizedBox(
      width: double.maxFinite,
      child: ElevatedButton(
        child: const Text('Stop'),
        onPressed: () {
          onStop();
        },
      ),
    );
    final clear = SizedBox(
      width: double.maxFinite,
      child: ElevatedButton(
        child: const Text('Clear Log'),
        onPressed: () {
          FileManager.clearLogFile();
          setState(() {
            logStr = '';
          });
        },
      ),
    );
    String msgStatus = "-";
    if (isRunning1) {
      msgStatus = 'Is running';
    } else {
      msgStatus = 'Is not running';
    }
    final status = Text("Status: $msgStatus");

    final log = Text(
      logStr,
    );

    return Scaffold(
      appBar: AppBar(
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
          "Location",
          style: TextStyle(
              fontFamily: 'SFProText',
              fontSize: 22.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textBlack),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          start,
          stop,
          clear,
          status,
          log,
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 20.w,
            ),
            child: TextFormField(
              controller: _textEditingController,
              onChanged: (value) => searchPlacesWorldwide(),
              validator: (value) => (value!.isEmpty)
                  ? "Please Enter Your Gym Location".tr()
                  : null,
              decoration: AppTextFieldStyles.standardInputDecoration(
                hintText: 'Enter your gym location',
                labelText: 'Gym Location',
                keyboardType: TextInputType.name,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 20.w,
            ),
            child: TextFormField(
              readOnly: true,
              controller: _textEditingController1,
              onTap: () {
                _selectTime(context);
              },
              validator: (value) =>
                  (value!.isEmpty) ? "Please Enter Your Gym Time".tr() : null,
              decoration: AppTextFieldStyles.standardInputDecoration(
                hintText: DateFormat.jm().format(
                  DateTime(
                    2022,
                    1,
                    1,
                    _selectedTime!.hour,
                    _selectedTime!.minute,
                  ),
                ),
                labelText: 'Gym Time',
                keyboardType: TextInputType.name,
              ),
            ),
          ),
          _textEditingController.text.isNotEmpty
              ? Expanded(
                  child: ListView.builder(
                    itemCount: _places.length,
                    itemBuilder: (BuildContext context, int index) {
                      final place = _places[index];
                      return ListTile(
                        title: place == 'No results found'
                            ? Text(place)
                            : Text(place),
                        onTap: () {
                          if (place != 'No results found') {
                            _textEditingController.text = place;
                            setState(() => _places.clear());
                          }
                        },
                      );
                    },
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
