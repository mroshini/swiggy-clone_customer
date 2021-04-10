import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:foodstar/src/constants/api_params_keys.dart';
import 'package:foodstar/src/constants/api_urls.dart';
import 'package:foodstar/src/constants/common_strings.dart';
import 'package:foodstar/src/constants/route_path.dart';
import 'package:foodstar/src/core/models/api_models/current_order_api_model.dart';
import 'package:foodstar/src/core/models/api_models/home_restaurant_list_api_model.dart';
import 'package:foodstar/src/core/models/arguments_model/restaurant_arg_model.dart';
import 'package:foodstar/src/core/models/sample_models/home_model_data.dart';
import 'package:foodstar/src/core/provider_viewmodels/common/base_change_notifier_model.dart';
import 'package:foodstar/src/core/provider_viewmodels/home_restaurant_list_view_model.dart';
import 'package:foodstar/src/ui/res/colors.dart';
import 'package:foodstar/src/ui/routes/search/sort_filter_screen.dart';
import 'package:foodstar/src/ui/shared/home_category_shimmer.dart';
import 'package:foodstar/src/ui/shared/home_search_listView_widget.dart';
import 'package:foodstar/src/ui/shared/sizedbox.dart';
import 'package:foodstar/src/utils/banner_slider_shimmer.dart';
import 'package:foodstar/src/utils/restaurant_info_list_shimmer.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FoodStarScreen extends StatefulWidget {
  @override
  _FoodStarScreenState createState() => _FoodStarScreenState();
}

class _FoodStarScreenState extends State<FoodStarScreen> {
//    with AutomaticKeepAliveClientMixin {
  var _homeInfo = HomeModelData().homeInfo;
  var _imagePath = HomeModelData().imagePath;
  bool showFilter = false;

  RestaurantsArgModel restaurantArgs;
  SharedPreferences prefs;
  HomeRestaurantListViewModel model;

  @override
  void initState() {
    super.initState();
    model = Provider.of<HomeRestaurantListViewModel>(context, listen: false);
    model.getLocationLatAndLong();
    model.currentTrackOrderApiRequest(context);
    model.getLocation(firstStatus: "1", buildContext: context);
    model.updateCategoriesIndex(0);

    showLog("HomeRestaurantListViewModel-accessToken--${model.accessToken}");
    // model.getCurrentLocationFromLocator(firstStatus: "1");
  }

