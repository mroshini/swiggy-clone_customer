//import 'package:flutter/material.dart';
//import 'package:foodstar/generated/l10n.dart';
//import 'package:foodstar/src/constants/api_params_keys.dart';
//import 'package:foodstar/src/constants/api_urls.dart';
//import 'package:foodstar/src/core/models/api_models/food_items_api_model.dart';
//import 'package:foodstar/src/core/provider_viewmodels/cart_bill_detail_view_model.dart';
//import 'package:foodstar/src/core/provider_viewmodels/rest_search_cart_food_items_view_model.dart';
//import 'package:foodstar/src/core/provider_viewmodels/restaurant_details_view_model.dart';
//import 'package:foodstar/src/core/provider_viewmodels/search_view_model.dart';
//import 'package:foodstar/src/ui/res/colors.dart';
//import 'package:foodstar/src/ui/routes/restaurant_details/change_restaurant_bottom_sheet.dart';
//import 'package:foodstar/src/ui/shared/others.dart';
//import 'package:foodstar/src/ui/shared/show_snack_bar.dart';
//import 'package:foodstar/src/ui/shared/sizedbox.dart';
//import 'package:foodstar/src/utils/banner_slider_shimmer.dart';
//import 'package:provider/provider.dart';
//
//class RestSearchCartFoodItemScreen extends StatefulWidget {
//  final int childIndex;
//
//  final int parentIndex;
//  final int shopAvailabilityStatus;
//  final int fromWhichScreen;
//  final RestaurantDetailsViewModel restDetailsViewModel;
//  final SearchViewModel searchViewModel;
//  final CartBillDetailViewModel cartBillDetailViewModel;
//
//  RestSearchCartFoodItemScreen({
//    this.childIndex,
//    this.parentIndex,
//    this.fromWhichScreen,
//    this.shopAvailabilityStatus,
//    this.restDetailsViewModel,
//    this.searchViewModel,
//    this.cartBillDetailViewModel,
//  });
//
//  @override
//  _RestSearchCartFoodItemScreenState createState() =>
//      _RestSearchCartFoodItemScreenState(
//          index: childIndex,
//          parentIndex: parentIndex,
//          fromWhichScreen: fromWhichScreen,
//          shopAvailabilityStatus: shopAvailabilityStatus);
//}
//
//class _RestSearchCartFoodItemScreenState
//    extends State<RestSearchCartFoodItemScreen> {
//  int favoriteIndex = 0;
//  final int fromWhichScreen;
//  final int shopAvailabilityStatus;
//
//  List<ACommonFoodItem> childFoodInfoList;
//  List<CommonCatFoodItem> parentFoodCatIntoList;
//  final int index;
//  final int parentIndex;
//  int foodPrice = 0;
//
//  _RestSearchCartFoodItemScreenState(
//      {this.index,
//      this.parentIndex,
//      this.fromWhichScreen,
//      this.shopAvailabilityStatus});
//
//  @override
//  void initState() {
//    super.initState();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    Provider.of<RestSearchCartFoodItemViewModel>(context, listen: false)
//        .getAllModelObjects(widget.searchViewModel,
//            widget.cartBillDetailViewModel, widget.restDetailsViewModel);
//
//    if (fromWhichScreen == 3) {
//      showLog("common  ${fromWhichScreen}");
//      try {
//        childFoodInfoList =
//            Provider.of<RestSearchCartFoodItemViewModel>(context, listen: false)
//                .foodItems;
//      } catch (e) {}
//    } else {
//      showLog("common  ${fromWhichScreen}");
//      try {
//        childFoodInfoList =
//            Provider.of<RestSearchCartFoodItemViewModel>(context, listen: false)
//                .catFoodItemsData[parentIndex]
//                .aFoodItems;
//      } catch (e) {}
//    }
//    return Consumer<RestSearchCartFoodItemViewModel>(
//      builder: (BuildContext context, RestSearchCartFoodItemViewModel model,
//          Widget child) {
//        return Container(
//          child: Padding(
//            padding: const EdgeInsets.all(8.0),
//            child: Row(
//              mainAxisAlignment: MainAxisAlignment.start,
//              crossAxisAlignment: CrossAxisAlignment.start,
//              children: <Widget>[
//                Offstage(
//                  offstage:
//                      childFoodInfoList[index].exactSrc == "" ? true : false,
//                  child: InkWell(
//                    onTap: () {
//                      //  DialogHelper.menuPopup(context);
//                    },
//                    child: ClipRRect(
//                      borderRadius: BorderRadius.circular(
//                        5.0,
//                      ),
//                      child: shopAvailabilityStatus == 1 &&
//                              childFoodInfoList[index].availability.status == 1
//                          ? networkImage(
//                              image: childFoodInfoList[index].exactSrc,
//                              loaderImage: loaderBeforeImage(),
//                              height: 80.0,
//                              width: 80.0,
//                            )
//                          : networkClosedRestImage(
//                              image: childFoodInfoList[index].exactSrc,
//                              loaderImage: loaderBeforeImage(),
//                              height: 80.0,
//                              width: 80.0,
//                            ),
////                    child: CachedNetworkImage(
////                      imageUrl: childFoodInfoList[index].exactSrc,
////                      placeholder: (context, url) => imageShimmer(),
////                      errorWidget: (context, url, error) => Icon(Icons.error),
////                      fit: BoxFit.fill,
////                      height: 80.0,
////                      width: 80.0,
////                    ),
//                    ),
//                  ),
//                ),
//                SizedBox(
//                  width: 12,
//                ),
//                Expanded(
//                  flex: 2,
//                  child: Column(
//                    children: <Widget>[
//                      Material(
//                        color: transparent,
//                        child: InkWell(
//                          onTap: () {
////                          openBottomSheet(
////                            context,
////                            restaurantItemDetailBottomSheet(
////                              model: model,
////                              foodItem: itemInfo,
////                              index: index,
////                              parentIndex: parentIndex,
////                              cartQuantity: itemInfo[index].cartDetail.quantity,
////                            ),
////----------------------
////                            RestaurantItemDetailBottomSheetScreen(
////                              imageSrc: itemInfo[index].exactSrc,
////                              nameOfDish: itemInfo[index].foodItem,
////                              description: itemInfo[index].description,
////                              price: itemInfo[index].showPrice,
////                              typeOfProvider: 1,
////                              foodID: itemInfo[index].id,
////                              index: index,
////                              parentIndex: parentIndex,
////                              cartQuantity: itemInfo[index].cartDetail.quantity,
////                              availabilityStatus: (widget.availabilityTime ==
////                                          1 &&
////                                      itemInfo[index].availability.status == 1)
////                                  ? true
////                                  : false,
////                            ),
////                            scrollControlled: true,
////                          );
//                          },
//                          child: Column(
//                            crossAxisAlignment: CrossAxisAlignment.start,
//                            children: <Widget>[
//                              Row(
//                                crossAxisAlignment: CrossAxisAlignment.start,
//                                mainAxisAlignment:
//                                    MainAxisAlignment.spaceBetween,
//                                children: <Widget>[
//                                  Row(
//                                    children: <Widget>[
//                                      Padding(
//                                        padding: const EdgeInsets.symmetric(
//                                          vertical: 3.0,
//                                        ),
//                                        child: Container(
//                                          height: 13,
//                                          width: 13,
//                                          decoration: BoxDecoration(
//                                            borderRadius: BorderRadius.circular(
//                                              2.0,
//                                            ),
//                                            border: Border.all(
//                                                color: childFoodInfoList[index]
//                                                            .status ==
//                                                        "Veg"
//                                                    ? Colors.green
//                                                    : red),
//                                          ),
//                                          child: Center(
//                                            child: Icon(
//                                              Icons.fiber_manual_record,
//                                              color: childFoodInfoList[index]
//                                                          .status ==
//                                                      "Veg"
//                                                  ? Colors.green
//                                                  : red,
//                                              size: 10,
//                                            ),
//                                          ),
//                                        ),
//                                      ),
//                                      SizedBox(
//                                        width: 5,
//                                      ),
//                                      Text(childFoodInfoList[index].foodItem,
//                                          overflow: TextOverflow.ellipsis,
//                                          style: Theme.of(context)
//                                              .textTheme
//                                              .display1),
//                                    ],
//                                  ),
//                                ],
//                              ),
//                              verticalSizedBoxFive(),
//                              Text(
//                                childFoodInfoList[index].description ?? "",
//                                overflow: TextOverflow.ellipsis,
//                                style: Theme.of(context).textTheme.display2,
//                              ),
//                              verticalSizedBoxFive(),
//                              Row(
//                                crossAxisAlignment: CrossAxisAlignment.start,
//                                mainAxisAlignment:
//                                    MainAxisAlignment.spaceBetween,
//                                children: <Widget>[
//                                  Flexible(
//                                    child: Row(
//                                      crossAxisAlignment:
//                                          CrossAxisAlignment.start,
//                                      children: <Widget>[
//                                        Text(
//                                          childFoodInfoList[index].showPrice,
//                                          style: Theme.of(context)
//                                              .textTheme
//                                              .display3
//                                              .copyWith(
//                                                  fontWeight: FontWeight.w600),
//                                        ),
//                                        horizontalSizedBox(),
//                                        Text(
//                                          childFoodInfoList[index]
//                                              .originalPrice
//                                              .toString(),
//                                          style: Theme.of(context)
//                                              .textTheme
//                                              .display2
//                                              .copyWith(
//                                                color: Colors.grey[400],
//                                                decoration:
//                                                    TextDecoration.lineThrough,
//                                              ),
//                                        ),
//                                      ],
//                                    ),
//                                  ),
//                                  childFoodInfoList[index].cartDetail.quantity >
//                                              0 &&
//                                          (shopAvailabilityStatus == 1 &&
//                                              childFoodInfoList[index]
//                                                      .availability
//                                                      .status ==
//                                                  1)
//                                      ? Flexible(
//                                          child: editButton(
//                                              model,
//                                              false,
//                                              childFoodInfoList[index]
//                                                  .cartDetail
//                                                  .quantity,
//                                              index,
//                                              parentIndex),
//                                        )
//                                      : Flexible(
//                                          child: addButton(
//                                              model,
//                                              index,
//                                              parentIndex,
//                                              childFoodInfoList[index]
//                                                  .cartDetail
//                                                  .quantity),
//                                        ),
//                                ],
//                              ),
//                            ],
//                          ),
//                        ),
//                      ),
//                    ],
//                  ),
//                ),
//              ],
//            ),
//          ),
//        );
//      },
//    );
//  }
//
//  Container restaurantItemDetailBottomSheet({
//    RestSearchCartFoodItemViewModel model,
//    List<ACommonFoodItem> foodItem,
//    int index,
//    int parentIndex,
//    int cartQuantity,
//  }) =>
//      Container(
//        height: MediaQuery.of(context).size.height * 0.85,
//        child: Scaffold(
//          resizeToAvoidBottomPadding: false,
//          body: Padding(
//            padding: EdgeInsets.symmetric(
//              horizontal: 10.0,
//            ),
//            child: Column(
//              children: <Widget>[
//                dragIcon(),
//                Expanded(
//                  child: Padding(
//                    padding: const EdgeInsets.all(
//                      10.0,
//                    ),
//                    child: ClipRRect(
//                      borderRadius: BorderRadius.circular(
//                        20.0,
//                      ),
//                      child: Container(
//                        height: MediaQuery.of(context).size.height,
//                        child: Column(
//                          crossAxisAlignment: CrossAxisAlignment.start,
//                          mainAxisAlignment: MainAxisAlignment.start,
//                          mainAxisSize: MainAxisSize.min,
//                          children: <Widget>[
//                            Container(
//                                height: 200,
//                                width: MediaQuery.of(context).size.width,
//                                child: (shopAvailabilityStatus == 1 &&
//                                        childFoodInfoList[index]
//                                                .availability
//                                                .status ==
//                                            1)
//                                    ? networkImage(
//                                        image:
//                                            childFoodInfoList[index].exactSrc,
//                                        loaderImage:
//                                            loaderBeforeResturantDetailBannerImage(),
//                                      )
////                                  ? CachedNetworkImage(
////                                      imageUrl:
////                                          childFoodInfoList[index].exactSrc,
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
//                                    : networkClosedRestImage(
//                                        image:
//                                            childFoodInfoList[index].exactSrc,
//                                        loaderImage: loaderBeforeImage(),
//                                      )
////                                      child: CachedNetworkImage(
////                                        imageUrl:
////                                            childFoodInfoList[index].exactSrc,
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
//
//                                ),
//                            verticalSizedBoxTwenty(),
//                            Row(
//                              crossAxisAlignment: CrossAxisAlignment.start,
//                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                              children: <Widget>[
//                                Flexible(
//                                  child: Column(
//                                    crossAxisAlignment:
//                                        CrossAxisAlignment.start,
//                                    mainAxisAlignment: MainAxisAlignment.start,
//                                    children: <Widget>[
//                                      Text(
//                                        childFoodInfoList[index].foodItem,
//                                        style: Theme.of(context)
//                                            .textTheme
//                                            .display1,
//                                      ),
//                                      verticalSizedBox(),
//                                      Text(
//                                        childFoodInfoList[index].description,
//                                        style: Theme.of(context)
//                                            .textTheme
//                                            .display3,
//                                      ),
//                                    ],
//                                  ),
//                                ),
//                                Container(
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
//                              ],
//                            ),
//                          ],
//                        ),
//                      ),
//                    ),
//                  ),
//                ),
//                Padding(
//                  padding: const EdgeInsets.all(10.0),
//                  child: Row(
//                    crossAxisAlignment: CrossAxisAlignment.start,
//                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                    children: <Widget>[
//                      Text(
//                        S.of(context).dishPrice,
//                        style: Theme.of(context).textTheme.display1,
//                      ),
//                      verticalSizedBox(),
//                      Text(
//                        childFoodInfoList[index].showPrice,
//                        style: Theme.of(context).textTheme.display1,
//                      ),
//                    ],
//                  ),
//                ),
//                verticalSizedBox(),
//                Padding(
//                  padding: const EdgeInsets.all(
//                    10.0,
//                  ),
//                  child: Container(
//                    width: MediaQuery.of(context).size.width,
//                    child: childFoodInfoList[index].cartDetail.quantity > 0 &&
//                            (shopAvailabilityStatus == 1 &&
//                                childFoodInfoList[index].availability.status ==
//                                    1)
//                        ? editButton(
//                            model, false, cartQuantity, index, parentIndex)
//                        : addButton(
//                            model,
//                            index,
//                            parentIndex,
//                            cartQuantity,
//                          ),
//                  ),
//                ),
//              ],
//            ),
//          ),
//        ),
//      );
//
//  Align addButton(RestSearchCartFoodItemViewModel model, int index,
//          int parentIndex, int cartQuantity) =>
//      // change
//
//      cartQuantity == 0
//          ? Align(
//              alignment: Alignment.centerRight,
//              child: GestureDetector(
//                onTap: () {
//                  if (shopAvailabilityStatus == 1 &&
//                      childFoodInfoList[index].availability.status == 1) {
//                    showLog(
//                        "childFoodInfoList1addItem-- ${childFoodInfoList[index].id}");
//
//                    checkCartExistsOrNot(
//                      model: model,
//                      foodID: childFoodInfoList[index].id,
//                      action: addItem,
//                      context: context,
//                      index: index,
//                      parentIndex: parentIndex,
//                      addOrRemove: true,
//                      typeofCalc: deleteItem,
//                      // newly adding item
//                    );
////                    model.initAddItem(index: index, parentIndex: parentIndex);
////                    model.cartActionsRequest(
////                      foodId: itemInfo[index].id,
////                      action: addItem,
////                      context: context,
////                      index: index,
////                      parentIndex: parentIndex,
////                    );
//                  } else {
//                    showSnackbar(
//                        message: 'Restaurant not available', context: context);
//                  }
//                },
//                child: Container(
//                  height: 25,
//                  width: 70,
//                  decoration: BoxDecoration(
//                    color: shopAvailabilityStatus == 1 &&
//                            childFoodInfoList[index].availability.status == 1
//                        ? appColor
//                        : Colors.grey[300],
//                    borderRadius: BorderRadius.circular(5.0),
//                  ),
//                  child: Center(
//                    child: Row(
//                      crossAxisAlignment: CrossAxisAlignment.start,
//                      mainAxisAlignment: MainAxisAlignment.center,
//                      children: <Widget>[
//                        Text(
//                          'Add',
//                          style: Theme.of(context)
//                              .textTheme
//                              .display3
//                              .copyWith(color: white, fontSize: 13),
//                        ),
//                        horizontalSizedBox(),
//                        Icon(
//                          Icons.add,
//                          color: Colors.white,
//                          size: 17,
//                        ),
//                      ],
//                    ),
//                  ),
//                ),
//              ),
//            )
//          : Align(
//              alignment: Alignment.centerRight,
//              child: GestureDetector(
//                onTap: () {
//                  showLog(
//                      "childFoodInfoList2deleteItem-- ${childFoodInfoList[index].id}");
//                  checkCartExistsOrNot(
//                      model: model,
//                      foodID: childFoodInfoList[index].id,
//                      action: deleteItem,
//                      context: context,
//                      index: index,
//                      parentIndex: parentIndex,
//                      typeofCalc: deleteItem);
//
////                  model.initAddItem(index: index, parentIndex: parentIndex);
////                  model.cartActionsRequest(
////                    foodId: itemInfo[index].id,
////                    action: deleteItem,
////                    context: context,
////                    index: index,
////                    parentIndex: parentIndex,
////                  );
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
//            );
//
//  Row editButton(RestSearchCartFoodItemViewModel model, bool favoriteStatus,
//          int quantity, int index, int parentIndex) =>
//      Row(
//        crossAxisAlignment: CrossAxisAlignment.start,
//        mainAxisAlignment: MainAxisAlignment.end,
//        children: <Widget>[
//          GestureDetector(
//            onTap: () {
////              openBottomSheet(context, AddDishNotesScreen(),
////                  scrollControlled: true);
//            },
//            child: Container(
//              height: 33,
//              width: 33,
//              child: Card(
//                elevation: 2,
//                child: Icon(
//                  favoriteStatus ? Icons.check_circle : Icons.edit,
//                  color: appColor,
//                  size: 17.0,
//                ),
//              ),
//            ),
//          ),
//          horizontalSizedBox(),
//          Card(
//            elevation: 2,
//            child: Container(
//              height: 25,
//              width: 70,
//              child: Center(
//                child: Padding(
//                  padding: const EdgeInsets.symmetric(vertical: 1.0),
//                  child: Row(
//                    crossAxisAlignment: CrossAxisAlignment.start,
//                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                    children: <Widget>[
//                      horizontalSizedBoxFive(),
//                      Flexible(
//                        child: Material(
//                          color: transparent,
//                          child: InkWell(
//                            onTap: () {
//                              showLog(
//                                  "childFoodInfoList3-- ${childFoodInfoList[index].id}");
//                              checkCartExistsOrNot(
//                                model: model,
//                                foodID: childFoodInfoList[index].id,
//                                action: removeItem,
//                                context: context,
//                                index: index,
//                                parentIndex: parentIndex,
//                                addOrRemove: false,
//                                typeofCalc: removeItem,
//                              );
//
////                                model.addAndRemoveFoodPrice(
////                                    index: index,
////                                    parentIndex: parentIndex,
////                                    addOrRemove: false);
////                                model.cartActionsRequest(
////                                  foodId: itemInfo[index].id,
////                                  action: removeItem,
////                                  context: context,
////                                  index: index,
////                                  parentIndex: parentIndex,
////                                );
//                            },
//                            child: Icon(
//                              Icons.remove,
//                              color: appColor,
//                              size: 20,
//                            ),
//                          ),
//                        ),
//                      ),
//                      horizontalSizedBox(),
//                      Text(
//                        "$quantity",
//                        style: Theme.of(context).textTheme.display3.copyWith(
//                            fontWeight: FontWeight.w400, fontSize: 14),
//                      ),
//                      horizontalSizedBox(),
//                      Flexible(
//                        child: Material(
//                          color: transparent,
//                          child: InkWell(
//                            onTap: () {
//                              showLog(
//                                  "childFoodInfoList4-- ${childFoodInfoList[index].id}");
//                              checkCartExistsOrNot(
//                                model: model,
//                                foodID: childFoodInfoList[index].id,
//                                action: addItem,
//                                context: context,
//                                index: index,
//                                parentIndex: parentIndex,
//                                addOrRemove: true,
//                                typeofCalc: addItem,
//                              );
//
////                                model.addAndRemoveFoodPrice(
////                                    index: index,
////                                    parentIndex: parentIndex,
////                                    addOrRemove: true);
////
////                                model.cartActionsRequest(
////                                  foodId: itemInfo[index].id,
////                                  action: addItem,
////                                  context: context,
////                                  index: index,
////                                  parentIndex: parentIndex,
////                                );
//                            },
//                            child: Icon(
//                              Icons.add,
//                              color: appColor,
//                              size: 20,
//                            ),
//                          ),
//                        ),
//                      ),
//                      horizontalSizedBoxFive(),
//                    ],
//                  ),
//                ),
//              ),
//            ),
//          ),
//        ],
//      );
//
//  checkCartExistsOrNot({
//    int foodID,
//    String action,
//    BuildContext context,
//    int index,
//    int parentIndex,
//    RestSearchCartFoodItemViewModel model,
//    bool addOrRemove,
//    String typeofCalc,
//    //add,remove, delete,init delete
//  }) async {
//    model.getAllRespectiveViewModels(fromWhichScreen, parentIndex, index);
//    if (fromWhichScreen == 3) {
//      model.cartActionsRequestFromCommonModel(
//          foodId: foodID,
//          action: action,
//          context: context,
//          index: index,
//          parentIndex: parentIndex,
//          fromWhichScreen: fromWhichScreen);
//      addRemoveDeleteItems(
//          action: action,
//          index: index,
//          foodID: foodID,
//          parentIndex: parentIndex,
//          addOrRemove: addOrRemove,
//          model: model);
//    } else {
//      if (model.cartExistsData) {
//        // cannot add
//        showLog("Exists or not1${model.cartExistsData} -- foo ${foodID}");
//
//        openBottomSheet(
//          context,
//          ChangeRestaurantScreen(
//            dynamicMapValue: {
//              deviceIDKey: model.deviceId,
//              userIdKey: model.userId.toString(),
//              foodIdKey: foodID.toString(),
//              actionKey: action,
//            },
//            //model: model,
//            context: context,
//          ),
//        ).then((value) => {
//              showLog("Exists or not${value}"),
//              if (value)
//                {
//                  // remove existing cart
//                  model.updateCartExistsFromCommonModel(
//                      fromWhichScreen: fromWhichScreen,
//                      parentIndex: parentIndex,
//                      childIndex: index),
//                  //add items
//                  addRemoveDeleteItems(
//                      action: action,
//                      foodID: foodID,
//                      index: index,
//                      parentIndex: parentIndex,
//                      addOrRemove: addOrRemove,
//                      model: model)
//                  // model: model),
//                }
//              else
//                {
//                  showLog("Exists or not2${model.cartExistsData}")
//                  // no need to do any changes
//                }
//            });
//
////      showCartAlreadyExistsDialog(
////        parentContext: context,
////        dynamicMapValue: {
////          deviceIDKey: model.deviceId,
////          userIdKey: model.userId.toString(),
////          foodIdKey: foodID.toString(),
////          actionKey: action,
////        },
////        fromWhere: 1,
////      ).then((value) => {
////            showLog("Exists or not${value}"),
////            if (value)
////              {
////                model.updateCartExists(),
////                //add items
////                addRemoveDeleteItems(
////                    action: action,
////                    index: index,
////                    parentIndex: parentIndex,
////                    addOrRemove: addOrRemove,
////                    model: model),
////              }
////            else
////              {
////                showLog("Exists or not2${model.restaurantData.cartExist}")
////                // no need to do any changes
////              }
////          });
//      } else {
//        // can add
//        showLog("Exists or not3${model.cartExistsData}");
//        model.cartActionsRequestFromCommonModel(
//            foodId: foodID,
//            action: action,
//            context: context,
//            index: index,
//            parentIndex: parentIndex,
//            fromWhichScreen: fromWhichScreen);
//
//        addRemoveDeleteItems(
//            action: action,
//            index: index,
//            foodID: foodID,
//            parentIndex: parentIndex,
//            addOrRemove: addOrRemove,
//            model: model);
//      }
//    }
//  }
//
//  addRemoveDeleteItems(
//      {String action,
//      int foodID,
//      int index,
//      int parentIndex,
//      bool addOrRemove,
//      RestSearchCartFoodItemViewModel model}) {
//    if (action == addItem) {
//      model.addAndRemoveFoodPriceFromCommonModel(
//          index: index,
//          parentIndex: parentIndex,
//          addOrRemove: true,
//          fromWhichScreen: fromWhichScreen);
//    } else if (action == deleteItem) {
//      model.initAddItemFromCommonModel(index: index, parentIndex: parentIndex);
//    } else if (action == removeItem) {
//      model.addAndRemoveFoodPriceFromCommonModel(
//          index: index,
//          parentIndex: parentIndex,
//          addOrRemove: false,
//          fromWhichScreen: fromWhichScreen);
//    }
//  }
//}
