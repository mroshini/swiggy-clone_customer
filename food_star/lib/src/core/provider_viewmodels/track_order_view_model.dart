import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodstar/src/constants/api_params_keys.dart';
import 'package:foodstar/src/constants/api_urls.dart';
import 'package:foodstar/src/constants/sharedpreference_keys.dart';
import 'package:foodstar/src/core/models/api_models/favorites_restaurant_api_model.dart';
import 'package:foodstar/src/core/models/api_models/track_order_api_model.dart';
import 'package:foodstar/src/core/provider_viewmodels/common/base_change_notifier_model.dart';
import 'package:foodstar/src/core/service/api_repository.dart';
import 'package:foodstar/src/core/service/database/database_helper.dart';
import 'package:foodstar/src/core/socket/listen_socket_event.dart';
import 'package:foodstar/src/ui/routes/orders/tracking/google_maps_requests.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TrackOrderViewModel extends BaseChangeNotifierModel {
  BuildContext context;
  String accessToken;
  List<ARestaurant> aRestaurant = [];
  final Set<Marker> _markers = {};
  final Set<Polyline> _polyLines = {};
  static LatLng _initialPosition;
  List<LatLng> routeCoords;
  LatLng _lastPosition = _initialPosition;
  static const double CAMERA_TILT = 80;
  static const double CAMERA_BEARING = 30;
  String orderID;
  bool cancelOrderLoader = false;
  var location = new Location();

//  GoogleMapPolyline googleMapPolyline =
//      GoogleMapPolyline(apiKey: kGoogleApiKey);

  GoogleMapsServices _googleMapsServices = GoogleMapsServices();
  FavoritesRestaurantApiModel favoritesRestaurantApiModelData;
  Box favouritesBox;
  AOrder orderData;
  List<OrderItems> orderItems;
  RestaurantDetail restaurantDetail;
  BoyDetail boyDetail;
  LatLng userLocation;
  LatLng resturantLocation;
  LatLng deliverBoyLocation;
  String currencySymbol;

  Set<Marker> get markers => _markers;

  Set<Polyline> get polyLines => _polyLines;

  BitmapDescriptor deliverBoyLocationIcon;
  BitmapDescriptor restaurantLocationIcon;
  BitmapDescriptor userLocationIcon;
  double latitude;
  double longitude;
  CameraPosition currentCameraPosition;

  //Map markers = {};
  // Marker marker;
  Circle circle;
  Uint8List imageData;

  static MarkerId markerId = MarkerId("1");

  //Set<Marker> markers = Set<Marker>();

  StreamSubscription subscription;

  // List<Marker> allMarkers = [];

  SharedPreferences prefs;
  DBHelper dbHelper;

  Completer<GoogleMapController> mapController = Completer();

  TrackOrderViewModel({this.context}) {
    // getLoginInfo();
    setSourceAndDestinationIcons();
    // initMarker();
    getLoginInfo();
    listenSocketForOrderUpdate();
    // updateLocation();
//    setCustomMapPin();
  }

//  getRoutePoints() async {
//    routeCoords = await googleMapPolyline.getCoordinatesWithLocation(
//        origin: resturantLocation,
//        destination: userLocation,
//        mode: RouteMode.driving);
//  }

//  CameraPosition currentCameraPosition = CameraPosition(
//    target: LatLng(9.9260717, 78.12152079999998),
//
//    //target: _initialPosition,
//    zoom: 16.0,
//  );

  Future<Uint8List> getMarker() async {
    ByteData byteData =
        await DefaultAssetBundle.of(context).load('assets/images/bike.jpg');
    return byteData.buffer.asUint8List();
  }

  void setSourceAndDestinationIcons() async {
//    final Uint8List markerIcon =
//        await getBytesFromAsset('assets/images/flutter.png', 100);
//    final Marker marker = Marker(icon: BitmapDescriptor.fromBytes(markerIcon));
    await BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: 2.0),
            'assets/images/restaurant_marker.png')
        .then((onValue) {
      restaurantLocationIcon = onValue;
    });

    await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.0),
      'assets/images/user_marker.png',
    ).then((onValue) {
      userLocationIcon = onValue;
    });

    await BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: 2.0),
            'assets/images/delivery_boy.png')
        .then((onValue) {
      deliverBoyLocationIcon = onValue;
    });

