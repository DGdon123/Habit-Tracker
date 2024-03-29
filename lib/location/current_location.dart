import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:isolate';
import 'dart:ui';
import 'package:habit_tracker/main.dart';
import 'package:http/http.dart' as http;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:habit_tracker/utils/colors.dart';
import 'package:habit_tracker/utils/textfields.dart';
import 'package:geolocator/geolocator.dart' as img;
import 'package:permission_handler/permission_handler.dart';
import 'package:carp_background_location/carp_background_location.dart';

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

  @override
  void initState() {
    super.initState();
    LocationManager().interval = 1;
    LocationManager().distanceFilter = 0;
    LocationManager().notificationTitle = 'CARP Location Example';
    LocationManager().notificationMsg = 'CARP is tracking your location';
    _status = LocationStatus.INITIALIZED;
    _getCurrentLocation();
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
    });
  }

  void stop() {
    locationSubscription?.cancel();
    LocationManager().stop();
    setState(() {
      _status = LocationStatus.STOPPED;
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

  Widget locationWidget() {
    if (_lastLocation == null) {
      return const Text("No location yet");
    } else {
      return Column(
        children: <Widget>[
          Text(
            '${_lastLocation!.latitude}, ${_lastLocation!.longitude}',
          ),
          const Text(
            '@',
          ),
          Text(
              '${DateTime.fromMillisecondsSinceEpoch(_lastLocation!.time ~/ 1)}')
        ],
      );
    }
  }

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
          locationWidget(),
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
