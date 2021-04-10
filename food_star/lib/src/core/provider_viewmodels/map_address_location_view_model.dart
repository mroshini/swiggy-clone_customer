import 'dart:async';
import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:foodstar/src/constants/api_urls.dart';
import 'package:foodstar/src/constants/sharedpreference_keys.dart';
import 'package:foodstar/src/core/models/api_models/saved_address_api_model.dart';
import 'package:foodstar/src/core/provider_viewmodels/common/base_change_notifier_model.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MapAddressLocationViewModel extends BaseChangeNotifierModel {
  BuildContext context;
  bool isMapDragging = false;
  bool isFetchingLocation = false;
  List<Marker> allMarkers = [];
  bool mapDragStarted = false;

//
//  CameraPosition currentCameraPosition =
//      CameraPosition(target: LatLng(8.764166, 78.134834), zoom: 14);

  // CameraPosition(target: LatLng(0.0, 0.0));

  // static final Position currentPosition;

//  String completeAddressLat = "";
//  String completeAddressLong = "";

  BitmapDescriptor pinLocationIcon;
  bool completeAddressSubmitted = false;
  bool landmarkSubmitted = false;
  SharedPreferences prefs;
  String accessToken;
  int userId;
  String currentAddress = ' ';
  String stateName = "";
  String cityLocality = "";
  String country = "";
  String currentAddressShownInHome = "";

//  Geolocator geoLocator;
  int selectedAddressTypeIndex;
  int selectedIndex = 0;
  String latitude;
  String longitude;
  bool showNextBottomSheet = false;
  double bottomSheetHeight = 0.4; //0.4;
  double maxChildSize = 0.65; //1.0;
  double minChildSize = .40; //0.4; // 0.2;
  List<AAddress> listOfAddress = [];

  // DBHelper dbHelper;

  Completer<GoogleMapController> mapController = Completer();

  // var geolocator = Geolocator();

  // GoogleMapController _mapController;

  // GoogleMapController get mapController => _mapController;

  //LatLng get initialPosition => _initialPosition;
  static LatLng _initialPosition;

  LatLng get lastPosition => _lastPosition;
  LatLng _lastPosition = _initialPosition;

  bool locationServiceActive = true;

  LatLng get initialPosition => latLng;

  LatLng latLng;
  bool mapsIsLoaded = true;

  MapAddressLocationViewModel({this.context}) {
    showLog("currentCameraPosition---- ");
//    initDbHelper();
    //  setCurrentLocationInCameraPosition();
    //  getCurrentLocation();
    //1  getUserLocation();
    // _loadingInitialPosition();
    //latLng = null;
    //getCurrentUserLocation();
  }

  void _loadingInitialPosition() async {
    await Future.delayed(Duration(seconds: 3)).then((v) {
      mapsIsLoaded = false;
      notifyListeners();
    });
  }

//  Future onCameraMoveStarted() async {
//    _lastPosition = LatLng(0.0, 0.0);
//    showLog(
//        "onCameraMoveStarted1--${_lastPosition.latitude}--${_lastPosition.longitude}");
//    notifyListeners();
//  }

//  void onCameraMove(CameraPosition position) async {
//    // _lastPosition = LatLng(0.0, 0.0);
//    _lastPosition = position.target;
//    _initialPosition = _lastPosition;
//    showLog(
//        "_lastPositiononCameraMove--${_lastPosition.latitude}--${_lastPosition.longitude}");
//
//    isMapDragging = true;
//    mapDragStarted = true;
//
//    showLog(
//        "initialPosition--${_initialPosition.latitude}--${_initialPosition.longitude}");
//    notifyListeners();
//  }

//  initDbHelper() {
//    dbHelper = DBHelper.instance;
//  }

  void onCreated() {
    //_mapController = controller;

    mapsIsLoaded = false;
    notifyListeners();
  }

//  storeAddressDataInSharedPref(DeliveryAddressSharedPrefModel data) async {
//    await initPref();
//    prefs.setString(
//      SharedPreferenceKeys.deliveryDataSharedPrefKey,
//      json.encode(data),
//    );
//  }

  showNextScreen(bool value) {
    showNextBottomSheet = value;
    notifyListeners();
  }

  changeBottomSheetHeight({double value, double min, double max}) {
    bottomSheetHeight = value;
    maxChildSize = max;
    minChildSize = min;
    notifyListeners();
  }

