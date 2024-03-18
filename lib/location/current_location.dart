import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:habit_tracker/utils/colors.dart';
import 'package:habit_tracker/utils/textfields.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:fluttertoast/fluttertoast.dart';

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
  Position? _currentPosition;
  String? _errorMessage;
  String _location = "None";
  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _selectedTime = TimeOfDay.now();
    bg.BackgroundGeolocation.onLocation((bg.Location location) {
      print('[location] - $location');
      setState(() {
        _location =
            "${location.coords.latitude} | ${location.coords.longitude}";
      });
      Fluttertoast.showToast(
          msg: "[location] -$location",
          toastLength: Toast.LENGTH_SHORT,
          // gravity: ToastGravity.CENTER,
          // timeInSecForIosWeb: 1,
          // backgroundColor: Colors.red,
          // textColor: Colors.white,
          fontSize: 16.0);
    });

    // Fired whenever the plugin changes motion-state (stationary->moving and vice-versa)
    bg.BackgroundGeolocation.onMotionChange((bg.Location location) {
      print('[motionchange] - $location');
      setState(() {
        _location =
            "${location.coords.latitude} | ${location.coords.longitude}";
      });
      Fluttertoast.showToast(
          msg: "[motionchange] -$location",
          toastLength: Toast.LENGTH_SHORT,
          // gravity: ToastGravity.CENTER,
          // timeInSecForIosWeb: 1,
          // backgroundColor: Colors.red,
          // textColor: Colors.white,
          fontSize: 16.0);
    });

    // Fired whenever the state of location-services changes.  Always fired at boot
    bg.BackgroundGeolocation.onProviderChange((bg.ProviderChangeEvent event) {
      print('[providerchange] - $event');

      Fluttertoast.showToast(
          msg: "[providerchange] -$event",
          toastLength: Toast.LENGTH_SHORT,
          // gravity: ToastGravity.CENTER,
          // timeInSecForIosWeb: 1,
          // backgroundColor: Colors.red,
          // textColor: Colors.white,
          fontSize: 16.0);
    });

    ////
    // 2.  Configure the plugin
    //
    bg.BackgroundGeolocation.ready(bg.Config(
            notification:
                bg.Notification(title: "Name Location", text: "Kathmandu"),
            desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
            distanceFilter: 10.0,
            stopOnTerminate: true,
            
            startOnBoot: true,
            debug: true,
            logLevel: bg.Config.LOG_LEVEL_VERBOSE))
        .then((bg.State state) {
      if (!state.enabled) {
        ////
        // 3.  Start the plugin.
        //
        bg.BackgroundGeolocation.start();
      }
    });
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position? position = await _determinePosition();
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
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw 'Location services are disabled.';
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw 'Location permissions are denied';
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw 'Location permissions are permanently denied, we cannot request permissions.';
    }

    return await Geolocator.getCurrentPosition();
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
          Center(
            child: Text(
              _location,
              style: const TextStyle(),
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
