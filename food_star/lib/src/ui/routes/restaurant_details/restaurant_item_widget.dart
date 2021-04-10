import 'package:flutter/material.dart';
import 'package:foodstar/generated/l10n.dart';
import 'package:foodstar/src/constants/api_params_keys.dart';
import 'package:foodstar/src/constants/api_urls.dart';
import 'package:foodstar/src/constants/common_strings.dart';
import 'package:foodstar/src/core/models/api_models/food_items_api_model.dart';
import 'package:foodstar/src/core/provider_viewmodels/restaurant_details_view_model.dart';
import 'package:foodstar/src/core/service/app_exception.dart';
import 'package:foodstar/src/ui/res/colors.dart';
import 'package:foodstar/src/ui/routes/restaurant_details/change_restaurant_bottom_sheet.dart';
import 'package:foodstar/src/ui/shared/others.dart';
import 'package:foodstar/src/ui/shared/rest_delete_food_items_delete_bottom_sheet.dart';
import 'package:foodstar/src/ui/shared/show_snack_bar.dart';
import 'package:foodstar/src/ui/shared/sizedbox.dart';
import 'package:foodstar/src/utils/banner_slider_shimmer.dart';
import 'package:foodstar/src/utils/common_navigation.dart';
import 'package:foodstar/src/utils/validation.dart';
import 'package:provider/provider.dart';

class RestaurantItem extends StatefulWidget {
  final List<ACommonFoodItem> itemInfo;
  final int childIndex;
  final int availabilityTime; // show plus icon or not with add text
  final String imageTag;
  final RestaurantDetailsViewModel model;
  final int parentIndex;

  RestaurantItem(
      {this.itemInfo,
      this.childIndex,
      this.parentIndex,
      this.availabilityTime = 0,
      this.imageTag,
      this.model});

  @override
  _RestaurantItemState createState() => _RestaurantItemState(
      index: childIndex,
      parentIndex: parentIndex,
      itemInfo: itemInfo,
      model: model);
}

class _RestaurantItemState extends State<RestaurantItem> {
  int favoriteIndex = 0;
  TextEditingController addNoteController;
  List<ACommonFoodItem> itemInfo;
  final int index;
  FocusNode addNoteTextFocus = new FocusNode();
  final int parentIndex;
  int foodPrice = 0;
  bool textEdited = false;
  RestaurantDetailsViewModel model;
  String itemNotesData;

