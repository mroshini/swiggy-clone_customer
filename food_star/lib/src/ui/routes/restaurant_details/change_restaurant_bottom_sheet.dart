import 'package:flutter/material.dart';
import 'package:foodstar/generated/l10n.dart';
import 'package:foodstar/src/constants/api_params_keys.dart';
import 'package:foodstar/src/constants/api_urls.dart';
import 'package:foodstar/src/core/provider_viewmodels/cart_quantity_view_model.dart';
import 'package:foodstar/src/core/provider_viewmodels/restaurant_details_view_model.dart';
import 'package:foodstar/src/core/provider_viewmodels/search_view_model.dart';
import 'package:foodstar/src/ui/res/colors.dart';
import 'package:foodstar/src/ui/shared/others.dart';
import 'package:foodstar/src/ui/shared/progress_indicator.dart';
import 'package:foodstar/src/ui/shared/sizedbox.dart';
import 'package:foodstar/src/utils/banner_slider_shimmer.dart';
import 'package:provider/provider.dart';

class ChangeRestaurantScreen extends StatefulWidget {
  final RestaurantDetailsViewModel model;
  final SearchViewModel searchViewModel;
  final int restFoodId;
  final String image;
  final Map<String, dynamic> dynamicMapValue;
  final int fromWhere;

  final BuildContext context;

  ChangeRestaurantScreen(
      {this.model,
      this.restFoodId = 0,
      this.context,
      this.dynamicMapValue,
      this.fromWhere,
      this.searchViewModel,
      this.image});

  @override
  _ChangeRestaurantScreenState createState() => _ChangeRestaurantScreenState();
}

class _ChangeRestaurantScreenState extends State<ChangeRestaurantScreen> {
  TextEditingController addNoteController = TextEditingController();
  FocusNode addNoteTextFocus = new FocusNode();
  bool isLoading = false;
  CartQuantityViewModel cartQuantityPriceProvider;

  @override
  void initState() {
    cartQuantityPriceProvider =
        Provider.of<CartQuantityViewModel>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 10.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                verticalSizedBox(),
                closeIconButton(
                    context: context,
                    onClicked: () {
                      Navigator.of(context).pop(false);
                    }),
                verticalSizedBox(),
                Flexible(
                  flex: 2,
                  child: Align(
                    alignment: Alignment.center,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        30.0,
                      ),
                      child: networkImage(
                        image: widget.image,
                        loaderImage: loaderBeforeImage(),
                        height: 150.0,
                        width: 200.0,
                      ),
                    ),
                  ),
                ),
                verticalSizedBoxTwenty(),
                Flexible(
                  child: Text(S.of(context).wantToChangeRestaurant,
                      style: Theme.of(context).textTheme.subhead),
                ),
                verticalSizedBox(),
                Flexible(
                  child: Text(S.of(context).changeRestaurantBodyContent,
                      style: Theme.of(context).textTheme.body2),
                ),
                verticalSizedBoxTwenty(),
                isLoading
                    ? showProgress(context)
                    : Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Expanded(
                              flex: 4,
                              child: OutlineButton(
                                child: Text(
                                  S.of(context).cancel,
                                  style: Theme.of(context)
                                      .textTheme
                                      .display3
                                      .copyWith(color: appColor, fontSize: 13),
                                ),
                                color: appColor,
                                onPressed: () {
                                  Navigator.pop(context, false);
                                },
                                highlightedBorderColor: darkGreen,
                                shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(
                                    8.0,
                                  ),
                                ),
                              ),
                            ),
                            verticalSizedBoxTwenty(),
                            Expanded(
                              flex: 4,
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: RaisedButton(
                                  color: appColor,
                                  child: Text(
                                    S.of(context).sureGoAhead,
                                    style: Theme.of(context)
                                        .textTheme
                                        .display3
                                        .copyWith(color: white, fontSize: 13),
                                  ),
                                  onPressed: () {
//                              Provider.of<RestaurantDetailsViewModel>(context,
//                                      listen: false)

                                    setProgress(true);
//if restFoodId!=0 means resdelete  or  restFoodId==0 food items delete
                                    showLog(
                                        "ChangeRestBottomsheet == ${widget.restFoodId}");
                                    if (widget.fromWhere == 1) {
                                      widget.restFoodId == 0
                                          ? widget.model
                                              .deleteRestaurantIfExist(
                                                dynamicMapValue:
                                                    widget.dynamicMapValue,
                                                context: context,
                                              )
                                              .then((value) => {
//                                                  cartQuantityPriceProvider
//                                                      .updateCartQuantity(
//                                                          value.aCart, false),

                                                    if (value)
                                                      {
                                                        widget.model
                                                            .cartActionsRequest(
                                                                resturantId: widget
                                                                    .restFoodId,
                                                                foodId: int.parse(
                                                                    widget.dynamicMapValue[
                                                                        foodIdKey]),
                                                                action: widget
                                                                        .dynamicMapValue[
                                                                    actionKey],
                                                                context: widget
                                                                    .context)
                                                            .then((value) => {
                                                                  bottomSheetNavigationAfterApiResponse(
                                                                      value),
                                                                }),
                                                        showLog(
                                                            "ChangeRestBottomsheet 1== ${widget.restFoodId}"),
                                                      }
                                                  })
                                          : widget.model
                                              .cartActionsRequest(
                                                  resturantId:
                                                      widget.restFoodId,
                                                  action: restaurantDelete,
                                                  context: widget.context)
                                              .then((value) => {
                                                    bottomSheetNavigationAfterApiResponse(
                                                        value),
                                                    showLog(
                                                        "ChangeRestBottomsheet2 == ${widget.restFoodId}"),
                                                  });
                                    } else if (widget.fromWhere == 2) {
                                      widget.restFoodId == 0
                                          ? widget.searchViewModel
                                              .deleteRestaurantIfExist(
                                                dynamicMapValue:
                                                    widget.dynamicMapValue,
                                                context: context,
                                              )
                                              .then((value) => {
//
                                                    showLog(" ${value}"),
                                                    if (value)
                                                      {
                                                        widget.searchViewModel
                                                            .cartActionsRequest(
                                                                resturantId: widget
                                                                    .restFoodId,
                                                                foodId: int.parse(
                                                                    widget.dynamicMapValue[
                                                                        foodIdKey]),
                                                                action: widget
                                                                        .dynamicMapValue[
                                                                    actionKey],
                                                                context: widget
                                                                    .context)
                                                            .then((value) => {
                                                                  bottomSheetNavigationAfterApiResponse(
                                                                      value),
                                                                }),
                                                        showLog(
                                                            "ChangeRestBottomsheet 1== ${widget.restFoodId}"),
                                                      }
                                                  })
                                          : widget.model
                                              .cartActionsRequest(
                                                  resturantId:
                                                      widget.restFoodId,
                                                  action: restaurantDelete,
                                                  context: widget.context)
                                              .then((value) => {
                                                    bottomSheetNavigationAfterApiResponse(
                                                        value),
                                                    showLog(
                                                        "ChangeRestBottomsheet2 == ${widget.restFoodId}"),
                                                  });
                                    }

//                                  model.cartActionsRequest(
//                                      foodId: widget.restFoodId,
//                                      action: restaurantDelete);
                                  },
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
      ),
    );
  }

  bottomSheetNavigationAfterApiResponse(dynamic value) {
    setProgress(false);
    if (value) {
      Navigator.pop(context, true);
    } else {
      Navigator.pop(context, false);
    }
  }

  setProgress(bool value) {
    setState(() {
      isLoading = value;
    });
  }
}
