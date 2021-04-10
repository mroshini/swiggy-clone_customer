import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodstar/src/constants/api_params_keys.dart';
import 'package:foodstar/src/constants/api_urls.dart';
import 'package:foodstar/src/core/models/api_models/delivery_address_model.dart';
import 'package:foodstar/src/core/provider_viewmodels/cart_bill_detail_view_model.dart';
import 'package:foodstar/src/core/provider_viewmodels/common/base_widget.dart';
import 'package:foodstar/src/core/provider_viewmodels/home_restaurant_list_view_model.dart';
import 'package:foodstar/src/core/provider_viewmodels/map_address_location_view_model.dart';
import 'package:foodstar/src/core/provider_viewmodels/saved_address_view_model.dart';
import 'package:foodstar/src/ui/res/colors.dart';
import 'package:foodstar/src/ui/shared/buttons/form_submit_button.dart';
import 'package:foodstar/src/ui/shared/others.dart';
import 'package:foodstar/src/ui/shared/progress_indicator.dart';
import 'package:foodstar/src/ui/shared/show_snack_bar.dart';
import 'package:foodstar/src/ui/shared/sizedbox.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class AddAddressScreen extends StatefulWidget {
  final Map<String, String> fromWhichScreen;

  AddAddressScreen({this.fromWhichScreen});

  @override
  _AddAddressScreenState createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  //TextEditingController completeAddressController;
  TextEditingController floorAddressController;
  TextEditingController landMarkAddressController;
  List<String> tag = ['Home', 'Work', 'Other'];

  // FocusNode completeAddressFocus;
  FocusNode floorAddressFocus;
  FocusNode landMarkAddressFocus;
  final _formKey = GlobalKey<FormState>();
  SavedAddressViewModel addressModel;

  // MapAddressLocationViewModel mapAddressLocationViewModel;
  int index;
  String latitude;
  String longitude;

  @override
  void initState() {
    super.initState();
    // completeAddressController = TextEditingController();
    floorAddressController = TextEditingController();
    landMarkAddressController = TextEditingController();
    // completeAddressFocus = FocusNode();
    floorAddressFocus = FocusNode();
    landMarkAddressFocus = FocusNode();
    addressModel = Provider.of<SavedAddressViewModel>(context, listen: false);
    if (widget.fromWhichScreen[fromWhichScreen] == "4") {
//      completeAddressController =
//          TextEditingController(text: widget.fromWhichScreen[addressKey]);
      floorAddressController =
          TextEditingController(text: widget.fromWhichScreen[buildingKey]);
      landMarkAddressController =
          TextEditingController(text: widget.fromWhichScreen[landmarkKey]);
      longitude = widget.fromWhichScreen[longKey];
      latitude = widget.fromWhichScreen[latKey];
    } else {
      longitude = widget.fromWhichScreen[longKey];
      latitude = widget.fromWhichScreen[latKey];
//      mapAddressLocationViewModel.latLng =
//          LatLng(double.parse(latitude), double.parse(longitude));
    }

    showLog(
        "widget.fromWhichScreen--${widget.fromWhichScreen[fromWhichScreen]}");
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget<MapAddressLocationViewModel>(
        onModelReady: (model) =>
            model.initMapProcess(
              getLocation: true,
              latitude: latitude == null ? null : double.parse(latitude),
              longitude: longitude == null ? null : double.parse(longitude),
            ),
        model: MapAddressLocationViewModel(context: context),
        builder: (BuildContext context, MapAddressLocationViewModel model,
            Widget child) {
          return Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    flex: 3,
                    child: Stack(
                      children: <Widget>[
                        model.initialPosition != null
                            ? Container(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          height:
                          MediaQuery
                              .of(context)
                              .size
                              .height / 1.58,
                          child: Stack(
                            children: [
                              GoogleMap(
                                mapType: MapType.normal,
                                initialCameraPosition: CameraPosition(
                                  target: model.initialPosition,
                                  zoom: 16.0,
                                ),
                                myLocationEnabled: true,
                                myLocationButtonEnabled: true,
                                onCameraMove: model.onCameraMove,
                                onCameraIdle: model.didMapViewIdle,
                                onMapCreated: (controller) {
                                  model.mapController
                                      .complete(controller);
                                  model.onCreated();
                                },
                              ),

//                                    (longitude != null && longitude != null) &&
//                                            model.mapDragStarted
//                                        ? GoogleMap(
//                                            mapType: MapType.normal,
//                                            initialCameraPosition:
//                                                CameraPosition(
//                                                    target:
//                                                        model.initialPosition,
//                                                    zoom: 16.0),
//                                            myLocationEnabled: true,
//                                            myLocationButtonEnabled: true,
//                                            onCameraMove: model.onCameraMove,
//                                            onCameraIdle: model.didMapViewIdle,
//                                            onMapCreated: (controller) {
//                                              model.mapController
//                                                  .complete(controller);
//                                              model.onCreated();
//                                            },
//                                          )
//                                        :
//                                        (longitude != null && longitude != null)
//                                            ? GoogleMap(
//                                                mapType: MapType.normal,
//                                                initialCameraPosition:
//                                                    CameraPosition(
//                                                  target: LatLng(
//                                                    double.parse(latitude),
//                                                    double.parse(longitude),
//                                                  ),
//                                                  zoom: 16.0,
//                                                ),
//                                                myLocationEnabled: true,
//                                                myLocationButtonEnabled: true,
//                                                onCameraMove:
//                                                    model.onCameraMove,
//                                                onCameraIdle:
//                                                    model.didMapViewIdle,
//                                                onMapCreated: (controller) {
//                                                  model.mapController
//                                                      .complete(controller);
//                                                  model.onCreated();
//                                                },
//                                              )
//                                            : GoogleMap(
//                                                mapType: MapType.normal,
//                                                initialCameraPosition:
//                                                    CameraPosition(
//                                                  target: model.initialPosition,
//                                                  zoom: 16.0,
//                                                ),
//                                                myLocationEnabled: true,
//                                                myLocationButtonEnabled: true,
//                                                onCameraMove:
//                                                    model.onCameraMove,
//                                                onCameraIdle:
//                                                    model.didMapViewIdle,
//                                                onMapCreated: (controller) {
//                                                  model.mapController
//                                                      .complete(controller);
//                                                  model.onCreated();
//                                                },
//                                              ),

//                                    Visibility(
//                                      visible: model.mapsIsLoaded,
//                                      child: Container(
//                                        child: Center(
//                                          child: Column(
//                                            crossAxisAlignment:
//                                                CrossAxisAlignment.center,
//                                            mainAxisAlignment:
//                                                MainAxisAlignment.center,
//                                            children: [
//                                              showProgress(context),
//                                              verticalSizedBoxTwenty(),
//                                              Text(
//                                                'Locating',
//                                                style: Theme.of(context)
//                                                    .textTheme
//                                                    .subhead,
//                                              ),
//                                            ],
//                                          ),
//                                        ),
//                                      ),
//                                    ),
                              Visibility(
                                visible: model.initialPosition != null &&
                                    !model.mapsIsLoaded,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Image.asset(
                                    'assets/images/marker_pin.png',
                                    width: 35.0,
                                    height: 35.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                            : Container(
                          child: Center(
//                                  child: Column(
//                                    crossAxisAlignment:
//                                        CrossAxisAlignment.center,
//                                    mainAxisAlignment: MainAxisAlignment.center,
//                                    children: [
//                                      showProgress(context),
//                                      verticalSizedBoxTwenty(),
//                                      Text(
//                                        'Locating',
//                                        style:
//                                            Theme.of(context).textTheme.subhead,
//                                      ),
//                                    ],
//                                  ),
                            child: Image.asset(
                              'assets/images/map_loader.gif',
                            ),
                          ),
                        ),
//                  Positioned(
//                    top: 20.0,
//                    right: 20.0,
//                    child: Container(
//                      height: 40,
//                      width: 40,
//                      color: Colors.white.withOpacity(0.8),
//                      child: IconButton(
//                        icon: Icon(
//                          Icons.my_location,
//                          size: 20.0,
//                        ),
//                        onPressed: () {
//                          Navigator.popAndPushNamed(
//                              context, changeUserAddressScreen,
//                              arguments: {
//                                fromWhichScreen:
//                                    widget.fromWhichScreen[fromWhichScreen],
//                              });
//                          // model.getCurrentUserLocation();
//                        },
//                      ),
//                    ),
//                  ),
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
//                        Visibility(
//                          visible: model.initialPosition != null &&
//                              !model.mapsIsLoaded,
//                          child: Align(
//                            alignment: Alignment.center,
//                            child: Image.asset(
//                              'assets/images/marker_pin.png',
//                              width: 35.0,
//                              height: 35.0,
//                            ),
//                          ),
//                        ),
//                  Positioned(
//                    top: MediaQuery.of(context).size.height / 2.2,
//                    left: MediaQuery.of(context).size.width / 2.2,
//                    // right: 20.0,
//                    child: Image.asset(
//                      'assets/images/marker_pin.png',
//                      width: 35.0,
//                      height: 35.0,
//                    ),
//                  ),
                        widget.fromWhichScreen[fromWhichScreen] ==
                            "4" //from edit address
                            ? completeAddressBottomSheet(model)
                            : widget.fromWhichScreen[fromWhichScreen] == "1"
                            ? Align(
                            alignment: Alignment.bottomCenter,
                            child: confirmAndProceedContainer(
                                1, model)) //from home
                            : widget.fromWhichScreen[fromWhichScreen] ==
                            "2" // from cart-> manage address ->current location
                            ? model.showNextBottomSheet
                            ? completeAddressBottomSheet(model)
                            : Align(
                            alignment: Alignment.bottomCenter,
                            child: confirmAndProceedContainer(
                                2, model))
                            : completeAddressBottomSheet(model),
                        // from cart location change
                      ],
                    ),
                  ),
//                  widget.fromWhichScreen[fromWhichScreen] ==
//                          "4" //from edit address
//                      ? completeAddressBottomSheet(model)
//                      : widget.fromWhichScreen[fromWhichScreen] == "1"
//                          ? Align(
//                              alignment: Alignment.bottomCenter,
//                              child: confirmAndProceedContainer(
//                                  1, model)) //from home
//                          : widget.fromWhichScreen[fromWhichScreen] ==
//                                  "2" // from cart-> manage address ->current location
//                              ? model.showNextBottomSheet
//                                  ? completeAddressBottomSheet(model)
//                                  : Align(
//                                      alignment: Alignment.bottomCenter,
//                                      child:
//                                          confirmAndProceedContainer(2, model))
//                              : completeAddressBottomSheet(model),
                ],
              ),
            ),
          );
        });
  }

