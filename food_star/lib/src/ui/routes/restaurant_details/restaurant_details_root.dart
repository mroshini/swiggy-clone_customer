import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodstar/src/constants/api_params_keys.dart';
import 'package:foodstar/src/constants/api_urls.dart';
import 'package:foodstar/src/constants/common_strings.dart';
import 'package:foodstar/src/constants/route_path.dart';
import 'package:foodstar/src/core/models/arguments_model/restaurant_arg_model.dart';
import 'package:foodstar/src/core/models/arguments_model/restaurant_map_view_arg_model.dart';
import 'package:foodstar/src/core/provider_viewmodels/cart_quantity_view_model.dart';
import 'package:foodstar/src/core/provider_viewmodels/common/base_change_notifier_model.dart';
import 'package:foodstar/src/core/provider_viewmodels/common/theme_changer.dart';
import 'package:foodstar/src/core/provider_viewmodels/home_restaurant_list_view_model.dart';
import 'package:foodstar/src/core/provider_viewmodels/restaurant_details_view_model.dart';
import 'package:foodstar/src/ui/res/colors.dart';
import 'package:foodstar/src/ui/routes/cart/cart_quanity_price_cart_view.dart';
import 'package:foodstar/src/ui/routes/restaurant_details/restaurant_item_widget.dart';
import 'package:foodstar/src/ui/shared/colored_sized_box.dart';
import 'package:foodstar/src/ui/shared/others.dart';
import 'package:foodstar/src/ui/shared/shop_closed_widget.dart';
import 'package:foodstar/src/ui/shared/sizedbox.dart';
import 'package:foodstar/src/utils/banner_slider_shimmer.dart';
import 'package:foodstar/src/utils/dialog_helper.dart';
import 'package:foodstar/src/utils/location_shimmer.dart';
import 'package:foodstar/src/utils/network_aware/connectivity_service.dart';
import 'package:foodstar/src/utils/no_network_screen.dart';
import 'package:foodstar/src/utils/restaurant_details_shimmer.dart';
import 'package:foodstar/src/utils/restaurant_info_list_shimmer.dart';
import 'package:foodstar/src/utils/search_restaurant_menu.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RestaurantDetailScreen extends StatefulWidget {
  final RestaurantsArgModel restaurantDetailInfo;

  RestaurantDetailScreen({this.restaurantDetailInfo});

  @override
  _RestaurantDetailScreenState createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends State<RestaurantDetailScreen>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  bool showIcon = false;
  Animation heartAnimation;
  AnimationController animController;

  RestaurantDetailsViewModel model;
  ConnectivityStatus network;
  SharedPreferences prefs;

  @override
  void initState() {
    super.initState();

    model = Provider.of<RestaurantDetailsViewModel>(context, listen: false);

//    model.initRestaurantDetailsApi(
//        restaurantID: widget.restaurantDetailInfo.restaurantID);

    model.initRestaurantDetailsApiRequest(
        restaurantID: widget.restaurantDetailInfo.restaurantID,
        fromWhere: widget.restaurantDetailInfo.fromWhere,
        cityValue: widget.restaurantDetailInfo.city,
        buildContext: context);

    model.restaurantDetailsScrollListener = ScrollController()
      ..addListener(() {
        setState(() {
          // model.offset = model.restaurantDetailsScrollListener.offset;
        });
      });

//    animController = AnimationController(
//        vsync: this, duration: Duration(milliseconds: 1200));
//    heartAnimation = Tween(begin: 130.0, end: 120.0).animate(
//        CurvedAnimation(curve: Curves.bounceOut, parent: animController));
//
//    animController.addStatusListener((AnimationStatus status) {
//      if (status == AnimationStatus.completed) {
//        animController.repeat();
//      }
//    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    network = Provider.of<ConnectivityStatus>(context);
    //model.checkNetworkConnectivity(context);
    return network == ConnectivityStatus.Offline
        ? NoNetworkConnectionScreen()
        : Consumer2<ThemeManager, RestaurantDetailsViewModel>(
            builder: (BuildContext context, ThemeManager theme,
                RestaurantDetailsViewModel model, Widget child) {
              return Scaffold(
                resizeToAvoidBottomInset: true,
                body: Stack(
                  children: <Widget>[
                    NestedScrollView(
                      controller: model.restaurantDetailsScrollListener,
                      headerSliverBuilder:
                          (BuildContext context, bool innerBoxIsScrolled) {
                        return <Widget>[
                          SliverAppBar(
                            leading: IconButton(
                              icon: Icon(Icons.arrow_back),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            iconTheme: IconThemeData(
                                color: model.showIcon
                                    ? theme.darkMode
                                        ? Colors.white
                                        : Colors.black
                                    : theme.darkMode
                                        ? Colors.white
                                        : Colors.black),
                            backgroundColor:
                                theme.darkMode ? Colors.black : Colors.white,
                            expandedHeight: 230.0,
                            floating: false,
                            pinned: true,
                            actions: showAppBarIcon(theme, model, context),
                            title: model.state == BaseViewState.Busy
                                ? ShowLocationShimmer()
                                : Container(
                                    child: model.showIcon
                                        ? Text("")
                                        : Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: widget.restaurantDetailInfo
                                                        .availabilityStatus ==
                                                    0
                                                ? RichText(
                                                    text: TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text: model
                                                              .restaurantData
                                                              ?.name,
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .display1
                                                                  .copyWith(
                                                                    fontSize:
                                                                        13,
                                                                    color: theme
                                                                            .darkMode
                                                                        ? Colors
                                                                            .white
                                                                        : model.showIcon
                                                                            ? Colors.white
                                                                            : Colors.black,
                                                                  ),
                                                        ),
                                                        TextSpan(text: "\n"),
                                                        TextSpan(
                                                          text: widget.restaurantDetailInfo
                                                                      .availabilityStatus ==
                                                                  0
                                                              ? CommonStrings
                                                                  .unServicable
                                                              : "",
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .display1
                                                              .copyWith(
                                                                  fontSize: 12,
                                                                  color:
                                                                      darkRed),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                : RichText(
                                                    text: TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text: model
                                                              .restaurantData
                                                              ?.name,
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .display1
                                                                  .copyWith(
                                                                    fontSize:
                                                                        13,
                                                                    color: theme
                                                                            .darkMode
                                                                        ? Colors
                                                                            .white
                                                                        : model.showIcon
                                                                            ? Colors.white
                                                                            : Colors.black,
                                                                  ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                          ),
                                  ),
                            flexibleSpace: FlexibleSpaceBar(
                              background: Hero(
                                tag: widget.restaurantDetailInfo.imageTag,
                                child: widget.restaurantDetailInfo.image == ""
                                    ? loaderBeforeResturantDetailBannerImage()
                                    : widget.restaurantDetailInfo
                                                .availabilityStatus ==
                                            1
                                        ? networkImage(
                                            image: widget
                                                .restaurantDetailInfo.image,
                                            loaderImage:
                                                loaderBeforeResturantDetailBannerImage(),
                                          )
                                        : networkClosedRestImage(
                                            image: widget
                                                .restaurantDetailInfo.image,
                                            loaderImage:
                                                loaderBeforeResturantDetailBannerImage(),
                                          ),
//                                  : CachedNetworkImage(
//                                      imageUrl:
//                                          widget.restaurantDetailInfo.image,
//                                      placeholder: (context, url) =>
//                                          loaderBeforeResturantDetailBannerImage(),
//                                      errorWidget: (context, url, error) =>
//                                          Icon(Icons.error),
//                                      fit: BoxFit.fill,
//                                    ),
                              ),
                            ),
                          ),
                        ];
                      },
                      body: LayoutBuilder(
                        builder: (BuildContext context,
                            BoxConstraints viewportConstraints) {
                          return model.state == BaseViewState.Busy
                              ? Column(
                                  children: <Widget>[
                                    Expanded(
                                      child: SingleChildScrollView(
                                        child: showRestaurantShimmer(
                                          context,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Stack(
                                  children: <Widget>[
                                    Container(
                                      // color: Colors.white,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Expanded(
                                            child: SingleChildScrollView(
                                              child: Container(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Container(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(15.0),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: <Widget>[
                                                            verticalSizedBoxFive(),
                                                            Text(
                                                                '${model.restaurantData?.name}',
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .subhead),
                                                            verticalSizedBox(),
                                                            Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: <
                                                                  Widget>[
                                                                Flexible(
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: <
                                                                        Widget>[
                                                                      Text(
                                                                        model.restaurantData?.cuisineText ??
                                                                            "",
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .display2,
                                                                      ),
                                                                      verticalSizedBox(),
                                                                      Row(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: <
                                                                            Widget>[
                                                                          Row(
                                                                            children: <Widget>[
                                                                              Container(
                                                                                color: Colors.red,
                                                                                child: Padding(
                                                                                  padding: const EdgeInsets.all(5.0),
                                                                                  child: Wrap(
                                                                                    children: <Widget>[
                                                                                      Row(
                                                                                        children: <Widget>[
                                                                                          Icon(
                                                                                            Icons.restaurant,
                                                                                            color: white,
                                                                                            size: 12,
                                                                                          ),
                                                                                          horizontalSizedBox(),
                                                                                          Text(
                                                                                            "${CommonStrings.appName} PARTNER",
                                                                                            style: Theme.of(context).textTheme.display2.copyWith(color: white, fontWeight: FontWeight.w600, fontSize: 12),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              horizontalSizedBox(),
                                                                              Visibility(
                                                                                visible: model.restaurantData?.promoStatus == 1 ? true : false,
                                                                                child: Container(
                                                                                  color: Colors.blue,
                                                                                  child: Padding(
                                                                                    padding: const EdgeInsets.all(5.0),
                                                                                    child: Text(
                                                                                      "On Promo",
                                                                                      style: Theme.of(context).textTheme.display2.copyWith(color: white, fontWeight: FontWeight.w800, fontSize: 12),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                GestureDetector(
                                                                  onTap: () {
                                                                    if (model
                                                                        .accessToken
                                                                        .isNotEmpty) {
                                                                      //call api
                                                                      model.wishListRequest(
                                                                          restaurantId: model
                                                                              .restaurantData
                                                                              ?.id,
                                                                          buildContext:
                                                                              context);
                                                                    } else {
                                                                      // move to login
                                                                      Navigator.pushNamed(
                                                                          context,
                                                                          login);
                                                                    }
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    height: 40,
                                                                    width: 40,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: Colors
                                                                          .white,
                                                                      borderRadius:
                                                                          BorderRadius
                                                                              .circular(
                                                                        20.0,
                                                                      ),
                                                                      boxShadow: [
                                                                        BoxShadow(
                                                                          color: Colors
                                                                              .white
                                                                              .withOpacity(
                                                                            theme.darkMode
                                                                                ? 0.0
                                                                                : 0.2,
                                                                          ),
                                                                          offset:
                                                                              Offset(
                                                                            -3,
                                                                            -3,
                                                                          ),
                                                                          blurRadius: theme.darkMode
                                                                              ? 0
                                                                              : 2,
                                                                          spreadRadius: theme.darkMode
                                                                              ? 0
                                                                              : 2,
                                                                        ),
                                                                        BoxShadow(
                                                                          color:
                                                                              Colors.grey[200],
                                                                          offset: Offset(
                                                                              3,
                                                                              3),
                                                                          blurRadius:
                                                                              2,
                                                                          spreadRadius:
                                                                              2,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    child: Icon(
                                                                      Icons
                                                                          .favorite,
                                                                      color: model.restaurantData?.favouriteStatus ??
                                                                              false
                                                                          ? Colors
                                                                              .red
                                                                          : Colors
                                                                              .grey[300],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            verticalSizedBox(),
                                                            Visibility(
                                                              maintainSize:
                                                                  false,
                                                              visible: model
                                                                          .restaurantData
                                                                          .freeDelivery ==
                                                                      "1"
                                                                  ? true
                                                                  : false,
                                                              child:
                                                                  freeDeliveryWidget(
                                                                      context),
                                                            ),
                                                            verticalSizedBox(),
                                                            divider(),
                                                            verticalSizedBox(),
                                                            Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: <
                                                                  Widget>[
                                                                Column(
                                                                  children: <
                                                                      Widget>[
                                                                    Row(
                                                                      children: <
                                                                          Widget>[
                                                                        Icon(
                                                                            Icons
                                                                                .star,
                                                                            color:
                                                                                Colors.amber),
                                                                        horizontalSizedBox(),
                                                                        Text(
                                                                            '${model.restaurantData?.rating} rating',
                                                                            style:
                                                                                Theme.of(context).textTheme.display1),
                                                                      ],
                                                                    ),
//                                                                    verticalSizedBox(),
//                                                                    Text(
//                                                                      '${model.restaurantData?.ratingCountText} rating',
//                                                                      style: Theme.of(
//                                                                              context)
//                                                                          .textTheme
//                                                                          .display2,
//                                                                    ),
                                                                  ],
                                                                ),
                                                                horizontalSizedBox(),
                                                                Column(
                                                                  children: <
                                                                      Widget>[
                                                                    Row(
                                                                      children: <
                                                                          Widget>[
                                                                        Icon(
                                                                          Icons
                                                                              .location_on,
                                                                        ),
                                                                        horizontalSizedBoxFive(),
                                                                        Text(
                                                                          '${model.restaurantData?.distance} ${CommonStrings.kms}',
                                                                          style: Theme.of(context)
                                                                              .textTheme
                                                                              .display1
                                                                              .copyWith(fontSize: 14),
                                                                        ),
                                                                        horizontalSizedBoxFive(),
                                                                        Text(
                                                                          '(${model.restaurantData?.deliveryTime} mins)',
                                                                          style: Theme.of(context)
                                                                              .textTheme
                                                                              .display1
                                                                              .copyWith(fontSize: 14),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    //  verticalSizedBox(),
                                                                  ],
                                                                ),
//                                                                horizontalSizedBox(),
//                                                                Column(
//                                                                  children: <
//                                                                      Widget>[
//                                                                    SizedBox(
//                                                                      height:
//                                                                          5.0,
//                                                                    ),
//                                                                    Container(
//                                                                      height:
//                                                                          15,
//                                                                      child: ListView.builder(
//                                                                          itemCount: 4,
//                                                                          shrinkWrap: true,
//                                                                          scrollDirection: Axis.horizontal,
//                                                                          itemBuilder: (context, index) {
//                                                                            return Text(
//                                                                              r"$",
//                                                                              style: Theme.of(context).textTheme.display1.copyWith(
//                                                                                    fontSize: 11,
//                                                                                    color: index < model.restaurantData?.budget ? Colors.black : Colors.grey,
//                                                                                  ),
//                                                                            );
//                                                                          }),
//                                                                    ),
////                                                                      verticalSizedBox(),
////                                                                      Text(
////                                                                        '40k - 100k',
////                                                                        style: Theme.of(context)
////                                                                            .textTheme
////                                                                            .display2,
////                                                                      ),
//                                                                  ],
//                                                                ),
                                                              ],
                                                            ),
                                                            verticalSizedBox(),
                                                            divider(),
                                                            verticalSizedBox(),
                                                            model
                                                                        .restaurantData
                                                                        ?.availability
                                                                        ?.status ==
                                                                    0
                                                                ? Row(
                                                                    children: <
                                                                        Widget>[
                                                                      Icon(
                                                                          Icons
                                                                              .access_time,
                                                                          color:
                                                                              darkRed),
                                                                      horizontalSizedBox(),
                                                                      ShopClosedWidget(
                                                                          status: model
                                                                              .restaurantData
                                                                              ?.availability
                                                                              ?.status,
                                                                          nextAvailableText: model
                                                                              .restaurantData
                                                                              ?.availability
                                                                              ?.text,
                                                                          showIcon:
                                                                              false),
                                                                    ],
                                                                  )
                                                                : Row(
                                                                    children: <
                                                                        Widget>[
                                                                      Icon(
                                                                          Icons
                                                                              .access_time,
                                                                          color:
                                                                              darkGreen),
                                                                      horizontalSizedBox(),
                                                                      Text(
                                                                        'Available',
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .display1
                                                                            .copyWith(
                                                                              color: darkGreen,
                                                                              fontSize: 14,
                                                                            ),
                                                                      )
                                                                    ],
                                                                  ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    VerticalColoredSizedBox(),
                                                    Visibility(
                                                      visible: model
                                                                  .restaurantData
                                                                  ?.promocode
                                                                  ?.length !=
                                                              0
                                                          ? true
                                                          : false,
                                                      maintainSize: false,
                                                      child: Container(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                            horizontal: 15.0,
                                                            vertical: 20.0,
                                                          ),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: <Widget>[
                                                              verticalSizedBox(),
                                                              Text(
                                                                "Available Promos",
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .display1,
                                                              ),
                                                              ListView.builder(
                                                                shrinkWrap:
                                                                    true,
                                                                itemCount: model
                                                                    .restaurantData
                                                                    ?.promocode
                                                                    ?.length,
                                                                physics:
                                                                    NeverScrollableScrollPhysics(),
                                                                itemBuilder:
                                                                    (context,
                                                                        index) {
                                                                  return Padding(
                                                                    padding: const EdgeInsets
                                                                            .symmetric(
                                                                        vertical:
                                                                            5.0),
                                                                    child: Row(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: <
                                                                          Widget>[
                                                                        Flexible(
                                                                          child:
                                                                              Row(
                                                                            children: <Widget>[
                                                                              model.restaurantData?.promocode[index]?.promoType == "percentage"
                                                                                  ? Image.asset(
                                                                                      "assets/images/percentage.jpg",
                                                                                      width: 20,
                                                                                      height: 20,
                                                                                      color: Colors.blue[700],
                                                                                    )
                                                                                  : Icon(
                                                                                      Icons.account_balance_wallet,
                                                                                      color: Colors.blue[700],
                                                                                    ),
                                                                              horizontalSizedBox(),
                                                                              Flexible(
                                                                                child: Text(
                                                                                  '${model.restaurantData?.promocode[index]?.promoCodeText}',
                                                                                  overflow: TextOverflow.ellipsis,
                                                                                  style: Theme.of(context).textTheme.display2,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
//                                                                  horizontalSizedBox(),
//                                                                  Icon(
//                                                                    Icons
//                                                                        .keyboard_arrow_right,
//                                                                  ),
                                                                      ],
                                                                    ),
                                                                  );
                                                                },
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    VerticalColoredSizedBox(),
//                                              model.isFoodItemsLoading
//                                                  ? ListView.builder(
//                                                      physics:
//                                                          NeverScrollableScrollPhysics(),
//                                                      shrinkWrap: true,
//                                                      itemCount: 5,
//                                                      itemBuilder:
//                                                          (BuildContext context,
//                                                              int index) {
//                                                        return showShimmer(
//                                                            context);
//                                                      },
//                                                    )
//                                                  :
                                                    model.catFoodItemsData
                                                                ?.length !=
//                                              model.restaurantDetailModelBoxData
//                                                          .catFoodItems.length !=
                                                            0
                                                        ? ListView.builder(
                                                            physics:
                                                                NeverScrollableScrollPhysics(),
                                                            shrinkWrap: true,
                                                            // ignore: null_aware_before_operator
//                                                      itemCount: model
//                                                              .restaurantDetailModelBoxData
//                                                              .catFoodItems
//                                                              .length +
//                                                          1,
//                                                            itemCount: model
//                                                                    .catFoodItemsData
//                                                                    .length +
//                                                                1,
                                                            itemCount: model
                                                                .catFoodItemsData
                                                                .length,
                                                            itemBuilder: (context,
                                                                parentIndex) {
//                                                              return parentIndex ==
//                                                                      model
//                                                                          .catFoodItemsData
//                                                                          ?.length
//                                                                  ? showWidgetEndOfScroll(
//                                                                      model,
//                                                                      context)
//
                                                              return Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        5.0),
                                                                child:
                                                                    Container(
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .symmetric(
                                                                      horizontal:
                                                                          15.0,
                                                                    ),
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      children: <
                                                                          Widget>[
                                                                        Text(
                                                                          model
                                                                              .catFoodItemsData[parentIndex]
                                                                              ?.mainCatName,
//                                                                          model
//                                                                              .restaurantDetailModelBoxData
//                                                                              .catFoodItems[parentIndex]
//                                                                              .mainCatName,
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                15.0,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                          ),
                                                                        ),
                                                                        verticalSizedBox(),
                                                                        divider(),
                                                                        verticalSizedBox(),
                                                                        ListView
                                                                            .separated(
                                                                          separatorBuilder: (context, index) =>
                                                                              Divider(
                                                                            color:
                                                                                Colors.grey[200],
                                                                          ),
                                                                          shrinkWrap:
                                                                              true,
                                                                          itemCount: model
                                                                              .catFoodItemsData[parentIndex]
                                                                              ?.aFoodItems
                                                                              ?.length,
//                                                                          itemCount: model
//                                                                              .restaurantDetailModelBoxData
//                                                                              .catFoodItems[parentIndex]
//                                                                              ?.aFoodItems
//                                                                              ?.length,
                                                                          physics:
                                                                              NeverScrollableScrollPhysics(),
                                                                          itemBuilder:
                                                                              (context, index) {
                                                                            return Padding(
                                                                              padding: const EdgeInsets.symmetric(
                                                                                vertical: 8.0,
                                                                              ),
                                                                              child: RestaurantItem(
                                                                                itemInfo: model.catFoodItemsData[parentIndex]?.aFoodItems,
                                                                                parentIndex: parentIndex,
                                                                                childIndex: index,
                                                                                availabilityTime: model.restaurantData?.availability?.status,
                                                                                model: model,
                                                                              ),
//                                                                                child: RestSearchCartFoodItemScreen(
//                                                                                  parentIndex: parentIndex,
//                                                                                  childIndex: index,
//                                                                                  fromWhichScreen: 1,
//                                                                                  shopAvailabilityStatus: model.restaurantData.availability.status,
//                                                                                  restDetailsViewModel: model,
//                                                                                ), //RestaurantItem(itemInfo: model.catFoodItemsData[parentIndex].aFoodItems, parentIndex: parentIndex, childIndex: index, availabilityTime: model.restaurantData.availability.status, model: model),
                                                                            );
                                                                          },
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          )
                                                        : ListView.builder(
                                                            physics:
                                                                NeverScrollableScrollPhysics(),
                                                            shrinkWrap: true,
                                                            itemCount: 5,
                                                            itemBuilder:
                                                                (BuildContext
                                                                        context,
                                                                    int index) {
                                                              return showShimmer(
                                                                  context);
                                                            },
                                                          )
//                                                      : Padding(
//                                                          padding:
//                                                              const EdgeInsets
//                                                                  .all(
//                                                            10.0,
//                                                          ),
//                                                          child:
//                                                              NoSearchItemsAvailableScreen(
//                                                            title:
//                                                                'No Food items available',
//                                                          ),
//                                                        ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Consumer<CartQuantityViewModel>(
                                              builder: (BuildContext context,
                                                  CartQuantityViewModel
                                                      cartModel,
                                                  Widget child) {
                                            return Visibility(
                                              visible: cartModel
                                                      .cartQuantityData
                                                      ?.totalQuantity !=
                                                  null,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 10.0,
                                                  vertical: 8.0,
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: <Widget>[
//                                          GestureDetector(
//                                            onTap: () async {
//                                              await menuPopup(
//                                                context: context,
//                                                rootModel: model,
//                                              ).then((value) => {
//                                                    showLog(
//                                                        "GestureDetector -- ${value}"),
//                                                    model.moveToMenuPosition(
//                                                        value),
//                                                  });
//                                            },
//                                            child: Container(
//                                              color: transparent,
//                                              child: Image.asset(
//                                                'assets/images/menu.png',
//                                                height: 50.0,
//                                                width: 50.0,
//                                              ),
//                                            ),
//                                          ),
//                                          verticalSizedBox(),
                                                    GestureDetector(
                                                      onTap: () async {
                                                        await Navigator
                                                                .pushNamed(
                                                                    context,
                                                                    cart,
                                                                    arguments:
                                                                        true)
                                                            .then((value) => {
                                                                  showLog(
                                                                      "Backpressed--${value}"),

                                                                  if (value ==
                                                                      null)
                                                                    {
                                                                      model.initRestaurantDetailsApiRequest(
                                                                          restaurantID: widget
                                                                              .restaurantDetailInfo
                                                                              .restaurantID,
                                                                          buildContext:
                                                                              context),
                                                                    }
                                                                  else
                                                                    {
                                                                      model.initRestaurantDetailsApiRequest(
                                                                          restaurantID: int.parse(
                                                                              value),
                                                                          buildContext:
                                                                              context),
                                                                    }
                                                                  //  model.updateItemNotes()
                                                                });
//                                              navigateToHome(
//                                                  context: context,
//                                                  menuType: 2);
                                                      },
//                                                  child: Padding(
//                                                    padding:
//                                                        const EdgeInsets.only(
//                                                            left: 50.0),
//                                                    child:
//                                                        CartQuantityPriceCardView(),
//                                                  ),
                                                      child:
                                                          CartQuantityPriceCardView(),
                                                    ),
//                                              Visibility(
//                                                visible: model.cartData
//                                                            .totalQuantity ==
//                                                        null
//                                                    ? false
//                                                    : true,
//                                                child: CartInfoCard(),
//                                              ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          })
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0.0,
                                      left: 0.0,
                                      right: 5.0,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              GestureDetector(
                                                onTap: () async {
                                                  await menuPopup(
                                                    context: context,
                                                    rootModel: model,
                                                  ).then((value) => {
                                                        showLog(
                                                            "GestureDetector -- ${value}"),
//                                                        model
//                                                            .moveToMenuPosition(
//                                                                value, context),

                                                        Navigator.pushNamed(
                                                            context,
                                                            restaurantMenuListScreen,
                                                            arguments: {
                                                              restaurantIdKey: widget
                                                                  .restaurantDetailInfo
                                                                  .restaurantID,
                                                              indexKey: value
                                                            })
                                                      });
                                                },
                                                child: Image.asset(
                                                  'assets/images/menu.png',
                                                  height: 50.0,
                                                  width: 50.0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                        },
                      ),
                    ),
                    Visibility(
                      visible: model.state == BaseViewState.Idle,
                      child: _buildMapButton(model),
                    ),
                  ],
                ),
              );
            },
          );
//    return ChangeNotifierProvider.value(
//        value: RestaurantDetailsViewModel(
//          context: context,
//          //  city: widget.restaurantDetailInfo.city,
//          restaurantId: widget.restaurantDetailInfo.restaurantID,
//          previousScreen: widget.restaurantDetailInfo.fromWhere,
//        ),
//      );
  }

  Widget showWidgetEndOfScroll(
      RestaurantDetailsViewModel model, BuildContext context) {
    if (model.paginationState == PaginationState.noUpdate) {
//      return Container(
//        width: MediaQuery.of(context).size.width,
//        color: appColor,
//        child: Padding(
//          padding: const EdgeInsets.all(8.0),
//          child: Center(
//            child: Text(
//              'No Update available for now',
//              style: Theme.of(context)
//                  .textTheme
//                  .display1
//                  .copyWith(color: Colors.white),
//            ),
//          ),
//        ),
//      );
      // return endOfScrollIfNoItemsAvailable(context);
      return Opacity(
        opacity: 00,
        child: Text(""),
      );
    } else if (model.paginationState == PaginationState.loading) {
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
      return Opacity(
        opacity: 00,
        child: Text(""),
      );
    }
  }

  List<Widget> showAppBarIcon(ThemeManager themeManager,
      RestaurantDetailsViewModel model, BuildContext context) {
    showLog("model.showIcon-- ${model.showIcon}");
    return model.showIcon
        ? <Widget>[
//            CircleAvatar(
//              backgroundColor: Colors.black26,
//              child: GestureDetector(
//                onTap: () {
//                  showSearchResults(context, model);
//                },
//                child: Icon(
//                  Icons.search,
//                  color: Colors.white,
//                  size: 30,
//                ),
//              ),
//            ),
//            horizontalSizedBoxTwenty(),
            GestureDetector(
              onTap: () {
                shareRestaurant(model);
              },
              child: CircleAvatar(
                backgroundColor: Colors.black26,
                child: Icon(
                  Icons.subdirectory_arrow_right,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
            horizontalSizedBox(),
          ]
        : <Widget>[
//            IconButton(
//              icon: Icon(
//                Icons.search,
//                color: themeManager.darkMode ? Colors.white : Colors.black,
//              ),
//              onPressed: () {
//                showSearchResults(context, model);
//              },
//            ),
//            horizontalSizedBoxTwenty(),
            GestureDetector(
              onTap: () {
                shareRestaurant(model);
//                showShareIntent(
//                    '${CommonStrings.LookAtThis} ${model.restaurantData.name}, ${CommonStrings.restaurantLinkDownloadNow}');
//                openChangeRestBottomSheet(
//                    model: model,
//                    restID: widget.restaurantDetailInfo.restaurantID,
//                    context: context);
              },
              child: Icon(
                Icons.subdirectory_arrow_right,
                color: themeManager.darkMode ? Colors.white : Colors.black,
              ),
            ),
            horizontalSizedBox(),
          ];
  }

  shareRestaurant(RestaurantDetailsViewModel model) async {
//    String urlToRedirect = "";
//    await initPref();
//    if (fetchTargetPlatform() == "android") {
//      urlToRedirect =
//          prefs.getString(SharedPreferenceKeys.androidPlayStoreLink);
//    } else {
//      urlToRedirect = prefs.getString(SharedPreferenceKeys.appleStoreLink);
//    }

    showShareIntent(
        '${CommonStrings.LookAtThis} ${model.restaurantData.name}, ${CommonStrings.restaurantLinkDownloadNow}');
  }

//
//  initPref() async {
//    if (prefs == null) prefs = await SharedPreferences.getInstance();
//  }

//  openChangeRestBottomSheet(
//      {int restID, RestaurantDetailsViewModel model, BuildContext context}) {
//    openBottomSheet(
//      context,
//      ChangeRestaurantScreen(
//        restFoodId: restID,
//        model: model,
//        context: context,
//        image: model.restaurantData.src,
//        fromWhere: 1, //restDetails screen
//      ),
//    ).then((value) => {
//          if (value)
//            {
//              showSnackbar(
//                  message: 'Items deleted successfully', context: context),
//              showLog("${value}"),
//              model.removeCartItemsAfterChangeRestaurant(),
//            }
//          else
//            {}
//        });
//  }

  showSearchResults(
          BuildContext context, RestaurantDetailsViewModel searchCategory) =>
      showSearch(
        context: context,
        delegate: SearchRestaurantMenu(model: searchCategory),
      );

  Positioned _buildMapButton(RestaurantDetailsViewModel model) {
//    final double defaultTopMargin = MediaQuery.of(context).size.height > 800
//        ? MediaQuery.of(context).size.height / 4
//        : 200.0 - 4.0;
//    //pixels from top where scaling should start
//
//    final double scaleStart = 96.0;
//    //pixels from top where scaling should end
//
//    final double scaleEnd = scaleStart / 2;
//    double scale = 1.0;
//
//    var top = defaultTopMargin;
//
//    if (_scrollController.hasClients) {
//      double offset = _scrollController.offset;
//      top -= offset;
//      if (offset < defaultTopMargin - scaleStart) {
//        //offset small => don't scale down
//        scale = 1.0;
//      } else if (offset < defaultTopMargin - scaleEnd) {
//        //offset between scaleStart and scaleEnd => scale down
//        scale = (defaultTopMargin - scaleEnd - offset) / scaleEnd;
//      } else {
//        //offset passed scaleEnd => hide fab
//        scale = 0.0;
//      }
//    }
    model.buildMapLocation(context);

    return Positioned(
      top: model.top,
      right: 16.0,
      child: GestureDetector(
        onTap: () {
//          Navigator.of(context).pushNamed(
//            restaurantMapView,
//            arguments: RestaurantsMapViewArgModel(
//              restaurantName: model.restaurantData.name,
//              description: model.restaurantData.resDesc,
//              rating: model.restaurantData.rating.toString(),
//              distance: model.restaurantData.distance.toString(),
//              timing: model.restaurantData.deliveryTime.toString(),
//              location: model.restaurantData.location,
//              availabilityStatus:
//                  model.restaurantData.availability.status.toString(),
//              nextAvailabilityText: model.restaurantData.availability.text,
//              mapImage: model.restaurantData.mapSrc,
//              restaurantTiming: model.restaurantData.restaurantTiming,
//            ), // show restaurant  rating details below map
//          );
          showLog(
              "nextAvailabilityText1--${model.restaurantData.availability.text}");

          Navigator.of(context).pushNamed(
            restaurantInfoScreen,
            arguments: RestaurantsMapViewArgModel(
              restaurantName: model.restaurantData.name,
              description: model.restaurantData.resDesc,
              rating: model.restaurantData.rating.toString(),
              distance: model.restaurantData.distance.toString(),
              timing: model.restaurantData.deliveryTime.toString(),
              location: model.restaurantData.location,
              availabilityStatus:
                  model.restaurantData.availability.status.toString(),
              nextAvailabilityText: model.restaurantData.availability.text,
              mapImage: model.restaurantData.mapSrc,
              restaurantTiming: model.restaurantData.restaurantTiming,
            ), // show restaurant  rating details below map
          );
        },
        child: new Transform(
          transform: new Matrix4.identity()..scale(model.scale),
          alignment: Alignment.center,
          child: Card(
            elevation: 20.0,
            child: Image.asset(
              'assets/images/map.png',
              height: 70,
              width: 70,
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    //animController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