//  final GoogleMapController controller = await _controller.future;
//  controller.animateCamera(
//  CameraUpdate.newCameraPosition(
//  CameraPosition(
//  target: LatLng(37.43296265331129, -122.08832357078792),
//  zoom: 19.151926040649414,
//  tilt: 59.440717697143555,
//  bearing: 192.8334901395799),
//  ),
//  );

  Future<void> getCurrentUserLocation() async {
    LocationPermission permission = await checkPermission();

    //LocationPermission permission = await checkPermission();

    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      showLog("LocationPermission.always--${permission}");
    } else if (permission == LocationPermission.denied) {
      showLog("LocationPermission.denied--${permission}");
      await requestPermission();
      // await getAddressFromLatLng();
    } else if (permission == LocationPermission.deniedForever) {
      showLog("LocationPermission.deniedForever--${permission}");
      await openAppSettingsIfPermissionDenied();
    } else {
      showLog("LocationPermission.Else--${permission}");
      await openAppSettingsIfPermissionDenied();
    }

    await getLatitudeLongitude();
//    if (permission == LocationPermission.denied) {
//      await requestPermission();
//    }

//    switch (permission) {
//      case LocationPermission.denied:
//        await openAppSettingsIfPermissionDenied();
//        break;
//      case LocationPermission.deniedForever:
//        await openAppSettingsIfPermissionDenied();
//        break;
//      case LocationPermission.always:
////        await Geolocator()
////            .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
////            .then((Position _position) {
////          if (_position != null) {
////            setState(() {
////              latLng = LatLng(
////                _position.latitude,
////                _position.longitude,
////              );
////            });
////            _getAddressFromLatLng();
////          }
////        });
//        await getLatitudeLongitude();
//        break;
//      case LocationPermission.whileInUse:
//        await getLatitudeLongitude();
//        break;
//      default:
//        break;
//    }

//    PermissionStatus permission = await PermissionHandler()
//        .checkPermissionStatus(PermissionGroup.location);
//    if (permission == PermissionStatus.denied) {
//      await PermissionHandler()
//          .requestPermissions([PermissionGroup.locationAlways]);
//    }
//    // geolocator = Geolocator()..forceAndroidLocationManager = true;
//    GeolocationStatus geolocationStatus =
//        await geolocator.checkGeolocationPermissionStatus();
//    switch (geolocationStatus) {
//      case GeolocationStatus.denied:
//        print('denied');
//        break;
//      case GeolocationStatus.disabled:
//      case GeolocationStatus.restricted:
//        print('restricted');
//        break;
//      case GeolocationStatus.unknown:
//        print('unknown');
//        break;
//      case GeolocationStatus.granted:
//        // await Geolocator()
//        await geolocator
//            .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
//            .then((Position _position) {
//          if (_position != null) {
//            latLng = LatLng(
//              _position.latitude,
//              _position.longitude,
//            );
//            getAddressFromLatLng();
//          }
//        });
//        break;
//    }

    _loadingInitialPosition();
  }

  getLatitudeLongitude() async {
    await getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) => {
              latLng = LatLng(
                position.latitude,
                position.longitude,
              ),
            });

    getAddressFromLatLng();
  }

  openAppSettingsIfPermissionDenied() async {
    await openAppSettings();
    await openLocationSettings();
  }

  getAddressFromLatLng() async {
    try {
//      showLog(
//          "getAddressFromLatLngForCurrentLocation-- ${latitude}-- ${longitude}");
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latLng.latitude, latLng.longitude);
//      List<Placemark> placemarks = await geolocator.placemarkFromCoordinates(
//          latLng.latitude,
//          latLng.longitude // latitude, // currentPosition.latitude,
//          //longitude, //currentPosition.longitude,
//          );

      Placemark place = placemarks[0];
      currentAddress = place.subLocality == ''
          ? place.name
          : place.subLocality.startsWith("Unnamed")
              ? place.subAdministrativeArea
              : place.subLocality;

      showLog("subLocality $cityLocality--${place.subLocality}--${place.name}");
      currentAddressShownInHome =
          place.subLocality == '' ? place.name + ',' : place.subLocality + ',';

      if (place.thoroughfare != null) {
        currentAddress = currentAddress + " " + place.thoroughfare + ', ';
      }
//        if (placemarks[0].subThoroughfare != null) {
//          _currentAddress =
//              _currentAddress + placemarks[0].subThoroughfare + ', ';
//        }

      if (place.locality != null) {
        cityLocality = place.locality;
        //  showLog("locality $city--${place.locality}");

        var locality =
            place.locality == "" ? place.subAdministrativeArea : place.locality;

        currentAddressShownInHome = currentAddressShownInHome + locality;

        showLog(
            "currentAddressShownInHome $cityLocality--${currentAddressShownInHome}");
        currentAddress = currentAddress + place.locality;
      }
//        if (placemarks[0].postalCode != null) {
//          _currentAddress = _currentAddress + placemarks[0].postalCode + ', ';
//        }

      if (place.administrativeArea != null) {
        stateName = place.administrativeArea;
        //  currentAddress = currentAddress + place.subAdministrativeArea;
        showLog(
            "subAdministrativeArea $stateName--${place.subAdministrativeArea}");
//          _currentAddress =
//              _currentAddress + placemarks[0].subAdministrativeArea + ', ';
      }

      if (place.country != null) {
        country = place.country;
        // currentAddress = currentAddress + place.country + '. ';
      }
    } catch (err) {
      print(err);
    }
    notifyListeners();
  }

  void didMapViewIdle() async {
    await getAddressFromLatLng();
    isMapDragging = false;
    notifyListeners();
  }

  onCameraMove(CameraPosition position) {
    latLng = LatLng(position.target.latitude, position.target.longitude);
    //initialPosition=_latLng;
    showLog(
        "onCameraMoveonCameraMove--${latLng.latitude}--${latLng.longitude}");
    isMapDragging = true;
    mapDragStarted = true;
    notifyListeners();
  }

  initMapProcess({bool getLocation, double latitude, double longitude}) async {
    // setCustomMapPin();

    //getCurrentLocation();
    // await getUserLocation();
    if (latitude != null && longitude != null) {
      latLng = LatLng(latitude, longitude);
      getAddressFromLatLng();
    } else {
      await getCurrentUserLocation();
    }
  }

  updateAddressTypeIndex(int index) {
    selectedAddressTypeIndex = index;
    if (selectedAddressTypeIndex == 0) {
      selectedIndex = 1;
    } else if (selectedAddressTypeIndex == 1) {
      selectedIndex = 2;
    } else {
      selectedIndex = 0;
    }
    notifyListeners();
  }