// .... @override
//  Widget build(BuildContext context) {
//    return BaseWidget<MapAddressLocationViewModel>(
//        onModelReady: (model) => model.initMapProcess(),
//        model: MapAddressLocationViewModel(context: context),
//        builder: (BuildContext context, MapAddressLocationViewModel model,
//            Widget child) {
//          return Scaffold(
//            body: SafeArea(
//              child: Column(
//                children: [
//                  Expanded(
//                    flex: 3,
//                    child: Stack(
//                      children: <Widget>[
//                        model.initialPosition != null
//                            ? Container(
//                                width: MediaQuery.of(context).size.width,
//                                height:
//                                    MediaQuery.of(context).size.height / 1.58,
//                                child: Stack(
//                                  children: [
//                                    (longitude != null && longitude != null) &&
//                                            model.mapDragStarted
//                                        ? GoogleMap(
//                                            mapType: MapType.normal,
//                                            initialCameraPosition:
//                                                CameraPosition(
//                                                    target:
//                                                        model.initialPosition,
//                                                    zoom: 16.0),
//                                            myLocationEnabled: true,
//                                            myLocationButtonEnabled: true,
//                                            onCameraMove: model.onCameraMove,
//                                            onCameraIdle: model.didMapViewIdle,
//                                            onMapCreated: (controller) {
//                                              model.mapController
//                                                  .complete(controller);
//                                              model.onCreated();
//                                            },
//                                          )
//                                        :
////                                    widget.fromWhichScreen[
////                                                    fromWhichScreen] ==
////                                                "4"
//                                        (longitude != null && longitude != null)
//                                            ? GoogleMap(
//                                                mapType: MapType.normal,
//                                                initialCameraPosition:
//                                                    CameraPosition(
//                                                  target: LatLng(
//                                                    double.parse(latitude),
//                                                    double.parse(longitude),
//                                                  ),
//                                                  zoom: 16.0,
//                                                ),
//                                                myLocationEnabled: true,
//                                                myLocationButtonEnabled: true,
//                                                onCameraMove:
//                                                    model.onCameraMove,
//                                                onCameraIdle:
//                                                    model.didMapViewIdle,
//                                                onMapCreated: (controller) {
//                                                  model.mapController
//                                                      .complete(controller);
//                                                  model.onCreated();
//                                                },
//                                              )
//                                            : GoogleMap(
//                                                mapType: MapType.normal,
//                                                initialCameraPosition:
//                                                    CameraPosition(
//                                                  target: model.initialPosition,
//                                                  zoom: 16.0,
//                                                ),
//                                                myLocationEnabled: true,
//                                                myLocationButtonEnabled: true,
//                                                onCameraMove:
//                                                    model.onCameraMove,
//                                                onCameraIdle:
//                                                    model.didMapViewIdle,
//                                                onMapCreated: (controller) {
//                                                  model.mapController
//                                                      .complete(controller);
//                                                  model.onCreated();
//                                                },
//                                              ),
////                                    Visibility(
////                                      visible: model.mapsIsLoaded,
////                                      child: Container(
////                                        child: Center(
////                                          child: Column(
////                                            crossAxisAlignment:
////                                                CrossAxisAlignment.center,
////                                            mainAxisAlignment:
////                                                MainAxisAlignment.center,
////                                            children: [
////                                              showProgress(context),
////                                              verticalSizedBoxTwenty(),
////                                              Text(
////                                                'Locating',
////                                                style: Theme.of(context)
////                                                    .textTheme
////                                                    .subhead,
////                                              ),
////                                            ],
////                                          ),
////                                        ),
////                                      ),
////                                    ),
//                                    Visibility(
//                                      visible: model.initialPosition != null &&
//                                          !model.mapsIsLoaded,
//                                      child: Align(
//                                        alignment: Alignment.center,
//                                        child: Image.asset(
//                                          'assets/images/marker_pin.png',
//                                          width: 35.0,
//                                          height: 35.0,
//                                        ),
//                                      ),
//                                    ),
//                                  ],
//                                ),
//                              )
//                            : Container(
//                                child: Center(
////                                  child: Column(
////                                    crossAxisAlignment:
////                                        CrossAxisAlignment.center,
////                                    mainAxisAlignment: MainAxisAlignment.center,
////                                    children: [
////                                      showProgress(context),
////                                      verticalSizedBoxTwenty(),
////                                      Text(
////                                        'Locating',
////                                        style:
////                                            Theme.of(context).textTheme.subhead,
////                                      ),
////                                    ],
////                                  ),
//                                  child: Image.asset(
//                                    'assets/images/map_loader.gif',
//                                  ),
//                                ),
//                              ),
////                  Positioned(
////                    top: 20.0,
////                    right: 20.0,
////                    child: Container(
////                      height: 40,
////                      width: 40,
////                      color: Colors.white.withOpacity(0.8),
////                      child: IconButton(
////                        icon: Icon(
////                          Icons.my_location,
////                          size: 20.0,
////                        ),
////                        onPressed: () {
////                          Navigator.popAndPushNamed(
////                              context, changeUserAddressScreen,
////                              arguments: {
////                                fromWhichScreen:
////                                    widget.fromWhichScreen[fromWhichScreen],
////                              });
////                          // model.getCurrentUserLocation();
////                        },
////                      ),
////                    ),
////                  ),
//                        Positioned(
//                          top: 20.0,
//                          child: IconButton(
//                            icon: Icon(
//                              Icons.arrow_back,
//                              size: 30.0,
//                            ),
//                            onPressed: () {
//                              Navigator.pop(context);
//                            },
//                          ),
//                        ),
////                        Visibility(
////                          visible: model.initialPosition != null &&
////                              !model.mapsIsLoaded,
////                          child: Align(
////                            alignment: Alignment.center,
////                            child: Image.asset(
////                              'assets/images/marker_pin.png',
////                              width: 35.0,
////                              height: 35.0,
////                            ),
////                          ),
////                        ),
////                  Positioned(
////                    top: MediaQuery.of(context).size.height / 2.2,
////                    left: MediaQuery.of(context).size.width / 2.2,
////                    // right: 20.0,
////                    child: Image.asset(
////                      'assets/images/marker_pin.png',
////                      width: 35.0,
////                      height: 35.0,
////                    ),
////                  ),
//                        widget.fromWhichScreen[fromWhichScreen] ==
//                                "4" //from edit address
//                            ? completeAddressBottomSheet(model)
//                            : widget.fromWhichScreen[fromWhichScreen] == "1"
//                                ? Align(
//                                    alignment: Alignment.bottomCenter,
//                                    child: confirmAndProceedContainer(
//                                        1, model)) //from home
//                                : widget.fromWhichScreen[fromWhichScreen] ==
//                                        "2" // from cart-> manage address ->current location
//                                    ? model.showNextBottomSheet
//                                        ? completeAddressBottomSheet(model)
//                                        : Align(
//                                            alignment: Alignment.bottomCenter,
//                                            child: confirmAndProceedContainer(
//                                                2, model))
//                                    : completeAddressBottomSheet(model),
//                        // from cart location change
//                      ],
//                    ),
//                  ),
////                  widget.fromWhichScreen[fromWhichScreen] ==
////                          "4" //from edit address
////                      ? completeAddressBottomSheet(model)
////                      : widget.fromWhichScreen[fromWhichScreen] == "1"
////                          ? Align(
////                              alignment: Alignment.bottomCenter,
////                              child: confirmAndProceedContainer(
////                                  1, model)) //from home
////                          : widget.fromWhichScreen[fromWhichScreen] ==
////                                  "2" // from cart-> manage address ->current location
////                              ? model.showNextBottomSheet
////                                  ? completeAddressBottomSheet(model)
////                                  : Align(
////                                      alignment: Alignment.bottomCenter,
////                                      child:
////                                          confirmAndProceedContainer(2, model))
////                              : completeAddressBottomSheet(model),
//                ],
//              ),
//            ),
//          );
//        });
//  }

