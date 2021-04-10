import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:foodstar/src/ui/routes/orders/tracking/google_maps_requests.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapViewModel with ChangeNotifier {
  static LatLng _initialPosition;
  LatLng _lastPosition = _initialPosition;
  bool locationServiceActive = true;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polyLines = {};
  GoogleMapController _mapController;
  GoogleMapsServices _googleMapsServices = GoogleMapsServices();
  TextEditingController startPointController = TextEditingController();
  TextEditingController endPointController = TextEditingController();
  FocusNode startPointFocusNode = FocusNode();
  FocusNode endPointFocusNode = FocusNode();

  LatLng get initialPosition => _initialPosition;

  LatLng get lastPosition => _lastPosition;

  GoogleMapsServices get googleMapsServices => _googleMapsServices;

  GoogleMapController get mapController => _mapController;

  Set<Marker> get markers => _markers;

  Set<Polyline> get polyLines => _polyLines;

  MapViewModel() {
    _getUserLocation();
    _loadingInitialPosition();
  }

  void _getUserLocation() async {
    print("GET USER METHOD RUNNING =========");
    Position position =
        await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemark =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    _initialPosition = LatLng(position.latitude, position.longitude);
    print(
        "the latitude is: ${position.longitude} and th longitude is: ${position.longitude} ");
    print("initial position is : ${_initialPosition.toString()}");
    startPointController.text = placemark[0].name;
    notifyListeners();
  }

//  void _getUserLocation() async {
//    Position position =
//        await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//    List<Placemark> placeMark =
//        await placemarkFromCoordinates(position.latitude, position.longitude);
//    _initialPosition = LatLng(position.latitude, position.longitude);
//    startPointController.text = placeMark[0].name;
//    notifyListeners();
//  }

  void createRoute(String encodedPoly) {
    _polyLines.add(Polyline(
        polylineId: PolylineId(_lastPosition.toString()),
        width: 10,
        points: _convertToLatLng(_decodePoly(encodedPoly)),
        color: Colors.black));
    notifyListeners();
  }

  void _addMarker(LatLng location, String address) {
    _markers.add(Marker(
        markerId: MarkerId(_lastPosition.toString()),
        position: location,
        infoWindow: InfoWindow(title: address, snippet: "go here"),
        icon: BitmapDescriptor.defaultMarker));
    notifyListeners();
  }

  List<LatLng> _convertToLatLng(List points) {
    List<LatLng> result = <LatLng>[];
    for (int i = 0; i < points.length; i++) {
      if (i % 2 != 0) {
        result.add(LatLng(points[i - 1], points[i]));
      }
    }
    return result;
  }

  List _decodePoly(String poly) {
    var list = poly.codeUnits;
    var lList = new List();
    int index = 0;
    int len = poly.length;
    int c = 0;
// repeating until all attributes are decoded
    do {
      var shift = 0;
      int result = 0;

      // for decoding value of one attribute
      do {
        c = list[index] - 63;
        result |= (c & 0x1F) << (shift * 5);
        index++;
        shift++;
      } while (c >= 32);
      /* if value is negetive then bitwise not the value */
      if (result & 1 == 1) {
        result = ~result;
      }
      var result1 = (result >> 1) * 0.00001;
      lList.add(result1);
    } while (index < len);

/*adding to previous value as done in encoding */
    for (var i = 2; i < lList.length; i++) lList[i] += lList[i - 2];

    print(lList.toString());

    return lList;
  }

  void sendRequest(String intendedLocation) async {
    List<Location> placemark = await locationFromAddress(intendedLocation);
    double latitude = placemark[0].latitude;
    double longitude = placemark[0].longitude;
    LatLng destination = LatLng(latitude, longitude);
    _addMarker(destination, intendedLocation);
    String route = await _googleMapsServices.getRouteCoordinates(
        _initialPosition, destination);
    createRoute(route);
    notifyListeners();
  }

  // ! SEND REQUEST
//  void sendRequest(String intendedLocation) async {
//    showLog('send request: $intendedLocation');
//    List<Location> locations = await locationFromAddress(intendedLocation);
//    double latitude = locations[0].latitude;
//    double longitude = locations[0].longitude;
//    LatLng destination = LatLng(latitude, longitude);
//    _addMarker(destination, intendedLocation);
//    String route = await _googleMapsServices.getRouteCoordinates(
//        _initialPosition, destination);
//    createRoute(route);
//    notifyListeners();
//  }

  // ! ON CAMERA MOVE
  void onCameraMove(CameraPosition position) {
    _lastPosition = position.target;
    notifyListeners();
  }

  // ! ON CREATE
  void onCreated(GoogleMapController controller) {
    _mapController = controller;
    notifyListeners();
  }

//  LOADING INITIAL POSITION
  void _loadingInitialPosition() async {
    await Future.delayed(Duration(seconds: 5)).then((v) {
      if (_initialPosition == null) {
        locationServiceActive = false;
        notifyListeners();
      }
    });
  }
}
