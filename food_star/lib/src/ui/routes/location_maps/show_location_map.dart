import 'dart:async';

import 'package:flutter/material.dart';
import 'package:foodstar/src/constants/sharedpreference_keys.dart';
import 'package:foodstar/src/ui/res/colors.dart';
import 'package:foodstar/src/ui/routes/location_maps/confirm_address_bottom_sheet.dart';
import 'package:foodstar/src/ui/routes/location_maps/track_order.dart';
import 'package:foodstar/src/ui/routes/orders/track_success_order.dart';
import 'package:foodstar/src/ui/routes/restaurant_details/restaurant_map_view.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowLocationMapScreen extends StatefulWidget {
  final int screenStatus;

  ShowLocationMapScreen({this.screenStatus});

  @override
  _ShowLocationMapScreenState createState() => _ShowLocationMapScreenState();
}

class _ShowLocationMapScreenState extends State<ShowLocationMapScreen> {
  Completer<GoogleMapController> _controller = Completer();

  //Geolocator geoLocator;
  String _currentAddress = ' ';
  bool isMapDragging = false;
  bool isFetchingLocation = false;
  Set<Marker> _markers = Set<Marker>();
  SharedPreferences prefs;
  static double lat = 0.0;
  static double long = 0.0;
  String accessToken;
  int userId;

  CameraPosition _currentCameraPosition;
  List<Marker> allMarkers = [];

//  CameraPosition _currentCameraPosition = CameraPosition(
//    target: LatLng(lat, long),
//    zoom: 14,
//  );

  getCurrentLatLangFromPref() async {
    await initPref();
    accessToken = prefs.getString(SharedPreferenceKeys.accessToken) ?? "";
    lat = double.parse(prefs.getString(SharedPreferenceKeys.latitude)) ?? 0.0;
    long = double.parse(prefs.getString(SharedPreferenceKeys.longitude)) ?? 0.0;
    userId = prefs.getInt(SharedPreferenceKeys.userId) ?? 0;
  }

  initPref() async {
    if (prefs == null) prefs = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    //geoLocator = Geolocator()..forceAndroidLocationManager;
    getCurrentLatLangFromPref();

    _getCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            isFetchingLocation
                ? GoogleMap(
                    mapType: MapType.normal,
                    initialCameraPosition: _currentCameraPosition,
                    myLocationButtonEnabled: true,
                    myLocationEnabled: true,
                    onCameraMove: _mapViewDragging,
                    onCameraIdle: _didMapViewIdle,
                    onMapCreated: (GoogleMapController googleMapController) {
                      _controller.complete(googleMapController);
                      // showPinsOnMap();
                    },
                    markers: Set.from(allMarkers),
                  )
                : Positioned(
                    top: 50.0,
                    child: CircularProgressIndicator(
                      backgroundColor: appColor,
                    ),
                  ),
            Positioned(
              top: 20.0,
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  size: 30.0,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
//            Positioned(
//              top: 55.0,
//              right: 20.0,
//              child: Center(
//                child: Image.asset(
//                  'assets/images/marker_pin.png',
//                  width: 35.0,
//                  height: 35.0,
//                ),
//              ),
//            ),
            Visibility(
              visible: widget.screenStatus == 3 ? false : true,
              child: Positioned(
                top: 60.0,
                left: 30.0,
                child: Center(
                  child: Image.asset(
                    'assets/images/hotel.jpg',
                    width: 35.0,
                    height: 35.0,
                  ),
                ),
              ),
            ),
            Visibility(
              visible: widget.screenStatus == 3 ? false : true,
              child: Positioned(
                top: 20.0,
                left: 30.0,
                right: 30.0,
                child: Center(
                  child: Image.asset(
                    'assets/images/bike.jpg',
                    width: 35.0,
                    height: 35.0,
                  ),
                ),
              ),
            ),
            showBody(),
          ],
        ),
      ),
    );
  }

  Widget showBody() {
    switch (widget.screenStatus) {
      case 1:
        return RestaurantMapViewScreen(); //SuccessOrderScreen(); //RestaurantMapViewScreen();
      case 2:
        return TrackSuccessOrderScreen();
      case 3:
        return AddAddressScreen();
      case 4:
        return TrackOrderScreen();
      default:
        return Align(
          alignment: Alignment.bottomLeft,
          child: Container(
            height: 240.0,
            color: Colors.white,
            child: AddAddressScreen(),
          ),
        );
    }
  }

  void _confirmLocationTapped() {
    Navigator.pop(context, _currentAddress);
  }

  void _mapViewDragging(CameraPosition position) {
    if (!isMapDragging) {
      setState(() {
        _currentCameraPosition = CameraPosition(
            target: LatLng(position.target.latitude, position.target.longitude),
            zoom: 14);

        allMarkers.add(
          Marker(
            markerId: MarkerId('MyMarker'),
            position:
                LatLng(position.target.latitude, position.target.longitude),
            // draggable: isMapDragging,
          ),
        );
        isMapDragging = true;
      });
    }
  }

  void _didMapViewIdle() {
    _getAddressFromLatLng();
    setState(() {
      isMapDragging = false;
    });
  }

  void _getAddressFromLatLng() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          _currentCameraPosition.target.latitude,
          _currentCameraPosition.target.longitude);

//      List<Placemark> placemarks = await geoLocator.placemarkFromCoordinates(
//        _currentCameraPosition.target.latitude,
//        _currentCameraPosition.target.longitude,
//      );
      setState(() {
        _currentAddress = placemarks[0].subLocality == ''
            ? placemarks[0].name
            : placemarks[0].subLocality;
        if (placemarks[0].thoroughfare != null) {
          _currentAddress = _currentAddress + placemarks[0].thoroughfare + ', ';
        }
        if (placemarks[0].subThoroughfare != null) {
          _currentAddress =
              _currentAddress + placemarks[0].subThoroughfare + ', ';
        }
        if (placemarks[0].locality != null) {
          _currentAddress = _currentAddress + placemarks[0].locality + ', ';
        }
        if (placemarks[0].postalCode != null) {
          _currentAddress = _currentAddress + placemarks[0].postalCode;
        }
        if (placemarks[0].subAdministrativeArea != null) {
          _currentAddress =
              _currentAddress + placemarks[0].subAdministrativeArea;
        }
        if (placemarks[0].country != null) {
          _currentAddress = _currentAddress + placemarks[0].country + ', ';
        }

        print('CURRENT LOCATION : {$_currentAddress}');
      });
    } catch (err) {
      print(err);
    }
  }

  void _getCurrentLocation() async {
    await getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() {
        _currentCameraPosition = CameraPosition(
            target: LatLng(position.latitude, position.longitude), zoom: 14);
        isFetchingLocation = true;
      });

      allMarkers.add(
        Marker(
          markerId: MarkerId('MyMarker'),
          position: LatLng(position.latitude, position.longitude),
          // draggable: isMapDragging,
        ),
      );
      _getAddressFromLatLng();
    }).catchError((err) {
      print(err);
    });

//    await geoLocator
//        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
//        .then((Position position) {
//      setState(() {
//        _currentCameraPosition = CameraPosition(
//            target: LatLng(position.latitude, position.longitude), zoom: 14);
//        isFetchingLocation = true;
//      });
//
//      allMarkers.add(
//        Marker(
//          markerId: MarkerId('MyMarker'),
//          position: LatLng(position.latitude, position.longitude),
//          // draggable: isMapDragging,
//        ),
//      );
//      _getAddressFromLatLng();
//    }).catchError((err) {
//      print(err);
//    });
  }
}