//  @override
//  Widget build(BuildContext context) {
//    return BaseWidget<MapAddressLocationViewModel>(
//        onModelReady: (model) => model.initMapProcess(),
//        model: MapAddressLocationViewModel(context: context),
//        builder: (BuildContext context, MapAddressLocationViewModel model,
//            Widget child) {
//          return Scaffold(
//            body: SafeArea(
//              child: Stack(
//                children: <Widget>[
//                  model.isFetchingLocation
//                      ? GoogleMap(
//                          mapType: MapType.normal,
//                          initialCameraPosition: model.currentCameraPosition,
//                          myLocationEnabled: true,
//                          myLocationButtonEnabled: true,
//                          onCameraMove: model.mapViewDragging,
//                          onCameraIdle: model.didMapViewIdle,
//                          onMapCreated:
//                              (GoogleMapController googleMapController) {
//                            //  model.mapController = googleMapController;
//                                setState(() {
//                                  model.mapController.complete(googleMapController);
//                                });
//
//
//                            // model.mapController = googleMapController;
//                            //showPinsOnMap();
//                          },
//                          //   markers: Set.from(model.allMarkers),
//                        )
//                      : Container(),
//                  Positioned(
//                    top: 20.0,
//                    child: IconButton(
//                      icon: Icon(
//                        Icons.arrow_back,
//                        size: 30.0,
//                      ),
//                      onPressed: () {
//                        Navigator.pop(context);
//                      },
//                    ),
//                  ),
//                  Align(
//                    alignment: Alignment.center,
//                    child: Image.asset(
//                      'assets/images/marker_pin.png',
//                      width: 40.0,
//                      height: 40.0,
//                    ),
//                  ),
////                  Positioned(
////                    top: MediaQuery.of(context).size.height / 2.2,
////                    left: MediaQuery.of(context).size.width / 2.2,
////                    // right: 20.0,
////                    child: Image.asset(
////                      'assets/images/marker_pin.png',
////                      width: 35.0,
////                      height: 35.0,
////                    ),
////                  ),
//                  widget.fromWhichScreen[fromWhichScreen] ==
//                          "4" //from edit address
//                      ? completeAddressBottomSheet(model)
//                      : widget.fromWhichScreen[fromWhichScreen] == "1"
//                          ? Align(
//                              alignment: Alignment.bottomCenter,
//                              child: confirmAndProceedContainer(
//                                  1, model)) //from home
//                          : widget.fromWhichScreen[fromWhichScreen] ==
//                                  "2" // from cart-> manage address ->current location
//                              ? model.showNextBottomSheet
//                                  ? completeAddressBottomSheet(model)
//                                  : Align(
//                                      alignment: Alignment.bottomCenter,
//                                      child:
//                                          confirmAndProceedContainer(2, model))
//                              : completeAddressBottomSheet(model),
//                  // from cart location change
//                ],
//              ),
//            ),
//          );
//        });
//  }

