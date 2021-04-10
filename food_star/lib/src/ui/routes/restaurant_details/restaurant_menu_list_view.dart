import 'package:flutter/material.dart';
import 'package:foodstar/src/constants/api_params_keys.dart';
import 'package:foodstar/src/constants/api_urls.dart';
import 'package:foodstar/src/constants/route_path.dart';
import 'package:foodstar/src/core/provider_viewmodels/cart_quantity_view_model.dart';
import 'package:foodstar/src/core/provider_viewmodels/common/theme_changer.dart';
import 'package:foodstar/src/core/provider_viewmodels/restaurant_details_view_model.dart';
import 'package:foodstar/src/ui/routes/cart/cart_quanity_price_cart_view.dart';
import 'package:foodstar/src/ui/routes/restaurant_details/restaurant_item_widget.dart';
import 'package:foodstar/src/ui/shared/sizedbox.dart';
import 'package:foodstar/src/utils/dialog_helper.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class RestaurantMenuListScreen extends StatefulWidget {
  final Map<String, dynamic> menuItemsData;

  RestaurantMenuListScreen({this.menuItemsData});

  @override
  _RestaurantMenuListScreenState createState() =>
      _RestaurantMenuListScreenState(menuItemsData: menuItemsData);
}

class _RestaurantMenuListScreenState extends State<RestaurantMenuListScreen> {
  final Map<String, dynamic> menuItemsData;
  RestaurantDetailsViewModel model;
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  _RestaurantMenuListScreenState({this.menuItemsData});

  ScrollController restaurantMenuScrollView = ScrollController();

  @override
  void initState() {
    super.initState();

    //  model = Provider.of<RestaurantDetailsViewModel>(context, listen: false);

    moveToRespectiveIndex(menuItemsData[indexKey].toString(), context);
  }

