import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:habit_tracker/utils/colors.dart';
import 'package:habit_tracker/utils/textfields.dart';
import 'package:geolocator/geolocator.dart';

class CurrentLocation extends StatefulWidget {
  const CurrentLocation({super.key});

  @override
  State<CurrentLocation> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<CurrentLocation> {
  List<String> _places = [];
  Position? _currentPosition;
  final TextEditingController _textEditingController = TextEditingController();
  final TextEditingController _textEditingController1 = TextEditingController();
  String? _errorMessage;
  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
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

  Future<void> searchPlacesInNepal() async {
    final query = _textEditingController.text;
    final url =
        'https://api.mapbox.com/geocoding/v5/mapbox.places/$query.json?country=np&access_token=pk.eyJ1IjoiZGdkb24tMTIzIiwiYSI6ImNsbGFlandwcjFxNGMzcm8xbGJjNTY4bmgifQ.dGSMw7Ai7BpXWW4qQRcLgA';

    try {
      final response = await http.get(Uri.parse(url));
      final data = jsonDecode(response.body);

      final features = data['features'] as List<dynamic>;
      final places = <String>[];

      for (final feature in features) {
        final placeTypes = feature['place_type'] as List<dynamic>;
        if (placeTypes.contains('district') ||
            placeTypes.contains('place') ||
            placeTypes.contains('locality')) {
          final placeName = feature['place_name'] as String;
          places.add(placeName);
        }
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
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: TextFormField(
              onChanged: (value) => searchPlacesInNepal(),
              validator: (value) => (value!.isEmpty)
                  ? "Please Enter Your Gym Location".tr()
                  : null,
              decoration: AppTextFieldStyles.standardInputDecoration(
                hintText: 'Enter your gym location',
                labelText: 'Gym Location',
                keyboardType: TextInputType.emailAddress,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _places.length,
              itemBuilder: (BuildContext context, int index) {
                final place = _places[index];
                return ListTile(
                  title:
                      place == 'No results found' ? Text(place) : Text(place),
                  onTap: () {
                    if (place != 'No results found') {
                      _textEditingController.text = place;
                      setState(() => _places.clear());
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
