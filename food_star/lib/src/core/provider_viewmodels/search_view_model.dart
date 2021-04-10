import 'package:flutter/cupertino.dart';
import 'package:foodstar/src/constants/api_params_keys.dart';
import 'package:foodstar/src/constants/api_urls.dart';
import 'package:foodstar/src/constants/sharedpreference_keys.dart';
import 'package:foodstar/src/core/models/api_models/already_searched_keyword_model.dart';
import 'package:foodstar/src/core/models/api_models/cart_action_api_model.dart';
import 'package:foodstar/src/core/models/api_models/food_items_api_model.dart';
import 'package:foodstar/src/core/models/api_models/search_api_model.dart';
import 'package:foodstar/src/core/provider_viewmodels/cart_quantity_view_model.dart';
import 'package:foodstar/src/core/provider_viewmodels/common/base_change_notifier_model.dart';
import 'package:foodstar/src/core/service/api_repository.dart';
import 'package:foodstar/src/core/service/app_exception.dart';
import 'package:foodstar/src/core/service/database/database_helper.dart';
import 'package:foodstar/src/core/service/database/database_statics.dart';
import 'package:foodstar/src/utils/target_platform.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchViewModel extends BaseChangeNotifierModel {
  BuildContext context;
  SharedPreferences prefs;
  List<Search> topSearch = [];
  List<Search> recentSearch = [];
  List<ARestaurant> listOfRestaurantData = [];
  List<CommonCatFoodItem> listOfDishData = [];
  List<CommonCatFoodItem> listOfFoodItems = [];
  List<CommonCatFoodItem> listOfClosedFoodItems = [];
  String type = "";
  String message = "";
  DBHelper dbHelper;
  Search topSearchedKeyword;
  Search recentSearchedKeyword;
  bool isSearching = false;
  CartQuantityPrice cartData;
  var isCartItemChange = false;
  CartQuantityViewModel cartQuantityPriceProvider;

  // RestSearchCartFoodItemViewModel restSearchCartFoodViewModel;
  String cityValue = "";

  int userId;
  String accessToken;

  SearchViewModel({this.context}) {
    initDbHelper();
    getInitData();
    cartQuantityPriceProvider =
        Provider.of<CartQuantityViewModel>(context, listen: false);
//    restSearchCartFoodViewModel =
//        Provider.of<RestSearchCartFoodItemViewModel>(context, listen: false);
    //getAlreadySearchedData();
  }

  var deviceId;
  String lat;
  String long;
  String currencySymbol;

  initPref() async {
    if (prefs == null) prefs = await SharedPreferences.getInstance();
  }

  initDbHelper() {
    dbHelper = DBHelper.instance;
  }

  initAddItemFromSearch({int index, int parentIndex}) {
    listOfDishData[parentIndex].aFoodItems[index].cartDetail.quantity =
        listOfDishData[parentIndex].aFoodItems[index].cartDetail.quantity + 1;

    notifyListeners();
  }

  deleteItem({int index, int parentIndex}) {
    listOfDishData[parentIndex].aFoodItems[index].cartDetail.quantity = 0;
    notifyListeners();
  }

//  updateCartAfterCancelExistCartRemoveDialog({int index, int parentIndex}) {
//    showLog("SearchViewModel");
//    listOfDishData[parentIndex].aFoodItems[index].cartDetail.quantity = 0;
//    notifyListeners();
//  }

  Future<bool> deleteRestaurantIfExist(
      {Map<String, dynamic> dynamicMapValue, BuildContext context}) async {
    bool result;
    try {
      await ApiRepository(mContext: context)
          .restDeleteIfAlreadyExits(
              dynamicMapValue: dynamicMapValue, context: context)
          .then((value) async => {
                await cartQuantityPriceProvider.updateCartQuantity(
                    aCart: value.aCart, progress: false),
                result = true,
              });
    } catch (e) {
//      cartQuantityPriceProvider.updateCartQuantity(
//          aCart: null, progress: false);
      result = false;
    }
    return result;
  }

  refreshScreenAfterFoodOrRestaurantDelete(
      {int index, int parentIndex, String action, int restaurantID}) {
    if (action == restaurantDelete) {
      for (var restItems in listOfDishData) {
        for (var foodItems in restItems.aFoodItems) {
          if (restaurantID == restItems.restaurantId) {
            foodItems.cartDetail.quantity = 0;
          }
        }
        if (restaurantID == restItems.restaurantId) {
          restItems.restaurantDetail.cartExist = false;
        }
      }
    } else {
      for (var restItem in listOfDishData) {
        if (restaurantID == restItem.restaurantId) {
          restItem.restaurantDetail.cartExist = false;
        }
      }
      listOfDishData[parentIndex].aFoodItems[index].cartDetail.quantity = 0;
    }
    notifyListeners();
  }

  notAvailable({int index, int parentIndex, String action, int restaurantID}) {
    listOfDishData[parentIndex].aFoodItems[index].cartDetail.quantity = 0;
    listOfDishData[parentIndex].aFoodItems[index].availability.status = 0;
    notifyListeners();
  }

  setFoodItemsNotAvailable(
      {int index, int parentIndex, String action, int restaurantID}) {
    for (var restItems in listOfDishData) {
      for (var foodItems in restItems.aFoodItems) {
        if (restaurantID == restItems.restaurantId) {
          foodItems.availability.status = 0;
        }
      }
//      if (restaurantID == restItems.restaurantId) {
//        restItems.restaurantDetail.cartExist = false;
//      }
    }

    notifyListeners();
  }

  setRestaurantNotAvailable(
      {int index, int parentIndex, String action, int restaurantID}) {
    for (var restItem in listOfDishData) {
      if (restaurantID == restItem.restaurantId) {
        restItem.restaurantDetail.availability.status = 0;
      }
    }
  }