  initPref() async {
    if (prefs == null) prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    //super.build(context);
    showLog("language--lan");
    model.getAccessToken();
//    Provider.of<HomeRestaurantListViewModel>(context, listen: false)
//        .askLocationPermission(firstStatus: "1");
//    Provider.of<HomeRestaurantListViewModel>(context, listen: false)
//        .getCurrentLocationFromLocator(firstStatus: "1");
    showLog("HomeRestaurantListViewModel-accessToken--${model.accessToken}");

    return Consumer<HomeRestaurantListViewModel>(
      builder: (BuildContext context, HomeRestaurantListViewModel model,
          Widget child) {
        return Scaffold(
//          appBar: AppBar(
//            automaticallyImplyLeading: false,
//            elevation: 1.0,
//            title: Material(
//              color: transparent,
//              child: InkWell(
//                onTap: () async {
////                  navigateToUserLocation(
////                      context: context, args: {fromWhichScreen: "1"});
//
//                  await Navigator.pushNamed(
//                    context,
//                    manageAddress, //changeUserAddressScreen,
//                    arguments: {
//                      fromWhichScreen: "1",
//                      latitudeKey: model.latitude,
//                      longitudeKey: model.longitude,
//                    },
//                  ).then((value) async => {
//                        if (value != null)
//                          {
//                            // model.updateCategoriesIndex(null),
//                            await model.updateDbValuesAfterChangeLocation(),
//                            model.getRestaurantDataApiRequest(
//                              firstStatus: "1",
//                              fromFilter: false,
//                              showProgress: true,
//                            ),
//                          },
//                        showLog("changeUserAddressScreen address-- ${value}"),
//                      });
//                },
//                child: model.currentAddress.isNotEmpty
////                    ? Container(
////                        width: 160,
////                        child: Row(
////                          children: <Widget>[
////                            Icon(Icons.location_on),
////                            horizontalSizedBoxFive(),
////                            Flexible(
////                              child: Text(
////                                model.currentAddress,
////                                //overflow: TextOverflow.ellipsis,
////                                style: Theme.of(context)
////                                    .textTheme
////                                    .display1
////                                    .copyWith(fontSize: 14),
////                              ),
////                            ),
////                          ],
////                        ),
////                      )
//                    ? model.addressType.isEmpty
//                        ? Container(
//                            width: 160,
//                            child: Row(
//                              children: <Widget>[
//                                Icon(Icons.location_on),
//                                horizontalSizedBoxFive(),
//                                Flexible(
//                                  child: Text(
//                                    model.currentAddress,
//                                    //overflow: TextOverflow.ellipsis,
//                                    style: Theme.of(context)
//                                        .textTheme
//                                        .display1
//                                        .copyWith(fontSize: 14),
//                                  ),
//                                ),
//                              ],
//                            ),
//                          )
//                        : Container(
//                            width: 160,
//                            child: Row(
//                              children: <Widget>[
//                                Icon(Icons.location_on),
//                                horizontalSizedBoxFive(),
//                                Flexible(
//                                    child: RichText(
//                                  text: TextSpan(
//                                    children: [
//                                      TextSpan(
//                                        text: model.addressType,
//                                        style: Theme.of(context)
//                                            .textTheme
//                                            .display1
//                                            .copyWith(fontSize: 14),
//                                      ),
//                                      TextSpan(text: "\n"),
//                                      TextSpan(
//                                        text: model.currentAddress,
//                                        // overflow: TextOverflow.ellipsis,
//                                        style: Theme.of(context)
//                                            .textTheme
//                                            .display2
//                                            .copyWith(fontSize: 14),
//                                      ),
//                                    ],
//                                  ),
//                                )),
//                              ],
//                            ),
//                          )
//                    : ShowCurrentLocationShimmer(),
//              ),
//            ),
//            actions: <Widget>[
//              IconButton(
//                icon: Icon(
//                  Icons.tune,
//                ),
//                onPressed: () {
//                  showModalBottomSheet(
//                    builder: (context) => SortFilterScreen(),
//                    context: context,
//                    isScrollControlled: true,
//                    backgroundColor: Colors.transparent,
//                  );
//                },
//              ),
//              horizontalSizedBox(),
//              IconButton(
//                icon: Icon(
//                  Icons.favorite_border,
//                ),
//                onPressed: () {
//                  if (model.accessToken.isNotEmpty) {
//                    Navigator.of(context).pushNamed(
//                      favorites,
//                    );
//                  } else {
//                    Navigator.of(context).pushNamed(
//                      login,
//                    );
//                  }
//                },
//              ),
//              horizontalSizedBox(),
//            ],
//          ),
          body: LayoutBuilder(
            builder:
                (BuildContext context, BoxConstraints viewportConstraints) {
              return Stack(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      verticalSizedBox(),
                      Container(
                        height: 55,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              //                    <--- top side
                              color: Colors.grey[300],
                              width: 1.0,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            Flexible(
                              flex: 3,
                              child: InkWell(
                                onTap: () async {
                                  await Navigator.pushNamed(
                                    context,
                                    manageAddress, //changeUserAddressScreen,
                                    arguments: {
                                      fromWhichScreen: "1",
                                      latitudeKey: model.latitude,
                                      longitudeKey: model.longitude,
                                    },
                                  ).then((value) async => {
                                        if (value != null)
                                          {
                                            // model.updateCategoriesIndex(null),
                                            await model
                                                .updateDbValuesAfterChangeLocation(),

                                            await model
                                                .getRestaurantDataApiRequest(
                                              firstStatus: "1",
                                              fromFilter: false,
                                              showProgress: true,
                                            ),
                                            await model
                                                .currentTrackOrderApiRequest(
                                                    context),
                                          },
                                        showLog(
                                            "changeUserAddressScreen address-- ${value}"),
                                      });
                                },
                                child: model.currentAddress.isNotEmpty
                                    ? Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          horizontalSizedBoxFive(),
                                          Icon(
                                            Icons.location_on,
                                            size: 22,
                                          ),
                                          horizontalSizedBoxFive(),
                                          model.addressType.isEmpty
                                              ? Expanded(
                                                  child: Text(
                                                    model.currentAddress,
                                                    //overflow: TextOverflow.ellipsis,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .display1
                                                        .copyWith(
                                                          fontSize: 14,
                                                        ),
                                                  ),
                                                )
                                              : Expanded(
                                                  child: Container(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          '${model.addressType}',
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .display1
                                                                  .copyWith(
                                                                    fontSize:
                                                                        15,
                                                                  ),
                                                        ),
                                                        verticalSizedBoxFive(),
                                                        Text(
                                                          '${model.currentAddress}',
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .display2
                                                                  .copyWith(
                                                                      fontSize:
                                                                          14),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                        ],
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Locating',
                                            style: Theme.of(context)
                                                .textTheme
                                                .display1
                                                .copyWith(
                                                  fontSize: 15,
                                                ),
                                          ),
                                        ),
                                      ),
                              ),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                  onTap: () {
                                    showModalBottomSheet(
                                      builder: (context) => SortFilterScreen(),
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                    );
                                  },
                                  child: Container(
                                    height: 30,
                                    width: 30,
                                    child: Icon(Icons.tune),
                                  ),
                                ),
                                horizontalSizedBoxTwenty(),
                                InkWell(
                                  onTap: () {
                                    if (model.accessToken.isNotEmpty) {
                                      Navigator.of(context)
                                          .pushNamed(
                                            favorites,
                                          )
                                          .then((value) => {
                                                model
                                                    .currentTrackOrderApiRequest(
                                                        context)
                                              });
                                    } else {
                                      Navigator.of(context).pushNamed(
                                        login,
                                      );
                                    }
                                  },
                                  child: Container(
                                    height: 30,
                                    width: 30,
                                    child: Icon(Icons.favorite_border),
                                  ),
                                ),
                                horizontalSizedBoxTwenty(),
                              ],
                            )
                          ],
                        ),
                      ),
//                          : Padding(
//                              padding: const EdgeInsets.all(10.0),
//                              child: Align(
//                                alignment: Alignment.centerLeft,
//                                child: Text(
//                                  'Locating',
//                                  style: Theme.of(context)
//                                      .textTheme
//                                      .display1
//                                      .copyWith(
//                                        fontSize: 15,
//                                      ),
//                                ),
//                              ),
//                            ),
                      //verticalSizedBoxFive(),
                      Expanded(
                        child: SingleChildScrollView(
                          controller: model.restaurantListScrollController,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: viewportConstraints.maxHeight,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 15.0,
                                  ),
                                  child: Container(
                                    height: 175,
                                    child: (model.bannerViewSliderData.length ==
                                            0)
                                        ? ListView.builder(
                                            itemCount: 5,
                                            shrinkWrap: true,
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (context, index) {
                                              return Container(
                                                width: 168,
                                                child: bannerShimmer(),
                                              );
                                            },
                                          )
                                        : Visibility(
                                            visible: model.bannerViewSliderData
                                                    .length >
                                                0,
                                            child: ListView.builder(
                                              itemCount: model
                                                  .bannerViewSliderData.length,
                                              scrollDirection: Axis.horizontal,
                                              itemBuilder: (context, index) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Container(
                                                    width: 168,
                                                    child:
                                                        model.bannerViewSliderData
                                                                    .length !=
                                                                0
                                                            ? networkImage(
                                                                image: model
                                                                    .bannerViewSliderData[
                                                                        index]
                                                                    .src,
                                                                loaderImage:
                                                                    loaderBeforeResturantDetailBannerImage(),
                                                              )

//                                                          ? CachedNetworkImage(
//                                                              imageUrl: model
//                                                                  .bannerViewSliderData[
//                                                                      index]
//                                                                  .src,
//                                                              placeholder: (context,
//                                                                      url) =>
//                                                                  bannerShimmer(),
//                                                              //
//                                                              errorWidget: (context,
//                                                                      url,
//                                                                      error) =>
//                                                                  Icon(Icons
//                                                                      .error),
//                                                              fit: BoxFit.fill,
//                                                              height: 200,
//                                                              width: 230,
//                                                            )
                                                            : noImagesContainer(),
                                                    //Image.asset(
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                  ),
                                ),
                                verticalSizedBoxFive(),
                                model.cusinesList.length == 0
                                    ? HomeCategoryShimmer()
                                    : Visibility(
//                                        visible: model.filter[2].filterValues
//                                                        .length >
//                                                    0 &&
//                                                (model.filter[2].filterValues
//                                                            .length ==
//                                                        1 &&
//                                                    model
//                                                            .filter[2]
//                                                            .filterValues[0]
//                                                            .name !=
//                                                        "All") ||
//                                            (model.filter[2].filterValues
//                                                    .length >
//                                                1),
                                        visible: model.cusinesList.length > 0 &&
                                                (model.cusinesList.length ==
                                                        1 &&
                                                    model.cusinesList[0].name !=
                                                        "All") ||
                                            (model.cusinesList.length > 1),
                                        //  visible: model.cusines.length > 0,
                                        maintainSize: false,
                                        child: Container(
                                          height: 120,
                                          child: ListView.builder(
                                              shrinkWrap: true,
                                              itemCount:
                                                  model.cusinesList.length > 0
                                                      ? model.cusinesList.length
                                                      : 0,
                                              scrollDirection: Axis.horizontal,
                                              itemBuilder: (context, index) {
                                                return InkWell(
                                                  onTap: () {
                                                    model
                                                        .getRestaurantDataApiRequest(
                                                      firstStatus: "1",
                                                      fromFilter: true,
                                                      showProgress: true,
                                                      //   city: cites[index].city,
                                                      cusines: model
                                                                  .cusinesList[
                                                                      index]
                                                                  .id ==
                                                              0
                                                          ? ''
                                                          : model
                                                              .cusinesList[
                                                                  index]
                                                              .id
                                                              .toString(),
                                                    );
                                                    model.updateCategoriesIndex(
                                                        index);
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10.0),
                                                    child: Container(
                                                      width: 85,
                                                      child: Column(
//                                                crossAxisAlignment: CrossAxisAlignment.start,
//                                                mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Container(
                                                            height: 70,
                                                            width: 55,
                                                            decoration:
                                                                BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              color:
                                                                  categoryColors[
                                                                      index],
                                                            ),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .all(
                                                                      10.0),
                                                              child: Center(
                                                                child:
                                                                    ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              20.0),
                                                                  child:
                                                                      Container(
                                                                    child:
                                                                        CachedNetworkImage(
                                                                      imageUrl: model
                                                                          .cusinesList[
                                                                              index]
                                                                          .src,
//                                                                  imageUrl:
//                                                                      "http://abserve.tech/projects/tastyeats73/uploads/slider/1532349845-66153228.jpg",
                                                                      placeholder:
                                                                          (context, url) =>
                                                                              imageShimmer(),
                                                                      errorWidget: (context,
                                                                              url,
                                                                              error) =>
                                                                          Image
                                                                              .asset(
                                                                        'assets/images/rest_image.png',
                                                                      ),
                                                                      // fit: BoxFit.fill,
//                                                                      height:
//                                                                          60.0,
//                                                                      width:
//                                                                          50.0,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          verticalSizedBoxFive(),
                                                          Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5.0),
                                                              color: model.categoriesIndex ==
                                                                      index
                                                                  ? Colors
                                                                      .grey[300]
                                                                  : transparent,
//                                                                border:
//                                                                    Border.all(
//                                                                  color: model.categoriesIndex ==
//                                                                          index
//                                                                      ? appColor
//                                                                      : transparent,
//                                                                  width: 2,
//                                                                ),
                                                            ),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(3.0),
                                                              child: Text(
                                                                '${model.cusinesList[index].name}',
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .display1
                                                                    .copyWith(
                                                                      fontSize:
                                                                          12.0,
                                                                    ),
                                                              ),
                                                            ),
                                                          ),
//                                                          Container(
//                                                            height: 3,
//                                                            width: 20,
//                                                            color:
//                                                                model.categoriesIndex ==
//                                                                        index
//                                                                    ? appColor
//                                                                    : transparent,
//                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }),
                                        ),
                                      ),
                                verticalSizedBoxFive(),
                                model.state == BaseViewState.Busy
                                    ? ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: 10,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return showShimmer(context);
                                        },
                                      )
                                    : model.demoData == 1
                                        ? noRestaurantAvailableForLocation(
                                            model.restaurantCitiesData,
                                            context,
                                            model)
                                        : model.listOfRestaurantData.length ==
                                                    0 &&
                                                model.restaurantCitiesData ==
                                                    null
                                            ? noRestaurantAvailable(
                                                model.restaurantCitiesData,
                                                context,
                                                model)
                                            : model.listOfRestaurantData
                                                        .length ==
                                                    0
                                                ? ListView.builder(
                                                    shrinkWrap: true,
                                                    physics:
                                                        NeverScrollableScrollPhysics(),
                                                    itemCount: 10,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      return showShimmer(
                                                          context);
                                                    },
                                                  )
                                                : ListView.builder(
                                                    shrinkWrap: true,
                                                    physics:
                                                        NeverScrollableScrollPhysics(),
                                                    itemCount: model
                                                                .listOfRestaurantData
                                                                .length ==
                                                            0
                                                        ? 5
                                                        : model
                                                            .listOfRestaurantData
                                                            .length,
                                                    itemBuilder:
                                                        (context, index) {
//                                                  model.state ==
//                                                      BaseViewState.Busy
//                                                      ? showShimmer(context)
//                                                      :
//                                                      return index ==
//                                                              model
//                                                                  .listOfRestaurantData
//                                                                  .length
//                                                          ? showWidgetEndOfScroll(
//                                                              model, context)
//                                                          :
                                                      return model.listOfRestaurantData
                                                                  .length ==
                                                              0
                                                          ? noRestaurantAvailable(
                                                              model
                                                                  .restaurantCitiesData,
                                                              context,
                                                              model)
                                                          : FoodItems(
                                                              restaurantInfo:
                                                                  RestaurantsArgModel(
                                                                index: index,
                                                                imageTag:
                                                                    "home",
                                                                restaurantData: model
                                                                            .listOfRestaurantData
                                                                            .length !=
                                                                        0
                                                                    ? model.listOfRestaurantData[
                                                                        index]
                                                                    : [],
                                                                city: model
                                                                    .cityValue,
                                                              ),
                                                            );
                                                    },
                                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      model.currentOrderLoading
                          ? Visibility(
                              visible: ((model.trackOrder.isNotEmpty ||
                                      model.payOrder.isNotEmpty) &&
                                  model.accessToken.isNotEmpty),
                              child: trackOrderCard(
                                  trackOrder: model.trackOrder,
                                  payOrder: model.payOrder),
                            )
                          : SizedBox()
//                      GestureDetector(
//                        onTap: () {
//                          navigateToHome(context: context, menuType: 2);
//                        },
//                        child: CartQuantityPriceCardView(),
//                      ),
                    ],
                  ),
//                  Visibility(
//                    visible: model.showFilter,
//                    child: SortFilterScreen(),
//                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Future<bool> _onWillPop() {
    AlertDialog alert = AlertDialog(
      shape:
          RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15)),
      title: Text(
        'Are you sure you want to exit the app?',
        style: Theme.of(context).textTheme.display1,
      ),
      actions: [
        new FlatButton(
          onPressed: () {
            // this line exits the app.
            Navigator.of(context).pop(true);

            model.removeLocationData();
            //  SystemChannels.platform.invokeMethod('SystemNavigator.pop');
          },
          child: new Text(
            'Yes',
            style: new TextStyle(fontSize: 18.0, color: appColor),
          ),
        ),
        new FlatButton(
          onPressed: () => Navigator.of(context).pop(false),
          //  Navigator.pop(context), // this line dismisses the dialog
          child: new Text(
            'No',
            style: new TextStyle(fontSize: 18.0, color: appColor),
          ),
        )
      ],
    );