//    BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 2.0),
//        'assets/destination_map_marker.png')
//        .then((onValue) {
//      deliverBoyLocationIcon = onValue;
//    });
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
  }

  initMarker() async {
    // imageData = await getMarker();
    deliverBoyLocation = LatLng(10.36896, 77.98036);

    markers.add(
      Marker(
          markerId: MarkerId('sourcePin'),
          position: deliverBoyLocation,
          flat: true,
          draggable: false,
          onTap: () {
//          setState(() {
//            currentlySelectedPin = sourcePinInfo;
//            pinPillPosition = 0;
//          });
          },
          icon: deliverBoyLocationIcon),
    );

//    markers = {
//      Marker(
//        markerId: markerId,
//        position: deliverBoyLocation,
//        draggable: false,
//        flat: true,
//        icon: BitmapDescriptor.fromBytes(imageData),
//        anchor: Offset(0.5, 0.5),
//        infoWindow: InfoWindow(
//          title: 'Custom Marker',
//          snippet: 'Inducesmile.com',
//        ),
//      ),
//    };

    notifyListeners();
  }

  setRestaurantLocation() {
    currentCameraPosition = CameraPosition(
      target: resturantLocation,
      bearing: CAMERA_BEARING,
      //target: _initialPosition,
      zoom: 16.0,
    );
    _markers.add(Marker(
        markerId: MarkerId('sourcePin'),
        position: resturantLocation,
        icon: restaurantLocationIcon));
    notifyListeners();
  }

  void setMapPins() async {
//    _markers.add(Marker(
//        markerId: MarkerId('sourcePin'),
//        position: resturantLocation,
//        icon: restaurantLocationIcon));
    // destination pin
    _markers.add(Marker(
        markerId: MarkerId('destPin'),
        position: userLocation,
        icon: userLocationIcon));
  }

  updateLocation({String orderID}) async {
    imageData = await getMarker();

    final GoogleMapController controller = await mapController.future;

    //setCustomMapPin();

    FirebaseFirestore.instance
        .collection('boy_info')
        .where(orderIDKey, isEqualTo: orderID)
        .snapshots()
        .listen((event) {
      event.docs.forEach((element) {
        latitude = double.parse(element.data()[latLangKey][latitudeKey]);
        longitude = double.parse(element.data()[latLangKey][longitudeKey]);

//        latitude = double.parse(element.data[latLangKey][latitudeKey]);
//        longitude = double.parse(element.data[latLangKey][longitudeKey]);
        showLog("latitudelongitude--${latitude} ${longitude}}");
        deliverBoyLocation = LatLng(latitude, longitude);
        notifyListeners();
        controller.animateCamera(
          CameraUpdate.newCameraPosition(CameraPosition(
            target: deliverBoyLocation,
            zoom: 16,
          )
//                    tilt: 59.440717697143555,
//                    bearing: 192.8334901395799),
              ),
        );
        markers.removeWhere((m) => m.markerId.value == 'deliveryPin');
        markers.add(
          Marker(
            markerId: MarkerId('deliveryPin'),
            position: deliverBoyLocation,
            flat: true,
            draggable: false,
            onTap: () {
//          setState(() {
//            currentlySelectedPin = sourcePinInfo;
//            pinPillPosition = 0;
//          });
            },
            icon: deliverBoyLocationIcon,
          ),
        );
        notifyListeners();
      });
    });

//    Firestore.instance
//        .collection('boy_info')
//        .snapshots()
//        .listen((event) {
//      event.documents.forEach((element) {
//        showLog("Delivery_boy_location--${element.data}");
//        Firestore.instance
//            .collection("Delivery_boy_location")
//            .document(element.documentID)
//            .collection("lat_long_info")
//            .getDocuments()
//            .then((querySnapshot) {
//          querySnapshot.documents.forEach((result) {
//            showLog(
//                "Delivery_boy_location11--${result.data['lat']} ${result.data['long']}-}");
//            latitude = double.parse(result.data['lat']);
//            longitude = double.parse(result.data['long']);
//            deliverBoyLocation = LatLng(latitude, longitude);
//            notifyListeners();
//            controller.animateCamera(
//              CameraUpdate.newCameraPosition(CameraPosition(
//                target: LatLng(latitude, longitude),
//                zoom: 16,
//              )
////                    tilt: 59.440717697143555,
////                    bearing: 192.8334901395799),
//              ),
//            );
//            markers.removeWhere((m) => m.markerId.value == 'deliveryPin');
//            markers.add(
//              Marker(
//                markerId: MarkerId('deliveryPin'),
//                position: deliverBoyLocation,
//                flat: true,
//                draggable: false,
//                onTap: () {
////          setState(() {
////            currentlySelectedPin = sourcePinInfo;
////            pinPillPosition = 0;
////          });
//                },
//                icon: deliverBoyLocationIcon,
//              ),
//            );
//
////            markers = {
////              Marker(
////                markerId: markerId,
////                position: deliverBoyLocation,
////                draggable: false,
////                flat: true,
////                icon: BitmapDescriptor.fromBytes(imageData),
////                anchor: Offset(0.5, 0.5),
////                infoWindow: InfoWindow(
////                  title: 'Custom Marker',
////                  snippet: 'Inducesmile.com',
////                ),
////              ),
////            };
//
////                    marker = Marker(
////                      markerId: MarkerId('delivery'),
////                      position: deliverBoyLocation,
//////              rotation
//////              :deliverBoyLocation.,
////                      draggable: false,
////                      zIndex: 2,
////                      flat: true,
////                      icon: BitmapDescriptor.fromBytes(imageData),
////
////                      anchor: Offset(0.5, 0.5),
////                    );
////                    circle = Circle(
////                        circleId: CircleId('bike'),
////                        zIndex: 1,
////                        strokeColor: Colors.blue,
////                        center: LatLng(latitude, longitude),
////                        fillColor: Colors.blue.withAlpha(70));
//
////                    currentCameraPosition = CameraPosition(
////                      target: LatLng(latitude, longitude),
////                      zoom: 16.0,
////                    );
//          });
//        });
//      });
//    });
//
//    Firestore.instance
//        .collection('Delivery_boy_location')
//        .getDocuments()
//        .then((value) => {
//              value.documents.forEach((element) {
//                showLog("Delivery_boy_location--${element.data}");
//                Firestore.instance
//                    .collection("Delivery_boy_location")
//                    .document(element.documentID)
//                    .collection("lat_long_info")
//                    .getDocuments()
//                    .then((querySnapshot) {
//                  querySnapshot.documents.forEach((result) {
//                    showLog(
//                        "Delivery_boy_location11--${result.data['lat']} ${result.data['long']}-}");
//                    latitude = double.parse(result.data['lat']);
//                    longitude = double.parse(result.data['long']);
//                    deliverBoyLocation = LatLng(latitude, longitude);
//
//                    controller.animateCamera(
//                      CameraUpdate.newCameraPosition(CameraPosition(
//                        target: LatLng(latitude, longitude),
//                        zoom: 16,
//                      )
////                    tilt: 59.440717697143555,
////                    bearing: 192.8334901395799),
//                          ),
//                    );
//
//                    markers = {
//                      Marker(
//                        markerId: markerId,
//                        position: deliverBoyLocation,
//                        draggable: false,
//                        flat: true,
//                        icon: BitmapDescriptor.fromBytes(imageData),
//                        anchor: Offset(0.5, 0.5),
//                        infoWindow: InfoWindow(
//                          title: 'Custom Marker',
//                          snippet: 'Inducesmile.com',
//                        ),
//                      ),
//                    };
//
////                    marker = Marker(
////                      markerId: MarkerId('delivery'),
////                      position: deliverBoyLocation,
//////              rotation
//////              :deliverBoyLocation.,
////                      draggable: false,
////                      zIndex: 2,
////                      flat: true,
////                      icon: BitmapDescriptor.fromBytes(imageData),
////
////                      anchor: Offset(0.5, 0.5),
////                    );
////                    circle = Circle(
////                        circleId: CircleId('bike'),
////                        zIndex: 1,
////                        strokeColor: Colors.blue,
////                        center: LatLng(latitude, longitude),
////                        fillColor: Colors.blue.withAlpha(70));
//
////                    currentCameraPosition = CameraPosition(
////                      target: LatLng(latitude, longitude),
////                      zoom: 16.0,
////                    );
//                  });
//                });
//              }),
//            });

    notifyListeners();
  }

  listenSocketForOrderUpdate({String orderId}) async {
    //   final GoogleMapController controller = await mapController.future;

//    location.onLocationChanged().listen((LocationData cLoc) {
//      // cLoc contains the lat and long of the
//      // current user's position in real time,
//      deliverBoyLocation = LatLng(cLoc.latitude, cLoc.longitude);
//      controller.animateCamera(
//        CameraUpdate.newCameraPosition(CameraPosition(
//          target: deliverBoyLocation,
//          zoom: 16,
//        )
////                    tilt: 59.440717697143555,
////                    bearing: 192.8334901395799),
//            ),
//      );
//      markers.removeWhere((m) => m.markerId.value == 'deliveryPin');
//      markers.add(
//        Marker(
//          markerId: MarkerId('deliveryPin'),
//          position: deliverBoyLocation,
//          flat: true,
//          draggable: false,
//          infoWindow: InfoWindow(
//            title: 'Delivery',
//            snippet: 'Here is an Info Window Text on a Google Map',
//          ),
//          onTap: () {
////          setState(() {
////            currentlySelectedPin = sourcePinInfo;
////            pinPillPosition = 0;
////          });
//          },
//          icon: deliverBoyLocationIcon,
//        ),
//      );
//
//      Fluttertoast.showToast(
//          msg: "${deliverBoyLocation}",
//          toastLength: Toast.LENGTH_LONG,
//          gravity: ToastGravity.CENTER,
//          timeInSecForIosWeb: 1,
//          backgroundColor: Colors.grey[300],
//          textColor: Colors.black,
//          fontSize: 16.0);
//      notifyListeners();
//    });
    subscription = ListenSocketEvents(context: context)
        .connectionStatusController
        .stream
        .listen((event) => {
              showLog("socketOrderDelivered1--${event.status}"),
              if (event.status == SocketEventStatus.handOveredToBoy)
                {
                  sendRequest(),
                  updateLocation(orderID: orderID),
                }
            });
    notifyListeners();
  }

  refreshPageAfterSocketEmit({String orderId}) async {
    listenSocketForOrderUpdate();
  }

  updateCancelOrderLoader(bool value) {
    cancelOrderLoader = value;
    notifyListeners();
  }

  Future<String> cancelOrder(
      {BuildContext context, Map<String, dynamic> ordersData}) async {
    try {
      String message;
      updateCancelOrderLoader(true);
      await ApiRepository(mContext: context)
          .cancelOrder(
            dynamicMapValue: ordersData,
            mContext: context,
          )
          .then((value) => {
                if (value != null)
                  {
                    message = value.message,
                    updateCancelOrderLoader(false),
                  }
              });
      return message;
    } catch (e) {
      updateCancelOrderLoader(false);
      return null;
    }
  }

  getLoginInfo() async {
    await initPref();
    //  accessToken = prefs.getString(SharedPreferenceKeys.accessToken) ?? "";
    currencySymbol = prefs.getString(SharedPreferenceKeys.currencySymbol) ?? "";
  }

  initPref() async {
    if (prefs == null) prefs = await SharedPreferences.getInstance();
  }

