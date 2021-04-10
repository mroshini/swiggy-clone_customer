import 'package:flutter/material.dart';
import 'package:foodstar/generated/l10n.dart';
import 'package:foodstar/src/constants/api_params_keys.dart';
import 'package:foodstar/src/constants/api_urls.dart';
import 'package:foodstar/src/constants/common_strings.dart';
import 'package:foodstar/src/constants/route_path.dart';
import 'package:foodstar/src/core/models/arguments_model/restaurant_arg_model.dart';
import 'package:foodstar/src/core/provider_viewmodels/common/base_change_notifier_model.dart';
import 'package:foodstar/src/core/provider_viewmodels/search_view_model.dart';
import 'package:foodstar/src/core/service/app_exception.dart';
import 'package:foodstar/src/ui/res/colors.dart';
import 'package:foodstar/src/ui/routes/restaurant_details/change_restaurant_bottom_sheet.dart';
import 'package:foodstar/src/ui/shared/no_search_item_restaurants.dart';
import 'package:foodstar/src/ui/shared/others.dart';
import 'package:foodstar/src/ui/shared/rest_delete_food_items_delete_bottom_sheet.dart';
import 'package:foodstar/src/ui/shared/shop_closed_widget.dart';
import 'package:foodstar/src/ui/shared/show_snack_bar.dart';
import 'package:foodstar/src/ui/shared/sizedbox.dart';
import 'package:foodstar/src/utils/banner_slider_shimmer.dart';
import 'package:foodstar/src/utils/common_navigation.dart';
import 'package:foodstar/src/utils/restaurant_info_list_shimmer.dart';
import 'package:provider/provider.dart';

class RestaurantItemSearchScreen extends StatefulWidget {
  final TextEditingController searchedKeyWord;
  final SearchViewModel model;

  RestaurantItemSearchScreen({this.searchedKeyWord, this.model});

  @override
  _RestaurantItemSearchScreenState createState() =>
      _RestaurantItemSearchScreenState(model: model);
}