    return showDialog(
          context: context,
          builder: (context) => alert,
        ) ??
        false;
  }

  Widget trackOrderCard(
          {List<ATrackOrder> trackOrder, List<ATrackOrder> payOrder}) =>
      payOrder.isEmpty
          ? GestureDetector(
              onTap: () {
                if (trackOrder.length > 1) {
                  Navigator.pushNamed(context, myOrdersRoute).then((value) => {
                        model.currentTrackOrderApiRequest(context),
                      });
                } else {
                  Navigator.pushNamed(context, trackOrderRoute, arguments: {
                    orderIDKey:
                        trackOrder.isNotEmpty ? '${trackOrder[0].id}' : ""
                  }).then((value) => {
                        model.currentTrackOrderApiRequest(context),
                      });
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  height:
                      trackOrder.length == 1 || payOrder.length == 1 ? 55 : 40,
                  decoration: BoxDecoration(
                    color: appColor,
                    borderRadius: BorderRadius.circular(
                      10.0,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      horizontalSizedBox(),
                      trackOrder.length > 1
                          ? Align(
                              alignment: Alignment.center,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  // verticalSizedBox(),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        CommonStrings.trackYourOrders,
                                        style: Theme.of(context)
                                            .textTheme
                                            .display1
                                            .copyWith(
                                                color: Colors.white,
                                                fontSize: 16),
                                      ),
//                                    horizontalSizedBox(),
//                                    SizedBox(
//                                        height: 50,
//                                        width: 50,
//                                        child: Image.asset(
//                                            'assets/images/bike.jpg')),
                                    ],
                                  ),
                                  verticalSizedBoxFive(),
                                ],
                              ),
                            )
                          : Align(
                              alignment: Alignment.centerLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  verticalSizedBoxFive(),
                                  Row(
                                    children: [
                                      Text(
                                        CommonStrings.trackYourOrder,
//                                        model.trackOrder.isEmpty
//                                            ? '${CommonStrings.trackYourOrder}'
//                                            : model.trackOrder[0].status ==
//                                                "" '${CommonStrings.trackYourOrder} ${model.currencySymbol} ${model.trackOrder[0].grandTotal}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .display1
                                            .copyWith(color: Colors.white),
                                      ),
//                                      Image.asset('assets/images/bike.jpg'),
                                    ],
                                  ),
                                  verticalSizedBoxFive(),
                                  Visibility(
                                    visible: trackOrder.isEmpty
                                        ? false
                                        : trackOrder[0].orderDetails != null,
                                    child: Text(
                                      trackOrder.isEmpty
                                          ? ""
                                          : '${trackOrder[0].orderDetails}',
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .display1
                                          .copyWith(
                                            color: white,
                                            fontSize: 12,
                                          ),
                                    ),
                                  ),
                                  verticalSizedBoxFive(),
                                ],
                              ),
                            ),
                      horizontalSizedBox(),
                      Flexible(
                        child: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: 13,
                        ),
                      ),
                      horizontalSizedBox(),
                    ],
                  ),
                ),
              ),
            )
          : GestureDetector(
              onTap: () {
                if (payOrder.isNotEmpty) {
                  if (payOrder[0].delivery == "unpaid" &&
                      payOrder[0].deliveryType == razorPayPaymentType &&
                      model.payOrder.length == 1) {
                    Navigator.pushNamed(
                      context,
                      addPaymentScreen,
                      arguments: {
                        grandTotalKey: payOrder[0].grandTotal.toString(),
                        orderNoteKey: payOrder[0].orderNote.toString(),
                        orderIDKey: payOrder[0].id.toString(),
                        mobileNumKey: payOrder[0].mobileNum.toString(),
                        typeKey: pendingPay
                      },
                    ).then((value) =>
                        {model.currentTrackOrderApiRequest(context)});
                  } else {
                    Navigator.pushNamed(context, myOrdersRoute).then((value) =>
                        {model.currentTrackOrderApiRequest(context)});
                  }
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  height: trackOrder != null && payOrder != null
                      ? trackOrder.length == 1 || payOrder.length == 1 ? 60 : 40
                      : 50,
                  decoration: BoxDecoration(
                    color: appColor,
                    borderRadius: BorderRadius.circular(
                      10.0,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      horizontalSizedBox(),
                      model.payOrder.length > 1
                          ? Align(
                              alignment: Alignment.center,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  verticalSizedBox(),
                                  Row(
                                    children: [
                                      Text(
                                        '${CommonStrings.trackYourOrders}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .display1
                                            .copyWith(color: Colors.white),
                                      ),
                                      // Image.asset('assets/images/bike.jpg'),
                                    ],
                                  ),
                                  verticalSizedBoxFive(),
                                ],
                              ),
                            )
                          : Align(
                              alignment: Alignment.centerLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  verticalSizedBoxFive(),
                                  verticalSizedBoxFive(),
                                  Row(
                                    children: [
                                      Text(
                                        model.payOrder.isNotEmpty
                                            ? "Complete your previous order" //'${CommonStrings.trackYourOrder}  ${model.currencySymbol}${model.payOrder[0].grandTotal}'
                                            : "",
                                        style: Theme.of(context)
                                            .textTheme
                                            .display1
                                            .copyWith(color: Colors.white),
                                      ),
                                      //   Image.asset('assets/images/bike.jpg'),
                                    ],
                                  ),
                                  verticalSizedBoxFive(),
                                  Row(
                                    children: [
                                      Visibility(
                                        visible:
                                            payOrder.isNotEmpty ? true : false,
                                        child: Text(
                                          payOrder.isNotEmpty
                                              ? '${payOrder[0].orderDetails}'
                                              : "",
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .display1
                                              .copyWith(
                                                color: white,
                                                fontSize: 12,
                                              ),
                                        ),
                                      ),
                                      horizontalSizedBox(),
//                                      Text(
//                                        payOrder.isNotEmpty
//                                            ? '${payOrder[0].statusText}'
//                                            : "",
//                                        overflow: TextOverflow.ellipsis,
//                                        style: Theme.of(context)
//                                            .textTheme
//                                            .display3
//                                            .copyWith(
//                                              color: white,
//                                              fontSize: 13,
//                                            ),
//                                      ),
//                                      SizedBox(
//                                        child: RaisedButton(
//                                          color: darkRed,
//                                          child: Text(
//                                            'Cancel Order',
//                                            style: Theme.of(context)
//                                                .textTheme
//                                                .display3
//                                                .copyWith(
//                                                  color: white,
//                                                ),
//                                          ),
//                                          onPressed: () {},
//                                        ),
//                                      )
                                    ],
                                  ),
                                  verticalSizedBoxFive(),
                                ],
                              ),
                            ),
                      horizontalSizedBox(),
                      Flexible(
                        child: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: 13,
                        ),
                      ),
                      horizontalSizedBox(),
                    ],
                  ),
                ),
              ),
            );

  // showing show closed info

  Container noImagesContainer() => Container(
        child: Image.asset(
          'assets/images/no_image.png',
          height: 200.0,
          width: 200.0,
        ),
      );

  Widget showWidgetEndOfScroll(
      HomeRestaurantListViewModel model, BuildContext context) {
    if (model.paginationState == PaginationState.noUpdate) {
      return Opacity(
        opacity: 00,
        child: Text(""),
      );
    } else if (model.paginationState == PaginationState.loading) {
      showLog("Loadeing  ${model.paginationState}");
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else if (model.paginationState == PaginationState.noNetwork) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'You are offline, No internet available',
            style: Theme.of(context)
                .textTheme
                .display1
                .copyWith(color: Colors.redAccent),
          ),
        ),
      );
    } else if ((model.paginationState == PaginationState.error)) {
      return Center(
        child: Text(
          'Something went wrong',
          style: Theme.of(context).textTheme.display1,
        ),
      );
    } else {
      return Opacity(opacity: 00, child: Text(""));
    }
  }

  Container noRestaurantAvailableForLocation(List<RestaurantCity> cites,
          BuildContext context, HomeRestaurantListViewModel model) =>
      Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'No Restaurant available in this location',
              style: Theme.of(context).textTheme.display1,
            ),
            verticalSizedBox(),
            Center(
              child: Image.asset(
                'assets/images/no_restaurant.png',
                height: 100,
                width: 100,
              ),
            ),
            verticalSizedBox(),
            Text(
              'Check Restaurants in below location',
              style: Theme.of(context).textTheme.display1,
            ),
            Container(
              height: 50,
              child: ListView.builder(
                itemCount: cites.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: GestureDetector(
                      onTap: () {
                        model.storeCityValue(cites[index].city);
                        model.getRestaurantDataApiRequest(
                          firstStatus: "1",
                          city: cites[index].city,
                          showProgress: true,
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                          ),
                          borderRadius: BorderRadius.circular(
                            7.0,
                          ),
                        ),
                        child: Wrap(
                          children: <Widget>[
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 5.0,
                                  horizontal: 5.0,
                                ),
                                child: Text(
                                  cites[index].city,
                                  style: Theme.of(context)
                                      .textTheme
                                      .display2
                                      .copyWith(fontSize: 13),
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
            ),
          ],
        ),
      );

  Container noRestaurantAvailable(List<RestaurantCity> cites,
          BuildContext context, HomeRestaurantListViewModel model) =>
      Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            verticalSizedBox(),
            Center(
              child: Image.asset(
                'assets/images/no_restaurant.png',
                height: 100,
                width: 100,
              ),
            ),
            verticalSizedBox(),
            Text(
              'No Restaurant available',
              style: Theme.of(context).textTheme.display1,
            ),
//            Text(
//              'Check Restaurants in below location',
//              style: Theme.of(context).textTheme.display1,
//            ),
//            Container(
//              height: 50,
//              child: ListView.builder(
//                itemCount: cites.length,
//                shrinkWrap: true,
//                scrollDirection: Axis.horizontal,
//                itemBuilder: (context, index) {
//                  return Padding(
//                    padding: const EdgeInsets.all(10.0),
//                    child: GestureDetector(
//                      onTap: () {
//                        model.storeCityValue(cites[index].city);
//                        model.getRestaurantDataApiRequest(
//                            firstStatus: "1",
//                            city: cites[index].city,
//                            noRestaurant: true);
//                      },
//                      child: Container(
//                        decoration: BoxDecoration(
//                          border: Border.all(
//                            color: Colors.grey,
//                          ),
//                          borderRadius: BorderRadius.circular(
//                            7.0,
//                          ),
//                        ),
//                        child: Wrap(
//                          children: <Widget>[
//                            Center(
//                              child: Padding(
//                                padding: const EdgeInsets.symmetric(
//                                  vertical: 5.0,
//                                  horizontal: 5.0,
//                                ),
//                                child: Text(
//                                  cites[index].city,
//                                  style: Theme.of(context)
//                                      .textTheme
//                                      .display2
//                                      .copyWith(fontSize: 13),
//                                ),
//                              ),
//                            ),
//                          ],
//                        ),
//                      ),
//                    ),
//                  );
//                },
//              ),
//            ),
          ],
        ),
      );

//  @override
//  bool get wantKeepAlive => true;
}
