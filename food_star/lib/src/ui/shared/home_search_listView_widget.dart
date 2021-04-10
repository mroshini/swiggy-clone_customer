import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodstar/src/constants/common_strings.dart';
import 'package:foodstar/src/constants/route_path.dart';
import 'package:foodstar/src/core/models/api_models/home_restaurant_list_api_model.dart';
import 'package:foodstar/src/core/models/arguments_model/restaurant_arg_model.dart';
import 'package:foodstar/src/core/models/sample_models/home_model_data.dart';
import 'package:foodstar/src/core/provider_viewmodels/home_restaurant_list_view_model.dart';
import 'package:foodstar/src/ui/res/colors.dart';
import 'package:foodstar/src/ui/shared/others.dart';
import 'package:foodstar/src/ui/shared/shop_closed_widget.dart';
import 'package:foodstar/src/ui/shared/sizedbox.dart';
import 'package:foodstar/src/utils/banner_slider_shimmer.dart';
import 'package:provider/provider.dart';

class FoodItems extends StatefulWidget {
  final Restaurant restaurantData;
  final RestaurantsArgModel restaurantInfo;

  FoodItems({this.restaurantData, this.restaurantInfo});

  @override
  _FoodItemsState createState() => _FoodItemsState(
      restaurantData: restaurantData, restaurantInfo: restaurantInfo);
}

class _FoodItemsState extends State<FoodItems> {
  var homeInfo = HomeModelData().homeInfo;
  final Restaurant restaurantData;
  final RestaurantsArgModel restaurantInfo;
  int index;

  _FoodItemsState({this.restaurantData, this.restaurantInfo});