//  void setCustomMapPin() async {
//    deliverBoyLocationIcon = await BitmapDescriptor.fromAssetImage(
//        ImageConfiguration(devicePixelRatio: 2.5), 'assets/images/bike.jpg');
//  }

  callOrderDetailsApiRequest(String orderID, BuildContext context) async {
    setState(BaseViewState.Busy);
    //
    //  await initMarker();
    try {
      await ApiRepository(mContext: context)
          .trackOrderDetailsApiRequest(staticMapValue: {
        userTypeKey: user,
        orderIDKey: orderID,
      }, context: context).then((value) async => {
                if (value != null)
                  {
                    showLog(
                        "callOrderDetailsApiRequest--${value.aOrder.orderDetails}"),
                    orderData = value.aOrder,
                    boyDetail = value.aOrder.boyDetail,
                    orderItems = value.aOrder.orderItems,
                    restaurantDetail = value.aOrder.restaurantDetail,
                    resturantLocation = LatLng(
                        restaurantDetail.latitude, restaurantDetail.longitude),
                    showLog("resturantLocation--${resturantLocation}"),
//                    deliverBoyLocation = boyDetail != null
//                        ? LatLng(boyDetail.latitude.toDouble(),
//                            boyDetail.longitude.toDouble())
//                        : LatLng(0.0, 0.0),
                    userLocation = LatLng(orderData.lat, orderData.lang),
                    showLog("userLocation--${userLocation}"),

//                    controller.animateCamera(
//                      CameraUpdate.newCameraPosition(CameraPosition(
//                        target: resturantLocation,
//                        zoom: 16,
//                      )
////                    tilt: 59.440717697143555,
////                    bearing: 192.8334901395799),
//                          ),
//                    ),
                    orderID = value.aOrder.id.toString(),

                    setRestaurantLocation(),

                    //  _initialPosition = resturantLocation,
                    // updateLocation(orderID: value.aOrder.id.toString()),

                    if (value.aOrder.status == "1")
                      {
                        sendRequest(
                          restLocation: resturantLocation,
                          userLocat: userLocation,
                        ),
                      },

                    //setMarkersOnMap(),
                    // await getRoutePoints(),
                    setState(BaseViewState.Idle),
                  }
              });

      final GoogleMapController controller = await mapController.future;
      controller.animateCamera(
        CameraUpdate.newCameraPosition(CameraPosition(
          target: resturantLocation,
          zoom: 16,
        )
//                    tilt: 59.440717697143555,
//                    bearing: 192.8334901395799),
            ),
      );

      listenSocketForOrderUpdate();
    } catch (e) {
      setState(BaseViewState.Idle);
      showLog("DataoffavoritesRestaurantApiModel2 --${e}");
    }

    // updateLocation(orderID: orderID);

    notifyListeners();
  }

  void createRoute(String encodedPoly) {
    showLog("encodedPoly --${encodedPoly}");
    _polyLines.add(
      Polyline(
        polylineId: PolylineId('route'),
        width: 5,
        visible: true,
        points: _convertToLatLng(_decodePoly(encodedPoly)),
        color: Colors.black,
      ),
    );
    notifyListeners();
  }