//  void setCustomMapPin() async {
//    pinLocationIcon = await BitmapDescriptor.fromAssetImage(
//        ImageConfiguration(devicePixelRatio: 2.5),
//        'assets/images/marker_pin.png');
//  }

  initPref() async {
    if (prefs == null) prefs = await SharedPreferences.getInstance();
  }

  textSubmitted() {
    completeAddressSubmitted = true;
    notifyListeners();
  }

  landMarkCompleted() {
    landmarkSubmitted = true;
    notifyListeners();
  }

  getCurrentLatLangFromPref() async {
    await initPref();
    accessToken = prefs.getString(SharedPreferenceKeys.accessToken) ?? "";
    userId = prefs.getInt(SharedPreferenceKeys.userId) ?? 0;
  }

  saveLatLongValues(
      {String lat, String lang, String currentAddressData}) async {
    await initPref();
    showLog("saveLatLongValues -- ${lat}--${lang} --${currentAddressData}");
    await prefs.remove(SharedPreferenceKeys.addressType);
    await prefs.setString(SharedPreferenceKeys.latitude, lat);
    await prefs.setString(SharedPreferenceKeys.longitude, lang);
    await prefs.setString(
        SharedPreferenceKeys.currentLocationMarked, currentAddressData);

//    await dbHelper.deleteTableRecordsAfterLogout(
//        DbStatics.tableTopAndRecentSearchedKeyWords);

    prefs.remove(SharedPreferenceKeys.city);
  }

//  void didMapViewIdle() async {
//    await getAddressFromLatLng();
//    isMapDragging = false;
//
//    notifyListeners();
//  }