class _RestaurantItemSearchScreenState
    extends State<RestaurantItemSearchScreen> {
  final SearchViewModel model;

  _RestaurantItemSearchScreenState({this.model});

  @override
  Widget build(BuildContext context) {
    return model.state == BaseViewState.Busy
        ? Container(
            child: ListView.builder(
                itemCount: 7,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return showShimmer(context);
                }),
          )
        : Container(
            child: model.listOfDishData.length == 0
                ? NoSearchItemsAvailableScreen(
                    title: "No Dishes Found",
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: model.listOfDishData.length ?? 0,
                    itemBuilder: (context, parentIndex) {
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () async {
                                model.updateSearchDoneOrNot(false);
                                model.saveClickedThroughSearch(
                                    widget.searchedKeyWord.text,
                                    model.listOfDishData[parentIndex]
                                        .restaurantId
                                        .toString(),
                                    model.listOfDishData[parentIndex].id
                                        .toString(),
                                    context);
                                widget.searchedKeyWord.text = "";
                                await Navigator.of(context)
                                    .pushNamed(
                                      restaurantDetails,
                                      arguments: RestaurantsArgModel(
                                          imageTag: "search$parentIndex",
                                          restaurantID: model
                                              .listOfDishData[parentIndex]
                                              .restaurantId,
                                          // image: "",
                                          image: model
                                              .listOfDishData[parentIndex]
                                              .restaurantDetail
                                              .src,
                                          city: 'Madurai',
                                          fromWhere: 2,
                                          availabilityStatus: model
                                              .listOfDishData[parentIndex]
                                              .restaurantDetail
                                              .availability
                                              .status),
                                    )
                                    .then((value) => {
                                          model.getAlreadySearchedData(context),
                                        });
                              },
                              child: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Flexible(
                                          child: Text(
                                            model.listOfDishData[parentIndex]
                                                .restaurantDetail.name,
                                            style: Theme.of(context)
                                                .textTheme
                                                .display1
                                                .copyWith(
                                                  fontSize: 16,
                                                ),
                                          ),
                                        ),
                                        Flexible(
                                          child: Text(
                                            'VIEW MENU',
                                            style: Theme.of(context)
                                                .textTheme
                                                .display3
                                                .copyWith(
                                                  color: blue,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    verticalSizedBox(),
                                    Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.star,
                                          size: 15,
                                          color: model
                                                      .listOfDishData[
                                                          parentIndex]
                                                      .restaurantDetail
                                                      .rating !=
                                                  0
                                              ? Colors.amber
                                              : Colors.grey,
                                        ),
                                        horizontalSizedBoxFive(),
                                        Text(
                                          model.listOfDishData[parentIndex]
                                              .restaurantDetail.rating
                                              .toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .display2,
                                        ),
                                        horizontalSizedBoxFive(),
                                        verticalDivider(),
                                        horizontalSizedBoxFive(),
                                        Text(
                                          ' ${model.listOfDishData[parentIndex].restaurantDetail.deliveryTime} mins ',
                                          style: Theme.of(context)
                                              .textTheme
                                              .display2,
                                        ),
                                        horizontalSizedBoxFive(),
                                        verticalDivider(),
                                        horizontalSizedBoxFive(),
                                        Flexible(
                                          child: Text(
                                            model.listOfDishData[parentIndex]
                                                .restaurantDetail.cuisineText,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .display2,
                                          ),
                                        ),
                                      ],
                                    ),
                                    verticalSizedBox(),
                                    (model
                                                .listOfDishData[parentIndex]
                                                .restaurantDetail
                                                .availability
                                                .status ==
                                            1)
                                        ? Container()
                                        : ShopClosedWidget(
                                            nextAvailableText: model
                                                .listOfDishData[parentIndex]
                                                .restaurantDetail
                                                .availability
                                                .text
                                                .toString(),
                                          )
                                  ],
                                ),
                              ),
                            ),
                            divider(),
                            verticalSizedBox(),
                            ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: model.listOfDishData[parentIndex]
                                    .aFoodItems.length,
                                itemBuilder: (context, index) {
//                                      return RestSearchCartFoodItemScreen(
//                                        parentIndex: parentIndex,
//                                        childIndex: index,
//                                        fromWhichScreen: 2,
//                                        shopAvailabilityStatus: model
//                                            .listOfDishData[parentIndex]
//                                            .restaurantDetail
//                                            .availability
//                                            .status,
//                                        searchViewModel: model,
//                                      );
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10.0),
                                    child: InkWell(
                                      onTap: () {
                                        showModalBottomSheet(
                                            builder: (context) =>
                                                restaurantItemDetailBottomSheet(
                                                  model: Provider.of<
                                                      SearchViewModel>(
                                                    context,
                                                  ),
                                                  parentIndex: parentIndex,
                                                  index: index,
                                                ),
                                            context: context,
                                            isScrollControlled: true);
                                      },
                                      child: Container(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Offstage(
                                              offstage: model
                                                              .listOfDishData[
                                                                  parentIndex]
                                                              .aFoodItems[index]
                                                              .exactSrc ==
                                                          "" ||
                                                      model
                                                              .listOfDishData[
                                                                  parentIndex]
                                                              .aFoodItems[index]
                                                              .exactSrc ==
                                                          null
                                                  ? true
                                                  : false,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  5.0,
                                                ),
                                                child: (model
                                                                .listOfDishData[
                                                                    parentIndex]
                                                                .restaurantDetail
                                                                .availability
                                                                .status ==
                                                            1 &&
                                                        model
                                                                .listOfDishData[
                                                                    parentIndex]
                                                                .aFoodItems[
                                                                    index]
                                                                .availability
                                                                .status ==
                                                            1)
                                                    ? networkImage(
                                                        image: model
                                                            .listOfDishData[
                                                                parentIndex]
                                                            .aFoodItems[index]
                                                            .exactSrc,
                                                        loaderImage:
                                                            loaderBeforeImage(),
                                                        height: 70.0,
                                                        width: 70.0,
                                                      )
                                                    : networkClosedRestImage(
                                                        image: model
                                                            .listOfDishData[
                                                                parentIndex]
                                                            .aFoodItems[index]
                                                            .exactSrc,
                                                        loaderImage:
                                                            loaderBeforeImage(),
                                                        height: 70.0,
                                                        width: 70.0,
                                                      ),
//                                                        ? CachedNetworkImage(
//                                                            imageUrl: model
//                                                                    .listOfDishData[
//                                                                        parentIndex]
//                                                                    .aFoodItems[
//                                                                        index]
//                                                                    .exactSrc ??
//                                                                "",
//                                                            placeholder: (context,
//                                                                    url) =>
//                                                                imageShimmer(),
//                                                            errorWidget:
//                                                                (context, url,
//                                                                        error) =>
//                                                                    Icon(Icons
//                                                                        .error),
//                                                            fit: BoxFit.fill,
//                                                            height: 80.0,
//                                                            width: 80.0,
//                                                          )
//                                                        : ColorFiltered(
//                                                            colorFilter: ColorFilter
//                                                                .mode(
//                                                                    Colors.black
//                                                                        .withOpacity(
//                                                                      0.2,
//                                                                    ),
//                                                                    BlendMode
//                                                                        .dstATop),
//                                                            child:
//                                                                CachedNetworkImage(
//                                                              imageUrl: model
//                                                                      .listOfDishData[
//                                                                          parentIndex]
//                                                                      .aFoodItems[
//                                                                          index]
//                                                                      .exactSrc ??
//                                                                  "",
//                                                              placeholder: (context,
//                                                                      url) =>
//                                                                  imageShimmer(),
//                                                              errorWidget: (context,
//                                                                      url,
//                                                                      error) =>
//                                                                  Icon(Icons
//                                                                      .error),
//                                                              fit: BoxFit.fill,
//                                                              height: 80.0,
//                                                              width: 80.0,
//                                                            ),
//                                                          ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 12,
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Column(
                                                children: <Widget>[
                                                  Material(
                                                    color: transparent,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: <Widget>[
                                                            Row(
                                                              children: <
                                                                  Widget>[
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      vertical:
                                                                          3.0),
                                                                  child:
                                                                      Container(
                                                                    height: 13,
                                                                    width: 13,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius
                                                                              .circular(
                                                                        2.0,
                                                                      ),
                                                                      border: Border.all(
                                                                          color: model.listOfDishData[parentIndex].aFoodItems[index].status == "Veg"
                                                                              ? Colors.green
                                                                              : red),
                                                                    ),
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .fiber_manual_record,
                                                                        color: model.listOfDishData[parentIndex].aFoodItems[index].status ==
                                                                                "Veg"
                                                                            ? Colors.green
                                                                            : red,
                                                                        size:
                                                                            10,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 5,
                                                                ),
                                                                Text(
                                                                    model
                                                                            .listOfDishData[
                                                                                parentIndex]
                                                                            .aFoodItems[
                                                                                index]
                                                                            .foodItem ??
                                                                        "",
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .display1),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                        verticalSizedBoxFive(),
                                                        Text(
                                                          model
                                                                  .listOfDishData[
                                                                      parentIndex]
                                                                  .aFoodItems[
                                                                      index]
                                                                  .description ??
                                                              "",
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .display2,
                                                        ),
                                                        verticalSizedBoxFive(),
                                                        Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: <Widget>[
                                                            Flexible(
                                                              child: Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: <
                                                                    Widget>[
                                                                  Flexible(
                                                                    child: Text(
                                                                      // show price added
                                                                      '${model.currencySymbol} ${model.listOfDishData[parentIndex].aFoodItems[index].showPrice}',
                                                                      style: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .display3
                                                                          .copyWith(
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                          ),
                                                                    ),
                                                                  ),
                                                                  horizontalSizedBox(),
                                                                  Flexible(
                                                                    child: Text(
                                                                      '${model.currencySymbol} ${model.listOfDishData[parentIndex].aFoodItems[index].originalPrice}',
                                                                      style: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .display2
                                                                          .copyWith(
                                                                            fontSize:
                                                                                13,
                                                                            color:
                                                                                Colors.grey[400],
                                                                            decoration:
                                                                                TextDecoration.lineThrough,
                                                                          ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            (model
                                                                            .listOfDishData[
                                                                                parentIndex]
                                                                            .aFoodItems[
                                                                                index]
                                                                            .cartDetail
                                                                            .quantity >
                                                                        0 &&
                                                                    (model.listOfDishData[parentIndex].restaurantDetail.availability.status ==
                                                                            1 &&
                                                                        model.listOfDishData[parentIndex].aFoodItems[index].availability.status ==
                                                                            1)
                                                                ? Flexible(
                                                                    child:
                                                                        editButton(
                                                                      favoriteStatus:
                                                                          true,
                                                                      quantity: model
                                                                          .listOfDishData[
                                                                              parentIndex]
                                                                          .aFoodItems[
                                                                              index]
                                                                          .cartDetail
                                                                          .quantity,
                                                                      model:
                                                                          model,
                                                                      index:
                                                                          index,
                                                                      parentIndex:
                                                                          parentIndex,
                                                                      isBottomsheet:
                                                                          false,
                                                                    ),
                                                                  )
                                                                : Flexible(
                                                                    child:
                                                                        addButton(
                                                                      model:
                                                                          model,
                                                                      index:
                                                                          index,
                                                                      parentIndex:
                                                                          parentIndex,
                                                                      cartQuantity: model
                                                                          .listOfDishData[
                                                                              parentIndex]
                                                                          .aFoodItems[
                                                                              index]
                                                                          .cartDetail
                                                                          .quantity,
                                                                      isBottomsheet:
                                                                          false,
                                                                    ),
                                                                  )),
                                                          ],
                                                        ),
                                                        verticalSizedBoxFive(),
//                                                        verticalSizedBoxFive(),
//                                                        (model
//                                                                        .listOfDishData[
//                                                                            parentIndex]
//                                                                        .aFoodItems[
//                                                                            index]
//                                                                        .cartDetail
//                                                                        .quantity >
//                                                                    0 &&
//                                                                (model
//                                                                            .listOfDishData[
//                                                                                parentIndex]
//                                                                            .restaurantDetail
//                                                                            .availability
//                                                                            .status ==
//                                                                        1 &&
//                                                                    model
//                                                                            .listOfDishData[parentIndex]
//                                                                            .aFoodItems[index]
//                                                                            .availability
//                                                                            .status ==
//                                                                        1)
//                                                            ? editButton(
//                                                                favoriteStatus:
//                                                                    true,
//                                                                quantity: model
//                                                                    .listOfDishData[
//                                                                        parentIndex]
//                                                                    .aFoodItems[
//                                                                        index]
//                                                                    .cartDetail
//                                                                    .quantity,
//                                                                model: model,
//                                                                index: index,
//                                                                parentIndex:
//                                                                    parentIndex,
//                                                                isBottomsheet:
//                                                                    false,
//                                                              )
//                                                            : addButton(
//                                                                model: model,
//                                                                index: index,
//                                                                parentIndex:
//                                                                    parentIndex,
//                                                                cartQuantity: model
//                                                                    .listOfDishData[
//                                                                        parentIndex]
//                                                                    .aFoodItems[
//                                                                        index]
//                                                                    .cartDetail
//                                                                    .quantity,
//                                                                isBottomsheet:
//                                                                    false,
//                                                              )),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                })
                          ],
                        ),
                      );
                    },
                  ),
          );
//    return Consumer<SearchViewModel>(
//      builder: (BuildContext context, SearchViewModel model, Widget child) {
//        return model.state == BaseViewState.Busy
//            ? Container(
//                child: ListView.builder(
//                    itemCount: 7,
//                    shrinkWrap: true,
//                    itemBuilder: (context, index) {
//                      return showShimmer(context);
//                    }),
//              )
//            : Container(
//                child: model.listOfDishData.length == 0
//                    ? NoSearchItemsAvailableScreen(
//                        title: "No Dishes Found",
//                      )
//                    : ListView.builder(
//                        shrinkWrap: true,
//                        physics: NeverScrollableScrollPhysics(),
//                        itemCount: model.listOfDishData.length ?? 0,
//                        itemBuilder: (context, parentIndex) {
//                          return Padding(
//                            padding: const EdgeInsets.all(10.0),
//                            child: Column(
//                              crossAxisAlignment: CrossAxisAlignment.start,
//                              children: <Widget>[
//                                GestureDetector(
//                                  onTap: () async {
//                                    model.saveClickedThroughSearch(
//                                      widget.searchedKeyWord,
//                                      model.listOfDishData[parentIndex]
//                                          .restaurantId
//                                          .toString(),
//                                      model.listOfDishData[parentIndex].id
//                                          .toString(),
//                                    );
//
//                                    await Navigator.of(context)
//                                        .pushNamed(
//                                          restaurantDetails,
//                                          arguments: RestaurantsArgModel(
//                                              imageTag: "search$parentIndex",
//                                              restaurantID: model
//                                                  .listOfDishData[parentIndex]
//                                                  .restaurantId,
//                                              // image: "",
//                                              image: model
//                                                  .listOfDishData[parentIndex]
//                                                  .restaurantDetail
//                                                  .src,
//                                              city: 'Madurai',
//                                              fromWhere: 2,
//                                              availabilityStatus: model
//                                                  .listOfDishData[parentIndex]
//                                                  .restaurantDetail
//                                                  .availability
//                                                  .status),
//                                        )
//                                        .then((value) => {
//                                              model
//                                                  .updateSearchListViewDataUpdatedFromRestDetails(),
//                                            });
//                                  },
//                                  child: Container(
//                                    child: Column(
//                                      crossAxisAlignment:
//                                          CrossAxisAlignment.start,
//                                      mainAxisAlignment:
//                                          MainAxisAlignment.start,
//                                      children: <Widget>[
//                                        Row(
//                                          crossAxisAlignment:
//                                              CrossAxisAlignment.start,
//                                          mainAxisAlignment:
//                                              MainAxisAlignment.spaceBetween,
//                                          children: <Widget>[
//                                            Text(
//                                              model.listOfDishData[parentIndex]
//                                                  .restaurantDetail.name,
//                                              style: Theme.of(context)
//                                                  .textTheme
//                                                  .display1
//                                                  .copyWith(
//                                                    fontSize: 18,
//                                                  ),
//                                            ),
//                                            Text(
//                                              'VIEW MENU',
//                                              style: Theme.of(context)
//                                                  .textTheme
//                                                  .display3
//                                                  .copyWith(
//                                                    color: blue,
//                                                  ),
//                                            ),
//                                          ],
//                                        ),
//                                        verticalSizedBox(),
//                                        Row(
//                                          children: <Widget>[
//                                            Icon(
//                                              Icons.star,
//                                              color: model
//                                                          .listOfDishData[
//                                                              parentIndex]
//                                                          .restaurantDetail
//                                                          .rating !=
//                                                      0
//                                                  ? Colors.amber
//                                                  : Colors.grey,
//                                            ),
//                                            Text(
//                                              model.listOfDishData[parentIndex]
//                                                  .restaurantDetail.rating
//                                                  .toString(),
//                                              style: Theme.of(context)
//                                                  .textTheme
//                                                  .display2,
//                                            ),
//                                            horizontalSizedBoxFive(),
//                                            verticalDivider(),
//                                            horizontalSizedBoxFive(),
//                                            Text(
//                                              ' ${model.listOfDishData[parentIndex].restaurantDetail.deliveryTime} mins ',
//                                              style: Theme.of(context)
//                                                  .textTheme
//                                                  .display2,
//                                            ),
//                                            horizontalSizedBoxFive(),
//                                            verticalDivider(),
//                                            horizontalSizedBoxFive(),
//                                            Flexible(
//                                              child: Text(
//                                                model
//                                                    .listOfDishData[parentIndex]
//                                                    .restaurantDetail
//                                                    .cuisineText,
//                                                overflow: TextOverflow.ellipsis,
//                                                style: Theme.of(context)
//                                                    .textTheme
//                                                    .display2,
//                                              ),
//                                            ),
//                                          ],
//                                        ),
//                                        verticalSizedBox(),
//                                        (model
//                                                    .listOfDishData[parentIndex]
//                                                    .restaurantDetail
//                                                    .availability
//                                                    .status ==
//                                                1)
//                                            ? Container()
//                                            : ShopClosedWidget(
//                                                nextAvailableText: model
//                                                    .listOfDishData[parentIndex]
//                                                    .restaurantDetail
//                                                    .availability
//                                                    .text
//                                                    .toString(),
//                                              )
//                                      ],
//                                    ),
//                                  ),
//                                ),
//                                divider(),
//                                verticalSizedBox(),
//                                ListView.builder(
//                                    shrinkWrap: true,
//                                    physics: NeverScrollableScrollPhysics(),
//                                    itemCount: model.listOfDishData[parentIndex]
//                                        .aFoodItems.length,
//                                    itemBuilder: (context, index) {
////                                      return RestSearchCartFoodItemScreen(
////                                        parentIndex: parentIndex,
////                                        childIndex: index,
////                                        fromWhichScreen: 2,
////                                        shopAvailabilityStatus: model
////                                            .listOfDishData[parentIndex]
////                                            .restaurantDetail
////                                            .availability
////                                            .status,
////                                        searchViewModel: model,
////                                      );
//                                      return Padding(
//                                        padding: const EdgeInsets.symmetric(
//                                            vertical: 10.0),
//                                        child: Container(
//                                          child: Row(
//                                            mainAxisAlignment:
//                                                MainAxisAlignment.start,
//                                            crossAxisAlignment:
//                                                CrossAxisAlignment.start,
//                                            children: <Widget>[
//                                              Offstage(
//                                                offstage: model
//                                                                .listOfDishData[
//                                                                    parentIndex]
//                                                                .aFoodItems[
//                                                                    index]
//                                                                .exactSrc ==
//                                                            "" ||
//                                                        model
//                                                                .listOfDishData[
//                                                                    parentIndex]
//                                                                .aFoodItems[
//                                                                    index]
//                                                                .exactSrc ==
//                                                            null
//                                                    ? true
//                                                    : false,
//                                                child: InkWell(
//                                                  onTap: () {
////                                                  DialogHelper.menuPopup(
////                                                      context);
//                                                  },
//                                                  child: ClipRRect(
//                                                    borderRadius:
//                                                        BorderRadius.circular(
//                                                      5.0,
//                                                    ),
//                                                    child: (model
//                                                                    .listOfDishData[
//                                                                        parentIndex]
//                                                                    .restaurantDetail
//                                                                    .availability
//                                                                    .status ==
//                                                                1 &&
//                                                            model
//                                                                    .listOfDishData[
//                                                                        parentIndex]
//                                                                    .aFoodItems[
//                                                                        index]
//                                                                    .availability
//                                                                    .status ==
//                                                                1)
//                                                        ? networkImage(
//                                                            image: model
//                                                                .listOfDishData[
//                                                                    parentIndex]
//                                                                .aFoodItems[
//                                                                    index]
//                                                                .exactSrc,
//                                                            loaderImage:
//                                                                loaderBeforeImage(),
//                                                            height: 80.0,
//                                                            width: 80.0,
//                                                          )
//                                                        : networkClosedRestImage(
//                                                            image: model
//                                                                .listOfDishData[
//                                                                    parentIndex]
//                                                                .aFoodItems[
//                                                                    index]
//                                                                .exactSrc,
//                                                            loaderImage:
//                                                                loaderBeforeImage(),
//                                                            height: 80.0,
//                                                            width: 80.0,
//                                                          ),
////                                                        ? CachedNetworkImage(
////                                                            imageUrl: model
////                                                                    .listOfDishData[
////                                                                        parentIndex]
////                                                                    .aFoodItems[
////                                                                        index]
////                                                                    .exactSrc ??
////                                                                "",
////                                                            placeholder: (context,
////                                                                    url) =>
////                                                                imageShimmer(),
////                                                            errorWidget:
////                                                                (context, url,
////                                                                        error) =>
////                                                                    Icon(Icons
////                                                                        .error),
////                                                            fit: BoxFit.fill,
////                                                            height: 80.0,
////                                                            width: 80.0,
////                                                          )
////                                                        : ColorFiltered(
////                                                            colorFilter: ColorFilter
////                                                                .mode(
////                                                                    Colors.black
////                                                                        .withOpacity(
////                                                                      0.2,
////                                                                    ),
////                                                                    BlendMode
////                                                                        .dstATop),
////                                                            child:
////                                                                CachedNetworkImage(
////                                                              imageUrl: model
////                                                                      .listOfDishData[
////                                                                          parentIndex]
////                                                                      .aFoodItems[
////                                                                          index]
////                                                                      .exactSrc ??
////                                                                  "",
////                                                              placeholder: (context,
////                                                                      url) =>
////                                                                  imageShimmer(),
////                                                              errorWidget: (context,
////                                                                      url,
////                                                                      error) =>
////                                                                  Icon(Icons
////                                                                      .error),
////                                                              fit: BoxFit.fill,
////                                                              height: 80.0,
////                                                              width: 80.0,
////                                                            ),
////                                                          ),
//                                                  ),
//                                                ),
//                                              ),
//                                              SizedBox(
//                                                width: 12,
//                                              ),
//                                              Expanded(
//                                                flex: 2,
//                                                child: Column(
//                                                  children: <Widget>[
//                                                    Material(
//                                                      color: transparent,
//                                                      child: InkWell(
//                                                        onTap: () {
//                                                          openBottomSheet(
//                                                              context,
//                                                              restaurantItemDetailBottomSheet(
//                                                                model: Provider
//                                                                    .of<SearchViewModel>(
//                                                                        context),
//                                                                parentIndex:
//                                                                    parentIndex,
//                                                                index: index,
//                                                              ),
//                                                              scrollControlled:
//                                                                  true);
////                                                        openBottomSheet(
////                                                            context,
////                                                            RestaurantItemDetailBottomSheetScreen(
////                                                              imageSrc: model
////                                                                  .listOfDishData[
////                                                                      parentIndex]
////                                                                  .foodItemView[
////                                                                      index]
////                                                                  .exactSrc,
////                                                              nameOfDish: model
////                                                                  .listOfDishData[
////                                                                      parentIndex]
////                                                                  .foodItemView[
////                                                                      index]
////                                                                  .foodItem,
////                                                              description: model
////                                                                  .listOfDishData[
////                                                                      parentIndex]
////                                                                  .foodItemView[
////                                                                      index]
////                                                                  .description,
////                                                              price: model
////                                                                  .listOfDishData[
////                                                                      parentIndex]
////                                                                  .foodItemView[
////                                                                      index]
////                                                                  .showPrice
////                                                                  .toString(),
////                                                              typeOfProvider: 2,
////                                                              foodID: model
////                                                                  .listOfDishData[
////                                                                      parentIndex]
////                                                                  .foodItemView[
////                                                                      index]
////                                                                  .id,
////                                                              index: index,
////                                                              parentIndex:
////                                                                  parentIndex,
////                                                              cartQuantity: model
////                                                                  .listOfDishData[
////                                                                      parentIndex]
////                                                                  .foodItemView[
////                                                                      index]
////                                                                  .cartQuantity,
////                                                              availabilityStatus:
////                                                                  (model.listOfDishData[parentIndex].restaurantDetail.availability.status ==
////                                                                              1 &&
////                                                                          model.listOfDishData[parentIndex].foodItemView[index].availability.status ==
////                                                                              1)
////                                                                      ? true
////                                                                      : false,
////                                                            ),
////                                                            scrollControlled:
////                                                                true);
//                                                        },
//                                                        child: Column(
//                                                          crossAxisAlignment:
//                                                              CrossAxisAlignment
//                                                                  .start,
//                                                          children: <Widget>[
//                                                            Row(
//                                                              crossAxisAlignment:
//                                                                  CrossAxisAlignment
//                                                                      .start,
//                                                              mainAxisAlignment:
//                                                                  MainAxisAlignment
//                                                                      .spaceBetween,
//                                                              children: <
//                                                                  Widget>[
//                                                                Row(
//                                                                  children: <
//                                                                      Widget>[
//                                                                    Padding(
//                                                                      padding: const EdgeInsets
//                                                                              .symmetric(
//                                                                          vertical:
//                                                                              3.0),
//                                                                      child:
//                                                                          Container(
//                                                                        height:
//                                                                            13,
//                                                                        width:
//                                                                            13,
//                                                                        decoration:
//                                                                            BoxDecoration(
//                                                                          borderRadius:
//                                                                              BorderRadius.circular(
//                                                                            2.0,
//                                                                          ),
//                                                                          border:
//                                                                              Border.all(color: model.listOfDishData[parentIndex].aFoodItems[index].status == "Veg" ? Colors.green : red),
//                                                                        ),
//                                                                        child:
//                                                                            Center(
//                                                                          child:
//                                                                              Icon(
//                                                                            Icons.fiber_manual_record,
//                                                                            color: model.listOfDishData[parentIndex].aFoodItems[index].status == "Veg"
//                                                                                ? Colors.green
//                                                                                : red,
//                                                                            size:
//                                                                                10,
//                                                                          ),
//                                                                        ),
//                                                                      ),
//                                                                    ),
//                                                                    SizedBox(
//                                                                      width: 5,
//                                                                    ),
//                                                                    Text(
//                                                                        model.listOfDishData[parentIndex].aFoodItems[index].foodItem ??
//                                                                            "",
//                                                                        overflow:
//                                                                            TextOverflow
//                                                                                .ellipsis,
//                                                                        style: Theme.of(context)
//                                                                            .textTheme
//                                                                            .display1),
//                                                                  ],
//                                                                ),
//                                                              ],
//                                                            ),
//                                                            verticalSizedBoxFive(),
//                                                            Text(
//                                                              model
//                                                                      .listOfDishData[
//                                                                          parentIndex]
//                                                                      .aFoodItems[
//                                                                          index]
//                                                                      .description ??
//                                                                  "",
//                                                              overflow:
//                                                                  TextOverflow
//                                                                      .ellipsis,
//                                                              style: Theme.of(
//                                                                      context)
//                                                                  .textTheme
//                                                                  .display2,
//                                                            ),
//                                                            verticalSizedBoxFive(),
//                                                            Row(
//                                                              crossAxisAlignment:
//                                                                  CrossAxisAlignment
//                                                                      .start,
//                                                              mainAxisAlignment:
//                                                                  MainAxisAlignment
//                                                                      .spaceBetween,
//                                                              children: <
//                                                                  Widget>[
//                                                                Flexible(
//                                                                  child: Row(
//                                                                    crossAxisAlignment:
//                                                                        CrossAxisAlignment
//                                                                            .start,
//                                                                    children: <
//                                                                        Widget>[
//                                                                      Text(
//                                                                        // show price added
//                                                                        '${model.currencySymbol} ${model.listOfDishData[parentIndex].aFoodItems[index].showPrice}',
//                                                                        style: Theme.of(context)
//                                                                            .textTheme
//                                                                            .display3
//                                                                            .copyWith(
//                                                                              fontWeight: FontWeight.w600,
//                                                                            ),
//                                                                      ),
//                                                                      horizontalSizedBox(),
//                                                                      Text(
//                                                                        '${model.currencySymbol} ${model.listOfDishData[parentIndex].aFoodItems[index].originalPrice}',
//                                                                        style: Theme.of(context)
//                                                                            .textTheme
//                                                                            .display2
//                                                                            .copyWith(
//                                                                              color: Colors.grey[400],
//                                                                              decoration: TextDecoration.lineThrough,
//                                                                            ),
//                                                                      ),
//                                                                    ],
//                                                                  ),
//                                                                ),
//                                                                (model.listOfDishData[parentIndex].aFoodItems[index].cartDetail.quantity >
//                                                                            0 &&
//                                                                        (model.listOfDishData[parentIndex].restaurantDetail.availability.status ==
//                                                                                1 &&
//                                                                            model.listOfDishData[parentIndex].aFoodItems[index].availability.status ==
//                                                                                1)
//                                                                    ? Flexible(
//                                                                        child:
//                                                                            editButton(
//                                                                          favoriteStatus:
//                                                                              true,
//                                                                          quantity: model
//                                                                              .listOfDishData[parentIndex]
//                                                                              .aFoodItems[index]
//                                                                              .cartDetail
//                                                                              .quantity,
//                                                                          model:
//                                                                              model,
//                                                                          index:
//                                                                              index,
//                                                                          parentIndex:
//                                                                              parentIndex,
//                                                                          isBottomsheet:
//                                                                              false,
//                                                                        ),
//                                                                      )
//                                                                    : Flexible(
//                                                                        child:
//                                                                            addButton(
//                                                                          model:
//                                                                              model,
//                                                                          index:
//                                                                              index,
//                                                                          parentIndex:
//                                                                              parentIndex,
//                                                                          cartQuantity: model
//                                                                              .listOfDishData[parentIndex]
//                                                                              .aFoodItems[index]
//                                                                              .cartDetail
//                                                                              .quantity,
//                                                                          isBottomsheet:
//                                                                              false,
//                                                                        ),
//                                                                      )),
//                                                              ],
//                                                            ),
//                                                          ],
//                                                        ),
//                                                      ),
//                                                    ),
//                                                  ],
//                                                ),
//                                              ),
//                                            ],
//                                          ),
//                                        ),
//                                      );
//                                    })
//                              ],
//                            ),
//                          );
//                        },
//                      ),
//              );
//      },
//    );
  }

  Container verticalDivider() => Container(
        color: Colors.black54,
        width: 2,
        height: 10,
      );

  addButtonForBottomSheet(
      {SearchViewModel model,
      int index,
      int parentIndex,
      int cartQuantity,
      bool isBottomsheet}) {
    return cartQuantity == 0
        ? Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {
                if (model.listOfDishData[parentIndex].aFoodItems[index]
                            .availability.status ==
                        1 &&
                    model.listOfDishData[parentIndex].restaurantDetail
                            .availability.status ==
                        1) {
//                    model.initAddItemFromSearch(
//                        index: index, parentIndex: parentIndex);
//                    model.cartActionsRequestFromSearch(
//                      foodId: model
//                          .listOfDishData[parentIndex].foodItemView[index].id,
//                      action: addItem,
//                      context: context,
//                    );

                  checkCartExistsOrNot(
                    foodID:
                        model.listOfDishData[parentIndex].aFoodItems[index].id,
                    action: addItem,
                    context: context,
                    index: index,
                    parentIndex: parentIndex,
                    model: model,
                    addOrRemove: false,
                    typeofCalc: deleteItem,
                    isBottomSheet: isBottomsheet,
                  );
                } else {
//                  showSnackbar(
//                      message: model.listOfDishData[parentIndex]
//                                      .restaurantDetail.availability.status ==
//                                  1 &&
//                              model.listOfDishData[parentIndex]
//                                      .aFoodItems[index].availability.status ==
//                                  0
//                          ? 'FoodItem not Available'
//                          : 'Restaurant not available',
//                      context: context);

                  showFoodOrRestNotAvailableSnackBar(
                      restAvailability: model.listOfDishData[parentIndex]
                          .restaurantDetail.availability.status,
                      itemAvailability: model.listOfDishData[parentIndex]
                          .aFoodItems[index].availability.status,
                      context: context);
                }
              },
              child: Container(
                height: 40,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: model.listOfDishData[parentIndex].aFoodItems[index]
                                  .availability.status ==
                              1 &&
                          model.listOfDishData[parentIndex].restaurantDetail
                                  .availability.status ==
                              1
                      ? appColor
                      : Colors.grey[300],
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Center(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Add',
                        style: Theme.of(context)
                            .textTheme
                            .display3
                            .copyWith(color: white, fontSize: 15),
                      ),
                      horizontalSizedBox(),
                      Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        : Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {
//                showSnackbar(
//                    message: 'Restaurant not available', context: context);

                checkRestOrFoodItemNotAvailable(
                    model: model,
                    index: index,
                    parentIndex: parentIndex,
                    foodItemAvailability: model.listOfDishData[parentIndex]
                        .aFoodItems[index].availability.status,
                    restaurantAvailability: model.listOfDishData[parentIndex]
                        .restaurantDetail.availability.status);
              },
              child: Card(
                elevation: 2,
                child: Container(
                  height: 30,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.grey[300],
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 1.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          horizontalSizedBoxFive(),
                          Flexible(
                            child: Material(
                              color: transparent,
                              child: Icon(
                                Icons.remove,
                                color: white,
                                size: 25,
                              ),
                            ),
                          ),
                          horizontalSizedBox(),
                          Text(
                            "$cartQuantity",
                            style: Theme.of(context)
                                .textTheme
                                .display3
                                .copyWith(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 18,
                                    color: white),
                          ),
                          horizontalSizedBox(),
                          Flexible(
                            child: Material(
                              color: transparent,
                              child: Icon(
                                Icons.add,
                                color: white,
                                size: 25,
                              ),
                            ),
                          ),
                          horizontalSizedBoxFive(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
//            child: GestureDetector(
//              onTap: () {
////                  model.initAddItemFromSearch(
////                      index: index, parentIndex: parentIndex);
////                  model.cartActionsRequestFromSearch(
////                    foodId: model
////                        .listOfDishData[parentIndex].foodItemView[index].id,
////                    action: deleteItem,
////                    context: context,
////                  );
//
//                checkCartExistsOrNot(
//                    foodID:
//                        model.listOfDishData[parentIndex].aFoodItems[index].id,
//                    action: deleteItem,
//                    context: context,
//                    index: index,
//                    parentIndex: parentIndex,
//                    model: model,
//                    typeofCalc: deleteItem,
//                    isBottomSheet: isBottomsheet);
//              },
//              child: Container(
//                height: 25,
//                width: 70,
//                decoration: BoxDecoration(
//                  color: Colors.grey[300],
//                  borderRadius: BorderRadius.circular(5.0),
//                ),
//                child: Center(
//                  child: Row(
//                    crossAxisAlignment: CrossAxisAlignment.start,
//                    mainAxisAlignment: MainAxisAlignment.center,
//                    children: <Widget>[
//                      Text(
//                        '$cartQuantity',
//                        style: Theme.of(context).textTheme.display3.copyWith(
//                              color: white,
//                              fontSize: 14,
//                            ),
//                      ),
//                      horizontalSizedBox(),
//                      Icon(
//                        Icons.delete,
//                        color: darkRed,
//                        size: 17,
//                      ),
//                    ],
//                  ),
//                ),
//              ),
//            ),
          );
  }

  Align addButton(
          {SearchViewModel model,
          int index,
          int parentIndex,
          int cartQuantity,
          bool isBottomsheet}) =>
      // change

      cartQuantity == 0
          ? Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  if (model.listOfDishData[parentIndex].aFoodItems[index]
                              .availability.status ==
                          1 &&
                      model.listOfDishData[parentIndex].restaurantDetail
                              .availability.status ==
                          1) {
//                    model.initAddItemFromSearch(
//                        index: index, parentIndex: parentIndex);
//                    model.cartActionsRequestFromSearch(
//                      foodId: model
//                          .listOfDishData[parentIndex].foodItemView[index].id,
//                      action: addItem,
//                      context: context,
//                    );

                    checkCartExistsOrNot(
                        foodID: model
                            .listOfDishData[parentIndex].aFoodItems[index].id,
                        action: addItem,
                        context: context,
                        index: index,
                        parentIndex: parentIndex,
                        model: model,
                        addOrRemove: false,
                        typeofCalc: deleteItem,
                        isBottomSheet: isBottomsheet);
                  } else {
//                    showSnackbar(
//                        message: 'Restaurant not available', context: context);

                    showFoodOrRestNotAvailableSnackBar(
                        restAvailability: model.listOfDishData[parentIndex]
                            .restaurantDetail.availability.status,
                        itemAvailability: model.listOfDishData[parentIndex]
                            .aFoodItems[index].availability.status,
                        context: context);

//                    showSnackbar(
//                        message: model.listOfDishData[parentIndex]
//                                        .restaurantDetail.availability.status ==
//                                    1 &&
//                                model
//                                        .listOfDishData[parentIndex]
//                                        .aFoodItems[index]
//                                        .availability
//                                        .status ==
//                                    0
//                            ? 'FoodItem not Available'
//                            : 'Restaurant not available',
//                        context: context);
                  }
                },
                child: Card(
                  elevation: 2,
                  child: Container(
                    height: 25,
                    width: 70,
                    decoration: BoxDecoration(
                      color: model.listOfDishData[parentIndex].aFoodItems[index]
                                      .availability.status ==
                                  1 &&
                              model.listOfDishData[parentIndex].restaurantDetail
                                      .availability.status ==
                                  1
                          ? appColor
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Center(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Add',
                            style: Theme.of(context)
                                .textTheme
                                .display3
                                .copyWith(color: white, fontSize: 13),
                          ),
                          horizontalSizedBox(),
                          Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 17,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          : Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
//                  showSnackbar(
//                      message: 'Restaurant not available', context: context);

//                  openFoodItemEditBottomSheet(
//                    context,
//                    RestDeleteFoodItemsDeleteBottomSheet(
//                      dynamicMapValue: {
//                        deviceIDKey: model.deviceId,
//                        userIdKey: model.userId.toString(),
//                        foodIdKey: model
//                            .listOfDishData[parentIndex].aFoodItems[index].id
//                            .toString(),
//                        restaurantIdKey: model.listOfDishData[parentIndex]
//                            .aFoodItems[index].restaurantId
//                            .toString(),
//                        actionKey: model.listOfDishData[parentIndex]
//                                        .restaurantDetail.availability.status ==
//                                    1 &&
//                                model
//                                        .listOfDishData[parentIndex]
//                                        .aFoodItems[index]
//                                        .availability
//                                        .status ==
//                                    0
//                            ? deleteItem
//                            : restaurantDelete,
//                        imageKey: model.listOfDishData[parentIndex]
//                                        .restaurantDetail.availability.status ==
//                                    1 &&
//                                model
//                                        .listOfDishData[parentIndex]
//                                        .aFoodItems[index]
//                                        .availability
//                                        .status ==
//                                    0
//                            ? model.listOfDishData[parentIndex]
//                                .aFoodItems[index].exactSrc
//                            : model.listOfDishData[parentIndex].restaurantDetail
//                                .src
//                                .toString(),
//                        fromWhichScreen: "2"
//                      },
//                      context: context,
//                    ),
//                  ).then((value) => {
//                        showLog("Exists or not${value}"),
//                        if (value != null)
//                          {
//                            model.refreshScreenAfterFoodOrRestaurantDelete(
//                                index: index,
//                                parentIndex: parentIndex,
//                                action: value,
//                                restaurantID: model.listOfDishData[parentIndex]
//                                    .aFoodItems[index].restaurantId)
//                          }
//                        else
//                          {
//                            // no need to do any changes
//                          }
//                      });

                  checkRestOrFoodItemNotAvailable(
                      model: model,
                      index: index,
                      parentIndex: parentIndex,
                      foodItemAvailability: model.listOfDishData[parentIndex]
                          .aFoodItems[index].availability.status,
                      restaurantAvailability: model.listOfDishData[parentIndex]
                          .restaurantDetail.availability.status);
                },
                child: Card(
                  elevation: 2,
                  child: Container(
                    height: 25,
                    width: 70,
                    color: Colors.grey,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 1.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            horizontalSizedBoxFive(),
                            Flexible(
                              child: Material(
                                color: transparent,
                                child: Icon(
                                  Icons.remove,
                                  color: appColor,
                                  size: 20,
                                ),
                              ),
                            ),
                            horizontalSizedBox(),
                            Text(
                              "$cartQuantity",
                              style: Theme.of(context)
                                  .textTheme
                                  .display3
                                  .copyWith(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14),
                            ),
                            horizontalSizedBox(),
                            Flexible(
                              child: Material(
                                color: transparent,
                                child: Icon(
                                  Icons.add,
                                  color: appColor,
                                  size: 20,
                                ),
                              ),
                            ),
                            horizontalSizedBoxFive(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
//              child: GestureDetector(
//                onTap: () {
////                  model.initAddItemFromSearch(
////                      index: index, parentIndex: parentIndex);
////                  model.cartActionsRequestFromSearch(
////                    foodId: model
////                        .listOfDishData[parentIndex].foodItemView[index].id,
////                    action: deleteItem,
////                    context: context,
////                  );
//
//                  checkCartExistsOrNot(
//                      foodID: model
//                          .listOfDishData[parentIndex].aFoodItems[index].id,
//                      action: deleteItem,
//                      context: context,
//                      index: index,
//                      parentIndex: parentIndex,
//                      model: model,
//                      typeofCalc: deleteItem,
//                      isBottomSheet: isBottomsheet);
//                },
//                child: Container(
//                  height: 25,
//                  width: 70,
//                  decoration: BoxDecoration(
//                    color: Colors.grey[300],
//                    borderRadius: BorderRadius.circular(5.0),
//                  ),
//                  child: Center(
//                    child: Row(
//                      crossAxisAlignment: CrossAxisAlignment.start,
//                      mainAxisAlignment: MainAxisAlignment.center,
//                      children: <Widget>[
//                        Text(
//                          '$cartQuantity',
//                          style: Theme.of(context).textTheme.display3.copyWith(
//                                color: white,
//                                fontSize: 14,
//                              ),
//                        ),
//                        horizontalSizedBox(),
//                        Icon(
//                          Icons.delete,
//                          color: darkRed,
//                          size: 17,
//                        ),
//                      ],
//                    ),
//                  ),
//                ),
//              ),
            );

  Row editButtonForBottomSheet(
          {bool favoriteStatus,
          int quantity,
          SearchViewModel model,
          int index,
          int parentIndex,
          bool isBottomsheet}) =>
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
//          GestureDetector(
//            onTap: () {
//              openFoodItemEditBottomSheet(
//                      context,
//                      AddDishNotesScreen(
//                        foodID: model
//                            .listOfDishData[parentIndex].aFoodItems[index].id,
//                        searchViewModel: model,
//                        fromWhere: 2,
//                        parentIndex: parentIndex,
//                        itemNotes: model.listOfDishData[parentIndex]
//                            .aFoodItems[index].cartDetail.itemNote,
//                        childIndex: index,
//                        mContext: context,
//                      ),
//                      scrollControlled: true)
//                  .then((value) => {
//                        if (value != null)
//                          {
//                            showLog("cartdataaa -- ${value} "),
//                            model.cartActionsRequest(
//                              foodId: model.listOfDishData[parentIndex]
//                                  .aFoodItems[index].id,
//                              action: itemNotes,
//                              itemNotes: value,
//                              context: context,
//                            ),
//                            model.updateItemNotes(
//                              parentIndex: parentIndex,
//                              index: index,
//                              itemNotes: value,
//                            ),
//                          }
//                      });
//            },
//            child: Container(
//              height: 33,
//              width: 33,
//              child: Card(
//                elevation: 2,
//                child: Icon(
//                  model.listOfDishData[parentIndex]
//                      .aFoodItems[index].cartDetail.itemNote!="" ? Icons.check_circle : Icons.edit,
//                  color: appColor,
//                  size: 17.0,
//                ),
//              ),
//            ),
//          ),
//          horizontalSizedBox(),
          Card(
            elevation: 2,
            child: Container(
              height: 35,
              width: MediaQuery.of(context).size.width / 1.5,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 1.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      horizontalSizedBoxFive(),
                      Flexible(
                        child: Material(
                          color: transparent,
                          child: InkWell(
                            onTap: () {
//                                model.addAndRemoveFoodPriceFromSearch(
//                                    index: index,
//                                    addOrRemove: false,
//                                    parentIndex: parentIndex);
//                                model.cartActionsRequestFromSearch(
//                                  foodId: model.listOfDishData[parentIndex]
//                                      .foodItemView[index].id,
//                                  action: removeItem,
//                                  context: context,
//                                );

                              checkCartExistsOrNot(
                                  foodID: model.listOfDishData[parentIndex]
                                      .aFoodItems[index].id,
                                  action: removeItem,
                                  context: context,
                                  index: index,
                                  parentIndex: parentIndex,
                                  model: model,
                                  addOrRemove: false,
                                  typeofCalc: removeItem,
                                  isBottomSheet: isBottomsheet);
                            },
                            child: Icon(
                              Icons.remove,
                              color: appColor,
                              size: 25,
                            ),
                          ),
                        ),
                      ),
                      horizontalSizedBox(),
                      Text(
                        "$quantity",
                        style: Theme.of(context).textTheme.display3.copyWith(
                            fontWeight: FontWeight.w400, fontSize: 18),
                      ),
                      horizontalSizedBox(),
                      Flexible(
                        child: Material(
                          color: transparent,
                          child: InkWell(
                            onTap: () {
//                                model.addAndRemoveFoodPriceFromSearch(
//                                    index: index,
//                                    addOrRemove: true,
//                                    parentIndex: parentIndex);
//
//                                model.cartActionsRequestFromSearch(
//                                  foodId: model.listOfDishData[parentIndex]
//                                      .foodItemView[index].id,
//                                  action: addItem,
//                                  context: context,
//                                );

                              checkCartExistsOrNot(
                                  foodID: model.listOfDishData[parentIndex]
                                      .aFoodItems[index].id,
                                  action: addItem,
                                  context: context,
                                  index: index,
                                  parentIndex: parentIndex,
                                  model: model,
                                  addOrRemove: true,
                                  typeofCalc: addItem,
                                  isBottomSheet: isBottomsheet);
                            },
                            child: Icon(
                              Icons.add,
                              color: appColor,
                              size: 25,
                            ),
                          ),
                        ),
                      ),
                      horizontalSizedBoxFive(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      );

  Row editButton(
          {bool favoriteStatus,
          int quantity,
          SearchViewModel model,
          int index,
          int parentIndex,
          bool isBottomsheet}) =>
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
//          GestureDetector(
//            onTap: () {
//              openFoodItemEditBottomSheet(
//                      context,
//                      AddDishNotesScreen(
//                        foodID: model
//                            .listOfDishData[parentIndex].aFoodItems[index].id,
//                        searchViewModel: model,
//                        fromWhere: 2,
//                        parentIndex: parentIndex,
//                        itemNotes: model.listOfDishData[parentIndex]
//                            .aFoodItems[index].cartDetail.itemNote,
//                        childIndex: index,
//                        mContext: context,
//                      ),
//                      scrollControlled: true)
//                  .then((value) => {
//                        if (value != null)
//                          {
//                            showLog("cartdataaa -- ${value} "),
//                            model.cartActionsRequest(
//                              foodId: model.listOfDishData[parentIndex]
//                                  .aFoodItems[index].id,
//                              action: itemNotes,
//                              itemNotes: value,
//                              context: context,
//                            ),
//                            model.updateItemNotes(
//                              parentIndex: parentIndex,
//                              index: index,
//                              itemNotes: value,
//                            ),
//                          }
//                      });
//            },
//            child: Container(
//              height: 37,
//              width: 33,
//              child: Card(
//                elevation: 2,
//                child: Icon(
//                  model.listOfDishData[parentIndex].aFoodItems[index].cartDetail
//                              .itemNote !=
//                          ""
//                      ? Icons.check_circle
//                      : Icons.edit,
//                  color: appColor,
//                  size: 17.0,
//                ),
//              ),
//            ),
//          ),
//          horizontalSizedBox(),
          Card(
            elevation: 2,
            child: Container(
//              height: 30,
//              width: 90,
              height: 27,
              width: 75,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 1.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      horizontalSizedBoxFive(),
                      Flexible(
                        child: Material(
                          color: transparent,
                          child: InkWell(
                            onTap: () {
//                                model.addAndRemoveFoodPriceFromSearch(
//                                    index: index,
//                                    addOrRemove: false,
//                                    parentIndex: parentIndex);
//                                model.cartActionsRequestFromSearch(
//                                  foodId: model.listOfDishData[parentIndex]
//                                      .foodItemView[index].id,
//                                  action: removeItem,
//                                  context: context,
//                                );

                              checkCartExistsOrNot(
                                  foodID: model.listOfDishData[parentIndex]
                                      .aFoodItems[index].id,
                                  action: removeItem,
                                  context: context,
                                  index: index,
                                  parentIndex: parentIndex,
                                  model: model,
                                  addOrRemove: false,
                                  typeofCalc: removeItem,
                                  isBottomSheet: isBottomsheet);
                            },
                            child: Container(
                              height: 30,
                              width: 30,
                              child: Icon(
                                Icons.remove,
                                color: appColor,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                      horizontalSizedBox(),
                      Center(
                        child: Text(
                          "$quantity",
                          style: Theme.of(context).textTheme.display3.copyWith(
                              fontWeight: FontWeight.w400, fontSize: 14),
                        ),
                      ),
                      horizontalSizedBox(),
                      Flexible(
                        child: Material(
                          color: transparent,
                          child: InkWell(
                            onTap: () {
//                                model.addAndRemoveFoodPriceFromSearch(
//                                    index: index,
//                                    addOrRemove: true,
//                                    parentIndex: parentIndex);
//
//                                model.cartActionsRequestFromSearch(
//                                  foodId: model.listOfDishData[parentIndex]
//                                      .foodItemView[index].id,
//                                  action: addItem,
//                                  context: context,
//                                );

                              checkCartExistsOrNot(
                                  foodID: model.listOfDishData[parentIndex]
                                      .aFoodItems[index].id,
                                  action: addItem,
                                  context: context,
                                  index: index,
                                  parentIndex: parentIndex,
                                  model: model,
                                  addOrRemove: true,
                                  typeofCalc: addItem,
                                  isBottomSheet: isBottomsheet);
                            },
                            child: Container(
                              height: 30,
                              width: 30,
                              child: Icon(
                                Icons.add,
                                color: appColor,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                      horizontalSizedBoxFive(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      );

  showFoodOrRestNotAvailableSnackBar(
      {int restAvailability, int itemAvailability, BuildContext context}) {
    showSnackbar(
        message: restAvailability == 1 && itemAvailability == 0
            ? CommonStrings.foodItemNotAvailable
            : CommonStrings.restaurantNotAvailable,
        context: context);
  }

  checkCartExistsOrNot(
      {int foodID,
      String action,
      BuildContext context,
      int index,
      int parentIndex,
      SearchViewModel model,
      bool addOrRemove,
      String typeofCalc,
      bool isBottomSheet //add,remove, delete,init delete
      }) async {
    if (model.listOfDishData[parentIndex].restaurantDetail.cartExist) {
      // cannot add
      showLog(
          "Exists or not1${model.listOfDishData[parentIndex].restaurantDetail.cartExist}");
      openBottomSheet(
        context,
        ChangeRestaurantScreen(
          dynamicMapValue: {
            deviceIDKey: model.deviceId,
            userIdKey: model.userId.toString(),
            foodIdKey: foodID.toString(),
            actionKey: action,
          },
          context: context,
          fromWhere: 2,
          searchViewModel: model,
          image: model
              .listOfDishData[parentIndex].restaurantDetail.src, //search screen
        ),
      ).then((value) => {
            showLog("Exists or not${value}"),
            if (value)
              {
                model.updateCartExists(parentIndex: parentIndex, index: index),
                //add items
                addRemoveDeleteItems(
                    action: action,
                    index: index,
                    parentIndex: parentIndex,
                    addOrRemove: addOrRemove,
                    model: model,
                    isBottomSheet: isBottomSheet)
              }
            else
              {
                showLog(
                    "Exists or not2${model.listOfDishData[parentIndex].restaurantDetail.cartExist}")
                // no need to do any changes
              }
          });
    } else {
      // can add
      showLog(
          "Exists or not3 ${model.listOfDishData[parentIndex].restaurantDetail.cartExist}");
      try {
        addRemoveDeleteItems(
          action: action,
          index: index,
          parentIndex: parentIndex,
          addOrRemove: addOrRemove,
          model: model,
          isBottomSheet: isBottomSheet,
        );
        await model.cartActionsRequest(
          foodId: foodID,
          action: action,
          context: context,
        );
      } on BadRequestException catch (e) {
        String error = e.toString();
        if (error == CommonStrings.foodItemNotAvailable) {
          showLog("checkRestOrFoodItemNotAvailable1 ${error}");
          model.setFoodItemsNotAvailable(
            index: index,
            parentIndex: parentIndex,
            restaurantID: model
                .listOfDishData[parentIndex].aFoodItems[index].restaurantId,
          );
          checkRestOrFoodItemNotAvailable(
            model: model,
            index: index,
            parentIndex: parentIndex,
            foodItemAvailability: 0,
            restaurantAvailability: 1,
          );
        } else if (error == CommonStrings.restaurantNotAvailable) {
          showLog("checkRestOrFoodItemNotAvailable2 ${error}");
          model.setRestaurantNotAvailable(
            index: index,
            parentIndex: parentIndex,
            restaurantID: model
                .listOfDishData[parentIndex].aFoodItems[index].restaurantId,
          );

          checkRestOrFoodItemNotAvailable(
            model: model,
            index: index,
            parentIndex: parentIndex,
            foodItemAvailability: 0,
            restaurantAvailability: 0,
          );
        } else if (error == CommonStrings.notAvailable) {
          model.notAvailable(index: index, parentIndex: parentIndex);
          showFoodOrRestNotAvailableSnackBar(
              restAvailability: 1, itemAvailability: 0, context: context);
        } else {
          showInfoAlertDialog(
              context: context,
              response: error,
              onClicked: () {
                Navigator.pop(context);
              });
        }
      }
    }
  }

  addRemoveDeleteItems(
      {String action,
      int index,
      int parentIndex,
      bool addOrRemove,
      SearchViewModel model,
      bool isBottomSheet}) {
    if (action == addItem) {
      model.addAndRemoveFoodPrice(
          index: index, parentIndex: parentIndex, addOrRemove: true);
    } else if (action == deleteItem) {
      model.deleteItem(index: index, parentIndex: parentIndex);
    } else if (action == removeItem) {
      model.addAndRemoveFoodPrice(
          index: index, parentIndex: parentIndex, addOrRemove: false);
    }

//    if (isBottomSheet) {
//      Navigator.pop(context);
//
//      showModalBottomSheet(
//        builder: (context) => restaurantItemDetailBottomSheet(
//          model: model,
//          parentIndex: parentIndex,
//          index: index,
//        ),
//        context: context,
//        isScrollControlled: true,
//      );
//    }
  }

  Widget restaurantItemDetailBottomSheet({
    SearchViewModel model,
    // List<ACommonFoodItem> foodItem,
    int index,
    int parentIndex,
    int cartQuantity,
  }) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 10.0,
          ),
          child: Column(
            children: <Widget>[
              dragIcon(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(
                    10.0,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                      20.0,
                    ),
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Visibility(
                            visible: model.listOfDishData[parentIndex]
                                .aFoodItems[index].exactSrc.isNotEmpty,
                            child: Container(
                              height: 200,
                              width: MediaQuery.of(context).size.width,
                              child: model
                                          .listOfDishData[parentIndex]
                                          .aFoodItems[index]
                                          .availability
                                          .status ==
                                      1
                                  ? networkImage(
                                      image: model.listOfDishData[parentIndex]
                                          .aFoodItems[index].exactSrc,
                                      loaderImage:
                                          loaderBeforeResturantDetailBannerImage(),
                                    )
                                  : networkClosedRestImage(
                                      image: model.listOfDishData[parentIndex]
                                          .aFoodItems[index].exactSrc,
                                      loaderImage:
                                          loaderBeforeResturantDetailBannerImage(),
//                                      height: 80.0,
//                                      width: 80.0,
                                    ),
//                            child: CachedNetworkImage(
//                              imageUrl: widget.imageSrc,
//                              placeholder: (context, url) =>
//                                  largeImageShimmer(context),
//                              errorWidget: (context, url, error) =>
//                                  Icon(Icons.error),
//                              fit: BoxFit.fill,
//                              height: 80.0,
//                              width: 80.0,
//                            ),
                            ),
                          ),
                          verticalSizedBoxTwenty(),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      model.listOfDishData[parentIndex]
                                          .aFoodItems[index].foodItem,
                                      style:
                                          Theme.of(context).textTheme.display1,
                                    ),
                                    verticalSizedBox(),
                                    Text(
                                      model.listOfDishData[parentIndex]
                                          .aFoodItems[index].description,
                                      style:
                                          Theme.of(context).textTheme.display3,
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  showShareIntent(CommonStrings.foodItemShare);
                                },
                                child: Container(
                                  height: 30,
                                  width: 80,
                                  decoration: BoxDecoration(
                                    color: appColor,
                                    borderRadius: BorderRadius.circular(
                                      5.0,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      S.of(context).share,
                                      style: Theme.of(context)
                                          .textTheme
                                          .display3
                                          .copyWith(color: white),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      S.of(context).dishPrice,
                      style: Theme.of(context).textTheme.display1,
                    ),
                    verticalSizedBox(),
                    Text(
                      '${model.currencySymbol} ${model.listOfDishData[parentIndex].aFoodItems[index].showPrice}',
                      style: Theme.of(context).textTheme.display1,
                    ),
                  ],
                ),
              ),
              verticalSizedBox(),
              Padding(
                padding: const EdgeInsets.all(
                  10.0,
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: model.listOfDishData[parentIndex].aFoodItems[index]
                                  .availability.status ==
                              1 &&
                          model.listOfDishData[parentIndex].aFoodItems[index]
                                  .cartDetail.quantity >
                              0
                      ? editButtonForBottomSheet(
                          quantity: model.listOfDishData[parentIndex]
                              .aFoodItems[index].cartDetail.quantity,
                          model: model,
                          index: index,
                          parentIndex: parentIndex,
                          isBottomsheet: true,
                        )
                      : addButtonForBottomSheet(
                          cartQuantity: model.listOfDishData[parentIndex]
                              .aFoodItems[index].cartDetail.quantity,
                          model: model,
                          index: index,
                          parentIndex: parentIndex,
                          isBottomsheet: true,
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  checkRestOrFoodItemNotAvailable(
      {SearchViewModel model,
      int index,
      int parentIndex,
      int restaurantAvailability,
      int foodItemAvailability}) {
    openFoodItemEditBottomSheet(
      context,
      RestDeleteFoodItemsDeleteBottomSheet(
        dynamicMapValue: {
          deviceIDKey: model.deviceId,
          userIdKey: model.userId.toString(),
          foodIdKey:
              model.listOfDishData[parentIndex].aFoodItems[index].id.toString(),
          restaurantIdKey: model
              .listOfDishData[parentIndex].aFoodItems[index].restaurantId
              .toString(),
          actionKey: restaurantAvailability == 1 && foodItemAvailability == 0
              ? deleteItem
              : restaurantDelete,
          imageKey: restaurantAvailability == 1 && foodItemAvailability == 0
              ? model.listOfDishData[parentIndex].aFoodItems[index].exactSrc
              : model.listOfDishData[parentIndex].restaurantDetail.src
                  .toString(),
          fromWhichScreen: "2"
        },
        context: context,
      ),
      scrollControlled: true,
    ).then((value) => {
          showLog("Exists or not${value}"),
          if (value != null)
            {
              model.refreshScreenAfterFoodOrRestaurantDelete(
                  index: index,
                  parentIndex: parentIndex,
                  action: value,
                  restaurantID: model.listOfDishData[parentIndex]
                      .aFoodItems[index].restaurantId)
            }
          else
            {
              // no need to do any changes
            }
        });
  }
}
