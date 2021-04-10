import 'package:flutter/material.dart';
import 'package:foodstar/generated/l10n.dart';
import 'package:foodstar/src/constants/api_params_keys.dart';
import 'package:foodstar/src/core/provider_viewmodels/cart_bill_detail_view_model.dart';
import 'package:foodstar/src/ui/res/colors.dart';
import 'package:foodstar/src/ui/shared/others.dart';
import 'package:foodstar/src/ui/shared/sizedbox.dart';
import 'package:foodstar/src/utils/banner_slider_shimmer.dart';
import 'package:provider/provider.dart';

class CartFoodItemBottomSheetScreen extends StatefulWidget {
  final String imageSrc;
  final String nameOfDish;
  final String description;
  final String price;
  final int typeOfProvider;
  final int index;
  final int parentIndex;
  final int cartQuantity;
  final bool availabilityStatus;
  final int foodID;

  CartFoodItemBottomSheetScreen(
      {this.imageSrc,
      this.nameOfDish,
      this.description,
      this.price,
      this.typeOfProvider,
      this.index,
      this.parentIndex,
      this.cartQuantity,
      this.availabilityStatus,
      this.foodID}); // type 1--> restaurant item, type 2 search, type 3 cart

  @override
  _CartFoodItemBottomSheetScreenState createState() =>
      _CartFoodItemBottomSheetScreenState();
}

class _CartFoodItemBottomSheetScreenState
    extends State<CartFoodItemBottomSheetScreen> {
  dynamic cartActionModel;

  @override
  Widget build(BuildContext context) {
    cartActionModel =
        Provider.of<CartBillDetailViewModel>(context, listen: false);
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
                            visible: widget.imageSrc != "",
                            child: Container(
                              height: 200,
                              width: MediaQuery.of(context).size.width,
                              child: networkImage(
                                  image: widget.imageSrc,
                                  loaderImage:
                                      loaderBeforeResturantDetailBannerImage()),
//                              child: CachedNetworkImage(
//                                imageUrl: widget.imageSrc,
//                                placeholder: (context, url) =>
//                                    largeImageShimmer(context),
//                                errorWidget: (context, url, error) =>
//                                    Icon(Icons.error),
//                                fit: BoxFit.fill,
//                              ),
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
                                      widget.nameOfDish,
                                      style:
                                          Theme.of(context).textTheme.display1,
                                    ),
                                    verticalSizedBox(),
                                    Text(
                                      widget.description,
                                      style:
                                          Theme.of(context).textTheme.display3,
                                    ),
                                  ],
                                ),
                              ),
                              Container(
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
                      widget.price,
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
                  child: widget.availabilityStatus && widget.cartQuantity > 0
                      ? editButton
                      : FlatButton(
                          color: widget.availabilityStatus
                              ? appColor
                              : Colors.grey,
                          child: Text(
                            S.of(context).addToCart,
                            style:
                                Theme.of(context).textTheme.display1.copyWith(
                                      color: Colors.white,
                                    ),
                          ),
                          onPressed: () {},
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row editButton() => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Flexible(
            child: Card(
              elevation: 2,
              child: Container(
                height: 25,
                width: 70,
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
//                                checkCartExistsOrNot(
//                                  model: model,
//                                  foodID: itemInfo[index].id,
//                                  action: removeItem,
//                                  context: context,
//                                  index: index,
//                                  parentIndex: parentIndex,
//                                  addOrRemove: false,
//                                  typeofCalc: removeItem,
//                                );

                                cartActionModel.addAndRemoveFoodPrice(
                                    index: widget.index,
                                    parentIndex: widget.parentIndex,
                                    addOrRemove: false);
                                cartActionModel.cartActionsRequest(
                                  foodId: widget.foodID,
                                  action: removeItem,
                                  context: context,
                                  index: widget.index,
                                  parentIndex: widget.parentIndex,
                                );
                              },
                              child: Icon(
                                Icons.remove,
                                color: appColor,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                        horizontalSizedBox(),
                        Text(
                          "${widget.cartQuantity}",
                          style: Theme.of(context).textTheme.display3.copyWith(
                              fontWeight: FontWeight.w400, fontSize: 14),
                        ),
                        horizontalSizedBox(),
                        Flexible(
                          child: Material(
                            color: transparent,
                            child: InkWell(
                              onTap: () {
//                                checkCartExistsOrNot(
//                                  model: model,
//                                  foodID: itemInfo[index].id,
//                                  action: addItem,
//                                  context: context,
//                                  index: index,
//                                  parentIndex: parentIndex,
//                                  addOrRemove: true,
//                                  typeofCalc: addItem,
//                                );

                                cartActionModel.addAndRemoveFoodPrice(
                                    index: widget.index,
                                    parentIndex: widget.parentIndex,
                                    addOrRemove: true);

                                cartActionModel.cartActionsRequest(
                                  foodId: widget.foodID,
                                  action: addItem,
                                  context: context,
                                  index: widget.index,
                                  parentIndex: widget.parentIndex,
                                );
                              },
                              child: Icon(
                                Icons.add,
                                color: appColor,
                                size: 20,
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
          ),
        ],
      );

//  checkCartExistsOrNot({
//    int foodID,
//    String action,
//    BuildContext context,
//    int index,
//    int parentIndex,
//    RestaurantDetailsViewModel model,
//    bool addOrRemove,
//    String typeofCalc, //add,remove, delete,init delete
//  }) async {
//    if (model.restaurantData.cartExist) {
//      // cannot add
//      showLog("Exists or not1${model.restaurantData.cartExist}");
//      showCartAlreadyExistsDialog(
//        parentContext: context,
//        dynamicMapValue: {
//          deviceIDKey: model.deviceId,
//          userIdKey: model.userId.toString(),
//          foodIdKey: foodID.toString(),
//          actionKey: action,
//        },
//        fromWhere: 1,
//        index: index,
//        parentIndex: parentIndex,
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
//    } else {
//      // can add
//      showLog("Exists or not3${model.restaurantData.cartExist}");
//      model.cartActionsRequest(
//        foodId: foodID,
//        action: action,
//        context: context,
//        index: index,
//        parentIndex: parentIndex,
//      );
//      addRemoveDeleteItems(
//          action: action,
//          index: index,
//          parentIndex: parentIndex,
//          addOrRemove: addOrRemove,
//          model: model);
//    }
//  }
//
//  addRemoveDeleteItems(
//      {String action,
//      int index,
//      int parentIndex,
//      bool addOrRemove,
//      RestaurantDetailsViewModel model}) {
//    if (action == addItem) {
//      model.addAndRemoveFoodPrice(
//          index: index, parentIndex: parentIndex, addOrRemove: true);
//    } else if (action == deleteItem) {
//      model.initAddItem(index: index, parentIndex: parentIndex);
//    } else if (action == removeItem) {
//      model.addAndRemoveFoodPrice(
//          index: index, parentIndex: parentIndex, addOrRemove: false);
//    }
//  }
}