//  getAddressFromLatLngForCurrentLocation(
//      double latitude, double longitude) async {
//    try {
//      showLog(
//          "getAddressFromLatLngForCurrentLocation-- ${latitude}-- ${longitude}");
//      List<Placemark> placemarks = await geolocator.placemarkFromCoordinates(
//        latitude,
//        longitude, // latitude, // currentPosition.latitude,
//        //longitude, //currentPosition.longitude,
//      );
//
//      currentAddress = placemarks[0].subLocality == ''
//          ? placemarks[0].name
//          : placemarks[0].subLocality;
//      currentAddressShownInHome = placemarks[0].subLocality == ''
//          ? placemarks[0].name + ','
//          : placemarks[0].subLocality + ',';
//
//      if (placemarks[0].thoroughfare != null) {
//        currentAddress =
//            currentAddress + " " + placemarks[0].thoroughfare + ', ';
//      }
////        if (placemarks[0].subThoroughfare != null) {
////          _currentAddress =
////              _currentAddress + placemarks[0].subThoroughfare + ', ';
////        }
//
//      if (placemarks[0].locality != null) {
//        cityLocality = placemarks[0].locality;
//        currentAddressShownInHome =
//            currentAddressShownInHome + placemarks[0].locality;
//        currentAddress = currentAddress + placemarks[0].locality + ', ';
//      }
////        if (placemarks[0].postalCode != null) {
////          _currentAddress = _currentAddress + placemarks[0].postalCode + ', ';
////        }
//
//      if (placemarks[0].administrativeArea != null) {
//        stateName = placemarks[0].administrativeArea;
////          _currentAddress =
////              _currentAddress + placemarks[0].subAdministrativeArea + ', ';
//      }
//      if (placemarks[0].country != null) {
//        country = placemarks[0].country;
//        currentAddress = currentAddress + placemarks[0].country + '. ';
//      }
//    } catch (err) {
//      print(err);
//    }
//    notifyListeners();
//  }

//  _getAddressFromLatLng() async {
//    try {
//      showLog(
//          "currentCameraPosition22-- ${_lastPosition.latitude}-- ${_lastPosition.longitude}");
//      List<Placemark> placemarks = await geoLocator.placemarkFromCoordinates(
//        _lastPosition.latitude,
//        _lastPosition.longitude, // latitude, // currentPosition.latitude,
//        //longitude, //currentPosition.longitude,
//      );
//
//      currentAddress = placemarks[0].subLocality == ''
//          ? placemarks[0].name
//          : placemarks[0].subLocality;
//      currentAddressShownInHome = placemarks[0].subLocality == ''
//          ? placemarks[0].name + ','
//          : placemarks[0].subLocality + ',';
//
//      if (placemarks[0].thoroughfare != null) {
//        currentAddress =
//            currentAddress + " " + placemarks[0].thoroughfare + ', ';
//      }
////        if (placemarks[0].subThoroughfare != null) {
////          _currentAddress =
////              _currentAddress + placemarks[0].subThoroughfare + ', ';
////        }
//
//      if (placemarks[0].locality != null) {
//        city = placemarks[0].locality;
//        currentAddressShownInHome =
//            currentAddressShownInHome + placemarks[0].locality;
//        currentAddress = currentAddress + placemarks[0].locality + ', ';
//      }
////        if (placemarks[0].postalCode != null) {
////          _currentAddress = _currentAddress + placemarks[0].postalCode + ', ';
////        }
//
//      if (placemarks[0].subAdministrativeArea != null) {
//        stateName = placemarks[0].subAdministrativeArea;
////          _currentAddress =
////              _currentAddress + placemarks[0].subAdministrativeArea + ', ';
//      }
//      if (placemarks[0].country != null) {
//        country = placemarks[0].country;
//        currentAddress = currentAddress + placemarks[0].country + '. ';
//      }
//    } catch (err) {
//      print(err);
//    }
//    notifyListeners();
//  }

  Future<String> editGivenAddressFromLatLng(
      {double latitude, double longitude}) async {
    var location;
    try {
      showLog("editGivenAddressFromLatLng1 -- ${latitude} --${longitude}");
      final GoogleMapController controller = await mapController.future;
//      await controller.animateCamera(
//        CameraUpdate.newCameraPosition(
//          CameraPosition(
//            target: LatLng(latitude, latitude),
//            zoom: 14.0,
//          ),
//        ),
//      );

      // _latLng = LatLng(latitude, longitude);

      // notifyListeners();

      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);

//      List<Placemark> p =
//          await geolocator.placemarkFromCoordinates(latitude, longitude);

      Placemark place = placemarks[0];

      location =
          place.subLocality == '' ? place.name : place.subLocality + ', ';

      if (place.thoroughfare != null) {
        location = location + place.thoroughfare + ', ';
      }

      location = place.locality != null ? location + " " + place.locality : "";

      showLog("editGivenAddressFromLatLng -- ${location}");
    } catch (e) {
      print(e);
    }
    return location;
  }

