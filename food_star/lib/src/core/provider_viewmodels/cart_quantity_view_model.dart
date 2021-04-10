import 'package:flutter/material.dart';
import 'package:foodstar/src/constants/api_urls.dart';
import 'package:foodstar/src/constants/sharedpreference_keys.dart';
import 'package:foodstar/src/core/models/api_models/cart_action_api_model.dart';
import 'package:foodstar/src/core/models/api_models/food_items_api_model.dart';
import 'package:foodstar/src/core/provider_viewmodels/common/base_change_notifier_model.dart';
import 'package:foodstar/src/core/provider_viewmodels/restaurant_details_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartQuantityViewModel extends BaseChangeNotifierModel {
  BuildContext context;

  //CartActionDetails cartActionDetails;
  CartQuantityPrice cartQuantityData;
  bool cartItemChanged = false;
  String currencySymbol;
  SharedPreferences prefs;
  List<ACommonFoodItem> aCommonFoodItems;
  RestaurantDetailsViewModel restModel;
  String restaurantName;
  String quantity = "0";
  bool showBadge = false;

  CartQuantityViewModel({this.context}) {
    getInitData();
    // restModel = Provider.of<RestaurantDetailsViewModel>(context, listen: false);
    showLog("CartQuantityViewModel -- ${cartQuantityData ?? ""}");
  }

  initPref() async {
    if (prefs == null) prefs = await SharedPreferences.getInstance();
  }

  getInitData() async {
    await initPref();
    currencySymbol = prefs.getString(SharedPreferenceKeys.currencySymbol);
    showLog("CartQuantityViewModel1 -- ${currencySymbol}");
  }

  updateProgress(bool progress) {
    cartItemChanged = progress;
    notifyListeners();
  }

  updateCartQuantity({CartQuantityPrice aCart, bool progress}) {
    getInitData();
    // cartActionDetails = value;
    showLog("updateCartQuantity --${aCart}");
    cartQuantityData = aCart;
    restaurantName = aCart.restaurantName ?? "";
    cartItemChanged = progress;
    quantity = cartQuantityData.totalQuantity.toString();
    showBadge = quantity == "null" || quantity == "0" ? false : true;
    showLog("updateCartQuantity -- ${quantity} -- ${showBadge}");
    notifyListeners();
  }
}
