import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:isolate';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:habit_tracker/auth/repositories/gymtime_model.dart';
import 'package:habit_tracker/auth/repositories/new_gymtime_model.dart';
import 'package:habit_tracker/main.dart';
import 'package:http/http.dart' as http;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:habit_tracker/utils/colors.dart';
import 'package:habit_tracker/utils/textfields.dart';
import 'package:geolocator/geolocator.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:carp_background_location/carp_background_location.dart';
import 'package:hive/hive.dart';

// import 'package:background_fetch/background_fetch.dart';
class CurrentLocation extends StatefulWidget {
  const CurrentLocation({super.key});

  @override
  State<CurrentLocation> createState() => _OnBoardingScreenState();
}

enum LocationStatus { UNKNOWN, INITIALIZED, RUNNING, STOPPED }

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

  Future<void> fetchUsers() async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    String? currentUserUid = getUsername();

    try {
      QuerySnapshot snapshot = await users.get();

      for (var doc in snapshot.docs) {
        String uid = doc.id;
        Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;

        if (uid == currentUserUid) {
          // This user document matches the current user
          // You can access the user data and do something with it
          latitude = userData['latitude'];
          longitude = userData['longitude'];

          log('Latitude: $latitude, Longitude: $longitude');
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
    LocationManager().interval = 1;
    LocationManager().distanceFilter = 0;
    LocationManager().notificationTitle = 'Tracking Your Location';
    LocationManager().notificationMsg =
        'Habit Tracker is tracking your location.';
    LocationManager().notificationBigMsg =
        'Habit Tracker is tracking your location.';
    _status = LocationStatus.INITIALIZED;
    _getCurrentLocation();
    fetchUsers();
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

    if (!granted) {
      granted =
          await Permission.locationAlways.request() == PermissionStatus.granted;
    }

    return granted;
  }

  /// Start listening to location events.
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
      // getLastLocationTime();
      // getLastLocationTime1();
    });
  }

  Widget stopButton() => SizedBox(
        width: double.maxFinite,
        child: ElevatedButton(
          onPressed: stop,
          child: const Text('STOP'),
        ),
      );

  Widget startButton() => SizedBox(
        width: double.maxFinite,
        child: ElevatedButton(
          onPressed: start,
          child: const Text('START'),
        ),
      );

  Widget statusText() => Text("Status: ${_status.toString().split('.').last}");

  Widget currentLocationButton() => SizedBox(
        width: double.maxFinite,
        child: ElevatedButton(
          onPressed: getCurrentLocation,
          child: const Text('CURRENT LOCATION'),
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

  // Function to calculate distance between two sets of latitude and longitude
  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2);
  }

  // locationWidget function to add data to Hive
  Future<Widget> locationWidget() async {
    if (_lastLocation == null) {
      return const Text("No location yet");
    } else {
      double distance = calculateDistance(
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
      } else {
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

// // getLastLocationTime function to retrieve data from Hive
//   Future<DateTime?> getLastLocationTime() async {
//     try {
//       // Initialize Hive

//       // Open the Hive box where user location times are stored
//       var box = await Hive.openBox<DataModel>('hive_box');

//       // Get the last added dataModel instance from the box
//       DataModel? lastDataModel =
//           box.isNotEmpty ? box.getAt(box.length - 1) : null;

//       // Extract the date and time from the lastDataModel instance
//       if (lastDataModel != null) {
//         var dateString = lastDataModel.date;
//         var timeString = lastDataModel.time;
//         var dateTimeString = '$dateString $timeString';
//         log('DataModel1: $dateTimeString');
//         return DateTime.parse(dateTimeString);
//       }
//       // Close the Hive box
//       await box.close();
//     } catch (error) {
//       print('Failed to retrieve last location time: $error');
//     }
//     return null;
//   }

//   Future<DateTime?> getLastLocationTime1() async {
//     try {
//       // Initialize Hive

//       // Open the Hive box where user location times are stored
//       var box = await Hive.openBox<DataModel1>('hive_box1');

//       // Get the last added dataModel instance from the box
//       DataModel1? lastDataModel =
//           box.isNotEmpty ? box.getAt(box.length - 1) : null;

//       // Extract the date and time from the lastDataModel instance
//       if (lastDataModel != null) {
//         var dateString = lastDataModel.date;
//         var timeString = lastDataModel.time;
//         var dateTimeString = '$dateString $timeString';
//         log('DataModel2: $dateTimeString');
//         return DateTime.parse(dateTimeString);
//       }
//       // Close the Hive box
//       await box.close();
//     } catch (error) {
//       print('Failed to retrieve last location time: $error');
//     }
//     return null;
//   }

  @override
  Widget build(BuildContext context) {
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
          startButton(),
          stopButton(),
          currentLocationButton(),
          const Divider(),
          statusText(),
          const Divider(),
          FutureBuilder<Widget>(
            future: locationWidget(), // Call locationWidget() here
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // While data is loading, return a loading indicator or placeholder
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                // If an error occurs, display an error message
                return Text('Error: ${snapshot.error}');
              } else {
                // If data is successfully loaded, return the widget from the future
                return snapshot.data ?? const Text('No location yet');
              }
            },
          ),
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
          Text(currentAddress.toString()),
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