//  showBottomSheet({ int type, MapAddressLocationViewModel model}) {
//    showModalBottomSheet(
//        context: context,
//        builder: (BuildContext context) {
//          return Scaffold(
//            body: Container(
//              child: Container(
//                child: Padding(
//                  padding: const EdgeInsets.symmetric(vertical: 10.0),
//                  child: Column(
//                    crossAxisAlignment: CrossAxisAlignment.start,
//                    mainAxisSize: MainAxisSize.min,
//                    children: <Widget>[
//                      dragIcon(),
//                      verticalSizedBox(),
//                      Padding(
//                        padding: const EdgeInsets.all(8.0),
//                        child: Text(
//                          'Select Delivery Location',
//                          style: Theme.of(context).textTheme.subhead,
//                        ),
//                      ),
//                      Padding(
//                        padding: const EdgeInsets.all(10.0),
//                        child: Column(
//                          crossAxisAlignment: CrossAxisAlignment.start,
//                          mainAxisAlignment: MainAxisAlignment.start,
//                          children: <Widget>[
//                            Text(
//                              'Your Location',
//                              style: Theme.of(context)
//                                  .textTheme
//                                  .display2
//                                  .copyWith(
//                                color: Colors.grey,
//                                fontSize: 13,
//                              ),
//                            ),
//                            verticalSizedBox(),
//                            model.isMapDragging
//                                ? Container(
//                              alignment: Alignment.centerLeft,
//                              margin: const EdgeInsets.symmetric(
//                                vertical: 10.0,
//                                horizontal: 15.0,
//                              ),
//                              height: 63.5,
//                              child: Column(
//                                mainAxisAlignment:
//                                MainAxisAlignment.center,
//                                crossAxisAlignment:
//                                CrossAxisAlignment.start,
//                                children: <Widget>[
//                                  Shimmer.fromColors(
//                                    baseColor: Colors.grey[100],
//                                    highlightColor: Colors.grey[200],
//                                    child: Container(
//                                      width: MediaQuery.of(context)
//                                          .size
//                                          .width /
//                                          2,
//                                      height: 10.0,
//                                      color: Colors.white,
//                                    ),
//                                  ),
//                                  verticalSizedBox(),
//                                  Shimmer.fromColors(
//                                    baseColor: Colors.grey[100],
//                                    highlightColor: Colors.grey[200],
//                                    child: Container(
//                                      width: MediaQuery.of(context)
//                                          .size
//                                          .width /
//                                          5,
//                                      height: 10.0,
//                                      color: Colors.green,
//                                    ),
//                                  ),
//                                  verticalSizedBox(),
//                                  Shimmer.fromColors(
//                                    baseColor: Colors.grey[100],
//                                    highlightColor: Colors.grey[200],
//                                    child: Container(
//                                      width: MediaQuery.of(context)
//                                          .size
//                                          .width /
//                                          3,
//                                      height: 10.0,
//                                      color: Colors.green,
//                                    ),
//                                  ),
//                                ],
//                              ),
//                            )
//                                : Row(
//                              crossAxisAlignment:
//                              CrossAxisAlignment.start,
//                              mainAxisAlignment:
//                              MainAxisAlignment.spaceBetween,
//                              children: <Widget>[
//                                Flexible(
//                                  flex: 2,
//                                  child: Row(
//                                    children: <Widget>[
//                                      Container(
//                                        height: 20,
//                                        width: 20,
//                                        decoration: BoxDecoration(
//                                          shape: BoxShape.circle,
//                                          border:
//                                          Border.all(color: blue),
//                                        ),
//                                        child: Center(
//                                          child: Icon(
//                                            Icons.check,
//                                            color: blue,
//                                            size: 13,
//                                          ),
//                                        ),
//                                      ),
//                                      horizontalSizedBox(),
//                                      Flexible(
//                                        child: Text(
//                                          '${model.currentAddress}',
//                                          style: Theme.of(context)
//                                              .textTheme
//                                              .display1,
//                                        ),
//                                      ),
//                                    ],
//                                  ),
//                                ),
//                                GestureDetector(
//                                  onTap: () {
//                                    if (widget.fromWhichScreen[
//                                    fromWhichScreen] ==
//                                        "1") {
//                                      // from home screen menu one
//                                      Navigator.pushNamed(
//                                          context, manageAddress,
//                                          arguments: {
//                                            fromWhichScreen:
//                                            widget.fromWhichScreen[
//                                            fromWhichScreen]
//                                          });
//                                    } else {
//                                      Navigator.pop(context);
//                                    }
//                                  },
//                                  child: Text(
//                                    'Change',
//                                    style: Theme.of(context)
//                                        .textTheme
//                                        .display1
//                                        .copyWith(
//                                      color: Colors.redAccent,
//                                    ),
//                                  ),
//                                ),
//                              ],
//                            ),
//                            verticalSizedBoxTwenty(),
//                            Consumer<HomeRestaurantListViewModel>(
//                              builder: (BuildContext context,
//                                  HomeRestaurantListViewModel homeModel,
//                                  Widget child) {
//                                return FormSubmitButton(
//                                  title: type == 1
//                                      ? 'Confirm location'
//                                      : 'Confirm location & Proceed',
//                                  buttonColor: appColor,
//                                  onPressed: () async {
//                                    if (type == 1) {
//                                      await model.saveLatLongValues(
//                                        lat: model.completeAddressLat,
//                                        lang: model.completeAddressLong,
//                                        currentAddressData:
//                                        model.currentAddressShownInHome,
//                                      );
////                                          homeModel
////                                              .updateLocationDependsOnUserChanged(
////                                              lat: completeAddressLat,
////                                              lang: completeAddressLong,
////                                              currentAddressData:
////                                              currentAddressShownInHome);
////                                          Navigator.of(context).popUntil(
////                                              ModalRoute.withName(mainHome));
//                                      Navigator.pop(context, true);
//                                    } else {
//                                      setState(() {
//                                        showNextBottomSheet = true;
//                                        bottomSheetHeight = 0.5;
//                                      });
//                                    }
//                                  },
//                                );
//                              },
//                            ),
//                          ],
//                        ),
//                      ),
//                    ],
//                  ),
//                ),
//              ),
//            ),
//          );
//        });
//  }

  Container confirmAndProceedContainer(int type,
      MapAddressLocationViewModel model) {
    return Container(
      color: Colors.white,
      height: 250.0,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
//                        dragIcon(),
            verticalSizedBoxFive(),
            Text(
              'Select Delivery Location',
              style: Theme
                  .of(context)
                  .textTheme
                  .subhead,
            ),
            verticalSizedBoxFive(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Your Location',
                  style: Theme
                      .of(context)
                      .textTheme
                      .display2
                      .copyWith(
                    color: Colors.grey,
                    fontSize: 13,
                  ),
                ),
                verticalSizedBox(),
                model.isMapDragging
                    ? Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.symmetric(
                    // vertical: 10.0,
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
                          width: MediaQuery
                              .of(context)
                              .size
                              .width / 2,
                          height: 10.0,
                          color: Colors.white,
                        ),
                      ),
                      verticalSizedBox(),
                      Shimmer.fromColors(
                        baseColor: Colors.grey[100],
                        highlightColor: Colors.grey[200],
                        child: Container(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width / 5,
                          height: 10.0,
                          color: Colors.green,
                        ),
                      ),
                      verticalSizedBox(),
                      Shimmer.fromColors(
                        baseColor: Colors.grey[100],
                        highlightColor: Colors.grey[200],
                        child: Container(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width / 3,
                          height: 10.0,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                )
                    : Container(
                  height: 63.5,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Flexible(
                        flex: 2,
                        child: Row(
                          children: <Widget>[
                            Container(
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: blue),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.check,
                                  color: blue,
                                  size: 13,
                                ),
                              ),
                            ),
                            horizontalSizedBox(),
                            (latitude != null && longitude != null) &&
                                model.mapDragStarted
                                ? Flexible(
                              child: Text(
                                model.initialPosition == null
                                    ? 'Locating'
                                    : '${model.currentAddress}',
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .display1,
                              ),
                            )
                                : Flexible(
//                                                  child: Text(
//                                                    '${model.currentAddress}',
//                                                    style: Theme.of(context)
//                                                        .textTheme
//                                                        .display1,
//                                                  ),
                              child:
//                                                      widget.fromWhichScreen[
//                                                                  fromWhichScreen] ==
//                                                              "4"
                              (latitude != null &&
                                  longitude != null)
                                  ? FutureBuilder(
                                future: model
                                    .editGivenAddressFromLatLng(
                                  latitude: double.parse(
                                      latitude),
                                  longitude: double.parse(
                                      longitude),
                                ),
                                builder: (BuildContext
                                context,
                                    AsyncSnapshot<dynamic>
                                    snapshot) {
                                  return Text(
                                    '${snapshot.data}',
                                    style:
                                    Theme
                                        .of(context)
                                        .textTheme
                                        .display1,
                                  );
                                },
                              )
                                  : Text(
                                '${model.currentAddress}',
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .display1,
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (widget.fromWhichScreen[fromWhichScreen] ==
                              "1") {
                            // from home screen menu one
//                                    Navigator.pushNamed(context, manageAddress,
//                                        arguments: {
//                                          fromWhichScreen: widget
//                                              .fromWhichScreen[fromWhichScreen]
//                                        }).then((value) => {});
                            Navigator.pop(context);
                          } else {
                            Navigator.pop(context);
                          }
                        },
                        child: Text(
                          'Change',
                          style: Theme
                              .of(context)
                              .textTheme
                              .display1
                              .copyWith(
                            color: Colors.redAccent,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                verticalSizedBox(),
                Consumer<HomeRestaurantListViewModel>(
                  builder: (BuildContext context,
                      HomeRestaurantListViewModel homeModel, Widget child) {
                    return FormSubmitButton(
                      title: type == 1
                          ? 'Confirm location'
                          : 'Confirm location & Proceed',
                      buttonColor: appColor,
                      onPressed: () async {
                        if (type == 1) {
                          await model.saveLatLongValues(
                            lat: model.initialPosition.latitude.toString(),
                            lang: model.initialPosition.longitude.toString(),
                            currentAddressData: model.currentAddressShownInHome,
                          );
//                                          homeModel
//                                              .updateLocationDependsOnUserChanged(
//                                              lat: completeAddressLat,
//                                              lang: completeAddressLong,
//                                              currentAddressData:
//                                              currentAddressShownInHome);
//                                          Navigator.of(context).popUntil(
//                                              ModalRoute.withName(mainHome));
                          Navigator.pop(context, true);
                        } else {
//                                        setState(() {
//                                          showNextBottomSheet = true;
//                                          bottomSheetHeight = 0.5;
//                                        });

                          model.showNextScreen(true);
//                            model.changeBottomSheetHeight(
//                                value: 0.5, min: 0.2, max: 1.0);
                        }
                      },
                    );
                  },
                ),
                verticalSizedBoxFive(),
              ],
            ),
          ],
        ),
      ),
    );
  }

