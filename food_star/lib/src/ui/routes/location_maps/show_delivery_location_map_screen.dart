import 'dart:async';

import 'package:flutter/material.dart';
import 'package:foodstar/generated/l10n.dart';
import 'package:foodstar/src/constants/route_path.dart';
import 'package:foodstar/src/ui/shared/buttons/form_submit_button.dart';
import 'package:foodstar/src/ui/shared/sizedbox.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shimmer/shimmer.dart';

class DeliveryLocationMapView extends StatefulWidget {
  @override
  _DeliveryLocationMapViewState createState() =>
      _DeliveryLocationMapViewState();
}

class _DeliveryLocationMapViewState extends State<DeliveryLocationMapView> {
  Completer<GoogleMapController> _controller = Completer();
  //Geolocator geoLocator;
  String _currentAddress = ' ';
  bool isMapDragging = false;

  CameraPosition _currentCameraPosition = CameraPosition(
    target: LatLng(8.764166, 78.134834),
    zoom: 14,
  );

  @override
  void initState() {
    super.initState();
    // geoLocator = Geolocator()..forceAndroidLocationManager;
    // _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return buildColumn(context);
  }

  Scaffold buildColumn(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 0.5,
            color: Colors.black,
          ),
          Container(
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
              child: Column(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.centerLeft,
                        height: 60.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  S.of(context).selectDeliveryLocation,
                                  style: Theme.of(context).textTheme.title,
                                ),
                              ),
                            ),
                            Container(
                              height: 0.5,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  isMapDragging
                      ? Container(
                          alignment: Alignment.centerLeft,
                          margin: const EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 15.0,
                          ),
                          height: 63.5,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Shimmer.fromColors(
                                baseColor: Colors.grey[100],
                                highlightColor: Colors.grey[200],
                                child: Container(
                                  width: MediaQuery.of(context).size.width / 2,
                                  height: 10.0,
                                  color: Colors.white,
                                ),
                              ),
                              verticalSizedBox(),
                              Shimmer.fromColors(
                                baseColor: Colors.grey[100],
                                highlightColor: Colors.grey[200],
                                child: Container(
                                  width: MediaQuery.of(context).size.width / 5,
                                  height: 10.0,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  S.of(context).yourLocation,
                                  style: TextStyle(
                                    fontSize: 12.0,
                                  ),
                                ),
                                Row(
                                  children: <Widget>[
                                    Icon(Icons.location_on),
                                    horizontalSizedBox(),
                                    Expanded(
                                      child: Text(
                                        _currentAddress,
                                        maxLines: 1,
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 14.0),
                                      ),
                                    ),
                                    horizontalSizedBox(),
                                    FlatButton(
                                      child: Text(
                                        S.of(context).change,
                                        style: TextStyle(
                                          color: Colors.red,
                                        ),
                                      ),
                                      onPressed: () {
                                        print('change button tapped');
                                        Navigator.pushNamed(
                                            context, searchLocation);
                                      },
                                    ),
                                  ],
                                ),
                                Container(
                                  height: 0.5,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ),
                        ),
                  Container(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: FormSubmitButton(
                        title: S.of(context).confirmLocation,
                        onPressed: () {
                          _confirmLocationTapped();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
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

//  void _getCurrentLocation() {
//    geoLocator
//        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
//        .then((Position position) {
//      _currentCameraPosition = CameraPosition(
//          target: LatLng(position.latitude, position.longitude), zoom: 14);
//      _getAddressFromLatLng();
//    }).catchError((err) {
//      print(err);
//    });
//  }
}
