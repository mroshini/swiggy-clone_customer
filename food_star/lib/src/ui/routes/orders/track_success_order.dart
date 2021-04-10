import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:foodstar/generated/l10n.dart';
import 'package:foodstar/src/constants/api_params_keys.dart';
import 'package:foodstar/src/constants/common_strings.dart';
import 'package:foodstar/src/constants/route_path.dart';
import 'package:foodstar/src/core/models/api_models/socket_data_model.dart';
import 'package:foodstar/src/core/provider_viewmodels/common/base_change_notifier_model.dart';
import 'package:foodstar/src/core/provider_viewmodels/common/theme_changer.dart';
import 'package:foodstar/src/core/provider_viewmodels/track_order_view_model.dart';
import 'package:foodstar/src/core/socket/listen_socket_event.dart';
import 'package:foodstar/src/ui/res/colors.dart';
import 'package:foodstar/src/ui/routes/UpcomingOrdersCard.dart';
import 'package:foodstar/src/ui/shared/circle_profile_image.dart';
import 'package:foodstar/src/ui/shared/colored_sized_box.dart';
import 'package:foodstar/src/ui/shared/delivery_and_restaurant_location_widget.dart';
import 'package:foodstar/src/ui/shared/others.dart';
import 'package:foodstar/src/ui/shared/progress_indicator.dart';
import 'package:foodstar/src/ui/shared/sizedbox.dart';
import 'package:foodstar/src/utils/banner_slider_shimmer.dart';
import 'package:foodstar/src/utils/common_navigation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class TrackSuccessOrderScreen extends StatefulWidget {
  final Map<String, String> orderID;

  TrackSuccessOrderScreen({this.orderID});

  @override
  _TrackSuccessOrderScreenState createState() =>
      _TrackSuccessOrderScreenState();
}

class _TrackSuccessOrderScreenState extends State<TrackSuccessOrderScreen> {
  // Socket socket;

