//import 'package:flutter/material.dart';
//import 'package:foodstar/src/constants/api_params_keys.dart';
//import 'package:foodstar/src/constants/api_urls.dart';
//import 'package:foodstar/src/constants/sharedpreference_keys.dart';
//import 'package:foodstar/src/core/models/api_models/food_items_api_model.dart';
//import 'package:foodstar/src/core/provider_viewmodels/cart_bill_detail_view_model.dart';
//import 'package:foodstar/src/core/provider_viewmodels/cart_quantity_view_model.dart';
//import 'package:foodstar/src/core/provider_viewmodels/common/base_change_notifier_model.dart';
//import 'package:foodstar/src/core/provider_viewmodels/restaurant_details_view_model.dart';
//import 'package:foodstar/src/core/provider_viewmodels/search_view_model.dart';
//import 'package:foodstar/src/core/service/api_repository.dart';
//import 'package:foodstar/src/utils/target_platform.dart';
//import 'package:provider/provider.dart';
//import 'package:shared_preferences/shared_preferences.dart';
//
//class RestSearchCartFoodItemViewModel extends BaseChangeNotifierModel {
//  List<ACommonFoodItem> foodItems = []; //food items
//  List<CommonCatFoodItem> catFoodItemsData =
//      []; // category list with food items
//  BuildContext context;
//  var deviceId;
//  bool cartItemChanged = false;
//  SharedPreferences prefs;
//  String lat = "";
//  String long = "";
//  int userId;
//  String accessToken;
//  CartQuantityViewModel cartQuantityPriceProvider;
//  RestaurantDetailsViewModel restDetailsViewModel;
//  SearchViewModel searchViewModel;
//  CartBillDetailViewModel cartBillDetailViewModel;
//  bool cartExistsData;
//
//  RestSearchCartFoodItemViewModel({this.context}) {
//    getLocationLatAndLong();
//    cartQuantityPriceProvider =
//        Provider.of<CartQuantityViewModel>(context, listen: false);
//
////    restDetailsViewModel = //context.watch<RestaurantDetailsViewModel>();
////        Provider.of<RestaurantDetailsViewModel>(context, listen: false);
////    searchViewModel = //context.watch<SearchViewModel>();
////        Provider.of<SearchViewModel>(context, listen: false);
////    cartBillDetailViewModel = // context.watch<CartBillDetailViewModel>();
////        Provider.of<CartBillDetailViewModel>(context, listen: false);
//  }
//
//  getAllModelObjects(
//      SearchViewModel searchViewModel,
//      CartBillDetailViewModel cartBillDetailViewModel,
//      RestaurantDetailsViewModel restaurantDetailsViewModel) {
//    this.searchViewModel = searchViewModel;
//    this.restDetailsViewModel = restaurantDetailsViewModel;
//    this.cartBillDetailViewModel = cartBillDetailViewModel;
//  }
//
//  getAllRespectiveViewModels(
//      int fromWhichScreen, int parentIndex, int childIndex) {
//    if (fromWhichScreen == 1) {
//      // rest details
//      cartExistsData = restDetailsViewModel.restaurantData.cartExist;
//    } else if (fromWhichScreen == 2) {
//      // search
//      cartExistsData = catFoodItemsData[parentIndex].restaurantDetail.cartExist;
//    } else if (fromWhichScreen == 3) {
//      // cart
//
//    } else {}
//    notifyListeners();
//  }
//
//  updateCatAndFoodItemsFromRestDetails(
//      {dynamic value, int fromWhere, int previousScreen}) {
//    if (fromWhere == 1) {
//      // rest details
//      if (previousScreen == 1) {
//        catFoodItemsData.addAll(value != null ? value : []);
//      } else {
//        catFoodItemsData = value;
//      }
//    } else if (fromWhere == 2) {
//      // search
//      catFoodItemsData = value != null ? value : [];
//    } else if (fromWhere == 3) {
//      // cart
//      foodItems = value != null ? value : [];
//    } else {}
//    notifyListeners();
//  }
//
//  initPref() async {
//    if (prefs == null) prefs = await SharedPreferences.getInstance();
//  }
//
//  getLocationLatAndLong() async {
//    await initPref();
//    deviceId = await fetchDeviceId();
//    accessToken = prefs.getString(SharedPreferenceKeys.accessToken) ?? "";
//    lat = prefs.getString(SharedPreferenceKeys.latitude) ?? "";
//    long = prefs.getString(SharedPreferenceKeys.longitude) ?? "";
//
//    userId = prefs.getInt(SharedPreferenceKeys.userId) ?? 0;
//  }
//
//  Future<bool> cartActionsRequestFromCommonModel(
//      {int foodId = 0,
//      String action = "",
//      BuildContext context,
//      int index,
//      int resturantId = 0,
//      int parentIndex,
//      int fromWhichScreen}) async {
//    cartQuantityPriceProvider.updateProgress(true);
//    bool cartActionResponse = false;
//    try {
//      await ApiRepository(mContext: context).callCartActionRequest(
//        dynamicMapValue: {
//          deviceIDKey: deviceId,
//          userIdKey: userId.toString(),
//          restaurantIdKey: resturantId.toString(),
//          foodIdKey: foodId.toString(),
//          actionKey: action
//        },
//        context: context,
//        fromWhere: 1,
//        index: index,
//        parentIndex: index,
//      ).then((value) => {
//            cartActionResponse = true,
//            cartItemChanged = false,
//            cartQuantityPriceProvider.updateCartQuantity(value.aCart, false),
//            if (fromWhichScreen == 3)
//              {
//                cartBillDetailViewModel.cartBillData.grandTotal =
//                    value.aCart.totalPrice
//              }
//          });
//
//      notifyListeners();
//    } catch (e) {
//      cartActionResponse = false;
//      cartItemChanged = false;
//      cartQuantityPriceProvider.updateCartQuantity(null, false);
//      showLog("cartActionsRequest -- ${e}");
//    }
//    return cartActionResponse;
//  }
//
//  Future<bool> deleteRestaurantIfExist(
//      {Map<String, dynamic> dynamicMapValue,
//      BuildContext context,
//      RestSearchCartFoodItemViewModel model}) async {
//    bool result;
//    try {
//      await ApiRepository(mContext: context)
//          .restDeleteIfAlreadyExits(
//              dynamicMapValue: dynamicMapValue, context: context, model: model)
//          .then((value) => {
//                cartQuantityPriceProvider.updateCartQuantity(
//                    value.aCart, false),
//                result = true,
//              });
//    } catch (e) {
//      cartQuantityPriceProvider.updateCartQuantity(null, false);
//      result = null;
//    }
//    return result;
//  }
//
//  initAddItemFromCommonModel({int index, int parentIndex}) {
//    catFoodItemsData[parentIndex].aFoodItems[index].cartDetail.quantity =
//        catFoodItemsData[parentIndex].aFoodItems[index].cartDetail.quantity + 1;
//
//    notifyListeners();
//  }
//
//  updateCartExistsFromCommonModel(
//      {int fromWhichScreen, int parentIndex, int childIndex}) {
//    if (fromWhichScreen == 1) {
//      restDetailsViewModel.restaurantData.cartExist = false;
//    } else if (fromWhichScreen == 2) {
//      for (int outer = 0; outer <= catFoodItemsData.length - 1; outer++) {
//        if (outer == parentIndex) {
//          catFoodItemsData[parentIndex].restaurantDetail.cartExist =
//              false; // could add
//        } else {
//          catFoodItemsData[outer].restaurantDetail.cartExist =
//              true; // could not add
//
//          for (int inner = 0;
//              inner <= catFoodItemsData[outer].aFoodItems.length - 1;
//              inner++) {
//            catFoodItemsData[outer].aFoodItems[inner].cartDetail.quantity = 0;
//          }
//        }
//      }
//    } else {}
//
//    notifyListeners();
//  }
//
////  removeCartItemsAfterChangeRestaurantFromCommonModel() {
////    showLog("outter loop --${catFoodItemsData.length}");
////    for (int outter = 0; outter <= catFoodItemsData.length - 1; outter++) {
////      for (int inner = 0;
////          inner <= catFoodItemsData[outter].aFoodItems.length - 1;
////          inner++) {
////        showLog("inner loop --${catFoodItemsData[outter].aFoodItems.length}");
////        catFoodItemsData[outter].aFoodItems[inner].cartDetail.quantity = 0;
////      }
////    }
////    notifyListeners();
////  }
//
//  updateCartAfterCancelExistCartRemoveDialogFromCommonModel(
//      {int index, int parentIndex}) {
//    showLog(
//        "updateCartAfterCancelExistCartRemoveDialog ${index} --${parentIndex}");
//    showLog("showPrice ${catFoodItemsData.length}");
////    var showPrice =
////        catFoodItemsData[parentIndex].aFoodItems[index].sellingPrice > 0
////            ? catFoodItemsData[parentIndex].aFoodItems[index].sellingPrice
////            : catFoodItemsData[parentIndex].aFoodItems[index].price;
////    catFoodItemsData[parentIndex].aFoodItems[index].showPrice =
////        showPrice.toString();
////    showLog("showPrice ${index} --${parentIndex} ${showPrice}");
////        double.parse(showPrice.toString()).toString();
//
//    catFoodItemsData[parentIndex].aFoodItems[index].cartDetail.quantity = 0;
//
//    notifyListeners();
//  }
//
//  addAndRemoveFoodPriceFromCommonModel(
//      {int index,
//      int parentIndex,
//      bool addOrRemove,
//      int fromWhichScreen}) async {
//    await initPref();
//    var quantity;
//    if (fromWhichScreen == 3) {
//      quantity = foodItems[index].cartDetail.quantity;
//
//      showLog("updateFoodPrice -- ${foodItems[index].showPrice}");
//
//      if (addOrRemove) {
//        foodItems[index].cartDetail.quantity = quantity + 1;
//      } else {
//        if (quantity > 0) {
//          // Remove
//          foodItems[index].cartDetail.quantity = quantity - 1;
//
////          if (foodItems[index].cartDetail.quantity == 0) {
////            showLog("updateFoodPrice1 -- ${index}");
////            foodItems.removeAt(index);
////          }
//        }
//      }
//    } else {
//      quantity =
//          catFoodItemsData[parentIndex].aFoodItems[index].cartDetail.quantity;
//
//      showLog(
//          "updateFoodPrice -- ${catFoodItemsData[parentIndex].aFoodItems[index].showPrice}");
//
//      if (addOrRemove) {
//        catFoodItemsData[parentIndex].aFoodItems[index].cartDetail.quantity =
//            quantity + 1;
//      } else {
//        if (quantity > 0) {
//          // Remove
//          catFoodItemsData[parentIndex].aFoodItems[index].cartDetail.quantity =
//              quantity - 1;
//        }
//      }
//    }
//
//    notifyListeners();
//  }
//}