  @override
  void initState() {
    index = restaurantInfo.index;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeRestaurantListViewModel>(
      builder: (BuildContext context, HomeRestaurantListViewModel model,
          Widget child) {
        return InkWell(
          onTap: () {
            Navigator.of(context)
                .pushNamed(
                  restaurantDetails,
                  arguments: RestaurantsArgModel(
                    imageTag:
                        "${restaurantInfo.imageTag}${restaurantInfo.index}",
                    restaurantID: model.listOfRestaurantData[index].id,
                    image: model.listOfRestaurantData[index].src,
                    city: restaurantInfo.city,
                    fromWhere: 1,
                    availabilityStatus:
                        model.listOfRestaurantData[index].availability.status,
                  ),
                )
                .then((value) => {model.currentTrackOrderApiRequest(context)});
          },
          child: Padding(
            padding: const EdgeInsets.all(7.0),
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Hero(
                        tag:
                            "${restaurantInfo.imageTag}${restaurantInfo.index}",
                        child: model.listOfRestaurantData[index].src == " "
                            ? Image.asset(
                                'assets/images/no_image.png',
                                height: 80.0,
                                width: 80.0,
                              )
                            : model.listOfRestaurantData[index].availability
                                        .status ==
                                    1
                                ? networkImage(
                                    image:
                                        model.listOfRestaurantData[index].src,
                                    loaderImage: loaderBeforeImage(),
                                    height: 80.0,
                                    width: 80.0,
                                  )
                                : networkClosedRestImage(
                                    image:
                                        model.listOfRestaurantData[index].src,
                                    loaderImage: loaderBeforeImage(),
                                    height: 80.0,
                                    width: 80.0,
                                  )
//                                  child: CachedNetworkImage(
//                                    imageUrl:
//                                        model.listOfRestaurantData[index].src,
//                                    placeholder: (context, url) =>
//                                        loaderBeforeImage(
//                                            height: 80.0, width: 80.0),
//                                    //imageShimmer(),
//                                    errorWidget: (context, url, error) =>
//                                        Icon(Icons.error),
//                                    fit: BoxFit.fill,
//                                    height: 80.0,
//                                    width: 80.0,
//                                  ),

                        ),
                  ),
                  SizedBox(
                    width: 15,
                    height: 10,
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          model.listOfRestaurantData[index].name,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.display1.copyWith(
                              fontSize: 14, fontWeight: FontWeight.w600),
                        ),
//                        Row(
//                          crossAxisAlignment: CrossAxisAlignment.start,
//                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                          children: <Widget>[
//                            Text(
//                              model.listOfRestaurantData[index].name,
//                              overflow: TextOverflow.ellipsis,
//                              style: Theme.of(context)
//                                  .textTheme
//                                  .display1
//                                  .copyWith(
//                                      fontSize: 14,
//                                      fontWeight: FontWeight.w600),
//                            ),
//                            GestureDetector(
//                              onTap: () {
//                                if (model.accessToken.isNotEmpty) {
//                                  //call api
//                                  model.updateFavoritesIndex(index);
//                                  model.wishListRequest(
//                                    restaurantId:
//                                        model.listOfRestaurantData[index].id,
//                                  );
//                                } else {
//                                  // move to login
//                                  Navigator.pushNamed(context, login);
//                                }
//                              },
//                              child: Padding(
//                                padding: const EdgeInsets.only(right: 10.0),
//                                child: Icon(
//                                  Icons.favorite,
//                                  color: model.listOfRestaurantData[index]
//                                          .favouriteStatus
//                                      ? Colors.red
//                                      : Colors.grey[300],
//                                ),
//                              ),
//                            ),
//                          ],
//                        ),
                        verticalSizedBoxFive(),
//                    Text(
//                      model.listOfRestaurantData[index].cuisineText,
//                      overflow: TextOverflow.ellipsis,
//                      style: Theme
//                          .of(context)
//                          .textTheme
//                          .display2
//                          .copyWith(
//                        fontSize: 13,
//                      ),
//                    ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                model.listOfRestaurantData[index].cuisineText,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .display2
                                    .copyWith(
                                      fontSize: 13,
                                    ),
                              ),
                            ),
//                            Text(
//                              ' - ',
//                              style:
//                                  Theme.of(context).textTheme.display3.copyWith(
//                                        fontWeight: FontWeight.w600,
//                                      ),
//                            ),
                            Container(
                              height: 15,
                              child: ListView.builder(
                                  itemCount: 4,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, bugetIndex) {
                                    return Text(
                                      r"$",
                                      style: Theme.of(context)
                                          .textTheme
                                          .display3
                                          .copyWith(
                                            fontSize: 11,
                                            color: bugetIndex <
                                                    model
                                                        .listOfRestaurantData[
                                                            index]
                                                        .budget
                                                ? Colors.black
                                                : Colors.grey,
                                          ),
                                    );
                                  }),
                            ),
                          ],
                        ),
                        verticalSizedBoxFive(),
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.star,
                              color:
                                  (model.listOfRestaurantData[index].rating ==
                                          0)
                                      ? Colors.grey[600]
                                      : Colors.amber,
                              size: 15.0,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              model.listOfRestaurantData[index].rating
                                  .toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .display3
                                  .copyWith(fontSize: 12),
                            ),
                            Text(
                              " - ",
                              style:
                                  Theme.of(context).textTheme.display3.copyWith(
                                        fontWeight: FontWeight.w500,
                                      ),
                            ),
                            Text(
                              '${model.listOfRestaurantData[index].distance} ${CommonStrings.kms}',
//                              model.listOfRestaurantData[index].distance == null
//                                  ? "50"
//                                  : ,
                              style: Theme.of(context)
                                  .textTheme
                                  .display3
                                  .copyWith(fontSize: 12),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "- (${model.listOfRestaurantData[index].deliveryTime} mins) " ??
                                  " ",
                              style: Theme.of(context)
                                  .textTheme
                                  .display2
                                  .copyWith(fontSize: 12),
                            ),
                          ],
                        ),
                        verticalSizedBox(),
                        divider(),
                        model.listOfRestaurantData[index].availability.status ==
                                1
                            ? model.listOfRestaurantData[index].promoStatus ==
                                        1 &&
                                    model.listOfRestaurantData[index]
                                            .freeDelivery ==
                                        "0"
                                ? Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      shopOpenedWidget(),
                                    ],
                                  )
                                : model.listOfRestaurantData[index]
                                                .promoStatus ==
                                            0 &&
                                        model.listOfRestaurantData[index]
                                                .freeDelivery ==
                                            "1"
                                    ? Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          freeDeliveryWidget(context),
                                        ],
                                      )
                                    : model.listOfRestaurantData[index]
                                                    .promoStatus ==
                                                1 &&
                                            model.listOfRestaurantData[index]
                                                    .freeDelivery ==
                                                "1"
                                        ? Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              shopOpenedWidget(),
                                              horizontalSizedBoxFive(),
                                              freeDeliveryWidget(context),
                                            ],
                                          )
                                        : Container()
                            : ShopClosedWidget(
                                nextAvailableText: model
                                    .listOfRestaurantData[index]
                                    .availability
                                    .text,
                              )