//  static final CameraPosition _kLake = CameraPosition(
//      bearing: 192.8334901395799,
//      target: LatLng(l, -122.08832357078792),
//      tilt: 59.440717697143555,
//      zoom: 19.151926040649414);

//  getCurrentUserLocation() async {
//    // _lastPosition = LatLng(0.0, 0.0);
//    Position position = await Geolocator()
//        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
////    List<Placemark> placemark = await Geolocator()
////        .placemarkFromCoordinates(position.latitude, position.longitude);
//    _initialPosition = LatLng(position.latitude, position.longitude);
//    print(
//        "the latitude is: ${position.latitude} and th longitude is: ${position.longitude} ");
//    print("initial position is : ${_initialPosition.toString()}");
//    _lastPosition = _initialPosition;
//    showLog(
//        "getCurrentUserLocationButtonPressed--${_lastPosition.latitude} ${_lastPosition.longitude}--${initialPosition.latitude}--${initialPosition.longitude}");
//    final GoogleMapController controller = await mapController.future;
//
////    CameraUpdate.newCameraPosition(
////      CameraPosition(
////        target: initialPosition,
////        zoom: 14.0,
////      ),
////    );
////    await controller.animateCamera(
////      CameraUpdate.newCameraPosition(
////        CameraPosition(
////          target: LatLng(currentPosition.latitude, currentPosition.longitude),
////          zoom: 14.0,
////        ),
////      ),
////    );
//
////    controller.animateCamera(CameraUpdate.newLatLngZoom(
////      LatLng(_lastPosition.latitude, _lastPosition.longitude),
////      14.0,
////    ));
//    await getAddressFromLatLngForCurrentLocation(
//        _lastPosition.latitude, _lastPosition.longitude);
//    isFetchingLocation = true;
//    notifyListeners();
//  }

//  Future getUserLocation() async {
//    print("GET USER METHOD RUNNING =========");
//    Position position = await Geolocator()
//        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//
//    _initialPosition = LatLng(position.latitude, position.longitude);
//    //currentPosition = position;
//    print(
//        "the latitude is: ${position.latitude} and th longitude is: ${position.longitude} ");
//    print("initial position is : ${_initialPosition.toString()}");
//    // locationController.text = placemark[0].name;
//    _lastPosition = _initialPosition;
//    isFetchingLocation = true;
//    notifyListeners();
//
////    allMarkers.add(
////      Marker(
////          markerId: MarkerId('MyMarker'),
////          position: LatLng(position.latitude, position.longitude),
////          draggable: isMapDragging,
////          icon: pinLocationIcon),
////    );
//
//    await getAddressFromLatLngForCurrentLocation(
//        position.latitude, position.longitude);
//  }

//  getCurrentLocation() async {
//    //geoLocator = Geolocator()..forceAndroidLocationManager=true;
//    await geoLocator
//        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
//        .then((Position position) async {
//      // final GoogleMapController controller = await mapController.future;
////      final GoogleMapController controller =  mapController.future;
////      mapController.animateCamera(
////        CameraUpdate.newCameraPosition(
////          CameraPosition(
////              target: LatLng(position.latitude, position.longitude),
////              zoom: 14
////          ),
////        ),);
//
////      controller.animateCamera(
////        CameraUpdate.newCameraPosition(
////          CameraPosition(
////            target: LatLng(position.latitude, position.longitude),
////            zoom: 18.0,
////          ),
////        ),
////      );
//
//      currentCameraPosition = CameraPosition(
//          target: LatLng(position.latitude, position.longitude), zoom: 14);
//      showLog(
//          "currentCameraPosition -- ${currentCameraPosition.target.latitude}-- ${currentCameraPosition.target.longitude}-- ");
//      isFetchingLocation = true;
////      completeAddressLat = currentCameraPosition.target.latitude.toString();
////      completeAddressLong = currentCameraPosition.target.longitude.toString();
//
////      allMarkers.add(
////        Marker(
////          markerId: MarkerId('MyMarker'),
////          position: LatLng(position.latitude, position.longitude),
////          draggable: isMapDragging,
////          icon: pinLocationIcon,
////        ),
////      );
//
//      await getAddressFromLatLng();
//    }).catchError((err) {
//      print(err);
//      showLog("currentCameraPosition4---- ${err}");
//    });
//    notifyListeners();
//  }

}
