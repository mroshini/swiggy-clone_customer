import 'dart:async';

import 'package:flutter/material.dart';
import 'package:foodstar/src/constants/api_params_keys.dart';
import 'package:foodstar/src/constants/api_urls.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserLocationScreen extends StatefulWidget {
  final Map<String, String> mapValue;

  UserLocationScreen({this.mapValue});

  @override
  _UserLocationScreenState createState() => _UserLocationScreenState();
}

class _UserLocationScreenState extends State<UserLocationScreen> {
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

  //List<Marker> allMarkers = [];

//  CameraPosition _currentCameraPosition = CameraPosition(
//    target: LatLng(lat, long),
//    zoom: 14,
//  );

//  getCurrentLatLangFromPref() async {
//    await initPref();
//    accessToken = prefs.getString(SharedPreferenceKeys.accessToken) ?? "";
//    lat = double.parse(prefs.getString(SharedPreferenceKeys.latitude)) ?? 0.0;
//    long = double.parse(prefs.getString(SharedPreferenceKeys.longitude)) ?? 0.0;
//    userId = prefs.getInt(SharedPreferenceKeys.userId) ?? 0;
//  }

  initPref() async {
    if (prefs == null) prefs = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    //  geoLocator = Geolocator()..forceAndroidLocationManager;
    //  getCurrentLatLangFromPref();

    //_getCurrentLocation();
    showLog(
        "Geolocator--${widget.mapValue[latitudeKey]} ${widget.mapValue[longitudeKey]}");
    super.initState();
    _currentCameraPosition = CameraPosition(
      target: LatLng(double.parse(widget.mapValue[latitudeKey]),
          double.parse(widget.mapValue[longitudeKey])),
      zoom: 16,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _currentCameraPosition,
              myLocationButtonEnabled: false,
              myLocationEnabled: false,
              //onCameraMove: _mapViewDrafagging,
              //onCameraIdle: _didMapViewIdle,
              onMapCreated: (GoogleMapController googleMapController) {
                _controller.complete(googleMapController);
                // showPinsOnMap();
              },
              // markers: Set.from(allMarkers),
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
            Align(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/images/marker_pin.png',
                width: 40.0,
                height: 40.0,
              ),
            ),
//            Visibility(
//              visible: widget.screenStatus == 3 ? false : true,
//              child: Positioned(
//                top: 60.0,
//                left: 30.0,
//                child: Center(
//                  child: Image.asset(
//                    'assets/images/hotel.jpg',
//                    width: 35.0,
//                    height: 35.0,
//                  ),
//                ),
//              ),
//            ),
//            Visibility(
//              visible: widget.screenStatus == 3 ? false : true,
//              child: Positioned(
//                top: 20.0,
//                left: 30.0,
//                right: 30.0,
//                child: Center(
//                  child: Image.asset(
//                    'assets/images/bike.jpg',
//                    width: 35.0,
//                    height: 35.0,
//                  ),
//                ),
//              ),
//            ),
            // showBody(),
          ],
        ),
      ),
    );
  }

//  Widget showBody() {
//    switch (widget.screenStatus) {
//      case 1:
//        return RestaurantMapViewScreen(); //SuccessOrderScreen(); //RestaurantMapViewScreen();
//      case 2:
//        return TrackSuccessOrderScreen();
//      case 3:
//        return AddAddressScreen();
//      case 4:
//        return TrackOrderScreen();
//      default:
//        return Align(
//          alignment: Alignment.bottomLeft,
//          child: Container(
//            height: 240.0,
//            color: Colors.white,
//            child: AddAddressScreen(),
//          ),
//        );
//    }
//  }

  void _confirmLocationTapped() {
    Navigator.pop(context, _currentAddress);
  }

//  void _mapViewDragging(CameraPosition position) {
//    if (!isMapDragging) {
//      setState(() {
//        _currentCameraPosition = CameraPosition(
//            target: LatLng(position.target.latitude, position.target.longitude),
//            zoom: 14);
//
//        allMarkers.add(
//          Marker(
//            markerId: MarkerId('MyMarker'),
//            position:
//                LatLng(position.target.latitude, position.target.longitude),
//            // draggable: isMapDragging,
//          ),
//        );
//        isMapDragging = true;
//      });
//    }
//  }
}