//  void createRoute() {
//    _polyLines.add(Polyline(
//      polylineId: PolylineId('routes'),
//      width: 10,
//      points: routeCoords,
//      color: Colors.black,
//      startCap: Cap.roundCap,
//      endCap: Cap.buttCap,
//    ));
//    notifyListeners();
//  }

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

  void sendRequest({LatLng restLocation, LatLng userLocat}) async {
    showLog('sendrequest $restLocation');
//    List<Location> locations = await locationFromAddress(intendedLocation);
//    double latitude = locations[0].latitude;
//    double longitude = locations[0].longitude;
//    LatLng destination = LatLng(latitude, longitude);
    // _addMarker(restLocation, "add");
    String route = await _googleMapsServices.getRouteCoordinates(
        resturantLocation, userLocation);
    createRoute(route);
    setMapPins();
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

  void onCameraMove(CameraPosition position) {
    _lastPosition = position.target;
    notifyListeners();
  }

//  setMarkersOnMap() async {
//    MarkerId markerId1 = MarkerId("1");
//
//    Marker marker1 = Marker(
//      markerId: markerId1,
//      position: resturantLocation,
//      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
//    );
//
//    MarkerId markerId2 = MarkerId("2");
//
//    Marker marker2 = Marker(
//      markerId: markerId2,
//      position: deliverBoyLocation,
//      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
//    );
//
//    MarkerId markerId3 = MarkerId("3");
//
//    Marker marker3 = Marker(
//      markerId: markerId3,
//      position: userLocation,
//      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
//    );
//
//    markers[markerId1] = marker1;
//    markers[markerId2] = marker2;
//
//    markers[markerId3] = marker3;
//
//    notifyListeners();
//  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }
}