  @override
  void initState() {
    super.initState();
    Provider.of<TrackOrderViewModel>(context, listen: false)
        .callOrderDetailsApiRequest(widget.orderID[orderIDKey], context);
//    socket = io(socketUrl, <String, dynamic>{
//      'transports': ['websocket'],
//      'autoConnect': false,
//    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TrackOrderViewModel>(
//        model: TrackOrderViewModel(context: context),
//        onModelReady: (model) => model.callOrderDetailsApiRequest(
//            widget.orderID[orderIDKey], context),
        builder: (BuildContext context, TrackOrderViewModel trackOrder,
            Widget child) {
      return trackOrder.state == BaseViewState.Busy
          ? Scaffold(
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  showProgress(context),
                  verticalSizedBoxTwenty(),
                  Text(
                    'Fetching Order Details',
                    style: Theme.of(context).textTheme.display1,
                  )
                ],
              ),
            )
          : Scaffold(
              body: Column(
                children: [
                  Expanded(
                    flex: 3,
                    child: Stack(
                      children: <Widget>[
                        Stack(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height / 1.4,
                              child: GoogleMap(
                                mapType: MapType.normal,
                                initialCameraPosition:
                                    trackOrder.currentCameraPosition,
                                myLocationButtonEnabled: false,
                                myLocationEnabled: false,
                                compassEnabled: true,
                                onMapCreated:
                                    (GoogleMapController googleMapController) {
                                  trackOrder.mapController
                                      .complete(googleMapController);
//                                      setState(() {
//                                        trackOrder.createRoute();
//                                      });
                                  // trackOrder.sendRequest();
                                },
                                markers: trackOrder.markers,
                                polylines: trackOrder.polyLines,
//                                    markers: Set.of((trackOrder.marker != null)
//                                        ? [trackOrder.marker]
//                                        : []),
//                                    circles: Set.of((trackOrder.circle != null)
//                                        ? [trackOrder.circle]
//                                        : []),
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
                          ],
                        ),
                        DraggableScrollableSheet(
                          maxChildSize: 1.0,
                          initialChildSize: 0.4,
                          minChildSize: 0.3, //.50,
                          builder: (context, scrollController) {
                            return Scaffold(
                              body: Consumer<ThemeManager>(
                                builder: (BuildContext context,
                                    ThemeManager theme, Widget child) {
                                  return Container(
                                    // padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                    decoration: BoxDecoration(
                                      border: theme.darkMode
                                          ? Border.all()
                                          : Border.all(
                                              color: Colors.grey[200],
                                              width: .5),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                      ),
                                    ),
                                    child: SingleChildScrollView(
                                      controller: scrollController,
                                      child: Container(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.max,
                                          children: <Widget>[
                                            Container(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  children: <Widget>[
                                                    dragIcon(),
                                                    Visibility(
                                                      visible: trackOrder
                                                              .boyDetail !=
                                                          null,
                                                      child: verticalSizedBox(),
                                                    ),
                                                    if (trackOrder.boyDetail ==
                                                        null)
                                                      SizedBox()
                                                    else
                                                      Column(
                                                        children: [
//                                                          Row(
//                                                            mainAxisAlignment:
//                                                                MainAxisAlignment
//                                                                    .start,
//                                                            crossAxisAlignment:
//                                                                CrossAxisAlignment
//                                                                    .start,
//                                                            children: <Widget>[
//                                                              Container(
//                                                                height: 35,
//                                                                width: 35,
//                                                                child:
//                                                                    CircleAvatar(
//                                                                  backgroundColor:
//                                                                      Colors.grey[
//                                                                          300],
//                                                                  child: Center(
//                                                                    child: Icon(
//                                                                      Icons
//                                                                          .photo_album,
//                                                                      size: 20,
//                                                                      color: Colors
//                                                                          .black,
//                                                                    ),
//                                                                  ),
//                                                                ),
//                                                              ),
//                                                              horizontalSizedBox(),
//                                                              Flexible(
//                                                                child: Column(
//                                                                  crossAxisAlignment:
//                                                                      CrossAxisAlignment
//                                                                          .start,
//                                                                  mainAxisAlignment:
//                                                                      MainAxisAlignment
//                                                                          .start,
//                                                                  children: <
//                                                                      Widget>[
//                                                                    RichText(
//                                                                      overflow:
//                                                                          TextOverflow
//                                                                              .ellipsis,
//                                                                      text:
//                                                                          TextSpan(
//                                                                        children: [
////                                                                  TextSpan(
////                                                                    text: trackOrder.orderData.orderRecieveText ==
////                                                                            ""
////                                                                        ? ""
////                                                                        : '${trackOrder.orderData.orderRecieveText}',
////                                                                    style: Theme.of(
////                                                                            context)
////                                                                        .textTheme
////                                                                        .display3
////                                                                        .copyWith(
////                                                                            color: trackOrder.orderData.orderRecieveText.isNotEmpty
////                                                                                ? trackOrder.orderData.orderRecieveText.startsWith("Pending") ? darkRed : darkGreen
////                                                                                : white),
////                                                                  ),
////                                                                  TextSpan(
////                                                                    text: " - ",
////                                                                    style:
////                                                                        TextStyle(
////                                                                      fontSize:
////                                                                          14.0,
////                                                                      fontStyle:
////                                                                          FontStyle
////                                                                              .normal,
////                                                                    ),
////                                                                  ),
//                                                                          TextSpan(
//                                                                            text:
//                                                                                '${trackOrder.orderData.orderDetails}',
//                                                                            style: Theme.of(context).textTheme.display3.copyWith(
//                                                                                  fontWeight: FontWeight.w500,
//                                                                                ),
//                                                                          ),
//                                                                        ],
//                                                                      ),
//                                                                    ),
//                                                                    verticalSizedBox(),
//                                                                    Text(
//                                                                      '${trackOrder.orderData.driverStatusText}',
//                                                                      style: Theme.of(
//                                                                              context)
//                                                                          .textTheme
//                                                                          .display1,
//                                                                    ),
//                                                                  ],
//                                                                ),
//                                                              ),
//                                                            ],
//                                                          ),
                                                          verticalSizedBox(),
                                                          Visibility(
                                                            maintainSize: false,
                                                            visible: trackOrder
                                                                    .boyDetail !=
                                                                null,
                                                            child: Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: <
                                                                  Widget>[
                                                                Flexible(
                                                                  child: Row(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    children: <
                                                                        Widget>[
                                                                      trackOrder.boyDetail !=
                                                                              null
                                                                          ? ClipRRect(
                                                                              borderRadius: BorderRadius.circular(20.0),
                                                                              child: CachedNetworkImage(
                                                                                imageUrl: trackOrder.boyDetail.src,
                                                                                placeholder: (context, url) => imageShimmer(),
                                                                                errorWidget: (context, url, error) => imageShimmer(),
                                                                                fit: BoxFit.fill,
                                                                                height: 30,
                                                                                width: 30,
                                                                              ),
                                                                            )
                                                                          : circleProfileImage(
                                                                              mContext: context,
                                                                              image: 'assets/images/delivery.png',
                                                                              heightValue: 35,
                                                                              widthValue: 35,
                                                                            ),
                                                                      horizontalSizedBox(),
                                                                      Flexible(
                                                                        child:
                                                                            Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          children: <
                                                                              Widget>[
                                                                            Text(
                                                                              trackOrder.boyDetail == null ? "" : '${trackOrder.boyDetail.username}',
                                                                              style: Theme.of(context).textTheme.display3,
                                                                            ),
                                                                            verticalSizedBox(),
                                                                            Text(
                                                                              trackOrder.boyDetail == null ? "" : '${trackOrder.boyDetail.phoneNumber}',
                                                                              style: Theme.of(context).textTheme.display1,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Flexible(
                                                                  child: Row(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .end,
                                                                    children: <
                                                                        Widget>[
                                                                      GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          UrlLauncher.launch(
                                                                              'tel:+${trackOrder.boyDetail.phoneNumber}');
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          height:
                                                                              30,
                                                                          width:
                                                                              30,
                                                                          child:
                                                                              CircleAvatar(
                                                                            backgroundColor:
                                                                                darkGreen,
                                                                            child:
                                                                                Icon(
                                                                              Icons.call,
                                                                              color: white,
                                                                              size: 17,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      horizontalSizedBox(),
//                                                                          Container(
//                                                                            height:
//                                                                                30,
//                                                                            width:
//                                                                                30,
//                                                                            child:
//                                                                                CircleAvatar(
//                                                                              backgroundColor: darkGreen,
//                                                                              child: Icon(
//                                                                                Icons.comment,
//                                                                                color: white,
//                                                                                size: 15,
//                                                                              ),
//                                                                            ),
//                                                                          ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    Visibility(
                                                        visible: trackOrder
                                                                .boyDetail !=
                                                            null,
                                                        child:
                                                            verticalSizedBox()),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Visibility(
                                                visible: trackOrder.boyDetail !=
                                                    null,
                                                child:
                                                    VerticalColoredSizedBox()),
                                            Container(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    verticalSizedBox(),
                                                    Text(
                                                      S
                                                          .of(context)
                                                          .deliveryDetails,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .display3
                                                          .copyWith(
                                                            fontSize: 15,
                                                          ),
                                                    ),
                                                    verticalSizedBoxTwenty(),
                                                    InkWell(
                                                      onTap: () {
                                                        Navigator.pushNamed(
                                                            context,
                                                            userLocationScreen,
                                                            arguments: {
                                                              latitudeKey: trackOrder
                                                                  .resturantLocation
                                                                  .latitude
                                                                  .toString(),
                                                              longitudeKey:
                                                                  trackOrder
                                                                      .resturantLocation
                                                                      .longitude
                                                                      .toString()
                                                            });
                                                      },
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          Container(
                                                            height: 30,
                                                            width: 30,
                                                            child: CircleAvatar(
                                                              backgroundColor:
                                                                  darkRed,
                                                              child: Center(
                                                                child: Icon(
                                                                  Icons
                                                                      .restaurant_menu,
                                                                  size: 20,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          horizontalSizedBox(),
                                                          Flexible(
                                                            child:
                                                                deliveryAndRestaurantLocationColumn(
                                                              context: context,
                                                              lineOne:
                                                                  '${trackOrder.restaurantDetail.name}',
                                                              styleOne: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .display2
                                                                  .copyWith(
                                                                    fontSize:
                                                                        15,
                                                                  ),
                                                              lineTwo:
                                                                  '${trackOrder.restaurantDetail.location}',
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    verticalSizedBoxTwenty(),
                                                    InkWell(
                                                      onTap: () {
//                                                      navigateToUserLocation(
//                                                          context: context,
//                                                          args: {
//                                                            fromWhichScreen: "3"
//                                                          }); // 3 after order completed tracking

                                                        Navigator.pushNamed(
                                                            context,
                                                            userLocationScreen,
                                                            arguments: {
                                                              latitudeKey: trackOrder
                                                                  .userLocation
                                                                  .latitude
                                                                  .toString(),
                                                              longitudeKey:
                                                                  trackOrder
                                                                      .userLocation
                                                                      .longitude
                                                                      .toString()
                                                            });
                                                      },
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          Container(
                                                            height: 30,
                                                            width: 30,
                                                            decoration:
                                                                BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .orange),
                                                            ),
                                                            child: Center(
                                                              child: Icon(
                                                                Icons
                                                                    .fiber_manual_record,
                                                                color: Colors
                                                                    .orange,
                                                                size: 10,
                                                              ),
                                                            ),
                                                          ),
                                                          horizontalSizedBox(),
                                                          Flexible(
                                                            child:
                                                                deliveryAndRestaurantLocationColumn(
                                                              context: context,
                                                              lineOne: S
                                                                  .of(context)
                                                                  .deliverLocation,
                                                              lineTwo:
                                                                  '${trackOrder.orderData.address}',
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    verticalSizedBox(),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            VerticalColoredSizedBox(),
                                            Container(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    verticalSizedBox(),
                                                    Text(
                                                      'Order info',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .display2
                                                          .copyWith(
                                                            fontSize: 15,
                                                          ),
                                                    ),
                                                    verticalSizedBoxTwenty(),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text(
                                                          '${trackOrder.orderData.orderid}',
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .display2
                                                                  .copyWith(
                                                                    fontSize:
                                                                        15,
                                                                  ),
                                                        ),
                                                        Text(
                                                          '${trackOrder.orderData.orderTime}',
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .display2
                                                                  .copyWith(
                                                                    fontSize:
                                                                        15,
                                                                  ),
                                                        ),
                                                      ],
                                                    ),
                                                    verticalSizedBox(),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            VerticalColoredSizedBox(),
                                            Container(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    verticalSizedBox(),
                                                    Text(
                                                      S.of(context).orderItemss,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .display2
                                                          .copyWith(
                                                            fontSize: 15,
                                                          ),
                                                    ),
                                                    //verticalSizedBox(),
                                                    ListView.builder(
                                                      itemCount: trackOrder
                                                          .orderItems.length,
                                                      shrinkWrap: true,
                                                      physics:
                                                          NeverScrollableScrollPhysics(),
                                                      itemBuilder:
                                                          (context, index) {
                                                        return Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      5.0),
                                                          child:
                                                              paymentDetailRow(
                                                            showSubTextOne:
                                                                false,
                                                            subTextValueOne:
                                                                '${trackOrder.orderItems[index].quantity} items',
                                                            styleSubTextOne:
                                                                Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .display2
                                                                    .copyWith(
                                                                      fontSize:
                                                                          12,
                                                                    ),
                                                            textValueOne:
                                                                '${trackOrder.orderItems[index].quantity} X ${trackOrder.orderItems[index].foodItem}',
                                                            styleOne: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .display2
                                                                .copyWith(
                                                                  fontSize: 14,
                                                                ),
                                                            textValueTwo:
                                                                '${trackOrder.currencySymbol} ${trackOrder.orderItems[index].quantity * trackOrder.orderItems[index].price}',
                                                            styleTwo: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .display2
                                                                .copyWith(
                                                                  fontSize: 14,
                                                                ),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Visibility(
                                                visible: trackOrder
                                                        .orderData.orderNote !=
                                                    "",
                                                child:
                                                    VerticalColoredSizedBox()),
                                            Visibility(
                                              visible: trackOrder
                                                      .orderData.orderNote !=
                                                  "",
                                              child: Container(
                                                child: Text(
                                                  'Order Note: ${trackOrder.orderData.orderNote}',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .display1,
                                                ),
                                              ),
                                            ),
                                            VerticalColoredSizedBox(),
                                            Container(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Column(
                                                  children: <Widget>[
                                                    verticalSizedBox(),
                                                    paymentDetailRow(
                                                      textValueOne: S
                                                          .of(context)
                                                          .paymentDetails,
                                                      styleOne:
                                                          Theme.of(context)
                                                              .textTheme
                                                              .display3,
                                                    ),
                                                    verticalSizedBox(),
                                                    divider(),
                                                    verticalSizedBox(),
                                                    Visibility(
                                                      visible: trackOrder
                                                              .orderData
                                                              .itemStrikePriceTotal >
                                                          trackOrder.orderData
                                                              .totalPrice,
                                                      child: paymentDetailRow(
                                                        showSubTextOne: true,
                                                        // subTextValueOne:
                                                        textValueOne:
                                                            CommonStrings
                                                                .originalPrice,
                                                        styleOne:
                                                            Theme.of(context)
                                                                .textTheme
                                                                .display2
                                                                .copyWith(
                                                                  fontSize: 14,
                                                                ),
                                                        textValueTwo:
                                                            '${trackOrder.currencySymbol} ${trackOrder.orderData.itemStrikePriceTotal}',
                                                        styleTwo:
                                                            Theme.of(context)
                                                                .textTheme
                                                                .display2
                                                                .copyWith(
                                                                  fontSize: 14,
                                                                  decoration:
                                                                      TextDecoration
                                                                          .lineThrough,
                                                                ),
                                                      ),
                                                    ),
//                                                        Visibility(
//                                                          visible: trackOrder
//                                                                  .orderData
//                                                                  .offerPrice !=
//                                                              0,
//                                                          child:
//                                                              paymentDetailRow(
//                                                            showSubTextOne:
//                                                                true,
//                                                            textValueOne:
//                                                                CommonStrings
//                                                                    .offerDiscount,
//                                                            styleOne: Theme.of(
//                                                                    context)
//                                                                .textTheme
//                                                                .display2
//                                                                .copyWith(
//                                                                  fontSize: 14,
//                                                                ),
//                                                            textValueTwo:
//                                                                '- ${trackOrder.currencySymbol} ${trackOrder.orderData.offerPrice}',
//                                                            styleTwo: Theme.of(
//                                                                    context)
//                                                                .textTheme
//                                                                .display2
//                                                                .copyWith(
//                                                                  fontSize: 14,
//                                                                ),
//                                                          ),
//                                                        ),
                                                    verticalSizedBox(),
                                                    paymentDetailRow(
                                                      showSubTextOne: true,
                                                      textValueOne: S
                                                          .of(context)
                                                          .priceEstimated,
                                                      styleOne:
                                                          Theme.of(context)
                                                              .textTheme
                                                              .display2
                                                              .copyWith(
                                                                fontSize: 14,
                                                              ),
                                                      textValueTwo:
                                                          '${trackOrder.currencySymbol} ${trackOrder.orderData.totalPrice}',
                                                      styleTwo:
                                                          Theme.of(context)
                                                              .textTheme
                                                              .display2
                                                              .copyWith(
                                                                fontSize: 14,
                                                              ),
                                                    ),
//                                                        Align(
//                                                          alignment: Alignment
//                                                              .centerRight,
//                                                          child: Text(
//                                                            '(${trackOrder.currencySymbol} ${trackOrder.orderItems[0].originalPrice} - ${trackOrder.currencySymbol} ${trackOrder.orderItems[0].originalPrice} = ${trackOrder.currencySymbol} ${trackOrder.orderItems[0].originalPrice - model.cartBillData.itemOfferPrice})',
//                                                            style: Theme.of(
//                                                                    context)
//                                                                .textTheme
//                                                                .display2
//                                                                .copyWith(
//                                                                  fontSize: 14,
//                                                                ),
//                                                          ),
//                                                        ),
                                                    verticalSizedBox(),
                                                    Visibility(
                                                      visible: trackOrder
                                                              .orderData
                                                              .offerPrice !=
                                                          0,
                                                      child: paymentDetailRow(
                                                        textValueOne:
                                                            CommonStrings
                                                                .offerDiscount,
                                                        styleOne:
                                                            Theme.of(context)
                                                                .textTheme
                                                                .display2
                                                                .copyWith(
                                                                  fontSize: 14,
                                                                ),
                                                        textValueTwo:
                                                            '${trackOrder.currencySymbol} ${trackOrder.orderData.offerPrice}',
                                                        styleTwo:
                                                            Theme.of(context)
                                                                .textTheme
                                                                .display2
                                                                .copyWith(
                                                                  fontSize: 14,
                                                                ),
                                                      ),
                                                    ),
                                                    verticalSizedBox(),
                                                    Visibility(
                                                      visible: trackOrder
                                                              .orderData
                                                              .sTax1 !=
                                                          0,
                                                      child: paymentDetailRow(
                                                        showSubTextOne: false,
                                                        textValueOne:
                                                            CommonStrings.tax,
                                                        styleOne:
                                                            Theme.of(context)
                                                                .textTheme
                                                                .display2
                                                                .copyWith(
                                                                  fontSize: 14,
                                                                ),
                                                        textValueTwo:
                                                            '${trackOrder.currencySymbol} ${trackOrder.orderData.sTax1}',
                                                        styleTwo:
                                                            Theme.of(context)
                                                                .textTheme
                                                                .display2
                                                                .copyWith(
                                                                  fontSize: 14,
                                                                ),
                                                      ),
                                                    ),
                                                    verticalSizedBox(),
                                                    paymentDetailRow(
                                                      showSubTextOne: false,
                                                      textValueOne:
                                                          CommonStrings
                                                              .deliveryCharges,
                                                      styleOne:
                                                          Theme.of(context)
                                                              .textTheme
                                                              .display2
                                                              .copyWith(
                                                                fontSize: 14,
                                                              ),
                                                      textValueTwo:
                                                          '${trackOrder.currencySymbol} ${trackOrder.orderData.delCharge}',
                                                      styleTwo:
                                                          Theme.of(context)
                                                              .textTheme
                                                              .display2
                                                              .copyWith(
                                                                fontSize: 14,
                                                              ),
                                                    ),
                                                    verticalSizedBox(),
                                                    Visibility(
                                                      visible: trackOrder
                                                              .orderData
                                                              .delChargeTaxPrice !=
                                                          0,
                                                      child: paymentDetailRow(
                                                        showSubTextOne: false,
                                                        textValueOne: CommonStrings
                                                            .deliveryChargeTax,
                                                        styleOne:
                                                            Theme.of(context)
                                                                .textTheme
                                                                .display2
                                                                .copyWith(
                                                                  fontSize: 14,
                                                                ),
                                                        textValueTwo:
                                                            '${trackOrder.currencySymbol} ${trackOrder.orderData.delChargeTaxPrice}',
                                                        styleTwo:
                                                            Theme.of(context)
                                                                .textTheme
                                                                .display2
                                                                .copyWith(
                                                                  fontSize: 14,
                                                                ),
                                                      ),
                                                    ),
                                                    verticalSizedBox(),
                                                    Visibility(
                                                      visible: trackOrder
                                                              .orderData
                                                              .couponPrice !=
                                                          0,
                                                      child: paymentDetailRow(
                                                        textValueOne:
                                                            CommonStrings
                                                                .couponDiscount,
                                                        styleOne:
                                                            Theme.of(context)
                                                                .textTheme
                                                                .display2
                                                                .copyWith(
                                                                  fontSize: 14,
                                                                ),
                                                        textValueTwo:
                                                            '- ${trackOrder.currencySymbol} ${trackOrder.orderData.discountPrice}',
                                                        styleTwo:
                                                            Theme.of(context)
                                                                .textTheme
                                                                .display2
                                                                .copyWith(
                                                                  fontSize: 14,
                                                                ),
                                                      ),
                                                    ),
//                                      verticalSizedBox(),
//                                      paymentDetailRow(
//                                        textValueOne:
//                                            S.of(context).convenienceFee,
//                                        styleOne: Theme.of(context)
//                                            .textTheme
//                                            .display2
//                                            .copyWith(
//                                              fontSize: 14,
//                                            ),
//                                        textValueTwo: S.of(context).free,
//                                        styleTwo: Theme.of(context)
//                                            .textTheme
//                                            .display2
//                                            .copyWith(
//                                              fontSize: 14,
//                                            ),
//                                      ),
                                                    verticalSizedBox(),
//                                                        Row(
//                                                          crossAxisAlignment:
//                                                              CrossAxisAlignment
//                                                                  .start,
//                                                          mainAxisAlignment:
//                                                              MainAxisAlignment
//                                                                  .spaceBetween,
//                                                          children: <Widget>[
//                                                            Text(
//                                                              S
//                                                                  .of(context)
//                                                                  .deliveryFee,
//                                                              style: Theme.of(
//                                                                      context)
//                                                                  .textTheme
//                                                                  .display2
//                                                                  .copyWith(
//                                                                    fontSize:
//                                                                        14,
//                                                                  ),
//                                                            ),
//                                                            Text(
//                                                              '${trackOrder.currencySymbol} ${trackOrder.orderData.delCharge}',
//                                                              style: Theme.of(
//                                                                      context)
//                                                                  .textTheme
//                                                                  .display2
//                                                                  .copyWith(
//                                                                    fontSize:
//                                                                        14,
//                                                                  ),
//                                                            ),
////                                          RichText(
////                                            text: TextSpan(
////                                              children: [
////                                                TextSpan(
////                                                  text: '( 15.000 - ',
////                                                  style: Theme.of(context)
////                                                      .textTheme
////                                                      .display2
////                                                      .copyWith(
////                                                        fontSize: 14,
////                                                      ),
////                                                ),
////                                                TextSpan(
////                                                  text: "6.000 ) ",
////                                                  style: Theme.of(context)
////                                                      .textTheme
////                                                      .display2
////                                                      .copyWith(
////                                                        fontSize: 15,
////                                                        color: blue,
////                                                      ),
////                                                ),
////                                                TextSpan(
////                                                  text: '9.000',
////                                                  style: Theme.of(context)
////                                                      .textTheme
////                                                      .display2
////                                                      .copyWith(
////                                                        fontSize: 15,
////                                                      ),
////                                                ),
////                                              ],
////                                            ),
////                                          ),
//                                                          ],
//                                                        ),
                                                    Visibility(
                                                      visible: trackOrder
                                                              .orderData
                                                              .discountPrice !=
                                                          "0.00",
                                                      child: Text(
                                                        'You Saved ${trackOrder.currencySymbol} ${trackOrder.orderData.discountPrice} on the bill',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .display2
                                                            .copyWith(
                                                                fontSize: 14,
                                                                color: blue),
                                                      ),
                                                    ),
                                                    divider(),
                                                    verticalSizedBox(),
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        horizontalSizedBox(),
                                                        Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: <Widget>[
                                                            Text(
                                                              '${trackOrder.currencySymbol} ${trackOrder.orderData.grandTotal}',
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .display1
                                                                  .copyWith(
                                                                      fontSize:
                                                                          17.0),
                                                            ),
//                                                                horizontalSizedBox(),
//                                                                GestureDetector(
//                                                                  onTap: () {},
//                                                                  child:
//                                                                      Container(
//                                                                    height: 30,
//                                                                    width: 50,
//                                                                    decoration:
//                                                                        BoxDecoration(
//                                                                      borderRadius:
//                                                                          BorderRadius.circular(
//                                                                              20.0),
//                                                                      color:
//                                                                          appColor,
//                                                                    ),
//                                                                    child:
//                                                                        Center(
//                                                                      child:
//                                                                          Text(
//                                                                        S
//                                                                            .of(context)
//                                                                            .cash,
//                                                                        style: Theme.of(context)
//                                                                            .textTheme
//                                                                            .display2
//                                                                            .copyWith(
//                                                                              color: white,
//                                                                            ),
//                                                                      ),
//                                                                    ),
//                                                                  ),
//                                                                ),
                                                          ],
                                                        ),
                                                        Spacer(),
                                                        Text(
                                                            '${trackOrder.currencySymbol} ${trackOrder.orderData.grandTotal}',
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .display3),
                                                      ],
                                                    ),
                                                    verticalSizedBox(),
//                                                        Container(
//                                                          width: MediaQuery.of(
//                                                                  context)
//                                                              .size
//                                                              .width,
//                                                          child: OutlineButton(
//                                                            splashColor:
//                                                                Colors.grey,
//                                                            shape:
//                                                                RoundedRectangleBorder(
//                                                              borderRadius:
//                                                                  BorderRadius
//                                                                      .circular(
//                                                                8.0,
//                                                              ),
//                                                            ),
//                                                            highlightElevation:
//                                                                0,
//                                                            borderSide: BorderSide(
//                                                                color:
//                                                                    darkGreen),
//                                                            child: Text(
//                                                              S
//                                                                  .of(context)
//                                                                  .needHelp,
//                                                              style: Theme.of(
//                                                                      context)
//                                                                  .textTheme
//                                                                  .display3
//                                                                  .copyWith(
//                                                                    color:
//                                                                        darkGreen,
//                                                                    fontSize:
//                                                                        16.0,
//                                                                  ),
//                                                            ),
//                                                            onPressed: () {},
//                                                          ),
//                                                        ),
//                                                        verticalSizedBox(),
//                                                        Center(
//                                                          child: Text(
//                                                            S
//                                                                .of(context)
//                                                                .cancelOrder,
//                                                            style: Theme.of(
//                                                                    context)
//                                                                .textTheme
//                                                                .display3
//                                                                .copyWith(
//                                                                  color:
//                                                                      darkRed,
//                                                                  fontSize:
//                                                                      16.0,
//                                                                  fontWeight:
//                                                                      FontWeight
//                                                                          .w800,
//                                                                ),
//                                                          ),
//                                                        ),
                                                    Visibility(
                                                      visible: trackOrder
                                                              .orderData
                                                              .status ==
                                                          "0",
                                                      child: Container(
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        child: OutlineButton(
                                                          splashColor:
                                                              Colors.grey,
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8.0)),
                                                          highlightElevation: 0,
                                                          borderSide:
                                                              BorderSide(
                                                                  color:
                                                                      darkRed),
                                                          child: Text(
                                                            S
                                                                .of(context)
                                                                .cancelOrder,
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .display3
                                                                .copyWith(
                                                                  color:
                                                                      darkRed,
                                                                  fontSize:
                                                                      16.0,
                                                                ),
                                                          ),
                                                          onPressed: () {
                                                            trackOrder
                                                                .cancelOrder(
                                                                    context:
                                                                        context,
                                                                    ordersData: {
                                                                  orderIDKey:
                                                                      trackOrder
                                                                          .orderData
                                                                          .id,
                                                                  userTypeKey:
                                                                      user,
                                                                }).then(
                                                                    (value) => {
                                                                          if (value !=
                                                                              null)
                                                                            {
                                                                              showInfoAlertDialog(context: context, response: 'Order cancelled successfully').then((value) => {
                                                                                    if (value)
                                                                                      {
                                                                                        Navigator.pop(context),
                                                                                      }
                                                                                  })
                                                                            }
                                                                        });
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                    verticalSizedBoxTwenty(),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                        StreamBuilder<SocketDataModel>(
                            initialData: SocketDataModel(
                                status: SocketEventStatus.none, orderId: 0),
                            stream: ListenSocketEvents(context: context)
                                .connectionStatusController
                                .stream,
                            builder: (context,
                                AsyncSnapshot<SocketDataModel> snapshot) {
                              return Visibility(
                                visible: snapshot.data.status !=
                                        SocketEventStatus.none
                                    ? true
                                    : false,
                                child: GestureDetector(
                                  onTap: () {
                                    //  updateClicked(false);
                                    ListenSocketEvents(
                                      context: context,
                                    ).connectionStatusController.add(
                                          SocketDataModel(
                                              status: SocketEventStatus.none,
                                              orderId: 0),
                                        );
                                    snapshot.data.status ==
                                            SocketEventStatus.delivered
                                        ? Navigator.pushNamed(
                                            context,
                                            rateOrder,
                                            arguments: snapshot.data.orderId,
                                          )
                                        : trackOrder.refreshPageAfterSocketEmit(
                                            orderId: snapshot.data.orderId
                                                .toString(),
                                          );
                                  },
                                  child: Align(
                                    alignment: Alignment.bottomCenter,
                                    // child: Text('${snapshot.data}'),
                                    child: UpcomingOrdersCard(),
                                  ),
                                ),
                              );
                            }),
                        Visibility(
                          visible: trackOrder.cancelOrderLoader,
                          child: Align(
                            alignment: Alignment.center,
                            child: Container(
                              color: Colors.transparent,
                              child: showProgress(context),
                              height: MediaQuery.of(context).size.height,
                            ),
                          ),
                        ),
//                        Align(
//                          alignment: Alignment.bottomCenter,
//                          // child: Text('${snapshot.data}'),
//                          child: UpcomingOrdersCard(),
//                        ),

//                            GestureDetector(
//                              onTap: () {
//                                //  updateClicked(false);
////                                ListenSocketEvents(
////                                        context: context, socket: socket)
////                                    .connectionStatusController
////                                    .add(SocketDataModel(
////                                        status: SocketEventStatus.none,
////                                        orderId: 0));
////                                snapshot.data.status ==
////                                        SocketEventStatus.delivered
////                                    ? Navigator.pushNamed(context, rateOrder,
////                                        arguments: snapshot.data.orderId)
////                                    : Navigator.pushNamed(
////                                        context, trackOrderRoute, arguments: {
////                                        orderIDKey: "${snapshot.data.orderId}"
////                                      });
//                              },
//                              child: Align(
//                                alignment: Alignment.bottomCenter,
//                                // child: Text('${snapshot.data}'),
//                                child: UpcomingOrdersCard(
//                                    acceptOrNewOrders:
//                                        "Order handovered to delivery boy"),
//                              ),
//                            ),
                      ],
                    ),
                  ),
                ],
              ),
            );
    });
  }
}