//  DraggableScrollableSheet confirmAndProceedBottomSheet(
//          int type, MapAddressLocationViewModel model) =>
//      DraggableScrollableSheet(
//          maxChildSize: model.maxChildSize,
//          initialChildSize: model.bottomSheetHeight,
//          minChildSize: 0.2, //model.minChildSize,
//          builder: (context, scrollController) {
//            return Scaffold(
//              body: Container(
//                child: Container(
//                  child: Padding(
//                    padding: const EdgeInsets.symmetric(vertical: 10.0),
//                    child: Column(
//                      crossAxisAlignment: CrossAxisAlignment.start,
//                      mainAxisSize: MainAxisSize.max,
//                      children: <Widget>[
////                        dragIcon(),
////                        verticalSizedBox(),
//                        Padding(
//                          padding: const EdgeInsets.all(8.0),
//                          child: Text(
//                            'Select Delivery Location',
//                            style: Theme.of(context).textTheme.subhead,
//                          ),
//                        ),
//                        Padding(
//                          padding: const EdgeInsets.all(10.0),
//                          child: Column(
//                            crossAxisAlignment: CrossAxisAlignment.start,
//                            mainAxisAlignment: MainAxisAlignment.start,
//                            children: <Widget>[
//                              Text(
//                                'Your Location',
//                                style: Theme.of(context)
//                                    .textTheme
//                                    .display2
//                                    .copyWith(
//                                      color: Colors.grey,
//                                      fontSize: 13,
//                                    ),
//                              ),
//                              verticalSizedBox(),
//                              model.isMapDragging
//                                  ? Container(
//                                      alignment: Alignment.centerLeft,
//                                      margin: const EdgeInsets.symmetric(
//                                        // vertical: 10.0,
//                                        horizontal: 15.0,
//                                      ),
//                                      height: 63.5,
//                                      child: Column(
//                                        mainAxisAlignment:
//                                            MainAxisAlignment.center,
//                                        crossAxisAlignment:
//                                            CrossAxisAlignment.start,
//                                        children: <Widget>[
//                                          Shimmer.fromColors(
//                                            baseColor: Colors.grey[100],
//                                            highlightColor: Colors.grey[200],
//                                            child: Container(
//                                              width: MediaQuery.of(context)
//                                                      .size
//                                                      .width /
//                                                  2,
//                                              height: 10.0,
//                                              color: Colors.white,
//                                            ),
//                                          ),
//                                          verticalSizedBox(),
//                                          Shimmer.fromColors(
//                                            baseColor: Colors.grey[100],
//                                            highlightColor: Colors.grey[200],
//                                            child: Container(
//                                              width: MediaQuery.of(context)
//                                                      .size
//                                                      .width /
//                                                  5,
//                                              height: 10.0,
//                                              color: Colors.green,
//                                            ),
//                                          ),
//                                          verticalSizedBox(),
//                                          Shimmer.fromColors(
//                                            baseColor: Colors.grey[100],
//                                            highlightColor: Colors.grey[200],
//                                            child: Container(
//                                              width: MediaQuery.of(context)
//                                                      .size
//                                                      .width /
//                                                  3,
//                                              height: 10.0,
//                                              color: Colors.green,
//                                            ),
//                                          ),
//                                        ],
//                                      ),
//                                    )
//                                  : Container(
//                                      height: 63.5,
//                                      child: Row(
//                                        crossAxisAlignment:
//                                            CrossAxisAlignment.start,
//                                        mainAxisAlignment:
//                                            MainAxisAlignment.spaceBetween,
//                                        children: <Widget>[
//                                          Flexible(
//                                            flex: 2,
//                                            child: Row(
//                                              children: <Widget>[
//                                                Container(
//                                                  height: 20,
//                                                  width: 20,
//                                                  decoration: BoxDecoration(
//                                                    shape: BoxShape.circle,
//                                                    border:
//                                                        Border.all(color: blue),
//                                                  ),
//                                                  child: Center(
//                                                    child: Icon(
//                                                      Icons.check,
//                                                      color: blue,
//                                                      size: 13,
//                                                    ),
//                                                  ),
//                                                ),
//                                                horizontalSizedBox(),
//                                                Flexible(
//                                                  child: Text(
//                                                    '${model.currentAddress}',
//                                                    style: Theme.of(context)
//                                                        .textTheme
//                                                        .display1,
//                                                  ),
//                                                ),
//                                              ],
//                                            ),
//                                          ),
//                                          GestureDetector(
//                                            onTap: () {
//                                              if (widget.fromWhichScreen[
//                                                      fromWhichScreen] ==
//                                                  "1") {
//                                                // from home screen menu one
//                                                Navigator.pushNamed(
//                                                    context, manageAddress,
//                                                    arguments: {
//                                                      fromWhichScreen: widget
//                                                              .fromWhichScreen[
//                                                          fromWhichScreen]
//                                                    }).then((value) => {});
//                                              } else {
//                                                Navigator.pop(context);
//                                              }
//                                            },
//                                            child: Visibility(
//                                              visible:
//                                                  model.accessToken != null,
//                                              child: Text(
//                                                'Change',
//                                                style: Theme.of(context)
//                                                    .textTheme
//                                                    .display1
//                                                    .copyWith(
//                                                      color: Colors.redAccent,
//                                                    ),
//                                              ),
//                                            ),
//                                          ),
//                                        ],
//                                      ),
//                                    ),
//                              verticalSizedBoxTwenty(),
//                              Consumer<HomeRestaurantListViewModel>(
//                                builder: (BuildContext context,
//                                    HomeRestaurantListViewModel homeModel,
//                                    Widget child) {
//                                  return FormSubmitButton(
//                                    title: type == 1
//                                        ? 'Confirm location'
//                                        : 'Confirm location & Proceed',
//                                    buttonColor: appColor,
//                                    onPressed: () async {
//                                      if (type == 1) {
//                                        await model.saveLatLongValues(
//                                          lat: model.completeAddressLat,
//                                          lang: model.completeAddressLong,
//                                          currentAddressData:
//                                              model.currentAddressShownInHome,
//                                        );
////                                          homeModel
////                                              .updateLocationDependsOnUserChanged(
////                                              lat: completeAddressLat,
////                                              lang: completeAddressLong,
////                                              currentAddressData:
////                                              currentAddressShownInHome);
////                                          Navigator.of(context).popUntil(
////                                              ModalRoute.withName(mainHome));
//                                        Navigator.pop(context, true);
//                                      } else {
////                                        setState(() {
////                                          showNextBottomSheet = true;
////                                          bottomSheetHeight = 0.5;
////                                        });
//
//                                        model.showNextScreen(true);
//                                        model.changeBottomSheetHeight(
//                                            value: 0.5, min: 0.2, max: 1.0);
//                                      }
//                                    },
//                                  );
//                                },
//                              ),
//                            ],
//                          ),
//                        ),
//                      ],
//                    ),
//                  ),
//                ),
//              ),
//            );
//          });