  moveToRespectiveIndex(String index, BuildContext context) {
    Future.delayed(Duration(seconds: 1)).then((v) {
      setState(() {
        // restaurantMenuScrollView.jumpTo(300);
        itemScrollController.scrollTo(
            index: menuItemsData[indexKey],
            duration: Duration(seconds: 2),
            curve: Curves.easeInOutCubic);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeManager, RestaurantDetailsViewModel>(builder:
        (BuildContext context, ThemeManager theme,
            RestaurantDetailsViewModel model, Widget child) {
      return Scaffold(
          appBar: AppBar(),
          body: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: ScrollablePositionedList.builder(
                      itemScrollController: itemScrollController,
                      itemPositionsListener: itemPositionsListener,
                      // physics: NeverScrollableScrollPhysics(),
                      //shrinkWrap: true,
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
                      itemCount: model.catFoodItemsData.length,
                      itemBuilder: (context, parentIndex) {
//                                                              return parentIndex ==
//                                                                      model
//                                                                          .catFoodItemsData
//                                                                          ?.length
//                                                                  ? showWidgetEndOfScroll(
//                                                                      model,
//                                                                      context)
//
                        return Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15.0,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    model.catFoodItemsData[parentIndex]
                                        ?.mainCatName,
//                                                                          model
//                                                                              .restaurantDetailModelBoxData
//                                                                              .catFoodItems[parentIndex]
//                                                                              .mainCatName,
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  verticalSizedBox(),
                                  divider(),
                                  verticalSizedBox(),
                                  ListView.separated(
                                    separatorBuilder: (context, index) =>
                                        Divider(
                                      color: Colors.grey[200],
                                    ),
                                    shrinkWrap: true,
                                    itemCount: model
                                        .catFoodItemsData[parentIndex]
                                        ?.aFoodItems
                                        ?.length,
//                                                                          itemCount: model
//                                                                              .restaurantDetailModelBoxData
//                                                                              .catFoodItems[parentIndex]
//                                                                              ?.aFoodItems
//                                                                              ?.length,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 8.0,
                                        ),
                                        child: RestaurantItem(
                                          itemInfo: model
                                              .catFoodItemsData[parentIndex]
                                              ?.aFoodItems,
                                          parentIndex: parentIndex,
                                          childIndex: index,
                                          availabilityTime: model.restaurantData
                                              ?.availability?.status,
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
                    ),
                  ),
                  Consumer<CartQuantityViewModel>(builder:
                      (BuildContext context, CartQuantityViewModel cartModel,
                          Widget child) {
                    return Visibility(
                      visible:
                          cartModel.cartQuantityData?.totalQuantity != null,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
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
                                await Navigator.pushNamed(context, cart,
                                        arguments: true)
                                    .then((value) => {
                                          showLog("Backpressed--${value}"),

                                          if (value == null)
                                            {
                                              model
                                                  .initRestaurantDetailsApiRequest(
                                                      restaurantID:
                                                          menuItemsData[
                                                              restaurantIdKey],
                                                      buildContext: context),
                                            }
                                          else
                                            {
                                              model
                                                  .initRestaurantDetailsApiRequest(
                                                      restaurantID:
                                                          int.parse(value),
                                                      buildContext: context),
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
                              child: CartQuantityPriceCardView(),
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
              Positioned(
                bottom: 0.0,
                left: 0.0,
                right: 5.0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () async {
                            await menuPopup(
                              context: context,
                              rootModel: model,
                            ).then((value) => {
                                  showLog("GestureDetector -- ${value}"),
//                                                        model
//                                                            .moveToMenuPosition(
//                                                                value, context),

//                            Navigator.pushNamed(
//                                context,
//                                restaurantMenuListScreen,
//                                arguments: {
//                                  restaurantIdKey: widget
//                                      .restaurantDetailInfo
//                                      .restaurantID,
//                                  indexKey: value
//                                })

                                  moveToRespectiveIndex(
                                      value.toString(), context),
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
          )

//        body: ListView.builder(
//          controller: restaurantMenuScrollView,
//          // physics: NeverScrollableScrollPhysics(),
//          shrinkWrap: true,
//          // ignore: null_aware_before_operator
////                                                      itemCount: model
////                                                              .restaurantDetailModelBoxData
////                                                              .catFoodItems
////                                                              .length +
////                                                          1,
////                                                            itemCount: model
////                                                                    .catFoodItemsData
////                                                                    .length +
////                                                                1,
//          itemCount: model.catFoodItemsData.length,
//          itemBuilder: (context, parentIndex) {
////                                                              return parentIndex ==
////                                                                      model
////                                                                          .catFoodItemsData
////                                                                          ?.length
////                                                                  ? showWidgetEndOfScroll(
////                                                                      model,
////                                                                      context)
////
//            return Padding(
//              padding: const EdgeInsets.all(5.0),
//              child: Container(
//                child: Padding(
//                  padding: const EdgeInsets.symmetric(
//                    horizontal: 15.0,
//                  ),
//                  child: Column(
//                    crossAxisAlignment: CrossAxisAlignment.start,
//                    mainAxisAlignment: MainAxisAlignment.start,
//                    children: <Widget>[
//                      Text(
//                        model.catFoodItemsData[parentIndex]?.mainCatName,
////                                                                          model
////                                                                              .restaurantDetailModelBoxData
////                                                                              .catFoodItems[parentIndex]
////                                                                              .mainCatName,
//                        style: TextStyle(
//                          fontSize: 15.0,
//                          fontWeight: FontWeight.bold,
//                        ),
//                      ),
//                      verticalSizedBox(),
//                      divider(),
//                      verticalSizedBox(),
//                      ListView.separated(
//                        separatorBuilder: (context, index) => Divider(
//                          color: Colors.grey[200],
//                        ),
//                        shrinkWrap: true,
//                        itemCount: model
//                            .catFoodItemsData[parentIndex]?.aFoodItems?.length,
////                                                                          itemCount: model
////                                                                              .restaurantDetailModelBoxData
////                                                                              .catFoodItems[parentIndex]
////                                                                              ?.aFoodItems
////                                                                              ?.length,
//                        physics: NeverScrollableScrollPhysics(),
//                        itemBuilder: (context, index) {
//                          return Padding(
//                            padding: const EdgeInsets.symmetric(
//                              vertical: 8.0,
//                            ),
//                            child: RestaurantItem(
//                              itemInfo: model
//                                  .catFoodItemsData[parentIndex]?.aFoodItems,
//                              parentIndex: parentIndex,
//                              childIndex: index,
//                              availabilityTime:
//                                  model.restaurantData?.availability?.status,
//                              model: model,
//                            ),
////                                                                                child: RestSearchCartFoodItemScreen(
////                                                                                  parentIndex: parentIndex,
////                                                                                  childIndex: index,
////                                                                                  fromWhichScreen: 1,
////                                                                                  shopAvailabilityStatus: model.restaurantData.availability.status,
////                                                                                  restDetailsViewModel: model,
////                                                                                ), //RestaurantItem(itemInfo: model.catFoodItemsData[parentIndex].aFoodItems, parentIndex: parentIndex, childIndex: index, availabilityTime: model.restaurantData.availability.status, model: model),
//                          );
//                        },
//                      ),
//                    ],
//                  ),
//                ),
//              ),
//            );
//          },
//        ),
          );
    });
  }
}