  _RestaurantItemState(
      {this.index, this.parentIndex, this.itemInfo, this.model});

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
//    model = Provider.of<RestaurantDetailsViewModel>(context, listen: false);
//    itemInfo = model.catFoodItemsData[parentIndex].aFoodItems;
    return Container(
      child: InkWell(
        onTap: () {
          showModalBottomSheet(
            builder: (context) => restaurantItemDetailBottomSheet(
              restModel: Provider.of<RestaurantDetailsViewModel>(context),
              aFoodItems: itemInfo,
              parentIndex: parentIndex,
              index: index,
            ),
            context: context,
            isScrollControlled: true,
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Offstage(
              offstage: itemInfo[index].exactSrc == "" ? true : false,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                    5.0,
                  ),
                  child: itemInfo[index].availability.status == 1 &&
                          widget.availabilityTime == 1
                      ? networkImage(
                          image: itemInfo[index].exactSrc,
//                          image: model.catFoodItemsData[parentIndex]
//                              .aFoodItems[index].exactSrc,
                          // itemInfo[index].exactSrc,
                          loaderImage: loaderBeforeImage(),
                          height: 70.0,
                          width: 70.0,
                        )
                      : networkClosedRestImage(
//                          image: model.catFoodItemsData[parentIndex]
//                              .aFoodItems[index].exactSrc,
                          image: itemInfo[index].exactSrc,
                          loaderImage: loaderBeforeImage(),
                          height: 70.0,
                          width: 70.0,
                        )
//              CachedNetworkImage(
//                  imageUrl: itemInfo[index].exactSrc,
//                  placeholder: (context, url) => imageShimmer(),
//                  errorWidget: (context, url, error) => Icon(Icons.error),
//                  fit: BoxFit.fill,
//                  height: 80.0,
//                  width: 80.0,
//                ),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 3.0,
                                  ),
                                  child: Container(
                                    height: 13,
                                    width: 13,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                        2.0,
                                      ),
                                      border: Border.all(
                                          color: itemInfo[index].status == "Veg"
                                              ? Colors.green
                                              : red),
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.fiber_manual_record,
                                        color: itemInfo[index].status == "Veg"
                                            ? Colors.green
                                            : red,
                                        size: 10,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(itemInfo[index].foodItem,
                                    overflow: TextOverflow.ellipsis,
                                    style:
                                        Theme.of(context).textTheme.display1),
                              ],
                            ),
                          ],
                        ),
                        verticalSizedBoxFive(),
                        Text(
                          itemInfo[index].description ?? "",
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.display2,
                        ),
                        verticalSizedBoxFive(),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Flexible(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Flexible(
                                    child: Text(
                                      '${model.currencySymbol} ${itemInfo[index].showPrice}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .display3
                                          .copyWith(
                                              fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  horizontalSizedBox(),
                                  Flexible(
                                    child: Text(
                                      '${model.currencySymbol} ${itemInfo[index].originalPrice}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .display2
                                          .copyWith(
                                            fontSize: 13,
                                            color: Colors.grey[400],
                                            decoration:
                                                TextDecoration.lineThrough,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            itemInfo[index].cartDetail.quantity > 0 &&
                                    (widget.availabilityTime == 1 &&
                                        itemInfo[index].availability.status ==
                                            1)
                                ? Flexible(
                                    child: editButton(
                                      itemInfo[index].cartDetail.quantity,
                                      model,
                                      index,
                                      parentIndex,
                                      false,
                                    ),
                                  )
                                : Flexible(
                                    child: addButton(
                                        model,
                                        index,
                                        parentIndex,
                                        itemInfo[index].cartDetail.quantity,
                                        false),
                                  ),
                          ],
                        ),
//                        itemInfo[index].cartDetail.quantity > 0 &&
//                                (widget.availabilityTime == 1 &&
//                                    itemInfo[index].availability.status == 1)
//                            ? editButton(
//                                itemInfo[index].cartDetail.quantity,
//                                model,
//                                index,
//                                parentIndex,
//                                false,
//                              )
//                            : addButton(model, index, parentIndex,
//                                itemInfo[index].cartDetail.quantity, false),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

//    return Consumer<RestaurantDetailsViewModel>(
//      builder: (BuildContext context, RestaurantDetailsViewModel model,
//          Widget child) {
//
//      },
//    );
  }

  Widget restaurantItemDetailBottomSheet({
    List<ACommonFoodItem> aFoodItems,
    RestaurantDetailsViewModel restModel,
    int index,
    int parentIndex,
    int cartQuantity,
  }) {
//    RestaurantDetailsViewModel restModel =
//        Provider.of<RestaurantDetailsViewModel>(context, listen: false);
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
                            visible: aFoodItems[index].exactSrc.isNotEmpty,
                            child: Container(
                              height: 200,
                              width: MediaQuery.of(context).size.width,
                              child: (widget.availabilityTime == 1 &&
                                      aFoodItems[index].availability.status ==
                                          1)
                                  ? networkImage(
                                      image: aFoodItems[index].exactSrc,
                                      // itemInfo[index].exactSrc,
                                      loaderImage:
                                          loaderBeforeResturantDetailBannerImage(),
//                                      height: 80.0,
//                                      width: 80.0,
                                    )
                                  : networkClosedRestImage(
                                      image: aFoodItems[index].exactSrc,
                                      loaderImage:
                                          loaderBeforeResturantDetailBannerImage(),
//                                      height: 80.0,
//                                      width: 80.0,
                                    ),
//                                  ? CachedNetworkImage(
//                                      imageUrl: itemInfo[index].exactSrc,
//                                      placeholder: (context, url) =>
//                                          loaderBeforeImage(
//                                              height: 80.0, width: 80.0),
//                                      //largeImageShimmer(context),
//                                      errorWidget: (context, url, error) =>
//                                          Icon(Icons.error),
//                                      fit: BoxFit.fill,
//                                      height: 80.0,
//                                      width: 80.0,
//                                    )
//                                  : ColorFiltered(
//                                      colorFilter: ColorFilter.mode(
//                                          Colors.black.withOpacity(
//                                            0.2,
//                                          ),
//                                          BlendMode.dstATop),
//                                      child: CachedNetworkImage(
//                                        imageUrl: itemInfo[index].exactSrc,
//                                        placeholder: (context, url) =>
//                                            loaderBeforeImage(
//                                                height: 80.0, width: 80.0),
//                                        //largeImageShimmer(context),
//                                        errorWidget: (context, url, error) =>
//                                            Icon(Icons.error),
//                                        fit: BoxFit.fill,
//                                        height: 80.0,
//                                        width: 80.0,
//                                      ),
//                                    ),
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
                                      aFoodItems[index].foodItem,
                                      style:
                                          Theme.of(context).textTheme.display1,
                                    ),
                                    verticalSizedBox(),
                                    Text(
                                      aFoodItems[index].description,
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
                      '${restModel.currencySymbol} ${aFoodItems[index].showPrice}',
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
                  child: aFoodItems[index].cartDetail.quantity > 0 &&
                          (widget.availabilityTime == 1 &&
                              aFoodItems[index].availability.status == 1)
                      ? editButtonForBottomSheet(
                          aFoodItems[index].cartDetail.quantity,
                          restModel,
                          index,
                          parentIndex,
                          true)
                      : addButtonForBottomSheet(
                          restModel,
                          index,
                          parentIndex,
                          aFoodItems[index].cartDetail.quantity,
                          true,
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

//  Widget restaurantItemDetailBottomSheet({
//     List<ACommonFoodItem> foodItem,
//    RestaurantDetailsViewModel restModel,
//    int index,
//    int parentIndex,
//    int cartQuantity,
//  }) {
////    RestaurantDetailsViewModel restModel =
////        Provider.of<RestaurantDetailsViewModel>(context, listen: false);
//    return Container(
//      height: MediaQuery.of(context).size.height * 0.85,
//      child: Scaffold(
//        resizeToAvoidBottomPadding: false,
//        body: Padding(
//          padding: EdgeInsets.symmetric(
//            horizontal: 10.0,
//          ),
//          child: Column(
//            children: <Widget>[
//              dragIcon(),
//              Expanded(
//                child: Padding(
//                  padding: const EdgeInsets.all(
//                    10.0,
//                  ),
//                  child: ClipRRect(
//                    borderRadius: BorderRadius.circular(
//                      20.0,
//                    ),
//                    child: Container(
//                      height: MediaQuery.of(context).size.height,
//                      child: Column(
//                        crossAxisAlignment: CrossAxisAlignment.start,
//                        mainAxisAlignment: MainAxisAlignment.start,
//                        mainAxisSize: MainAxisSize.min,
//                        children: <Widget>[
//                          Visibility(
//                            visible: restModel.catFoodItemsData[parentIndex]
//                                .aFoodItems[index].exactSrc.isNotEmpty,
//                            child: Container(
//                              height: 200,
//                              width: MediaQuery.of(context).size.width,
//                              child: (widget.availabilityTime == 1 &&
//                                      restModel
//                                              .catFoodItemsData[parentIndex]
//                                              .aFoodItems[index]
//                                              .availability
//                                              .status ==
//                                          1)
//                                  ? networkImage(
//                                      image: restModel
//                                          .catFoodItemsData[parentIndex]
//                                          .aFoodItems[index]
//                                          .exactSrc,
//                                      // itemInfo[index].exactSrc,
//                                      loaderImage: loaderBeforeImage(),
//                                      height: 80.0,
//                                      width: 80.0,
//                                    )
//                                  : networkClosedRestImage(
//                                      image: restModel
//                                          .catFoodItemsData[parentIndex]
//                                          .aFoodItems[index]
//                                          .exactSrc,
//                                      loaderImage: loaderBeforeImage(),
//                                      height: 80.0,
//                                      width: 80.0,
//                                    ),
////                                  ? CachedNetworkImage(
////                                      imageUrl: itemInfo[index].exactSrc,
////                                      placeholder: (context, url) =>
////                                          loaderBeforeImage(
////                                              height: 80.0, width: 80.0),
////                                      //largeImageShimmer(context),
////                                      errorWidget: (context, url, error) =>
////                                          Icon(Icons.error),
////                                      fit: BoxFit.fill,
////                                      height: 80.0,
////                                      width: 80.0,
////                                    )
////                                  : ColorFiltered(
////                                      colorFilter: ColorFilter.mode(
////                                          Colors.black.withOpacity(
////                                            0.2,
////                                          ),
////                                          BlendMode.dstATop),
////                                      child: CachedNetworkImage(
////                                        imageUrl: itemInfo[index].exactSrc,
////                                        placeholder: (context, url) =>
////                                            loaderBeforeImage(
////                                                height: 80.0, width: 80.0),
////                                        //largeImageShimmer(context),
////                                        errorWidget: (context, url, error) =>
////                                            Icon(Icons.error),
////                                        fit: BoxFit.fill,
////                                        height: 80.0,
////                                        width: 80.0,
////                                      ),
////                                    ),
//                            ),
//                          ),
//                          verticalSizedBoxTwenty(),
//                          Row(
//                            crossAxisAlignment: CrossAxisAlignment.start,
//                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                            children: <Widget>[
//                              Flexible(
//                                child: Column(
//                                  crossAxisAlignment: CrossAxisAlignment.start,
//                                  mainAxisAlignment: MainAxisAlignment.start,
//                                  children: <Widget>[
//                                    Text(
//                                      restModel.catFoodItemsData[parentIndex]
//                                          .aFoodItems[index].foodItem,
//                                      style:
//                                          Theme.of(context).textTheme.display1,
//                                    ),
//                                    verticalSizedBox(),
//                                    Text(
//                                      restModel.catFoodItemsData[parentIndex]
//                                          .aFoodItems[index].description,
//                                      style:
//                                          Theme.of(context).textTheme.display3,
//                                    ),
//                                  ],
//                                ),
//                              ),
//                              GestureDetector(
//                                onTap: () {
//                                  showShareIntent(CommonStrings.foodItemShare);
//                                },
//                                child: Container(
//                                  height: 30,
//                                  width: 80,
//                                  decoration: BoxDecoration(
//                                    color: appColor,
//                                    borderRadius: BorderRadius.circular(
//                                      5.0,
//                                    ),
//                                  ),
//                                  child: Center(
//                                    child: Text(
//                                      S.of(context).share,
//                                      style: Theme.of(context)
//                                          .textTheme
//                                          .display3
//                                          .copyWith(color: white),
//                                    ),
//                                  ),
//                                ),
//                              ),
//                            ],
//                          ),
//                        ],
//                      ),
//                    ),
//                  ),
//                ),
//              ),
//              Padding(
//                padding: const EdgeInsets.all(10.0),
//                child: Row(
//                  crossAxisAlignment: CrossAxisAlignment.start,
//                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                  children: <Widget>[
//                    Text(
//                      S.of(context).dishPrice,
//                      style: Theme.of(context).textTheme.display1,
//                    ),
//                    verticalSizedBox(),
//                    Text(
//                      '${restModel.currencySymbol} ${restModel.catFoodItemsData[parentIndex].aFoodItems[index].showPrice}',
//                      style: Theme.of(context).textTheme.display1,
//                    ),
//                  ],
//                ),
//              ),
//              verticalSizedBox(),
//              Padding(
//                padding: const EdgeInsets.all(
//                  10.0,
//                ),
//                child: Container(
//                  width: MediaQuery.of(context).size.width,
//                  child: restModel.catFoodItemsData[parentIndex]
//                                  .aFoodItems[index].cartDetail.quantity >
//                              0 &&
//                          (widget.availabilityTime == 1 &&
//                              restModel.catFoodItemsData[parentIndex]
//                                      .aFoodItems[index].availability.status ==
//                                  1)
//                      ? editButtonForBottomSheet(
//                          restModel.catFoodItemsData[parentIndex]
//                              .aFoodItems[index].cartDetail.quantity,
//                          restModel,
//                          index,
//                          parentIndex,
//                          true)
//                      : addButtonForBottomSheet(
//                          restModel,
//                          index,
//                          parentIndex,
//                          restModel.catFoodItemsData[parentIndex]
//                              .aFoodItems[index].cartDetail.quantity,
//                          true,
//                        ),
//                ),
//              ),
//            ],
//          ),
//        ),
//      ),
//    );
//  }

  Align addButtonForBottomSheet(RestaurantDetailsViewModel model, int index,
      int parentIndex, int cartQuantity, bool isbottomSheet) {
    return cartQuantity == 0
        ? Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {
                if (widget.availabilityTime == 1 &&
                    itemInfo[index].availability.status == 1) {
                  checkCartExistsOrNot(
                    model: model,
                    foodID: itemInfo[index].id,
                    action: addItem,
                    context: context,
                    index: index,
                    parentIndex: parentIndex,
                    addOrRemove: true,
                    typeofCalc: deleteItem,
                    isbottomSheet: isbottomSheet,
                    cartQuantity: cartQuantity,
                    // newly adding item
                  );
//                    model.initAddItem(index: index, parentIndex: parentIndex);
//                    model.cartActionsRequest(
//                      foodId: itemInfo[index].id,
//                      action: addItem,
//                      context: context,
//                      index: index,
//                      parentIndex: parentIndex,
//                    );
                } else {
//                  showSnackbar(
//                      message: widget.availabilityTime == 1 &&
//                              itemInfo[index].availability.status == 0
//                          ? 'FoodItem not Available'
//                          : 'Restaurant not available',
//                      context: context);
                  showFoodOrRestNotAvailableSnackBar(
                      restAvailability: widget.availabilityTime,
                      itemAvailability: itemInfo[index].availability.status,
                      context: context);
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: widget.availabilityTime == 1 &&
                            itemInfo[index].availability.status == 1
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
            ),
          )
        : Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {
//                showSnackbar(
//                    message: 'Restaurant not available', context: context);
//                openFoodItemEditBottomSheet(
//                  context,
//                  RestDeleteFoodItemsDeleteBottomSheet(
//                    dynamicMapValue: {
//                      deviceIDKey: model.deviceId,
//                      userIdKey: model.userId.toString(),
//                      foodIdKey: itemInfo[index].id.toString(),
//                      restaurantIdKey: itemInfo[index].restaurantId.toString(),
//                      actionKey: widget.availabilityTime == 1 &&
//                              itemInfo[index].availability.status == 0
//                          ? deleteItem
//                          : restaurantDelete,
//                      imageKey: widget.availabilityTime == 1 &&
//                              itemInfo[index].availability.status == 0
//                          ? itemInfo[index].exactSrc
//                          : model.restaurantData.src.toString(),
//                      fromWhichScreen: "1"
//                    },
//                    context: context,
//                  ),
//                ).then((value) => {
//                      showLog("Exists or not${value}"),
//                      if (value != null)
//                        {
//                          model.refreshScreenAfterFoodOrRestaurantDelete(
//                              index: index,
//                              parentIndex: parentIndex,
//                              action: value)
//                        }
//                      else
//                        {
//                          // no need to do any changes
//                        }
//                    });

//                if (itemInfo[index].cartDetail.quantity == 0) {

//                  model.makeFoodItemUnavailable(
//                      parentIndex: parentIndex, index: index);
//                  showFoodOrRestNotAvailableSnackBar(
//                      restAvailability: widget.availabilityTime,
//                      itemAvailability: itemInfo[index].availability.status,
//                      context: context);
//                } else {
//
//                }
                checkRestOrFoodItemNotAvailable(
                    parentIndex: parentIndex,
                    index: index,
                    model: model,
                    restaurantAvailability: widget.availabilityTime,
                    foodItemAvailability: itemInfo[index].availability.status,
                    context: context);
              },
              child: Card(
                elevation: 2,
                child: Container(
                  height: 35,
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
                            style:
                                Theme.of(context).textTheme.display3.copyWith(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 18,
                                      color: white,
                                    ),
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
          );
  }

  Align addButton(RestaurantDetailsViewModel model, int index, int parentIndex,
          int cartQuantity, bool isbottomSheet) =>
      // change

      cartQuantity == 0
          ? Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  if (widget.availabilityTime == 1 &&
                      itemInfo[index].availability.status == 1) {
                    checkCartExistsOrNot(
                        model: model,
                        foodID: itemInfo[index].id,
                        action: addItem,
                        context: context,
                        index: index,
                        parentIndex: parentIndex,
                        addOrRemove: true,
                        typeofCalc: deleteItem,
                        isbottomSheet: isbottomSheet
                        // newly adding item
                        );
//                    model.initAddItem(index: index, parentIndex: parentIndex);
//                    model.cartActionsRequest(
//                      foodId: itemInfo[index].id,
//                      action: addItem,
//                      context: context,
//                      index: index,
//                      parentIndex: parentIndex,
//                    );
                  } else {
//                    showSnackbar(
//                        message: widget.availabilityTime == 1 &&
//                                itemInfo[index].availability.status == 0
//                            ? 'FoodItem not Available'
//                            : 'Restaurant not available',
//                        context: context);

                    showFoodOrRestNotAvailableSnackBar(
                        restAvailability: widget.availabilityTime,
                        itemAvailability: itemInfo[index].availability.status,
                        context: context);
                    // if rest not available rest delete

                  }
                },
                child: Card(
                  elevation: 2,
                  child: Container(
                    height: 25,
                    width: 80,
                    decoration: BoxDecoration(
                      color: widget.availabilityTime == 1 &&
                              itemInfo[index].availability.status == 1
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
                            style:
                                Theme.of(context).textTheme.display3.copyWith(
                                      color: white,
                                      fontSize: 14,
                                    ),
                          ),
                          horizontalSizedBox(),
                          Container(
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 20,
                            ),
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
                  // if food items not available food delete
//                  openFoodItemEditBottomSheet(
//                    context,
//                    RestDeleteFoodItemsDeleteBottomSheet(
//                      dynamicMapValue: {
//                        deviceIDKey: model.deviceId,
//                        userIdKey: model.userId.toString(),
//                        foodIdKey: itemInfo[index].id.toString(),
//                        restaurantIdKey:
//                            itemInfo[index].restaurantId.toString(),
//                        actionKey: widget.availabilityTime == 1 &&
//                                itemInfo[index].availability.status == 0
//                            ? deleteItem
//                            : restaurantDelete,
//                        imageKey: model.restaurantData.src.toString(),
//                        fromWhichScreen: "1"
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
//                                action: value)
//                          }
//                        else
//                          {
//                            // no need to do any changes
//                          }
//                      });

                  checkRestOrFoodItemNotAvailable(
                      parentIndex: parentIndex,
                      index: index,
                      model: model,
                      restaurantAvailability: widget.availabilityTime,
                      foodItemAvailability: itemInfo[index].availability.status,
                      context: context);
                },
                child: Card(
                  elevation: 2,
                  child: Container(
                    height: 30,
                    width: 70,
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
                                      color: white,
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
            );

  showFoodOrRestNotAvailableSnackBar(
      {int restAvailability, int itemAvailability, BuildContext context}) {
    showSnackbar(
        message: restAvailability == 1 && itemAvailability == 0
            ? CommonStrings.foodItemNotAvailable
            : CommonStrings.restaurantNotAvailable,
        context: context);
  }

  editButtonForBottomSheet(int quantity, RestaurantDetailsViewModel model,
      int index, int parentIndex, bool isbottomSheet) {
    showLog("editButtonForBottomSheet ${quantity}");
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
//        GestureDetector(
//          onTap: () {
//            openFoodItemEditBottomSheet(
//                    context,
//                    AddDishNotesScreen(
//                      foodID: model
//                          .catFoodItemsData[parentIndex].aFoodItems[index].id,
//                      //   model: model,
//                      fromWhere: 1,
//                      parentIndex: parentIndex,
//                      itemNotes: model.catFoodItemsData[parentIndex]
//                          .aFoodItems[index].cartDetail.itemNote,
//                      childIndex: index,
//                      mContext: context,
//                    ),
//                    scrollControlled: true)
//                .then((value) => {
//                      if (value != null)
//                        {
//                          showLog("cartdataaa -- ${value} "),
//                          model.cartActionsRequest(
//                            foodId: model.catFoodItemsData[parentIndex]
//                                .aFoodItems[index].id,
//                            action: itemNotes,
//                            itemNotes: value,
//                            context: context,
//                          ),
//                          model.updateItemNotes(
//                            parentIndex: parentIndex,
//                            index: index,
//                            itemNotes: value,
//                          ),
//                        }
//                    });
//          },
//          child: Container(
//            height: 40,
//            width: 40,
//            child: Card(
//              elevation: 2,
//              child: Icon(
//                model.catFoodItemsData[parentIndex].aFoodItems[index].cartDetail
//                            .itemNote !=
//                        ""
//                    ? Icons.check_circle
//                    : Icons.edit,
//                color: appColor,
//                size: 17.0,
//              ),
//            ),
//          ),
//        ),
//        horizontalSizedBox(),
        Card(
          elevation: 2,
          child: Container(
            height: 30,
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
                            checkCartExistsOrNot(
                              model: model,
                              foodID: itemInfo[index].id,
                              action: removeItem,
                              context: context,
                              index: index,
                              parentIndex: parentIndex,
                              addOrRemove: false,
                              typeofCalc: removeItem,
                              isbottomSheet: isbottomSheet,
                              cartQuantity: quantity,
                            );

//                                model.addAndRemoveFoodPrice(
//                                    index: index,
//                                    parentIndex: parentIndex,
//                                    addOrRemove: false);
//                                model.cartActionsRequest(
//                                  foodId: itemInfo[index].id,
//                                  action: removeItem,
//                                  context: context,
//                                  index: index,
//                                  parentIndex: parentIndex,
//                                );
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
                      quantity == null ? model.cartQuantity : "${quantity}",
                      style: Theme.of(context)
                          .textTheme
                          .display3
                          .copyWith(fontWeight: FontWeight.w400, fontSize: 16),
                    ),
                    horizontalSizedBox(),
                    Flexible(
                      child: Material(
                        color: transparent,
                        child: InkWell(
                          onTap: () {
                            checkCartExistsOrNot(
                              model: model,
                              foodID: itemInfo[index].id,
                              action: addItem,
                              context: context,
                              index: index,
                              parentIndex: parentIndex,
                              addOrRemove: true,
                              typeofCalc: addItem,
                              isbottomSheet: isbottomSheet,
                              cartQuantity: quantity,
                            );

//                                model.addAndRemoveFoodPrice(
//                                    index: index,
//                                    parentIndex: parentIndex,
//                                    addOrRemove: true);
//
//                                model.cartActionsRequest(
//                                  foodId: itemInfo[index].id,
//                                  action: addItem,
//                                  context: context,
//                                  index: index,
//                                  parentIndex: parentIndex,
//                                );
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
  }

  Row editButton(int quantity, RestaurantDetailsViewModel model, int index,
          int parentIndex, bool isbottomSheet) =>
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
//          GestureDetector(
//            onTap: () {
//              openFoodItemEditBottomSheet(
//                      context,
//                      AddDishNotesScreen(
//                        foodID: itemInfo[index].id,
//                        //   model: model,
//                        fromWhere: 1,
//                        parentIndex: parentIndex,
//                        itemNotes: itemInfo[index].cartDetail.itemNote,
//                        childIndex: index,
//                        mContext: context,
//                      ),
//                      scrollControlled: true)
//                  .then((value) => {
//                        if (value != null)
//                          {
//                            //  showLog("AddDishNotesScreen -- ${value}"),
//                            model.cartActionsRequest(
//                              foodId: itemInfo[index].id,
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
//              height: 34,
//              width: 33,
//              child: Card(
//                elevation: 2,
//                child: Icon(
//                  itemInfo[index].cartDetail.itemNote != ""
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
              height: 25,
              width: 80,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  horizontalSizedBoxFive(),
                  Flexible(
                    child: Material(
                      color: transparent,
                      child: InkWell(
                        onTap: () {
                          checkCartExistsOrNot(
                              model: model,
                              foodID: itemInfo[index].id,
                              action: removeItem,
                              context: context,
                              index: index,
                              parentIndex: parentIndex,
                              addOrRemove: false,
                              typeofCalc: removeItem,
                              isbottomSheet: isbottomSheet);
//                                model.addAndRemoveFoodPrice(
//                                    index: index,
//                                    parentIndex: parentIndex,
//                                    addOrRemove: false);
//                                model.cartActionsRequest(
//                                  foodId: itemInfo[index].id,
//                                  action: removeItem,
//                                  context: context,
//                                  index: index,
//                                  parentIndex: parentIndex,
//                                );
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
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "$quantity",
                      style: Theme.of(context)
                          .textTheme
                          .display3
                          .copyWith(fontWeight: FontWeight.w400, fontSize: 14),
                    ),
                  ),
                  horizontalSizedBox(),
                  Flexible(
                    child: Material(
                      color: transparent,
                      child: InkWell(
                        onTap: () {
                          checkCartExistsOrNot(
                              model: model,
                              foodID: itemInfo[index].id,
                              action: addItem,
                              context: context,
                              index: index,
                              parentIndex: parentIndex,
                              addOrRemove: true,
                              typeofCalc: addItem,
                              isbottomSheet: isbottomSheet);

//                                model.addAndRemoveFoodPrice(
//                                    index: index,
//                                    parentIndex: parentIndex,
//                                    addOrRemove: true);
//
//                                model.cartActionsRequest(
//                                  foodId: itemInfo[index].id,
//                                  action: addItem,
//                                  context: context,
//                                  index: index,
//                                  parentIndex: parentIndex,
//                                );
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
        ],
      );

  checkCartExistsOrNot({
    int foodID,
    String action,
    BuildContext context,
    int index,
    int parentIndex,
    RestaurantDetailsViewModel model,
    bool addOrRemove,
    String typeofCalc,
    int cartQuantity,
    bool isbottomSheet, //add,remove, delete,init delete
  }) async {
    if (model.restaurantData.cartExist) {
      // cannot add
      showLog("Exists or not1${model.restaurantData.cartExist}");

      openBottomSheet(
        context,
        ChangeRestaurantScreen(
          dynamicMapValue: {
            deviceIDKey: model.deviceId,
            userIdKey: model.userId.toString(),
            foodIdKey: foodID.toString(),
            actionKey: action,
          },
          model: model,
          context: context,
          fromWhere: 1,
          image: model.restaurantData.src,
        ),
      ).then((value) => {
            showLog("Exists or not${value}"),
            if (value)
              {
                model.updateCartExists(itemInfo[index].restaurantId),
                //add items
                addRemoveDeleteItems(
                    action: action,
                    index: index,
                    parentIndex: parentIndex,
                    addOrRemove: addOrRemove,
                    model: model,
                    isbottomSheet: isbottomSheet),
              }
            else
              {
                showLog("Exists or not2${model.restaurantData.cartExist}")
                // no need to do any changes
              }
          });

//      showCartAlreadyExistsDialog(
//        parentContext: context,
//        dynamicMapValue: {
//          deviceIDKey: model.deviceId,
//          userIdKey: model.userId.toString(),
//          foodIdKey: foodID.toString(),
//          actionKey: action,
//        },
//        fromWhere: 1,
//      ).then((value) => {
//            showLog("Exists or not${value}"),
//            if (value)
//              {
//                model.updateCartExists(),
//                //add items
//                addRemoveDeleteItems(
//                    action: action,
//                    index: index,
//                    parentIndex: parentIndex,
//                    addOrRemove: addOrRemove,
//                    model: model),
//              }
//            else
//              {
//                showLog("Exists or not2${model.restaurantData.cartExist}")
//                // no need to do any changes
//              }
//          });

    } else {
      // can add

      try {
        addRemoveDeleteItems(
          action: action,
          index: index,
          parentIndex: parentIndex,
          addOrRemove: addOrRemove,
          model: model,
          isbottomSheet: isbottomSheet,
        );
        await model.cartActionsRequest(
          foodId: foodID,
          action: action,
          context: context,
          index: index,
          parentIndex: parentIndex,
        );
//            .then((value) async {
//          try {} catch (e) {
//            var error = e.toString();
//
//            showLog("checkRestOrFoodItemNotAvailable ${error}");
//
//            if (error == CommonStrings.foodItemNotAvailable) {
//              checkRestOrFoodItemNotAvailable(
//                parentIndex: parentIndex,
//                index: index,
//                model: model,
//                restaurantAvailability: 1,
//                foodItemAvailability: 0,
//              );
//            } else if (error == CommonStrings.restaurantNotAvailable) {
//              checkRestOrFoodItemNotAvailable(
//                parentIndex: parentIndex,
//                index: index,
//                model: model,
//                restaurantAvailability: 0,
//                foodItemAvailability: 0,
//              );
//            }
//          }
//        });
      } on BadRequestException catch (e) {
        String error = e.toString();

        showLog("checkRestOrFoodItemNotAvailable ${error}");

        if (error == CommonStrings.foodItemNotAvailable) {
          showLog("checkRestOrFoodItemNotAvailable1 ${error}");
          model.setFoodAvailability(index: index, parentIndex: parentIndex);
          checkRestOrFoodItemNotAvailable(
              parentIndex: parentIndex,
              index: index,
              model: model,
              restaurantAvailability: 1,
              foodItemAvailability: 0,
              context: context);
        } else if (error == CommonStrings.restaurantNotAvailable) {
          showLog("checkRestOrFoodItemNotAvailable2 ${error}");
          model.setRestaurantAvailability(
              index: index, parentIndex: parentIndex);
          checkRestOrFoodItemNotAvailable(
              parentIndex: parentIndex,
              index: index,
              model: model,
              restaurantAvailability: 0,
              foodItemAvailability: 0,
              context: context);
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
      RestaurantDetailsViewModel model,
      bool isbottomSheet}) {
    if (action == addItem) {
      model.addAndRemoveFoodPrice(
          index: index,
          parentIndex: parentIndex,
          addOrRemove: true,
          restaurantID: itemInfo[index].restaurantId);
    } else if (action == deleteItem) {
      model.deleteItem(
          index: index,
          parentIndex: parentIndex,
          restaurantID: itemInfo[index].restaurantId);
    } else if (action == removeItem) {
      model.addAndRemoveFoodPrice(
          index: index,
          parentIndex: parentIndex,
          addOrRemove: false,
          restaurantID: itemInfo[index].restaurantId);
    }

    if (isbottomSheet) {}

//    if (isbottomSheet) {
//      showLog("isbottomSheet --${parentIndex}");
//      showModalBottomSheet(
//        builder: (context) => Consumer<RestaurantDetailsViewModel>(
//          builder: (BuildContext context, RestaurantDetailsViewModel value,
//              Widget child) {
//            return restaurantItemDetailBottomSheet(
//              parentIndex: parentIndex,
//              index: index,
//            );
//          },
//        ),
//        context: context,
//        isScrollControlled: true,
//      );
//      //  Navigator.pop(context);
//    }
  }

  addNotesBottomSheet() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    dragIcon(),
                    verticalSizedBox(),
                    Text(S.of(context).addNotesToYourDish,
                        style: Theme.of(context).textTheme.subhead),
                    verticalSizedBox(),
                    divider(),
                    verticalSizedBox(),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      width: MediaQuery.of(context).size.width,
                      child: TextFormField(
                        focusNode: addNoteTextFocus,
                        validator: (value) {
                          return nameValidation(value);
                        },
                        onChanged: (value) {
                          setState(() {
                            textEdited = true;
                          });
                        },
                        controller: addNoteController,
                        style: TextStyle(
                          fontStyle: FontStyle.normal,
                          color: Colors.black,
                          fontSize: 16,
                        ),
                        maxLength: 200,
                        decoration: InputDecoration(
                          hintText: S.of(context).exampleMakeMyFoodSpicy,
                          hintStyle:
                              Theme.of(context).textTheme.display2.copyWith(
                                    color: Colors.grey,
                                  ),
                        ),
                        onSaved: (value) => {addNoteController.text = value},
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            //Navigator.of(context).pop();
                            if (textEdited) {
                              itemNotesData = addNoteController.text;
//                              if (widget.fromWhere == 1) {
//                                model.cartActionsRequest(
//                                  foodId: foodID,
//                                  action: itemNotes,
//                                  itemNotes: itemNotesData,
//                                );
//                                model.updateItemNotes(
//                                  parentIndex: parentIndex,
//                                  index: childIndex,
//                                  itemNotes: itemNotesData,
//                                );
//                              } else if (widget.fromWhere == 2) {
//                                searchViewModel.cartActionsRequest(
//                                  foodId: foodID,
//                                  action: itemNotes,
//                                  itemNotes: itemNotesData,
//                                );
//                                searchViewModel.updateItemNotes(
//                                  parentIndex: parentIndex,
//                                  index: childIndex,
//                                  itemNotes: itemNotesData,
//                                );
//                              } else if (widget.fromWhere == 3) {
//                                cartBillDetailViewModel.cartActionsRequest(
//                                  foodId: foodID,
//                                  action: itemNotes,
//                                  itemNotes: itemNotesData,
//                                );
//                                cartBillDetailViewModel.updateItemNotes(
//                                  parentIndex: parentIndex,
//                                  index: childIndex,
//                                  itemNotes: itemNotesData,
//                                );
//                              } else {}

//                              showSnackbar(
//                                  message: CommonStrings.notesSavedSuccessfully,
//                                  context: widget.mContext);

                              Navigator.of(context).pop(itemNotesData);
                            } else {}
                          },
                          child: Container(
                            height: 30,
                            width: 70,
                            decoration: BoxDecoration(
                              color: textEdited ? appColor : Colors.grey,
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Center(
                              child: Text(
                                S.of(context).done,
                                style: Theme.of(context)
                                    .textTheme
                                    .display3
                                    .copyWith(
                                      color: white,
                                    ),
                              ),
                            ),
                          ),
                        ),
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
  }

  checkRestOrFoodItemNotAvailable(
      {RestaurantDetailsViewModel model,
      int index,
      int parentIndex,
      int restaurantAvailability,
      int foodItemAvailability,
      BuildContext context}) {
    openFoodItemEditBottomSheet(
            context,
            RestDeleteFoodItemsDeleteBottomSheet(
              dynamicMapValue: {
                deviceIDKey: model.deviceId,
                userIdKey: model.userId.toString(),
                foodIdKey: itemInfo[index].id.toString(),
                restaurantIdKey: itemInfo[index].restaurantId.toString(),
                actionKey:
                    restaurantAvailability == 1 && foodItemAvailability == 0
                        ? deleteItem
                        : restaurantDelete,
                imageKey:
                    restaurantAvailability == 1 && foodItemAvailability == 0
                        ? itemInfo[index].exactSrc
                        : model.restaurantData.src.toString(),
                fromWhichScreen: "1"
              },
              context: context,
            ),
            scrollControlled: true)
        .then((value) => {
              showLog("Exists or not${value}"),
              if (value != null)
                {
                  model.refreshScreenAfterFoodOrRestaurantDelete(
                      index: index, parentIndex: parentIndex, action: value)
                }
              else
                {
                  // no need to do any changes
                }
            });
  }
}