//  updateFoodItemsFromSearchDataChangesDoneFromCart() {
//    for (int i = 0;
//        i <= restSearchCartFoodViewModel.foodItems.length - 1;
//        i++) {
//      showLog(
//          "updateFoodItemsDataChange ${listOfDishData[0].aFoodItems[0].foodItem}");
//      for (int inner = 0; inner <= listOfDishData.length - 1; inner++) {
//        for (int inin = 0;
//            inin <= listOfDishData[inner].aFoodItems.length - 1;
//            inin++) {
//          showLog(
//              "updateFoodItemsDataChangeDoneFromCart4 ${listOfDishData[inner].aFoodItems[inin].id}");
//          showLog(
//              "updateFoodItemsDataChangeDoneFromCart5 ${listOfDishData[inner].aFoodItems.indexWhere(
//                    (f) =>
//                        (f.id == restSearchCartFoodViewModel.foodItems[i].id),
//                  )}");
//          if (listOfDishData[inner].aFoodItems[inin].id ==
//              restSearchCartFoodViewModel.foodItems[i].id) {
//            var indexValue = listOfDishData[inner].aFoodItems.indexWhere(
//              (f) {
//                showLog(
//                    "updateFood ${f.id} -- ${restSearchCartFoodViewModel.foodItems[i].id}");
//
//                return (f.id == restSearchCartFoodViewModel.foodItems[i].id);
//              },
//            );
//
//            listOfDishData[inner].aFoodItems[indexValue].cartDetail.quantity =
//                restSearchCartFoodViewModel.foodItems[i].cartDetail.quantity;
//            notifyListeners();
//          }
//        }
//      }
//    }
//  }
//
//  updateSearchListViewDataUpdatedFromRestDetails() {
//    updateFoodItemsFromSearchDataChangesDoneFromCart();
//    restSearchCartFoodViewModel.updateCatAndFoodItemsFromRestDetails(
//      value: listOfDishData,
//      fromWhere: 2,
//    );
//  }

  updateCartExistsWhileRemoveAllItemFromSearch() {
    for (int outer = 0; outer <= listOfDishData.length - 1; outer++) {
      listOfDishData[outer].restaurantDetail.cartExist = false; // could not add

//        for (int inner = 0;
//        inner <= listOfDishData[outer].aFoodItems.length - 1;
//        inner++) {
//          listOfDishData[outer].aFoodItems[inner].cartDetail.quantity = 0;
//        }

    }

    notifyListeners();
  }

  updateCartExists({int parentIndex, int index}) async {
    await initPref();
    prefs.remove(SharedPreferenceKeys.givenAddressForDelivery);
    prefs.remove(SharedPreferenceKeys.deliveryDataSharedPrefKey);
    showLog(
        "updateCartExists -- ${listOfDishData[parentIndex].restaurantDetail.cartExist}");
    var quantity;
    for (int outer = 0; outer <= listOfDishData.length - 1; outer++) {
      if (outer == parentIndex) {
        listOfDishData[parentIndex].restaurantDetail.cartExist =
            false; // could add
      } else {
        listOfDishData[outer].restaurantDetail.cartExist =
            true; // could not add

        for (int inner = 0;
            inner <= listOfDishData[outer].aFoodItems.length - 1;
            inner++) {
          listOfDishData[outer].aFoodItems[inner].cartDetail.quantity = 0;
        }
      }
    }

    notifyListeners();
  }

  addAndRemoveFoodPrice({int index, int parentIndex, bool addOrRemove}) {
//
//    var foodOriginalPrice =
//        listOfDishData[parentIndex].foodItemView[index].sellingPrice > 0
//            ? listOfDishData[parentIndex].foodItemView[index].sellingPrice
//            : listOfDishData[parentIndex].foodItemView[index].price;

    var quantity =
        listOfDishData[parentIndex].aFoodItems[index].cartDetail.quantity;

    showLog(
        "updateFoodPrice -- ${listOfDishData[parentIndex].aFoodItems[index].showPrice}");

    if (addOrRemove) {
      // Add
      //foodPrice = foodPrice + newFoodPrice;
//      listOfDishData[parentIndex].foodItemView[index].showPrice = (double.parse(
//                listOfDishData[parentIndex].foodItemView[index].showPrice,
//              ) +
//              foodOriginalPrice.toDouble())
//          .toString();
      listOfDishData[parentIndex].aFoodItems[index].cartDetail.quantity =
          quantity + 1;
    } else {
//      if (double.parse(
//            listOfDishData[parentIndex].foodItemView[index].showPrice,
//          ) >
//          foodOriginalPrice.toDouble()) {
//        listOfDishData[parentIndex].foodItemView[index].showPrice =
//            (double.parse(
//                      listOfDishData[parentIndex].foodItemView[index].showPrice,
//                    ) -
//                    foodOriginalPrice.toDouble())
//                .toString();
//      }
      if (quantity > 0) {
        // Remove
        listOfDishData[parentIndex].aFoodItems[index].cartDetail.quantity =
            quantity - 1;
      }
    }

    updateCartExists(parentIndex: parentIndex, index: index);

    notifyListeners();
  }

  updateItemNotes({int index, int parentIndex, String itemNotes}) {
    listOfDishData[parentIndex].aFoodItems[index].cartDetail.itemNote =
        itemNotes;
    notifyListeners();
  }

  Future<bool> cartActionsRequest(
      {int foodId = 0,
      String action = "",
      BuildContext context,
      int resturantId = 0,
      String itemNotes = ""}) async {
    bool cartActionResponse = false;
    try {
      await initPref();
      isCartItemChange = true;
      cartQuantityPriceProvider.updateProgress(true);

      userId = prefs.getInt(SharedPreferenceKeys.userId) ?? 0;
      deviceId = await fetchDeviceId();

      await ApiRepository(mContext: context).callCartActionRequest(
        dynamicMapValue: {
          deviceIDKey: deviceId,
          restaurantIdKey: resturantId.toString(),
          userIdKey: userId.toString(),
          foodIdKey: foodId.toString(),
          actionKey: action,
          itemNotesKey: itemNotes
        },
        mContext: context,
        fromWhere: 2,
      ).then((value) => {
            showLog("cartActionsRequestFromSearch ${value.aCart}"),
            if (value.aCart.totalQuantity == null)
              {
                updateCartExistsWhileRemoveAllItemFromSearch(),
              },
            cartQuantityPriceProvider.updateCartQuantity(
                aCart: value.aCart, progress: false),
            cartActionResponse = true,
//            cartData.totalQuantity = value.aCart.totalQuantity,
//            cartData.totalPrice = value.aCart.totalPrice,
            isCartItemChange = false, // loader
//        if (action == restaurantDelete) {navigateToHome()}
          });
      notifyListeners();
      return cartActionResponse;
    } catch (e) {
      // isCartItemChange = false;

//      cartQuantityPriceProvider.updateCartQuantity(
//        aCart: null,
//        progress: false,
//      );
      showLog("cartActionsRequestFromSearchee");
      //  cartActionResponse = false;
      showLog("cartActionsRequestFromSearch $e");
      throw BadRequestException(e.toString());
    }
  }

  updateWishListIndex(int index) {
    listOfRestaurantData[index].favouriteStatus =
        !listOfRestaurantData[index].favouriteStatus;
    notifyListeners();
  }