//  textSubmitted() {
//    setState(() {
//      completeAddressSubmitted = true;
//    });
//  }

  //show after confirm and proceed

  DraggableScrollableSheet completeAddressBottomSheet(
      MapAddressLocationViewModel model) =>
      DraggableScrollableSheet(
          maxChildSize: model.maxChildSize, //1.0,
          initialChildSize: model.bottomSheetHeight, //0.5
          minChildSize: model.minChildSize, //0.2,
          builder: (context, scrollController) {
            return Scaffold(
              body: Container(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 10.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          dragIcon(),
                          verticalSizedBoxFive(),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Enter address details',
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .subhead,
                              ),
//                              Visibility(
//                                visible:
//                                    (widget.fromWhichScreen[fromWhichScreen] !=
//                                        "4"),
//                                child: closeIconButton(
//                                    context: context,
//                                    onClicked: () {
////                                    setState(() {
////                                      showNextBottomSheet = false;
////                                      bottomSheetHeight = 0.3;
////                                    });
//                                      model.showNextScreen(false);
//                                      model.changeBottomSheetHeight(
//                                          value: 0.3, max: 0.4, min: 0.2);
//                                    }),
//                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Your Location',
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .display2
                                    .copyWith(
                                  color: Colors.grey,
                                  fontSize: 13,
                                ),
                              ),
                              verticalSizedBox(),
                              model.isMapDragging
                                  ? Container(
                                alignment: Alignment.centerLeft,
                                margin: const EdgeInsets.symmetric(
                                  vertical: 10.0,
                                  horizontal: 15.0,
                                ),
                                height: 63.5,
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Shimmer.fromColors(
                                      baseColor: Colors.grey[100],
                                      highlightColor: Colors.grey[200],
                                      child: Container(
                                        width: MediaQuery
                                            .of(context)
                                            .size
                                            .width /
                                            2,
                                        height: 10.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                    verticalSizedBox(),
                                    Shimmer.fromColors(
                                      baseColor: Colors.grey[100],
                                      highlightColor: Colors.grey[200],
                                      child: Container(
                                        width: MediaQuery
                                            .of(context)
                                            .size
                                            .width /
                                            5,
                                        height: 10.0,
                                        color: Colors.green,
                                      ),
                                    ),
                                    verticalSizedBox(),
                                    Shimmer.fromColors(
                                      baseColor: Colors.grey[100],
                                      highlightColor: Colors.grey[200],
                                      child: Container(
                                        width: MediaQuery
                                            .of(context)
                                            .size
                                            .width /
                                            3,
                                        height: 10.0,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                                  : Row(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Flexible(
                                    flex: 2,
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          height: 20,
                                          width: 20,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border:
                                            Border.all(color: blue),
                                          ),
                                          child: Center(
                                            child: Icon(
                                              Icons.check,
                                              color: blue,
                                              size: 13,
                                            ),
                                          ),
                                        ),
                                        horizontalSizedBox(),
//                                              widget.fromWhichScreen[
//                                                              fromWhichScreen] ==
//                                                          "4" &&
//                                                      model.mapDragStarted
                                        (latitude != null &&
                                            longitude != null) &&
                                            model.mapDragStarted
                                            ? Flexible(
                                          child: Text(
                                            '${model.currentAddress}',
                                            style: Theme
                                                .of(context)
                                                .textTheme
                                                .display1,
                                          ),
                                        )
                                            : Flexible(
//                                                  child: Text(
//                                                    '${model.currentAddress}',
//                                                    style: Theme.of(context)
//                                                        .textTheme
//                                                        .display1,
//                                                  ),
                                          child:
//                                                      widget.fromWhichScreen[
//                                                                  fromWhichScreen] ==
//                                                              "4"
                                          (latitude != null &&
                                              longitude !=
                                                  null)
                                              ? FutureBuilder(
                                            future: model
                                                .editGivenAddressFromLatLng(
                                              latitude: double
                                                  .parse(
                                                  latitude),
                                              longitude:
                                              double.parse(
                                                  longitude),
                                            ),
                                            builder: (BuildContext
                                            context,
                                                AsyncSnapshot<
                                                    dynamic>
                                                snapshot) {
                                              return Text(
                                                '${snapshot.data}',
                                                style: Theme
                                                    .of(
                                                    context)
                                                    .textTheme
                                                    .display1,
                                              );
                                            },
                                          )
                                              : Text(
                                            '${model.currentAddress}',
                                            style: Theme
                                                .of(
                                                context)
                                                .textTheme
                                                .display1,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
//                                              Navigator.pushNamed(
//                                                  context, manageAddress,
//                                                  arguments: {
//                                                    fromWhichScreen:
//                                                        widget.fromWhichScreen[
//                                                            fromWhichScreen],
//                                                  });
                                      Navigator.pop(context, null);
                                    },
                                    child: Text(
                                      'Change',
                                      style: Theme
                                          .of(context)
                                          .textTheme
                                          .display1
                                          .copyWith(
                                        color: Colors.redAccent,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              verticalSizedBox(),
                              Form(
                                key: _formKey,
                                child: Column(
                                  children: <Widget>[
//                                      TextFormField(
//                                        controller: completeAddressController,
//                                        style:
//                                            Theme.of(context).textTheme.body1,
//                                        validator: (value) {
//                                          return nameValidation(value);
//                                        },
//                                        onChanged: (value) {
//                                          model.textSubmitted();
//                                        },
//                                        onFieldSubmitted: (term) {
//                                          completeAddressFocus.unfocus();
//                                          FocusScope.of(context)
//                                              .requestFocus(floorAddressFocus);
//                                          model.textSubmitted();
//                                        },
//                                        textInputAction: TextInputAction.next,
//                                        decoration: InputDecoration(
//                                          border: InputBorder.none,
//                                          labelText: 'Complete Address*',
//                                          labelStyle: Theme.of(context)
//                                              .textTheme
//                                              .bodyText1
//                                              .copyWith(
//                                                color: Colors.grey[400],
//                                              ),
//                                          hintText: 'Complete Address*',
//                                          hintStyle: Theme.of(context)
//                                              .textTheme
//                                              .bodyText1
//                                              .copyWith(
//                                                color: Colors.grey,
//                                              ),
//                                          counterText: '',
//                                        ),
//                                        onSaved: (value) => {
//                                          completeAddressController.text = value
//                                        },
//                                        focusNode: completeAddressFocus,
//                                      ),
                                    // verticalSizedBox(),
                                    TextFormField(
                                      controller: floorAddressController,
                                      style: Theme
                                          .of(context)
                                          .textTheme
                                          .body1,
                                      onChanged: (value) {
                                        model.textSubmitted();
                                      },
                                      onFieldSubmitted: (term) {
                                        floorAddressFocus.unfocus();
                                        FocusScope.of(context)
                                            .requestFocus(landMarkAddressFocus);
                                        model.textSubmitted();
                                      },
                                      textInputAction: TextInputAction.next,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        labelText: 'Floor',
                                        labelStyle: Theme
                                            .of(context)
                                            .textTheme
                                            .bodyText1
                                            .copyWith(
                                          color: Colors.grey[400],
                                        ),
                                        hintText: 'e.g Ground Floor',
                                        hintStyle: Theme
                                            .of(context)
                                            .textTheme
                                            .bodyText1
                                            .copyWith(
                                          color: Colors.grey,
                                        ),
                                        counterText: '',
                                      ),
                                      onSaved: (value) =>
                                      floorAddressController.text = value,
                                      focusNode: floorAddressFocus,
                                    ),
                                    verticalSizedBox(),
                                    TextFormField(
                                      controller: landMarkAddressController,
                                      style: Theme
                                          .of(context)
                                          .textTheme
                                          .body1,
                                      onChanged: (value) {
                                        model.landMarkCompleted();
                                      },
                                      onFieldSubmitted: (term) {
                                        landMarkAddressFocus.unfocus();
                                        FocusScope.of(context)
                                            .requestFocus(null);
                                        model.landMarkCompleted();
                                        // FocusScope.of(context).requestFocus(emailFocus);
                                      },
                                      textInputAction: TextInputAction.done,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        labelText: 'How to reach',
                                        labelStyle: Theme
                                            .of(context)
                                            .textTheme
                                            .bodyText1
                                            .copyWith(
                                          color: Colors.grey[400],
                                        ),
                                        hintText: 'Landmark/Entry gate/Street',
                                        hintStyle: Theme
                                            .of(context)
                                            .textTheme
                                            .bodyText1
                                            .copyWith(
                                          color: Colors.grey,
                                        ),
                                        counterText: '',
                                      ),
                                      onSaved: (value) =>
                                      landMarkAddressController.text =
                                          value,
                                      focusNode: landMarkAddressFocus,
                                    ),
                                  ],
                                ),
                              ),
//                                enterAddressFields(completeAddressController,
//                                    'Complete Address* '),
//                                verticalSizedBox(),
//                                enterAddressFields(floorAddressController,
//                                    'Floor (Optional) '),
//                                verticalSizedBox(),
//                                enterAddressFields(landMarkAddressController,
//                                    'How to reach (Optional) '),
                              verticalSizedBoxTwenty(),
                              Text(
                                'Tag this location for later',
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .display2
                                    .copyWith(
                                  color: Colors.grey,
                                ),
                              ),
                              Container(
                                height: 40,
                                child: ListView.builder(
                                    itemCount: tag.length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Align(
                                          child: GestureDetector(
                                            onTap: () {
                                              model.updateAddressTypeIndex(
                                                  index);
                                            },
                                            child: Container(
                                              height: 20,
                                              decoration: new BoxDecoration(
                                                border: Border.all(
                                                  color: model
                                                      .completeAddressSubmitted &&
                                                      model
                                                          .landmarkSubmitted
                                                      ? appColor
                                                      : Colors.grey,
                                                  width: 0.0,
                                                ),
                                                color: index ==
                                                    model
                                                        .selectedAddressTypeIndex
                                                    ? appColor
                                                    : white,
                                                borderRadius:
                                                new BorderRadius.all(
                                                  Radius.elliptical(
                                                    50,
                                                    50,
                                                  ),
                                                ),
                                              ),
                                              child: Wrap(
                                                children: <Widget>[
                                                  Center(
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                        vertical: 5.0,
                                                        horizontal: 5.0,
                                                      ),
                                                      child: Row(
                                                        children: <Widget>[
                                                          Text(
                                                            tag[index],
                                                            style:
                                                            Theme
                                                                .of(
                                                                context)
                                                                .textTheme
                                                                .display2
                                                                .copyWith(
                                                              fontSize:
                                                              12,
                                                              color: model
                                                                  .completeAddressSubmitted &&
                                                                  model
                                                                      .landmarkSubmitted
                                                                  ? index ==
                                                                  model
                                                                      .selectedAddressTypeIndex
                                                                  ? white
                                                                  : appColor
                                                                  : Colors
                                                                  .grey,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 5,
                                                          ),
                                                          Visibility(
                                                            visible: index ==
                                                                model
                                                                    .selectedAddressTypeIndex,
                                                            child: Icon(
                                                              Icons
                                                                  .check_circle_outline,
                                                              size: 14,
                                                              color: white,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
//                                              child: Center(
//                                                child: Text(
//                                                  tag[index],
//                                                  style: Theme.of(context)
//                                                      .textTheme
//                                                      .display2
//                                                      .copyWith(
//                                                        fontSize: 12,
//                                                        color: Colors.grey,
//                                                      ),
//                                                ),
//                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                              ),
                              verticalSizedBoxTwenty(),
                              Consumer<CartBillDetailViewModel>(
                                builder: (BuildContext context,
                                    CartBillDetailViewModel cartModel,
                                    Widget child) {
//                                    return model.state == BaseViewState.Busy
//                                        ? showProgress(context)
//                                        :
                                  return addressModel.isLoading
                                      ? showProgress(context)
                                      : widget.fromWhichScreen[
                                  fromWhichScreen] !=
                                      "4"
                                      ? FormSubmitButton(
                                    title: 'Save Address',
                                    buttonColor: (model
                                        .completeAddressSubmitted &&
                                        model
                                            .landmarkSubmitted) &&
                                        (floorAddressController
                                            .text.length >
                                            0 &&
                                            landMarkAddressController
                                                .text.length >
                                                0)
                                        ? appColor
                                        : Colors.grey[200],
                                    onPressed: () {
                                      if ((model
                                          .completeAddressSubmitted &&
                                          model.landmarkSubmitted &&
                                          (floorAddressController
                                              .text.length >
                                              0 &&
                                              landMarkAddressController
                                                  .text.length >
                                                  0))) {
                                        if (_formKey.currentState
                                            .validate()) {
                                          _formKey.currentState
                                              .save();
                                          FocusScope.of(context)
                                              .requestFocus(
                                              FocusNode());
                                          showLog(
                                              "widget.fromWhichScreen--${widget
                                                  .fromWhichScreen[fromWhichScreen]}");
                                          if (widget.fromWhichScreen[
                                          fromWhichScreen] ==
                                              "6") {
                                            // add address
                                            addressModel
                                                .editOrDeleteAddress(
                                                dynamicMapValue: {
                                                  actionKey:
                                                  addAddress,
                                                  latKey: model
                                                      .initialPosition
                                                      .latitude
                                                      .toString(),
                                                  longKey: model
                                                      .initialPosition
                                                      .longitude
                                                      .toString(),
                                                  addressKey:
                                                  "${model.currentAddress}",
                                                  stateKey:
                                                  model.stateName,
                                                  buildingKey:
                                                  floorAddressController
                                                      .text,
                                                  landmarkKey:
                                                  landMarkAddressController
                                                      .text,
                                                  addressTypeKey: model
                                                      .selectedIndex
                                                      .toString(),
                                                  cityKey: model
                                                      .cityLocality,
                                                  userTypeKey: user,
                                                },
                                                mContext:
                                                context).then(
                                                    (value) =>
                                                {
                                                  if (value !=
                                                      null)
                                                    {
                                                      if (widget
                                                          .fromWhichScreen[fromWhichScreen] ==
                                                          "6")
                                                        {
                                                          Navigator.pop(
                                                              context),
                                                        }
                                                      else
                                                        {
                                                          Navigator.pop(
                                                            context,
                                                            DeliveryAddressSharedPrefModel(
                                                              latitude: model
                                                                  .initialPosition
                                                                  .latitude
                                                                  .toString(),
                                                              longitude: model
                                                                  .initialPosition
                                                                  .longitude
                                                                  .toString(),
                                                              address: "${model
                                                                  .currentAddress}",
                                                              state: model
                                                                  .stateName,
                                                              building: floorAddressController
                                                                  .text,
                                                              landmark: landMarkAddressController
                                                                  .text,
                                                              addressType: model
                                                                  .selectedIndex
                                                                  .toString(),
                                                              city: model
                                                                  .cityLocality,
                                                            ),
                                                          ),
                                                        }
                                                    }
                                                  else
                                                    {}
                                                });
                                          } else {
                                            addressModel
                                                .updateLoader(true);
                                            cartModel
                                                .initCartBillDetailRequest(
                                                addressData: {
                                                  latKey: model
                                                      .initialPosition
                                                      .latitude
                                                      .toString(),
                                                  longKey: model
                                                      .initialPosition
                                                      .longitude
                                                      .toString(),
                                                  addressKey:
                                                  "${model.currentAddress}",
                                                  stateKey:
                                                  model.stateName,
                                                  addressChangeKey:
                                                  "1",
                                                  buildingKey:
                                                  floorAddressController
                                                      .text,
                                                  landmarkKey:
                                                  landMarkAddressController
                                                      .text,
                                                  addressTypeKey: model
                                                      .selectedIndex
                                                      .toString(),
                                                  cityKey: model
                                                      .cityLocality
                                                },
                                                mContext:
                                                context).then(
                                                    (value) =>
                                                {
                                                  if (value !=
                                                      null)
                                                    {
                                                      addressModel
                                                          .updateLoader(false),

                                                      showLog(
                                                          "ConfirmAddressBottomSheet--${cartModel
                                                              .cartBillData
                                                              .distance} --${cartModel
                                                              .cartBillData
                                                              .durationText}"),
                                                      Navigator
                                                          .pop(
                                                        context,
                                                        DeliveryAddressSharedPrefModel(
                                                          latitude:
                                                          model.initialPosition
                                                              .latitude
                                                              .toString(),
                                                          longitude:
                                                          model.initialPosition
                                                              .longitude
                                                              .toString(),
                                                          address:
                                                          "${model
                                                              .currentAddress}",
                                                          state:
                                                          model.stateName,
                                                          building:
                                                          floorAddressController
                                                              .text,
                                                          landmark:
                                                          landMarkAddressController
                                                              .text,
                                                          addressType:
                                                          model.selectedIndex
                                                              .toString(),
                                                          city:
                                                          model.cityLocality,
                                                          addressId:
                                                          widget
                                                              .fromWhichScreen[addressIdKey]
                                                              .toString(),
                                                          distance:
                                                          cartModel.cartBillData
                                                              .distance,
                                                          durationText:
                                                          cartModel.cartBillData
                                                              .durationText,
                                                        ),
                                                      ),

//                                                          Navigator.of(context)
//                                                              .pop(
//                                                            PopWithResults(
//                                                              fromPage:
//                                                                  changeUserAddressScreen,
//                                                              toPage: widget.fromWhichScreen[
//                                                                          cartFromWhichScreen] ==
//                                                                      restaurantDetails
//                                                                  ? cart
//                                                                  : mainHome,
//                                                              results: {
//                                                                "pop_result":
//                                                                    '${model.givenAddressForDelivery}'
//                                                              },
//                                                            ),
//                                                          ),

//                                                                          widget.fromWhichScreen[cartFromWhichScreen] == restaurantDetails
//                                                                              ? navigateToHome(context: context, menuType: 2)
//                                                                              : Navigator.of(context).popUntil(
//                                                                                  ModalRoute.withName(mainHome),
//                                                                                )
                                                    }
                                                  else
                                                    {
                                                      addressModel
                                                          .updateLoader(false),
                                                    }
                                                });
                                          }
                                        }
                                      } else {
                                        showSnackbar(
                                            message:
                                            'Please fill address field',
                                            context: context);
                                      }
                                    },
                                  )
                                      : FormSubmitButton(
                                    title: 'Save Address',
                                    buttonColor: appColor,
                                    onPressed: () {
                                      if (_formKey.currentState
                                          .validate()) {
                                        _formKey.currentState.save();
                                        FocusScope.of(context)
                                            .requestFocus(
                                            FocusNode());

                                        // edit address
                                        addressModel
                                            .editOrDeleteAddress(
                                            oldAddress: widget
                                                .fromWhichScreen[
                                            addressKey],
                                            dynamicMapValue: {
                                              addressIdKey: widget
                                                  .fromWhichScreen[
                                              addressIdKey]
                                                  .toString(),
                                              actionKey:
                                              editAddress,
                                              latKey: model
                                                  .initialPosition
                                                  .latitude
                                                  .toString(),
                                              longKey: model
                                                  .initialPosition
                                                  .longitude
                                                  .toString(),
                                              addressKey:
                                              "${model.currentAddress}",
                                              stateKey:
                                              model.stateName,
                                              buildingKey:
                                              floorAddressController
                                                  .text,
                                              landmarkKey:
                                              landMarkAddressController
                                                  .text,
                                              addressTypeKey: model
                                                  .selectedIndex
                                                  .toString(),
                                              cityKey: model
                                                  .cityLocality,
                                              userTypeKey: user,
                                            },
                                            mContext: context)
                                            .then((value) =>
                                        {
                                          if (value != null)
                                            {
                                              Navigator.pop(
                                                context,
                                                DeliveryAddressSharedPrefModel(
                                                    latitude: model
                                                        .initialPosition
                                                        .latitude
                                                        .toString(),
                                                    longitude: model
                                                        .initialPosition
                                                        .longitude
                                                        .toString(),
                                                    address:
                                                    "${model.currentAddress}",
                                                    state: model
                                                        .stateName,
                                                    building:
                                                    floorAddressController
                                                        .text,
                                                    landmark:
                                                    landMarkAddressController
                                                        .text,
                                                    addressType: model
                                                        .selectedIndex
                                                        .toString(),
                                                    city: model
                                                        .cityLocality,
                                                    addressId: widget
                                                        .fromWhichScreen[
                                                    addressIdKey]
                                                        .toString()),
                                              ),
                                            }
                                          else
                                            {}
                                        });
                                      }
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          });

  TextFormField enterAddressFields(TextEditingController controller,
      String hint) =>
      TextFormField(
        onChanged: (value) {
          setState(() {
            //  showSearchList = true;
          });
        },
        controller: controller,
        style: Theme
            .of(context)
            .textTheme
            .display2
            .copyWith(
          fontSize: 16,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: Theme
              .of(context)
              .textTheme
              .display2
              .copyWith(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      );

//  void _mapViewDragging(CameraPosition position) {
//    if (!isMapDragging) {
//      setState(() {
//        _currentCameraPosition = CameraPosition(
//            target: LatLng(position.target.latitude, position.target.longitude),
//            zoom: 14);
//
//        allMarkers.add(
//          Marker(
//              markerId: MarkerId('MyMarker'),
//              position:
//                  LatLng(position.target.latitude, position.target.longitude),
//              draggable: isMapDragging,
//              icon: pinLocationIcon),
//        );
//        completeAddressLat = position.target.latitude.toString();
//        completeAddressLong = position.target.longitude.toString();
//        isMapDragging = true;
//      });
//    }
//  }

//  void setCustomMapPin() async {
//    pinLocationIcon = await BitmapDescriptor.fromAssetImage(
//        ImageConfiguration(devicePixelRatio: 2.5),
//        'assets/images/marker_pin.png');
//  }

}
