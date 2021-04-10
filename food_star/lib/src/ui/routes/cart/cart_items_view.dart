import 'package:flutter/material.dart';
import 'package:foodstar/generated/l10n.dart';
import 'package:foodstar/src/constants/api_params_keys.dart';
import 'package:foodstar/src/constants/api_urls.dart';
import 'package:foodstar/src/constants/common_strings.dart';
import 'package:foodstar/src/core/models/api_models/food_items_api_model.dart';
import 'package:foodstar/src/core/provider_viewmodels/cart_bill_detail_view_model.dart';
import 'package:foodstar/src/core/service/app_exception.dart';
import 'package:foodstar/src/ui/res/colors.dart';
import 'package:foodstar/src/ui/shared/others.dart';
import 'package:foodstar/src/ui/shared/rest_delete_food_items_delete_bottom_sheet.dart';
import 'package:foodstar/src/ui/shared/show_snack_bar.dart';
import 'package:foodstar/src/ui/shared/sizedbox.dart';
import 'package:foodstar/src/utils/banner_slider_shimmer.dart';
import 'package:foodstar/src/utils/common_navigation.dart';
import 'package:provider/provider.dart';

class CartItemsScreen extends StatefulWidget {
  final int childIndex;
  final String imageTag;
  final List<ACommonFoodItem> cartOrderedItems;
  final CartBillDetailViewModel model;

  CartItemsScreen({
    this.childIndex,
    this.imageTag,
    this.cartOrderedItems,
    this.model,
  });

  @override
  _CartItemsScreenState createState() => _CartItemsScreenState(
        index: childIndex,
        // cartOrderedItems: cartOrderedItems,
        model: model,
      );
}

class _CartItemsScreenState extends State<CartItemsScreen> {
  final int index;

  int foodPrice = 0;
  final CartBillDetailViewModel model;