//                            : RichText(
//                                text: TextSpan(
//                                  children: [
//                                    WidgetSpan(
//                                      child: Icon(
//                                        Icons.access_time,
//                                        size: 15,
//                                        color: darkRed,
//                                      ),
//                                    ),
//                                    TextSpan(text: " "),
//                                    TextSpan(
//                                      text: 'Closed',
//                                      style: Theme.of(context)
//                                          .textTheme
//                                          .display1
//                                          .copyWith(
//                                              color: darkRed, fontSize: 12),
//                                    ),
//                                    TextSpan(text: " "),
//                                    TextSpan(
//                                      text:
//                                          '${model.listOfRestaurantData[index].availability.text}',
//                                      style: Theme.of(context)
//                                          .textTheme
//                                          .display2
//                                          .copyWith(
//                                            fontSize: 12,
//                                            color: darkRed,
//                                          ),
//                                    ),
//                                  ],
//                                ),
//                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

//  @override
//  Widget build(BuildContext context) {
//    return Consumer<HomeRestaurantListViewModel>(
//      builder: (BuildContext context, HomeRestaurantListViewModel model,
//          Widget child) {
//        return InkWell(
//          onTap: () {
//            Navigator.of(context).pushNamed(restaurantDetails,
//                arguments: RestaurantsArgModel(
//                  imageTag: "${restaurantInfo.imageTag}${restaurantInfo.index}",
//                  restaurantID: restaurantInfo.restaurantData.id,
//                  image: restaurantInfo.restaurantData.src,
//                  city: restaurantInfo.city,
//                ));
//          },
//          child: Padding(
//            padding: const EdgeInsets.all(7.0),
//            child: Container(
//              child: Row(
//                mainAxisAlignment: MainAxisAlignment.start,
//                crossAxisAlignment: CrossAxisAlignment.start,
//                children: <Widget>[
//                  ClipRRect(
//                    borderRadius: BorderRadius.circular(10.0),
//                    child: Hero(
//                      tag: "${restaurantInfo.imageTag}${restaurantInfo.index}",
//                      child: restaurantInfo.restaurantData.src == " "
//                          ? Image.asset(
//                              'assets/images/no_image.png',
//                              height: 80.0,
//                              width: 80.0,
//                            )
//                          : CachedNetworkImage(
//                              imageUrl: restaurantInfo.restaurantData.src,
//                              placeholder: (context, url) => imageShimmer(),
//                              errorWidget: (context, url, error) =>
//                                  Icon(Icons.error),
//                              fit: BoxFit.fill,
//                              height: 80.0,
//                              width: 80.0,
//                            ),
//                    ),
//                  ),
//                  SizedBox(
//                    width: 15,
//                    height: 10,
//                  ),
//                  Expanded(
//                    flex: 2,
//                    child: Column(
//                      crossAxisAlignment: CrossAxisAlignment.start,
//                      children: <Widget>[
//                        Row(
//                          crossAxisAlignment: CrossAxisAlignment.start,
//                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                          children: <Widget>[
//                            Text(
//                              restaurantInfo.restaurantData.name,
//                              overflow: TextOverflow.ellipsis,
//                              style: Theme.of(context)
//                                  .textTheme
//                                  .display1
//                                  .copyWith(
//                                      fontSize: 14,
//                                      fontWeight: FontWeight.w600),
//                            ),
//                            GestureDetector(
//                              onTap: () {
//                                if (model.accessToken.isNotEmpty) {
//                                  //call api
//                                  model.updateFavoritesIndex(index);
//                                  model.wishListRequest(
//                                    restaurantId:
//                                        restaurantInfo.restaurantData.id,
//                                  );
////                                  setState(
////                                    () {
////                                      favoriteIndex = widget.index;
////                                    },
////                                  );
//
//                                } else {
//                                  // move to login
//                                  Navigator.pushNamed(context, login);
//                                }
//                              },
//                              child: Padding(
//                                padding: const EdgeInsets.only(right: 10.0),
//                                child: Icon(
//                                  Icons.favorite,
//                                  color: restaurantInfo
//                                          .restaurantData.favouriteStatus
//                                      ? Colors.red
//                                      : Colors.grey[300],
//                                ),
//                              ),
//                            ),
//                          ],
//                        ),
//                        verticalSizedBox(),
//                        Row(
//                          crossAxisAlignment: CrossAxisAlignment.start,
//                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                          children: <Widget>[
//                            Flexible(
//                              child: Text(
//                                restaurantInfo.restaurantData.resDesc,
//                                overflow: TextOverflow.ellipsis,
//                                style: Theme.of(context)
//                                    .textTheme
//                                    .display2
//                                    .copyWith(
//                                      fontSize: 13,
//                                    ),
//                              ),
//                            ),
//                            Text(
//                              ' - ',
//                              style:
//                                  Theme.of(context).textTheme.display3.copyWith(
//                                        fontWeight: FontWeight.w600,
//                                      ),
//                            ),
//                            Container(
//                              height: 15,
//                              child: ListView.builder(
//                                  itemCount: 4,
//                                  shrinkWrap: true,
//                                  scrollDirection: Axis.horizontal,
//                                  itemBuilder: (context, index) {
//                                    return Text(
//                                      r"$",
//                                      style: Theme.of(context)
//                                          .textTheme
//                                          .display3
//                                          .copyWith(
//                                            fontSize: 11,
//                                            color: index <=
//                                                    restaurantInfo
//                                                        .restaurantData.budget
//                                                ? Colors.black
//                                                : Colors.grey,
//                                          ),
//                                    );
//                                  }),
//                            )
//                          ],
//                        ),
//                        verticalSizedBoxFive(),
//                        Row(
//                          children: <Widget>[
//                            Icon(
//                              Icons.star,
//                              color: (restaurantInfo.restaurantData.rating == 0)
//                                  ? Colors.grey[600]
//                                  : Colors.amber,
//                              size: 20.0,
//                            ),
//                            SizedBox(
//                              width: 8,
//                            ),
//                            Text(
//                              restaurantInfo.restaurantData.rating.toString(),
//                              style: Theme.of(context)
//                                  .textTheme
//                                  .display3
//                                  .copyWith(fontSize: 12),
//                            ),
//                            Text(
//                              " - ",
//                              style:
//                                  Theme.of(context).textTheme.display3.copyWith(
//                                        fontWeight: FontWeight.w500,
//                                      ),
//                            ),
//                            Text(
//                              restaurantInfo.restaurantData.distance.toString(),
//                              style: Theme.of(context)
//                                  .textTheme
//                                  .display3
//                                  .copyWith(fontSize: 12),
//                            ),
//                            SizedBox(
//                              width: 5,
//                            ),
//                            Text(
//                              "(${restaurantInfo.restaurantData.deliveryTime.toString()} mins) " ??
//                                  " ",
//                              style: Theme.of(context)
//                                  .textTheme
//                                  .display2
//                                  .copyWith(fontSize: 12),
//                            ),
//                          ],
//                        ),
//                        verticalSizedBox(),
//                        divider(),
//                        restaurantInfo.restaurantData.promoStatus == 1
//                            ? shopOpenedWidget()
//                            : Visibility(
//                                visible:
//                                    restaurantInfo.restaurantData.mode == "open"
//                                        ? false
//                                        : true,
//                                child: Column(
//                                  children: <Widget>[
//                                    Divider(
//                                      color: Colors.black45,
//                                    ),
//                                    SizedBox(
//                                      height: 3,
//                                    ),
//                                    ShopClosedWidget()
//                                  ],
//                                ),
//                              ),
//                      ],
//                    ),
//                  ),
//                ],
//              ),
//            ),
//          ),
//        );
//      },
//    );
//  }

  Row shopOpenedWidget() => Row(
        children: <Widget>[
          Image.asset(
            "assets/images/percentage.jpg",
            width: 20,
            height: 20,
            color: Colors.blue,
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            'Promo',
            style: Theme.of(context).textTheme.display2.copyWith(fontSize: 13),
          ),
        ],
      );

  Row showOutlets() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 18,
                width: 18,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.orange,
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.fiber_manual_record,
                    color: Colors.orange,
                    size: 6,
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                'See more outlets',
                style: Theme.of(context).textTheme.display2.copyWith(
                      color: darkGreen,
                      fontSize: 13,
                    ),
              ),
            ],
          ),
          Flexible(
            child: GestureDetector(
              onTap: () {},
              child: Icon(
                Icons.keyboard_arrow_right,
                size: 20,
              ),
            ),
          ),
        ],
      );
}
