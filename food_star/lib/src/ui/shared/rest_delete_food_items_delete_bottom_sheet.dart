import 'package:flutter/material.dart';
import 'package:foodstar/generated/l10n.dart';
import 'package:foodstar/src/constants/api_params_keys.dart';
import 'package:foodstar/src/constants/api_urls.dart';
import 'package:foodstar/src/constants/common_strings.dart';
import 'package:foodstar/src/core/provider_viewmodels/cart_bill_detail_view_model.dart';
import 'package:foodstar/src/core/provider_viewmodels/cart_quantity_view_model.dart';
import 'package:foodstar/src/core/provider_viewmodels/restaurant_details_view_model.dart';
import 'package:foodstar/src/core/provider_viewmodels/search_view_model.dart';
import 'package:foodstar/src/ui/res/colors.dart';
import 'package:foodstar/src/ui/shared/progress_indicator.dart';
import 'package:foodstar/src/ui/shared/sizedbox.dart';
import 'package:foodstar/src/utils/banner_slider_shimmer.dart';
import 'package:provider/provider.dart';

class RestDeleteFoodItemsDeleteBottomSheet extends StatefulWidget {
  final Map<String, String> dynamicMapValue;

  final BuildContext context;

  RestDeleteFoodItemsDeleteBottomSheet({
    this.context,
    this.dynamicMapValue,
  });

  @override
  _RestDeleteFoodItemsDeleteBottomSheetState createState() =>
      _RestDeleteFoodItemsDeleteBottomSheetState(
          dynamicMapValue: dynamicMapValue);
}

class _RestDeleteFoodItemsDeleteBottomSheetState
    extends State<RestDeleteFoodItemsDeleteBottomSheet> {
  final Map<String, String> dynamicMapValue;
  TextEditingController addNoteController = TextEditingController();
  FocusNode addNoteTextFocus = new FocusNode();
  bool isLoading = false;
  CartQuantityViewModel cartQuantityPriceProvider;
  RestaurantDetailsViewModel restaurantDetailsViewModel;
  SearchViewModel searchViewModel;
  CartBillDetailViewModel cartBillDetailViewModel;

  _RestDeleteFoodItemsDeleteBottomSheetState({this.dynamicMapValue});

  @override
  void initState() {
    cartQuantityPriceProvider =
        Provider.of<CartQuantityViewModel>(context, listen: false);
    restaurantDetailsViewModel =
        Provider.of<RestaurantDetailsViewModel>(context, listen: false);
    searchViewModel = Provider.of<SearchViewModel>(context, listen: false);
    cartBillDetailViewModel =
        Provider.of<CartBillDetailViewModel>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 10.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
//            verticalSizedBox(),
//            closeIconButton(
//                context: context,
//                onClicked: () {
//                  Navigator.of(context).pop();
//                }),
            verticalSizedBox(),
            Visibility(
              visible: dynamicMapValue[imageKey] != "",
              maintainSize: false,
              child: Flexible(
                flex: 2,
                child: Align(
                  alignment: Alignment.center,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                      30.0,
                    ),
                    child: networkImage(
                      image: dynamicMapValue[imageKey],
                      loaderImage: loaderBeforeImage(),
                      height: 150.0,
                      width: 200.0,
                    ),
                  ),
                ),
              ),
            ),
            verticalSizedBoxTwenty(),
            Text(
                dynamicMapValue[actionKey] == restaurantDelete
                    ? CommonStrings.restaurantNotAvailable
                    : dynamicMapValue[fromWhichScreen] == "3"
                        ? CommonStrings.someOfFoodItemsNotAvailable
                        : CommonStrings.foodItemNotAvailable,
                style: Theme.of(context).textTheme.subhead),
            verticalSizedBox(),
            Text(
                dynamicMapValue[actionKey] == restaurantDelete
                    ? S.of(context).wantToChangeRestaurant
                    : 'Want to Remove added Food Items?',
                style: Theme.of(context).textTheme.display1),
            verticalSizedBox(),
            Visibility(
              visible: dynamicMapValue[actionKey] == restaurantDelete,
              child: Flexible(
                child: Text(
                  S.of(context).changeRestaurantBodyContent,
                  style: Theme.of(context).textTheme.body2,
                ),
              ),
            ),
            verticalSizedBoxTwenty(),
            isLoading
                ? showProgress(context)
                : Row(
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
                            Navigator.pop(context);
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
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                              setProgress(true);
                              showLog(
                                  "ChangeRestBottomsheet == ${dynamicMapValue[fromWhichScreen]}");
                              if (dynamicMapValue[fromWhichScreen] == "1") {
                                // from restaurant
                                restaurantDetailsViewModel
                                    .cartActionsRequest(
                                      foodId: dynamicMapValue[foodIdKey] == null
                                          ? "0"
                                          : int.parse(
                                              dynamicMapValue[foodIdKey]),
                                      action: dynamicMapValue[actionKey],
                                      context: context,
                                      resturantId: int.parse(
                                          dynamicMapValue[restaurantIdKey]),
                                    )
                                    .then((value) => {
                                          if (value)
                                            {
                                              Navigator.pop(context,
                                                  dynamicMapValue[actionKey])
                                            }
                                        });
                              } else if (dynamicMapValue[fromWhichScreen] ==
                                  "2") {
                                // from search
                                searchViewModel
                                    .cartActionsRequest(
                                      foodId: dynamicMapValue[foodIdKey] == null
                                          ? "0"
                                          : int.parse(
                                              dynamicMapValue[foodIdKey]),
                                      action: dynamicMapValue[actionKey],
                                      context: context,
                                      resturantId: int.parse(
                                          dynamicMapValue[restaurantIdKey]),
                                    )
                                    .then((value) => {
                                          if (value)
                                            {
                                              showLog(
                                                  "dynamicMapValue--${value}"),
                                              Navigator.pop(context,
                                                  dynamicMapValue[actionKey])
                                            }
                                        });
                              } else if (dynamicMapValue[fromWhichScreen] ==
                                  "3") {
                                // from cart
                                cartBillDetailViewModel
                                    .cartActionsRequest(
                                      foodId: dynamicMapValue[foodIdKey],
                                      action: dynamicMapValue[actionKey],
                                      mContext: context,
                                      restaurantID:
                                          dynamicMapValue[restaurantIdKey],
                                    )
                                    .then((value) => {
                                          if (value)
                                            {
                                              showLog(
                                                  "dynamicMapValue1--${value}--${dynamicMapValue[actionKey]}"),
                                              Navigator.pop(context,
                                                  dynamicMapValue[actionKey])
                                            }
                                          else
                                            {
                                              showLog(
                                                  "dynamicMapValue2--${value}"),
                                            }
                                        });
                              }
                            },
                          ),
                        ),
                      ),
                      verticalSizedBoxTwenty(),
                    ],
                  ),
          ],
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