//  wishListRequestFromSearch({int restaurantId = 0,BuildContext buildContext}) async {
//    try {
//      await ApiRepository(mContext: context)
//          .callWishListRequest(dynamicMapValue: {
//        userTypeKey: 'user',
//        userIdKey: userId.toString(),
//        restaurantIdKey: restaurantId.toString(),
//      },mContext: buildContext);
//    } catch (e) {}
//  }

  getInitData() async {
    await initPref();
    isSearching = false;
    accessToken = prefs.getString(SharedPreferenceKeys.accessToken) ?? "";
    lat = prefs.getString(SharedPreferenceKeys.latitude) ?? "";
    long = prefs.getString(SharedPreferenceKeys.longitude) ?? "";
    userId = prefs.getInt(SharedPreferenceKeys.userId) ?? 0;
    cityValue = prefs.getString(SharedPreferenceKeys.city) ?? "";
    currencySymbol = prefs.getString(SharedPreferenceKeys.currencySymbol) ?? "";
  }

  getAlreadySearchedData(BuildContext buildContext) async {
    deviceId = await fetchDeviceId();
    await initPref();
    isSearching = false;
    accessToken = prefs.getString(SharedPreferenceKeys.accessToken) ?? "";
    lat = prefs.getString(SharedPreferenceKeys.latitude) ?? "";
    long = prefs.getString(SharedPreferenceKeys.longitude) ?? "";
    userId = prefs.getInt(SharedPreferenceKeys.userId) ?? 0;
    cityValue = prefs.getString(SharedPreferenceKeys.city) ?? "";
    topSearch.clear();
    recentSearch.clear();
    await getRecentAndTopSearchFromTable();

    if (topSearch.length == 0) {
      setState(BaseViewState.Busy);
    }
    cartQuantityPriceProvider.updateProgress(true);

    try {
      await ApiRepository(mContext: context)
          .callAlreadySearchedKeywordsRequest({
        deviceIDKey: deviceId,
        longitudeKey: lat,
        latitudeKey: long,
        userIdKey: userId.toString(),
        cityKey: cityValue,
      }, buildContext).then((value) async => {
                topSearch.clear(),
                recentSearch.clear(),
                topSearch = value.aTopSearch.reversed.toList(),
                recentSearch = value.aRecentSearch.reversed.toList(),

                cartQuantityPriceProvider.updateCartQuantity(
                    aCart: value.aCart, progress: false),

                for (int i = 0; i <= topSearch.length - 1; i++)
                  {
                    topSearchedKeyword = Search(
                      id: topSearch[i].id,
                      keyword: topSearch[i].keyword,
                      restaurantId: topSearch[i].restaurantId,
                      foodId: topSearch[i].foodId,
                      type: 1,
                    )
                  },

                if (topSearchedKeyword != null)
                  {
                    await dbHelper.insert(topSearchedKeyword.toJson(),
                        DbStatics.tableTopAndRecentSearchedKeyWords)
                  },

//          for (int i = 0; i <= recentSearch.length - 1; i++)
//            {
//              topSearchedKeyword = Search(
//                id: recentSearch[i].id,
//                keyword: recentSearch[i].keyword,
//                restaurantId: recentSearch[i].restaurantId,
//                foodId: recentSearch[i].foodId,
//                type: 2,
//              )
//            },
//          if (topSearchedKeyword != null)
//            {
//              await dbHelper.insert(topSearchedKeyword.toJson(),
//                  DbStatics.tableTopAndRecentSearchedKeyWords)
//            }
              });
    } catch (e) {
//      cartQuantityPriceProvider.updateCartQuantity(
//          aCart: null, progress: false);
    }
    setState(BaseViewState.Idle);
    notifyListeners();
  }

  getRecentAndTopSearchFromTable() async {
    await dbHelper.getTopAndRecentlySearchedKeywords().then((value) => {
          if (value != null)
            {
              for (int i = 0; i <= value.aTopSearch.length - 1; i++)
                {
                  if (!topSearch.contains(value.aTopSearch[i].keyword))
                    {
                      topSearch.add(
                        Search(
                          id: value.aTopSearch[i].id,
                          keyword: value.aTopSearch[i].keyword,
                          restaurantId: value.aTopSearch[i].restaurantId,
                          foodId: value.aTopSearch[i].foodId,
                        ),
                      ),
                      recentSearch.add(
                        Search(
                          id: value.aTopSearch[i].id,
                          keyword: value.aTopSearch[i].keyword,
                          restaurantId: value.aTopSearch[i].restaurantId,
                          foodId: value.aTopSearch[i].foodId,
                        ),
                      )
                    }
                },
//              for (int i = 0; i <= value.aRecentSearch.length - 1; i++)
//                {
//                  recentSearch.add(
//                    Search(
//                      id: value.aRecentSearch[i].id,
//                      keyword: value.aRecentSearch[i].keyword,
//                      restaurantId: value.aRecentSearch[i].restaurantId,
//                      foodId: value.aRecentSearch[i].foodId,
//                    ),
//                  )
//                }
            }
          else
            {
              topSearch = [],
              recentSearch = [],
            }
        });
    notifyListeners();
  }

  clearRecentAndTopSearch(BuildContext buildContext) async {
    await initPref();
    userId = prefs.getInt(SharedPreferenceKeys.userId) ?? 0;
    try {
      await ApiRepository(mContext: context).clearRecentAndTopSearch({
        deviceIDKey: deviceId, //lat,
        userIdKey: userId.toString(), //long,
        actionKey: 'clear',
      }, buildContext).then((value) => {
            dbHelper.deleteRecordFromTable(
                DbStatics.tableTopAndRecentSearchedKeyWords),
            topSearch = [],
            recentSearch = [],
          });
    } catch (e) {}
    notifyListeners();
  }

  searchByDishKeyWord(
      {String searchFor, String keyword, BuildContext buildContext}) async {
    setState(BaseViewState.Busy);

    try {
      await ApiRepository(mContext: context).callSearchRestaurantDishRequest({
        latitudeKey: lat, //"9.92227790141", //lat, //"9.92227790141", // lat,
        //lat, //"9.92227790141", //lat, //lat,
        longitudeKey:
            long, //"78.1189935361", //long, //"78.1189935361", // long,
        // long, //"78.1189935361", //long, //long,
        cityKey: cityValue,
        deviceIDKey: deviceId,
        userIdKey: userId.toString(),
        searchForKey: "searchview",
        keywordKey: keyword,
      }, buildContext).then((value) async => {
            listOfRestaurantData =
                value.aRestaurant != null ? value.aRestaurant : [],
//            await restSearchCartFoodViewModel
//                .updateCatAndFoodItemsFromRestDetails(
//                    value: value.aFoodItems, fromWhere: 2),
            listOfDishData.clear(),
            listOfFoodItems.clear(),
            listOfClosedFoodItems.clear(),
            listOfFoodItems = value.aFoodItems != null ? value.aFoodItems : [],
            showLog("listOfFoodItems -- ${listOfFoodItems.length}"),
            for (var foodItems in listOfFoodItems)
              {
                if (foodItems.restaurantDetail.availability.status == 1)
                  {
                    showLog(
                        "searchByDishKeyWord1 -- ${foodItems.restaurantDetail.availability.status}"),
                    if (!listOfDishData.contains(foodItems))
                      {
                        listOfDishData.add(foodItems),
                      }
                  }
                else
                  {
                    showLog(
                        "searchByDishKeyWord 2-- ${foodItems.restaurantDetail.availability.status}"),
                    if (!listOfClosedFoodItems.contains(foodItems))
                      {
                        listOfClosedFoodItems.add(foodItems),
                      }
                  }
              },

            showLog("searchByDishKeyWord3 -- ${listOfClosedFoodItems.length}"),

            listOfClosedFoodItems.asMap().forEach((key, value) {
              if (!listOfDishData.contains(value)) {
                listOfDishData.add(value);
              }
            }),
            //listOfDishData.addAll(listOfClosedFoodItems),
            //listOfDishData =
            // cartData = value.aCart != null ? value.aCart : null,
            cartQuantityPriceProvider.updateCartQuantity(
              aCart: value.aCart,
              progress: false,
            ),
            message = value.message != null ? value.message : "",
            showLog("searchByDishKeyWord -- ${message}")
          });
      //  setState(BaseViewState.Idle);
    } catch (e) {
      showLog("searchByDishKeyWorderror -- ${e}");
//      cartQuantityPriceProvider.updateCartQuantity(
//          aCart: null, progress: false);
    }

    setState(BaseViewState.Idle);
    notifyListeners();
  }

  saveClickedThroughSearch(String keyWord, String restaurantID, String foodId,
      BuildContext context) async {
    await initPref();
    userId = prefs.getInt(SharedPreferenceKeys.userId) ?? 0;
    try {
      await ApiRepository(mContext: context).saveSearchKeyWordRequest({
        deviceIDKey: deviceId,
        userIdKey: userId.toString(),
        foodIdKey: foodId,
        restaurantIdKey: restaurantID,
        keywordKey: keyWord,
      }, context).then((value) => {
            // move to restaurant detail page.
          });
    } catch (e) {}
  }

  updateSearchDoneOrNot(bool search) {
    isSearching = search;
    notifyListeners();
  }

  bool showClose = false;

  showCloseIcon(bool value) {
    showClose = value;
    notifyListeners();
  }
}