  _CartItemsScreenState({this.index, this.model});

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartBillDetailViewModel>(builder:
        (BuildContext context, CartBillDetailViewModel model, Widget child) {
      return Stack(
        children: [
          Container(
            child: InkWell(
              onTap: () {
                showModalBottomSheet(
                    builder: (context) => restaurantItemDetailBottomSheet(
                        model: Provider.of<CartBillDetailViewModel>(
                          context,
                        ),
                        // model: model,
                        index: index,
                        context: context),
                    context: context,
                    isScrollControlled: true);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  model.cartOrderedItems.length != 0
                      ? Offstage(
                          offstage: model.cartOrderedItems[index].exactSrc == ""
                              ? true
                              : false,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                              5.0,
                            ),
                            child: model.cartBillData.restaurant.availability
                                        .status ==
                                    1
                                ? networkImage(
                                    image:
                                        model.cartOrderedItems[index].exactSrc,
                                    loaderImage: loaderBeforeImage(),
                                    height: 70.0,
                                    width: 70.0,
                                  )
                                : networkClosedRestImage(
                                    image:
                                        model.cartOrderedItems[index].exactSrc,
                                    loaderImage: loaderBeforeImage(),
                                    height: 70.0,
                                    width: 70.0,
                                  ),
//                          child: CachedNetworkImage(
//                            imageUrl: model.cartOrderedItems[index].exactSrc,
//                            placeholder: (context, url) =>
//                                loaderBeforeImage(height: 80.0, width: 80.0),
//                            //imageShimmer(),
//                            errorWidget: (context, url, error) =>
//                                Icon(Icons.error),
//                            fit: BoxFit.fill,
//                            height: 80.0,
//                            width: 80.0,
//                          ),
                          ),
                        )
                      : Container(),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 3.0),
                                        child: Container(
                                          height: 13,
                                          width: 13,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              2.0,
                                            ),
                                            border: Border.all(
                                                color: model
                                                            .cartOrderedItems[
                                                                index]
                                                            .status ==
                                                        "Veg"
                                                    ? Colors.green
                                                    : red),
                                          ),
                                          child: Center(
                                            child: Icon(
                                              Icons.fiber_manual_record,
                                              color:
                                                  model.cartOrderedItems[index]
                                                              .status ==
                                                          "Veg"
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
                                      Text(
                                          model
                                              .cartOrderedItems[index].foodItem,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .display1),
                                    ],
                                  ),
                                ],
                              ),
                              verticalSizedBoxFive(),
                              Text(
                                model.cartOrderedItems[index].description ?? "",
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.display2,
                              ),
                              verticalSizedBoxFive(),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Flexible(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Flexible(
                                          flex: 2,
                                          child: Text(
                                            '${model.cartOrderedItems[index].cartDetail.quantity} X ${model.currencySymbol} ${model.cartOrderedItems[index].showPrice}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .display3
                                                .copyWith(
                                                    fontWeight:
                                                        FontWeight.w600),
                                          ),
                                        ),
                                        horizontalSizedBox(),
                                        Visibility(
                                          visible: model.cartOrderedItems[index]
                                                  .originalPrice >
                                              model.cartOrderedItems[index]
                                                  .sellingPrice,
                                          child: Flexible(
                                            child: Text(
                                              '${model.currencySymbol} ${model.cartOrderedItems[index].originalPrice}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .display2
                                                  .copyWith(
                                                    color: Colors.grey[500],
                                                    decoration: TextDecoration
                                                        .lineThrough,
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  model.cartOrderedItems[index].cartDetail
                                                  .quantity >
                                              0 &&
                                          (model.cartBillData.restaurant
                                                      .availability.status ==
                                                  1 &&
                                              model.cartOrderedItems[index]
                                                      .availability.status ==
                                                  1)
                                      ? Flexible(
                                          child: editButton(
                                              false,
                                              model.cartOrderedItems[index]
                                                  .cartDetail.quantity,
                                              model,
                                              index),
                                        )
                                      : Flexible(
                                          child: addButton(
                                            model,
                                            index,
                                            model.cartOrderedItems[index]
                                                .cartDetail.quantity,
                                          ),
                                        ),
                                ],
                              ),
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
//          Visibility(
//            visible: model.removeOrAddItemLoader,
//            child: Center(
//              child: Container(
//                color: Colors.transparent,
//                child: showProgress(context),
//                height: 20,
//                width: 20,
//              ),
//            ),
//          )
        ],
      );
    });
  }

  Widget restaurantItemDetailBottomSheet({
    CartBillDetailViewModel model,
    int index,
    int parentIndex,
    int cartQuantity,
    BuildContext context,
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
                            visible: model
                                .cartOrderedItems[index].exactSrc.isNotEmpty,
                            child: Container(
                              height: 200,
                              width: MediaQuery.of(context).size.width,
                              child: (model.cartBillData.restaurant.availability
                                              .status ==
                                          1 &&
                                      model.cartOrderedItems[index].availability
                                              .status ==
                                          1)
                                  ? networkImage(
                                      image: model
                                          .cartOrderedItems[index].exactSrc,
                                      // itemInfo[index].exactSrc,
                                      loaderImage:
                                          loaderBeforeResturantDetailBannerImage(),
//                                      height: 80.0,
//                                      width: 80.0,
                                    )
                                  : networkClosedRestImage(
                                      image: model
                                          .cartOrderedItems[index].exactSrc,
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
                                      model.cartOrderedItems[index].foodItem,
                                      style:
                                          Theme.of(context).textTheme.display1,
                                    ),
                                    verticalSizedBox(),
                                    Text(
                                      model.cartOrderedItems[index].description,
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
                      '${model.currencySymbol} ${model.cartOrderedItems[index].showPrice}',
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
                  child: model.cartOrderedItems[index].cartDetail.quantity >
                              0 &&
                          (model.cartBillData.restaurant.availability.status ==
                                  1 &&
                              model.cartOrderedItems[index].availability
                                      .status ==
                                  1)
                      ? editButtonForBottomSheet(
                          model.cartOrderedItems[index].cartDetail.quantity,
                          model,
                          index,
                          parentIndex,
                          true,
                          context)
                      : addButtonForBottomSheet(
                          model,
                          index,
                          parentIndex,
                          model.cartOrderedItems[index].cartDetail.quantity,
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

  Align addButtonForBottomSheet(CartBillDetailViewModel model, int index,
      int parentIndex, int cartQuantity, bool isbottomSheet) {
    return cartQuantity == 0
        ? Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {
                if (model.cartBillData.restaurant.availability.status == 1 &&
                    model.cartOrderedItems[index].availability.status == 1) {
//            checkCartExistsOrNot(
//                model: model,
//                foodID: itemInfo[index].id,
//                action: addItem,
//                context: context,
//                index: index,
//                parentIndex: parentIndex,
//                addOrRemove: true,
//                typeofCalc: deleteItem,
//                isbottomSheet: isbottomSheet
//              // newly adding item
//            );
                  model.initAddItemFromCart(index: index);
                  initCartActionRequest(
                      foodId: model.cartOrderedItems[index].id,
                      action: addItem,
                      mContext: context,
                      cartModel: model
                      // index: index,
                      );
//                  showBottomSheet(
//                    model: model,
//                    index: index,
//                  );
                } else {
                  showSnackbar(
                      message:
                          model.cartBillData.restaurant.availability.status ==
                                      1 &&
                                  model.cartOrderedItems[index].availability
                                          .status ==
                                      0
                              ? 'FoodItem not Available'
                              : 'Restaurant not available',
                      context: context);
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: model.cartBillData.restaurant.availability.status ==
                                1 &&
                            model.cartOrderedItems[index].availability.status ==
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
                    foodItemAvailability:
                        model.cartOrderedItems[index].availability.status,
                    restaurantAvailability:
                        model.cartBillData.restaurant.availability.status);
//
//                openFoodItemEditBottomSheet(
//                  context,
//                  RestDeleteFoodItemsDeleteBottomSheet(
//                    dynamicMapValue: {
//                      deviceIDKey: model.deviceId,
//                      userIdKey: model.userId.toString(),
//                      foodIdKey: cartOrderedItems[index].id.toString(),
//                      restaurantIdKey:
//                          cartOrderedItems[index].restaurantId.toString(),
//                      actionKey: model.cartBillData.restaurant.availability
//                                      .status ==
//                                  1 &&
//                              cartOrderedItems[index].availability.status == 0
//                          ? deleteItem
//                          : restaurantDelete,
//                      imageKey: model.cartBillData.restaurant.availability
//                                      .status ==
//                                  1 &&
//                              cartOrderedItems[index].availability.status == 0
//                          ? cartOrderedItems[index].exactSrc
//                          : model.cartBillData.restaurant.src.toString(),
//                      fromWhichScreen: "3"
//                    },
//                    context: context,
//                  ),
//                ).then((value) => {
//                      showLog("Exists or not${value}"),
//                      if (value != null)
//                        {
//                          model.refreshScreenAfterFoodOrRestaurantDelete(
//                              index: index, action: value)
//                        }
//                      else
//                        {
//                          // no need to do any changes
//                        }
//                    });
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

  Align addButton(CartBillDetailViewModel model, int index, int cartQuantity) =>
      // change
      cartQuantity == 0
          ? Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () async {
                  if (model.cartBillData.restaurant.availability.status == 1 &&
                      model.cartOrderedItems[index].availability.status == 1) {
                    await model.initAddItemFromCart(index: index);
                    initCartActionRequest(
                        foodId: model.cartOrderedItems[index].id,
                        action: addItem,
                        mContext: context,
                        cartModel: model
                        // index: index,
                        );
                  } else {
                    showSnackbar(
                        message:
                            model.cartBillData.restaurant.availability.status ==
                                        1 &&
                                    model.cartOrderedItems[index].availability
                                            .status ==
                                        0
                                ? 'FoodItem not Available'
                                : 'Restaurant not available',
                        context: context);
                  }
                },
                child: Container(
                  height: 25,
                  width: 70,
                  decoration: BoxDecoration(
                    color: model.cartOrderedItems[index].availability.status ==
                                1 &&
                            model.cartOrderedItems[index].availability.status ==
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
            )
          : Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
//                  showSnackbar(
//                      message: 'Restaurant not available', context: context);

//        openFoodItemEditBottomSheet(
//          context,
//          RestDeleteFoodItemsDeleteBottomSheet(
//            dynamicMapValue: {
//              deviceIDKey: model.deviceId,
//              userIdKey: model.userId.toString(),
//              foodIdKey: cartOrderedItems[index].id.toString(),
//              restaurantIdKey:
//              cartOrderedItems[index].restaurantId.toString(),
//              actionKey: model.cartBillData.restaurant.availability
//                  .status ==
//                  1 &&
//                  cartOrderedItems[index].availability.status == 0
//                  ? deleteItem
//                  : restaurantDelete,
//              imageKey: model.cartBillData.restaurant.availability
//                  .status ==
//                  1 &&
//                  cartOrderedItems[index].availability.status == 0
//                  ? cartOrderedItems[index].exactSrc
//                  : model.cartBillData.restaurant.src.toString(),
//              fromWhichScreen: "3"
//            },
//            context: context,
//          ),
//        ).then((value) =>
//        {
//          showLog("Exists or not${value}"),
//          if (value != null)
//            {
//              model.refreshScreenAfterFoodOrRestaurantDelete(
//                  index: index, action: value)
//            }
//          else
//            {
//              // no need to do any changes
//            }
//        });
                  checkRestOrFoodItemNotAvailable(
                      model: model,
                      index: index,
                      foodItemAvailability:
                          model.cartOrderedItems[index].availability.status,
                      restaurantAvailability:
                          model.cartBillData.restaurant.availability.status);
                },
                child: Card(
                  elevation: 2,
                  child: Container(
                    height: 25,
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
//                  model.deleteItem(index: index);
//                  model.cartActionsRequest(
//                    foodId: model.cartOrderedItems[index].id,
//                    action: deleteItem,
//                    context: context,
//                  );
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
//                          style: Theme.of(context)
//                              .textTheme
//                              .display3
//                              .copyWith(color: white, fontSize: 14),
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

  checkRestOrFoodItemNotAvailable(
      {CartBillDetailViewModel model,
      int index,
      // int parentIndex,
      int restaurantAvailability,
      int foodItemAvailability}) {
    openFoodItemEditBottomSheet(
            context,
            RestDeleteFoodItemsDeleteBottomSheet(
              dynamicMapValue: {
                deviceIDKey: model.deviceId,
                userIdKey: model.userId.toString(),
                foodIdKey: model.cartOrderedItems[index].id.toString(),
                restaurantIdKey:
                    model.cartOrderedItems[index].restaurantId.toString(),
                actionKey:
                    restaurantAvailability == 1 && foodItemAvailability == 0
                        ? deleteItem
                        : restaurantDelete,
                imageKey:
                    restaurantAvailability == 1 && foodItemAvailability == 0
                        ? model.cartOrderedItems[index].exactSrc
                        : model.cartBillData.restaurant.src.toString(),
                fromWhichScreen: "3"
              },
              context: context,
            ),
            scrollControlled: true)
        .then((value) => {
              showLog("Exists or not${value}"),
              if (value != null)
                {
                  model.refreshScreenAfterFoodOrRestaurantDelete(
                      index: index, action: value)
                }
              else
                {
                  // no need to do any changes
                }
            });
  }

  editButtonForBottomSheet(int quantity, CartBillDetailViewModel model,
      int index, int parentIndex, bool isbottomSheet, BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
//        GestureDetector(
//          onTap: () {
//            openFoodItemEditBottomSheet(
//                    context,
//                    AddDishNotesScreen(
//                      foodID: cartOrderedItems[index].id,
//                      //   model: model,
//                      fromWhere: 1,
//                      parentIndex: parentIndex,
//                      itemNotes: cartOrderedItems[index].cartDetail.itemNote,
//                      childIndex: index,
//                      mContext: context,
//                    ),
//                    scrollControlled: true)
//                .then((value) => {
//                      if (value != null)
//                        {
//                          showLog("cartdataaa -- ${value} "),
//                          model.cartActionsRequest(
//                            foodId: cartOrderedItems[index].id,
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
//                cartOrderedItems[index].cartDetail.itemNote != ""
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
                          onTap: () async {
//                            checkCartExistsOrNot(
//                                model: model,
//                                foodID: itemInfo[index].id,
//                                action: removeItem,
//                                context: context,
//                                index: index,
//                                parentIndex: parentIndex,
//                                addOrRemove: false,
//                                typeofCalc: removeItem,
//                                isbottomSheet: isbottomSheet);

                            if (quantity == 1) {
                              Navigator.pop(context);
                            }

                            await model.addAndRemoveFoodPrice(
                              index: index,
                              parentIndex: parentIndex,
                              addOrRemove: false,
                              isbottomSheet: true,
                              foodId: model.cartOrderedItems[index].id,
                            );
                            initCartActionRequest(
                                foodId: model.cartOrderedItems[index].id,
                                action: removeItem,
                                mContext: context,
                                cartModel: model);

//                            showBottomSheet(
//                                model: model, index: index, remove: true);
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
                          onTap: () async {
//                            checkCartExistsOrNot(
//                                model: model,
//                                foodID: itemInfo[index].id,
//                                action: addItem,
//                                context: context,
//                                index: index,
//                                parentIndex: parentIndex,
//                                addOrRemove: true,
//                                typeofCalc: addItem,
//                                isbottomSheet: isbottomSheet);
                            await model.addAndRemoveFoodPrice(
                                index: index,
                                parentIndex: parentIndex,
                                addOrRemove: true);

                            initCartActionRequest(
                              foodId: model.cartOrderedItems[index].id,
                              action: addItem,
                              mContext: context,
                              cartModel: model,
                            );
//                            showBottomSheet(
//                              model: model,
//                              index: index,
//                            );
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

  initCartActionRequest(
      {int foodId,
      String action,
      CartBillDetailViewModel cartModel,
      BuildContext mContext}) async {
    try {
      await cartModel.cartActionsRequest(
        foodId: foodId.toString(),
        action: action,
        mContext: mContext,
      );
    } on BadRequestException catch (e) {
      cartModel.initLoader(false);
      String error = e.toString();
      showLog("checkRestOrFoodItemNotAvailable11 ${error}");
      if (error == CommonStrings.foodItemNotAvailable) {
        showLog("checkRestOrFoodItemNotAvailable1 ${error}");
        cartModel.setFoodItemsNotAvailable(index: index);
        checkRestOrFoodItemNotAvailable(
            model: cartModel,
            index: index,
            foodItemAvailability: 0,
            restaurantAvailability: 1);
      } else if (error == CommonStrings.restaurantNotAvailable) {
        showLog("checkRestOrFoodItemNotAvailable2 ${error}");
        model.setRestaurantNotAvailable(
          index: index,
        );

        checkRestOrFoodItemNotAvailable(
            model: cartModel,
            index: index,
            foodItemAvailability: 0,
            restaurantAvailability: 0);
      } else {
        showInfoAlertDialog(
            context: context,
            response: error,
            onClicked: () {
              Navigator.pop(context);
            });
      }
    }
    await model.checkUserLoggedInOrNot(context: context, showShimmer: false);
  }

  Row editButton(bool favoriteStatus, int quantity,
          CartBillDetailViewModel model, int index) =>
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
//          GestureDetector(
//            onTap: () {
//              openFoodItemEditBottomSheet(
//                      context,
//                      AddDishNotesScreen(
//                        foodID: cartOrderedItems[index].id,
//                        cartBillDetailViewModel: model,
//                        fromWhere: 3,
//                        childIndex: index,
//                        itemNotes: cartOrderedItems[index].cartDetail.itemNote,
//                        mContext: context,
//                      ),
//                      scrollControlled: true)
//                  .then((value) => {
//                        if (value != null)
//                          {
//                            model.cartActionsRequest(
//                              foodId: cartOrderedItems[index].id,
//                              action: itemNotes,
//                              itemNotes: value,
//                              context: context,
//                            ),
//                            model.updateItemNotes(
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
//                  cartOrderedItems[index].cartDetail.itemNote != ""
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
              height: 30,
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
                            onTap: () async {
//                                if (quantity > 1) {
//                                  model.addAndRemoveFoodPrice(
//                                      index: index, addOrRemove: false);
//                                }else{
//                                  model.removeItem(index);
//                                }

                              var foodID = model.cartOrderedItems[index].id;

                              await model.addAndRemoveFoodPrice(
                                index: index,
                                addOrRemove: false,
                                foodId: model.cartOrderedItems[index].id,
                              );

                              await initCartActionRequest(
                                  foodId: foodID,
                                  action: removeItem,
                                  mContext: context,
                                  // index: index,
                                  cartModel: model);
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
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                              ),
                        ),
                      ),
                      horizontalSizedBox(),
                      Flexible(
                        child: Material(
                          color: transparent,
                          child: InkWell(
                            onTap: () async {
                              var foodID = model.cartOrderedItems[index].id;
                              await model.addAndRemoveFoodPrice(
                                  index: index, addOrRemove: true);

                              await initCartActionRequest(
                                  foodId: foodID,
                                  action: addItem,
                                  mContext: context,
                                  cartModel: model
//                                  index: index,
//                                  parentIndex: parentIndex,
                                  );
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

//  showBottomSheet({
//    CartBillDetailViewModel model,
//    int index,
//    bool remove = false,
//  }) {
//    Navigator.pop(context);
//
//    showModalBottomSheet(
//      builder: (context) =>
//          restaurantItemDetailBottomSheet(model: model, index: index),
//      context: context,
//      isScrollControlled: true,
//    ).then((value) => {
//          if (remove)
//            {
//              model.removeFromCart(index: index),
//            }
//        });
//  }
}
