import 'package:flutter/material.dart';
import 'package:foodstar/src/constants/api_params_keys.dart';
import 'package:foodstar/src/constants/api_urls.dart';
import 'package:foodstar/src/constants/sharedpreference_keys.dart';
import 'package:foodstar/src/core/models/api_models/cart_action_api_model.dart';
import 'package:foodstar/src/core/models/api_models/favorites_restaurant_api_model.dart';
import 'package:foodstar/src/core/models/api_models/food_items_api_model.dart';
import 'package:foodstar/src/core/models/api_models/restaurant_details_api_model.dart';
import 'package:foodstar/src/core/models/db_model/total_pages_model.dart';
import 'package:foodstar/src/core/provider_viewmodels/cart_bill_detail_view_model.dart';
import 'package:foodstar/src/core/provider_viewmodels/cart_quantity_view_model.dart';
import 'package:foodstar/src/core/provider_viewmodels/common/base_change_notifier_model.dart';
import 'package:foodstar/src/core/provider_viewmodels/home_restaurant_list_view_model.dart';
import 'package:foodstar/src/core/service/api_repository.dart';
import 'package:foodstar/src/core/service/app_exception.dart';
import 'package:foodstar/src/core/service/database/database_helper.dart';
import 'package:foodstar/src/core/service/hive_database/hive_constants.dart';
import 'package:foodstar/src/utils/network_aware/connectivity_service.dart';
import 'package:foodstar/src/utils/target_platform.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RestaurantDetailsViewModel extends BaseChangeNotifierModel {
  BuildContext context;
  int restaurantId;
  String city = "";
  ScrollController restaurantMenuScrollView = ScrollController();
  ScrollController restaurantDetailsScrollListener = ScrollController();
  PaginationState _paginationState = PaginationState.loading;
  SharedPreferences prefs;
  List<ACateory> searchCategory = [];
  DBHelper dbHelper;
  String lat = "";
  String long = "";
  var deviceId;
  int totalPages = 0;
  int mainCatID = 0;
  int foodCount = 0;
  int currentPageNumber = 0;
  bool showIcon = false;
  double scale = 1.0;
  double top = 0.0;
  String accessToken;
  int userId;
  TotalPagesModel totalPagesModel;
  int foodPrice = 0;
  int cartItemQuantity = 1;
  RestaurantData restaurantData;
  List<CommonCatFoodItem> catFoodItemsData = [];
  List<ACommonFoodItem> aFoodItems = [];
  CartQuantityPrice cartData;
  bool cartItemChanged = false;
  double offset = 0.0;
  CartQuantityViewModel cartQuantityPriceProvider;
  CartBillDetailViewModel cartBillDetailViewModel;
  Box favouritesBox;
  List<ARestaurant> aRestaurantData;
  bool isFavouritesBoxExists;

  // HomeRestaurantListApiModel restaurantListApiModelBoxData;
  // RestaurantDetailsApiModel restaurantDetailModelBoxData;

  // Box restaurantDetailsBox;

  //RestSearchCartFoodItemViewModel restSearchCartFoodViewModel;

  int previousScreen;
  bool initCall;
  String currencySymbol;
  int cartQuantity;
  ConnectivityStatus network;

  RestaurantDetailsViewModel(
      {this.context, this.restaurantId, this.previousScreen, this.initCall}) {
    initDbHelper();
    getLocationLatAndLong();
    checkBoxExistOrNot();

    // listenScrollController();
    //searchCategory = searchCategory;
//    restSearchCartFoodViewModel =
//        Provider.of<RestSearchCartFoodItemViewModel>(context, listen: false);

    cartQuantityPriceProvider =
        Provider.of<CartQuantityViewModel>(context, listen: false);

//    cartBillDetailViewModel =
//        Provider.of<CartBillDetailViewModel>(context, listen: false);

//    if (initCall) {
//      //initRestaurantDetailsApi();
//    }
    //initRestaurantDetailsApi();
    //listenScrollController();

    restaurantDetailsScrollListener = ScrollController()
      ..addListener(() {
        // offset = restaurantDetailsScrollListener.offset;
      });
  }

//  checkNetworkConnectivity(BuildContext mContext) {
//    network = Provider.of<ConnectivityStatus>(mContext, listen: false);
//
//    if (network == ConnectivityStatus.Offline) {
//      showSnackbar(message: 'No Internet connection', context: mContext);
//    }
//  }

  checkBoxExistOrNot() async {
    isFavouritesBoxExists = await Hive.boxExists(favouritesHive);
  }

  initPref() async {
    if (prefs == null) prefs = await SharedPreferences.getInstance();
  }

  initDbHelper() {
    dbHelper = DBHelper.instance;
  }

  getLocationLatAndLong() async {
    await initPref();
    currencySymbol = prefs.getString(SharedPreferenceKeys.currencySymbol) ?? "";
    accessToken = prefs.getString(SharedPreferenceKeys.accessToken) ?? "";
    lat = prefs.getString(SharedPreferenceKeys.latitude) ?? "";
    long = prefs.getString(SharedPreferenceKeys.longitude) ?? "";
    userId = prefs.getInt(SharedPreferenceKeys.userId) ?? 0;
    city = prefs.getString(SharedPreferenceKeys.city) ?? "";
  }

  PaginationState get paginationState => _paginationState;

  initRestaurantDetailsApiRequest({
    String latitude,
    String longitude,
    String cityValue,
    String categoryID,
    String dish,
    int restaurantID,
    int initialPageNumber,
    BuildContext buildContext,
    int fromWhere,
  }) async {
    // await initBox();
    await initPref();

    if (fromWhere == 3 || fromWhere == 1) {
      await prefs.setString(SharedPreferenceKeys.city, cityValue);
    }

    city = prefs.getString(SharedPreferenceKeys.city) ?? "";

    restaurantDetailsScrollListener = ScrollController();

    restaurantDetailsScrollListener.addListener(() => {notifyListeners()});

    await getLocationLatAndLong();
    deviceId = await fetchDeviceId();
    currentPageNumber = 0;
    catFoodItemsData.clear();
    //.. await loadRestDetailsFromDb(restaurantID);

    showLog("CartExitsData--${catFoodItemsData.length}");
    setState(BaseViewState.Busy);
    await callAgainApiAtEndOfPageRequest(
        restaurantID: restaurantID,
        categoryID: categoryID,
        dish: dish,
        city: city,
        initCall: true,
        buildContext: buildContext);

    restaurantDetailsScrollListener.addListener(() async {
      if (restaurantDetailsScrollListener.position.pixels ==
          restaurantDetailsScrollListener.position.maxScrollExtent) {
        await callAgainApiAtEndOfPageRequest(
            restaurantID: restaurantID,
            latitude: lat,
            longitude: long,
            categoryID: categoryID,
            dish: dish,
            initCall: false,
            buildContext: buildContext);
      }
    });

    restaurantDetailsScrollListener.addListener(() async {
      if (restaurantDetailsScrollListener.position.pixels ==
          restaurantDetailsScrollListener.position.minScrollExtent) {
        // currentPageNumber = 0;
        mainCatID = 0;
        foodCount = 0;
        showLog("restaurantDetailsScrollListener");
      }
    });

//    restaurantListApiModelBoxData =
//        await restaurantDetailsBox.get(0) as HomeRestaurantListApiModel;
//    await loadRestDetailsFromDb(restaurantID);
//
//    if (restaurantDetailModelBoxData != null) {
//
//    } else {
//
//    }
  }

  var isFoodItemsLoading = false;

  callAgainApiAtEndOfPageRequest(
      {String latitude = "",
      String longitude = "",
      String categoryID = "",
      String dish = "",
      int restaurantID = 0,
      String city = "",
      bool initCall = true,
      BuildContext buildContext}) async {
    // await initBox();

    showLog("CartExitsData--${restaurantID}");

    //. await loadRestDetailsFromDb(restaurantID);

    await callApiRequest(
        restaurantID: restaurantID,
        latitude: lat,
        longitude: long,
        categoryID: categoryID,
        dish: dish,
        city: city,
        initCall: initCall,
        buildContext: buildContext);

//    if (restaurantDetailModelBoxData != null) {
//      // await loadFoodItemsFromDb();
//      // isFoodItemsLoading = true;
//      if (initCall) {
//        //   isFoodItemsLoading = true;
//        await callApiRequest(
//            restaurantID: restaurantID,
//            latitude: lat,
//            longitude: long,
//            categoryID: categoryID,
//            dish: dish,
//            city: city,
//            initCall: initCall,
//            buildContext: buildContext);
//        // isFoodItemsLoading = false;
//      } else {
//        setPageState(PaginationState.loading);
//        await callApiRequest(
//            restaurantID: restaurantID,
//            latitude: lat,
//            longitude: long,
//            categoryID: categoryID,
//            dish: dish,
//            city: city,
//            initCall: initCall,
//            buildContext: buildContext);
//        setPageState(PaginationState.done);
//        // isFoodItemsLoading = false;
//      }
//    } else {
//      //isFoodItemsLoading = true;
//      setState(BaseViewState.Busy);
//      await callApiRequest(
//          restaurantID: restaurantID,
//          latitude: lat,
//          longitude: long,
//          categoryID: categoryID,
//          dish: dish,
//          city: city,
//          initCall: initCall,
//          buildContext: buildContext);
//      setState(BaseViewState.Idle);
//      //isFoodItemsLoading = false;
//    }
  }

  setFoodAvailability({int index, int parentIndex}) {
    catFoodItemsData[parentIndex].aFoodItems[index].availability.status = 0;
    notifyListeners();
  }

  notAvailable({int index, int parentIndex}) {
    catFoodItemsData[parentIndex].aFoodItems[index].cartDetail.quantity = 0;
    catFoodItemsData[parentIndex].aFoodItems[index].availability.status = 0;
    notifyListeners();
  }

  setRestaurantAvailability({int index, int parentIndex}) {
    for (var catFoodItems in catFoodItemsData) {
      for (var foodItems in catFoodItems.aFoodItems) {
        foodItems.availability.status = 0;
      }
    }
    notifyListeners();
  }

  updateData(RestaurantDetailsApiModel value) async {
    restaurantData = value.restaurant;

//    restaurantDetailModelBoxData.catFoodItems =
//        restaurantDetailModelBoxData.catFoodItems;

    catFoodItemsData = value.catFoodItems;

    //showLog("loadFoodItemsFromDb2--${catFoodItemsData.length}");
//      mainCatID = catFoodItemsData.length != 0
//          ? restaurantDetailModelBoxData
//              .catFoodItems[
//                  restaurantDetailModelBoxData.catFoodItems.length - 1]
//              .mainCat
//          : 0;

    mainCatID = catFoodItemsData.length != 0
        ? catFoodItemsData[catFoodItemsData.length - 1].mainCat
        : 0;
    foodCount = catFoodItemsData.length != 0
        ? catFoodItemsData[catFoodItemsData.length - 1].foodcount
        : 0;
//      foodCount = restaurantDetailModelBoxData.catFoodItems.length != 0
//          ? restaurantDetailModelBoxData
//              .catFoodItems[
//                  restaurantDetailModelBoxData.catFoodItems.length - 1]
//              .foodcount
//          : 0;
    searchCategory = value.aCateory;
    totalPages = value.totalPages;

    notifyListeners();
  }

//  Future<void> loadRestDetailsFromDb(int restaurantID) async {
//    // await initBox();
//
//    restaurantListApiModelBoxData =
//        await restaurantDetailsBox.get(0) as HomeRestaurantListApiModel;
//    if (restaurantListApiModelBoxData != null) {
//      restaurantListApiModelBoxData.restaurant.asMap().forEach((key, value) {
//        showLog(
//            "restaurantListApiModelBoxDatarestaID--${restaurantID} --${value.id}");
//
//        if (value.id == restaurantID) {
//          showLog("restaID--${restaurantID} --${value.id}");
//          restaurantDetailModelBoxData =
//              restaurantListApiModelBoxData.restaurant[key].restaurantDetails;
//        } else {
//          // no need to add
//          showLog("restaIDelse--${restaurantID}");
//        }
//      });
//    }
//
//    notifyListeners();
//    loadFoodItemsFromDb(restID: restaurantID);
//
//    setState(BaseViewState.Idle);
//  }

  Future updateCartActionFromDb() async {
//    if (restaurantDetailModelBoxData != null) {
//      restaurantData = restaurantDetailModelBoxData.restaurant;
//      catFoodItemsData = restaurantDetailModelBoxData.catFoodItems;
//    }

    restaurantData = restaurantData;
    catFoodItemsData = catFoodItemsData;

    notifyListeners();
  }

//  Future loadFoodItemsFromDb({int restID}) async {
//    //await loadRestDetailsFromDb(restID);
//    restaurantListApiModelBoxData =
//        await restaurantDetailsBox.get(0) as HomeRestaurantListApiModel;
//    if (restaurantDetailModelBoxData != null) {
//      showLog("restaurantDetailModelBoxData--fjdskf");
//
//      restaurantDetailModelBoxData.catFoodItems
//          .asMap()
//          .forEach((parent, value) {
//        restaurantDetailModelBoxData.catFoodItems[parent].aFoodItems =
//            value.aFoodItems;
//
//        value.aFoodItems.asMap().forEach((key, value) {
//          showLog(
//              "CataaaaaDataaa--${restID}--${restaurantDetailModelBoxData.catFoodItems[parent].aFoodItems[key].foodItem}");
//        });
//      });
//
//      restaurantData = restaurantDetailModelBoxData.restaurant;
//
//      restaurantDetailModelBoxData.catFoodItems =
//          restaurantDetailModelBoxData.catFoodItems;
//
//      catFoodItemsData = restaurantDetailModelBoxData.catFoodItems;
//
//      //showLog("loadFoodItemsFromDb2--${catFoodItemsData.length}");
////      mainCatID = catFoodItemsData.length != 0
////          ? restaurantDetailModelBoxData
////              .catFoodItems[
////                  restaurantDetailModelBoxData.catFoodItems.length - 1]
////              .mainCat
////          : 0;
//
//      mainCatID = catFoodItemsData.length != 0
//          ? catFoodItemsData[catFoodItemsData.length - 1].mainCat
//          : 0;
//      foodCount = catFoodItemsData.length != 0
//          ? catFoodItemsData[catFoodItemsData.length - 1].foodcount
//          : 0;
////      foodCount = restaurantDetailModelBoxData.catFoodItems.length != 0
////          ? restaurantDetailModelBoxData
////              .catFoodItems[
////                  restaurantDetailModelBoxData.catFoodItems.length - 1]
////              .foodcount
////          : 0;
//      searchCategory = restaurantDetailModelBoxData.aCateory;
//      totalPages = restaurantDetailModelBoxData.totalPages;
////      cartQuantityPriceProvider.updateCartQuantity(
////          aCart: restaurantDetailModelBoxData.aCart, progress: false);
//    } else {
//      showLog("restaurantDetailModelBoxData--fjdskfelseee");
//    }
//
//    notifyListeners();
//
//    //have to add acart
//  }
//
//  initBox() async {
//    try {
//      if (restaurantDetailsBox == null || !restaurantDetailsBox.isOpen) {
//        showLog("initBox --");
//        restaurantDetailsBox =
//            await Hive.openBox<dynamic>(homeRestaurantListHive);
//      } else {
//        if (restaurantDetailsBox != null && restaurantDetailsBox.isOpen) {
//          showLog("initBox2 --");
//
//          restaurantDetailsBox = Hive.box<dynamic>(homeRestaurantListHive);
//        } else {
////          showLog("initBox3 --");
////          restaurantDetailsBox = await Hive.openBox<HomeRestaurantListApiModel>(
////              homeRestaurantListHive);
//        }
//      }
//    } catch (e) {
//      showLog("initBox24 --");
//      restaurantDetailsBox =
//          await Hive.openBox<dynamic>(homeRestaurantListHive);
//    }
//  }

  Future addRestaurantDetails(
      {RestaurantDetailsApiModel data, int restaurantID}) async {
//    restaurantListApiModelBoxData =
//        await restaurantDetailsBox.get(0) as HomeRestaurantListApiModel;
    //.  await loadRestDetailsFromDb(restaurantID);
    showLog("initState2 --");

    for (var newCatData in data.catFoodItems) {
      showLog("${newCatData.continution} ----");
      if (newCatData.continution == 1) {
        //   showLog("${newCatData.continution} --${restaurantDetailModelBoxData}");
//        restaurantDetailModelBoxData
//            .catFoodItems[restaurantDetailModelBoxData.catFoodItems.length - 1]
//            .aFoodItems
//            .addAll(newCatData.aFoodItems);
        catFoodItemsData[catFoodItemsData.length - 1]
            .aFoodItems
            .addAll(newCatData.aFoodItems);
      } else {
        //add in catfood items
        showLog("addRestaurantDetails -${newCatData.restaurantId}-");
        // restaurantDetailModelBoxData.catFoodItems.add(newCatData);
        catFoodItemsData.add(newCatData);
      }

      catFoodItemsData[catFoodItemsData.length - 1].mainCat =
          newCatData.mainCat;

      catFoodItemsData[catFoodItemsData.length - 1].foodcount =
          newCatData.foodcount;
      catFoodItemsData[catFoodItemsData.length - 1].continution =
          newCatData.continution;

//      restaurantDetailModelBoxData
//          .catFoodItems[restaurantDetailModelBoxData.catFoodItems.length - 1]
//          .mainCat = newCatData.mainCat;
//      restaurantDetailModelBoxData
//          .catFoodItems[restaurantDetailModelBoxData.catFoodItems.length - 1]
//          .foodcount = newCatData.foodcount;
//      restaurantDetailModelBoxData
//          .catFoodItems[restaurantDetailModelBoxData.catFoodItems.length - 1]
//          .continution = newCatData.continution;

    }

//    restaurantListApiModelBoxData.restaurant.asMap().forEach((key, value) {
//      if (value.id == restaurantID) {
//        showLog("initState3 ${value.id} --${restaurantID}");
//        restaurantDetailModelBoxData =
//            restaurantListApiModelBoxData.restaurant[key].restaurantDetails;
//        showLog("initState3 ${value.id} --${restaurantID}");
//        for (var newCatData in data.catFoodItems) {
//          showLog("${newCatData.continution} ----");
//          if (newCatData.continution == 1) {
//            showLog(
//                "${newCatData.continution} --${restaurantDetailModelBoxData}");
//            restaurantDetailModelBoxData
//                .catFoodItems[
//                    restaurantDetailModelBoxData.catFoodItems.length - 1]
//                .aFoodItems
//                .addAll(newCatData.aFoodItems);
//          } else {
//            //add in catfood items
//            showLog("addRestaurantDetails -${newCatData.restaurantId}-");
//            restaurantDetailModelBoxData.catFoodItems.add(newCatData);
//          }
//          //newCatData.continution=
//          restaurantDetailModelBoxData
//              .catFoodItems[
//                  restaurantDetailModelBoxData.catFoodItems.length - 1]
//              .mainCat = newCatData.mainCat;
//          restaurantDetailModelBoxData
//              .catFoodItems[
//                  restaurantDetailModelBoxData.catFoodItems.length - 1]
//              .foodcount = newCatData.foodcount;
//          restaurantDetailModelBoxData
//              .catFoodItems[
//                  restaurantDetailModelBoxData.catFoodItems.length - 1]
//              .continution = newCatData.continution;
//        }
//      } else {
//        // no need to add
//
//      }
//    });

    // . loadRestDetailsFromDb(restaurantID);

    notifyListeners();
  }

  updateRestaurantDetails(
      RestaurantDetailsApiModel data, int restaurantID) async {
//    restaurantListApiModelBoxData =
//        await restaurantDetailsBox.get(0) as HomeRestaurantListApiModel;
//    showLog("RestaurantDetailsApiModel --RestaurantDetailsApiModel");
//
//    if (restaurantListApiModelBoxData != null) {
//      restaurantListApiModelBoxData.restaurant.asMap().forEach((key, value) {
//        showLog(
//            "updateRestaurantDetailsrestaurant --${value.id}//$restaurantID");
//
//        if (value.id == restaurantID) {
//          showLog("updateRestaurantDetails --${value.id}//$restaurantID");
////        restaurantListApiModelBoxData
////            .restaurant[key].restaurantDetails.catFoodItems
////            .asMap()
////            .forEach((key, value) {
////          value.aFoodItems.clear();
////        });
//          if (restaurantListApiModelBoxData.restaurant[key].restaurantDetails !=
//              null) {
//            showLog(
//                "updateRestaurantDetails11${restaurantListApiModelBoxData.restaurant[key].restaurantDetails.restaurant.id} --${data.catFoodItems.length}//$restaurantID");
////          restaurantListApiModelBoxData
////              .restaurant[key].restaurantDetails.catFoodItems
////              .clear();
//
////          restaurantListApiModelBoxData
////              .restaurant[key].restaurantDetails.restaurant = data.restaurant;
////          restaurantListApiModelBoxData
////              .restaurant[key].restaurantDetails.aCart = data.aCart;
////          restaurantListApiModelBoxData.restaurant[key].restaurantDetails
////              .catFoodItems = data.catFoodItems;
////          restaurantListApiModelBoxData
////              .restaurant[key].restaurantDetails.totalPages = data.totalPages;
////          restaurantListApiModelBoxData
////              .restaurant[key].restaurantDetails.aCateory = data.aCateory;
//          } else {
//            /*   restaurantListApiModelBoxData.restaurant[key].restaurantDetails =
//              data;*/
////          restaurantListApiModelBoxData
////              .restaurant[key].restaurantDetails.restaurant = data.restaurant;
////          restaurantListApiModelBoxData
////              .restaurant[key].restaurantDetails.aCart = data.aCart;
////          restaurantListApiModelBoxData.restaurant[key].restaurantDetails
////              .catFoodItems = data.catFoodItems;
////          restaurantListApiModelBoxData
////              .restaurant[key].restaurantDetails.totalPages = data.totalPages;
////          restaurantListApiModelBoxData
////              .restaurant[key].restaurantDetails.aCateory = data.aCateory;
////          showLog(
////              "updateRestaurantDetails${restaurantListApiModelBoxData.restaurant[key].restaurantDetails.restaurant.id} --${data.catFoodItems.length}//$restaurantID");
//          }
//          restaurantListApiModelBoxData.restaurant[key].restaurantDetails =
//              data;
////        showLog(
////            'restaurantDetailsBox${restaurantListApiModelBoxData.restaurant[key]}');
////        restaurantDetailsBox.put(
////            '${restaurantListApiModelBoxData.restaurant[key]}', data);
//        } else {
//          // no need to add
//          showLog("updateRestaurantDetailselse --${value.id}//$restaurantID");
//        }
//      });
//    } else {
//      restaurantData = data.restaurant;
//      catFoodItemsData = data.catFoodItems;
//      mainCatID = catFoodItemsData.length != 0
//          ? catFoodItemsData[catFoodItemsData.length - 1].mainCat
//          : 0;
//      foodCount = catFoodItemsData.length != 0
//          ? catFoodItemsData[catFoodItemsData.length - 1].foodcount
//          : 0;
//      searchCategory = data.aCateory;
//      totalPages = data.totalPages;
//    }

    restaurantData = data.restaurant;
    catFoodItemsData = data.catFoodItems;
    mainCatID = catFoodItemsData.length != 0
        ? catFoodItemsData[catFoodItemsData.length - 1].mainCat
        : 0;
    foodCount = catFoodItemsData.length != 0
        ? catFoodItemsData[catFoodItemsData.length - 1].foodcount
        : 0;
    searchCategory = data.aCateory;
    totalPages = data.totalPages;
    notifyListeners();
    // await loadFoodItemsFromDb();
  }

  callApiRequest({
    String latitude = "",
    String longitude = "",
    String categoryID = "",
    String dish = "",
    int restaurantID = 0,
    bool initCall = true,
    String city = "",
    @required BuildContext buildContext,
  }) async {
    if (currentPageNumber <= totalPages) {
      try {
        showLog(
            "callApiRequestForRestaurantDetails 3 ${restaurantID} -- ${dish}");
        await ApiRepository(mContext: context)
            .callApiRequestForRestaurantDetails(staticMapValue: {
          deviceIDKey: deviceId,
          longitudeKey: long,
          latitudeKey: lat,
          restaurantIdKey: restaurantID.toString(),
          cityKey: city,
          mainCategoryIdKey: initCall ? "" : mainCatID.toString(),
          foodCountKey: initCall ? "" : foodCount.toString(),
          categoryIdKey: categoryID ?? "",
          dishKey: dish ?? "",
          userIdKey: userId.toString()
        }, mContext: buildContext).then((value) async => {
                  // await initBox(),
                  if (value != null)
                    {
                      showLog(
                          "callApiRequestForRestaurantDetail4 --${value.aCart}"),
                      if (initCall)
                        {
                          showLog(
                              "callApiRequestForRestaurantDetail4 --${initCall}"),
//
//                          await updateRestaurantDetails(value, restaurantID),
//
//                          await loadRestDetailsFromDb(restaurantID),

                          updateData(value)
                        }
                      else
                        {
                          showLog(
                              "callApiRequestForRestaurantDetail5 --${value.restaurant.id}"),
                          await addRestaurantDetails(
                            data: value,
                            restaurantID: restaurantID,
                          ),
                        },
                      cartQuantityPriceProvider.updateCartQuantity(
                        aCart: value.aCart,
                        progress: false,
                      ),
//                      restaurantData = value.restaurant,
//
//                      catFoodItemsData.addAll(
//                          value.catFoodItems != null ? value.catFoodItems : []),
//                      mainCatID = catFoodItemsData.length != 0
//                          ? catFoodItemsData[catFoodItemsData.length - 1]
//                              .mainCat
//                          : 0,
//                      foodCount = catFoodItemsData.length != 0
//                          ? catFoodItemsData[catFoodItemsData.length - 1]
//                              .foodcount
//                          : 0,

//                  if (catFoodItemsData.length != 0)
//                    {
//                      if (catFoodItemsData[catFoodItemsData.length - 1]
//                              .continution ==
//                          0)
//                        {catFoodItemsData.addAll(value.catFoodItems)}
//                      else
//                        {
//                          aFoodItems.addAll(value
//                              .catFoodItems[catFoodItemsData.length - 1]
//                              .aFoodItems)
//                        }
//                    },
//                      searchCategory.addAll(value.aCateory ?? []),
//                      cartQuantityPriceProvider.updateCartQuantity(
//                        aCart: value.aCart,
//                        progress: false,
//                      ),
//                      //  cartData = value.aCart,
//
//                      totalPages = value.totalPages != null
//                          ? value.totalPages
//                          : totalPages,
//
//                      showLog(
//                          "callApiRequestForRestaurantDetails -- ${mainCatID} -- ${foodCount} --${totalPages}"),
//                      if (value.totalPages != null)
//                        {
//                          totalPagesModel = TotalPagesModel(
//                              id: 2,
//                              url: restaurantList,
//                              totalPages: totalPages),
//                          showLog(
//                              "totalPagesModel-- ${totalPagesModel.totalPages}"),
//                          await dbHelper.insert(
//                            totalPagesModel.toJson(),
//                            DbStatics.tableTotalPages,
//                          )
//                        },
//                      getTotalPages(),
                    },
                });

        currentPageNumber++;
      } catch (e) {
//        cartQuantityPriceProvider.updateCartQuantity(
//          aCart: null,
//          progress: false,
//        );
        showLog("Errrirrrr -- ${e}");
//        Fluttertoast.showToast(
//            msg: "$e",
//            toastLength: Toast.LENGTH_LONG,
//            gravity: ToastGravity.CENTER,
//            timeInSecForIosWeb: 1,
//            backgroundColor: Colors.grey[300],
//            textColor: Colors.black,
//            fontSize: 16.0);
        if (e.toString().startsWith("SocketException: Connection failed")) {
          setPageState(PaginationState.noNetwork);
        } else {
          showLog("${e}");
          setPageState(PaginationState.error);
        }
      }
    } else {
      showLog("noUpdate 5 ${currentPageNumber} -- ${totalPages}");
      setPageState(PaginationState.noUpdate);
    }
    setState(BaseViewState.Idle);
    notifyListeners();
  }

//  initRestaurantDetailsApi(
//      {String latitude,
//      String longitude,
//      String city,
//      String categoryID,
//      String dish,
//      int restaurantID,
//      int initialPageNumber,
//      BuildContext context}) async {
//    showLog("callApiRequestForRestaurantDetails 1 ${restaurantId}");
//
//    restaurantDetailsScrollListener = ScrollController();
//
//    restaurantDetailsScrollListener.addListener(() => {notifyListeners()});
//
//    await getLocationLatAndLong();
//    currentPageNumber = 0;
//    catFoodItemsData.clear();
//    showLog("catFoodItemsData1 ${catFoodItemsData.length}");
//
//    deviceId = await fetchDeviceId();
//    showLog("callApiRequestForRestaurantDetails 2");
//    setState(BaseViewState.Busy);
//    await callAgainApiAtEndOfPage(
//      restaurantID: restaurantID,
//      categoryID: categoryID,
//      dish: dish,
//      initCall: true,
//    );
//
//    restaurantDetailsScrollListener.addListener(() async {
//      if (restaurantDetailsScrollListener.position.pixels ==
//          restaurantDetailsScrollListener.position.maxScrollExtent) {
//        await callAgainApiAtEndOfPage(
//          restaurantID: restaurantID,
//          latitude: lat,
//          longitude: long,
//          categoryID: categoryID,
//          dish: dish,
//          initCall: false,
//        );
//        //  showLog("restaurantDetailsScrollListener");
//      }
//    });
//    // notifyListeners();
//  }

//  removeCartItemsAfterChangeRestaurant() {
//    showLog("outter loop --${catFoodItemsData.length}");
//    for (int outter = 0; outter <= catFoodItemsData.length - 1; outter++) {
//      for (int inner = 0;
//          inner <= catFoodItemsData[outter].aFoodItems.length - 1;
//          inner++) {
//        showLog("inner loop --${catFoodItemsData[outter].aFoodItems.length}");
//        catFoodItemsData[outter].aFoodItems[inner].cartDetail.quantity = 0;
//      }
//    }
//
//    notifyListeners();
//  }

  initAddItem({int index, int parentIndex}) async {
    catFoodItemsData[parentIndex].aFoodItems[index].cartDetail.quantity =
        catFoodItemsData[parentIndex].aFoodItems[index].cartDetail.quantity + 1;

    cartQuantity =
        catFoodItemsData[parentIndex].aFoodItems[index].cartDetail.quantity;
//    restaurantDetailModelBoxData.catFoodItems[parentIndex].aFoodItems[index]
//        .cartDetail.quantity = restaurantDetailModelBoxData
//            .catFoodItems[parentIndex].aFoodItems[index].cartDetail.quantity +
//        1;
//    cartQuantity = restaurantDetailModelBoxData
//        .catFoodItems[parentIndex].aFoodItems[index].cartDetail.quantity;

    await updateCartActionFromDb();

    notifyListeners();
  }

  deleteItem({int index, int parentIndex, int restaurantID}) async {
    //  await loadRestDetailsFromDb(restaurantID);
    catFoodItemsData[parentIndex].aFoodItems[index].cartDetail.quantity = 0;
//    restaurantDetailModelBoxData
//        .catFoodItems[parentIndex].aFoodItems[index].cartDetail.quantity = 0;
    await updateCartActionFromDb();
    notifyListeners();
  }

  Future<bool> deleteRestaurantIfExist(
      {Map<String, dynamic> dynamicMapValue, BuildContext context}) async {
    bool result;
    try {
      await ApiRepository(mContext: context)
          .restDeleteIfAlreadyExits(
              dynamicMapValue: dynamicMapValue, context: context)
          .then((value) => {
                cartQuantityPriceProvider.updateCartQuantity(
                    aCart: value.aCart, progress: false),
                result = true,
              });
    } catch (e) {
      cartQuantityPriceProvider.updateCartQuantity(
        aCart: null,
        progress: false,
      );
      result = null;
    }
    return result;
  }

//  updateFoodItemsDataChangeDoneFromCart() {
//    if (cartBillDetailViewModel.cartOrderedItems.length == 0) {}
//    for (int i = 0;
//        i <= cartBillDetailViewModel.cartOrderedItems.length - 1;
//        i++) {
//      showLog(
//          "updateFoodItemsDataChange ${catFoodItemsData[0].aFoodItems[0].foodItem}");
//      for (int inner = 0; inner <= catFoodItemsData.length - 1; inner++) {
//        for (int inin = 0;
//            inin <= catFoodItemsData[inner].aFoodItems.length - 1;
//            inin++) {
//          showLog(
//              "updateFoodItemsDataChangeDoneFromCart4 ${catFoodItemsData[inner].aFoodItems[inin].id}");
//
//          showLog(
//              "updateFoodItemsDataChangeDoneFromCart5 ${catFoodItemsData[inner].aFoodItems.indexWhere(
//                    (f) => (f.id ==
//                        cartBillDetailViewModel.cartOrderedItems[i].id),
//                  )}");
//
//          if (catFoodItemsData[inner].aFoodItems[inin].id ==
//              cartBillDetailViewModel.cartOrderedItems[i].id) {
//            var indexValue = catFoodItemsData[inner].aFoodItems.indexWhere(
//              (f) {
//                showLog(
//                    "updateFood ${f.id} -- ${cartBillDetailViewModel.cartOrderedItems[i].id}");
//
//                return (f.id == cartBillDetailViewModel.cartOrderedItems[i].id);
//              },
//            );
//
//            catFoodItemsData[inner].aFoodItems[indexValue].cartDetail.quantity =
//                cartBillDetailViewModel.cartOrderedItems[i].cartDetail.quantity;
//            notifyListeners();
//          }
//        }
//      }
//    }
//
////    for (int i = 0;
////        i <= restSearchCartFoodViewModel.foodItems.length - 1;
////        i++) {
////      showLog(
////          "updateFoodItemsDataChange ${catFoodItemsData[0].aFoodItems[0].foodItem}");
////      for (int inner = 0; inner <= catFoodItemsData.length - 1; inner++) {
////        for (int inin = 0;
////            inin <= catFoodItemsData[inner].aFoodItems.length - 1;
////            inin++) {
////          showLog(
////              "updateFoodItemsDataChangeDoneFromCart4 ${catFoodItemsData[inner].aFoodItems[inin].id}");
////          showLog(
////              "updateFoodItemsDataChangeDoneFromCart5 ${catFoodItemsData[inner].aFoodItems.indexWhere(
////                    (f) =>
////                        (f.id == restSearchCartFoodViewModel.foodItems[i].id),
////                  )}");
////          if (catFoodItemsData[inner].aFoodItems[inin].id ==
////              restSearchCartFoodViewModel.foodItems[i].id) {
////            var indexValue = catFoodItemsData[inner].aFoodItems.indexWhere(
////              (f) {
////                showLog(
////                    "updateFood ${f.id} -- ${restSearchCartFoodViewModel.foodItems[i].id}");
////
////                return (f.id == restSearchCartFoodViewModel.foodItems[i].id);
////              },
////            );
////
////            catFoodItemsData[inner].aFoodItems[indexValue].cartDetail.quantity =
////                restSearchCartFoodViewModel.foodItems[i].cartDetail.quantity;
////            notifyListeners();
////          }
////        }
////      }
////    }
//  }

  makeFoodItemUnavailable({int index, int parentIndex}) async {
    catFoodItemsData[parentIndex].aFoodItems[index].cartDetail.quantity = 0;
    notifyListeners();
  }

  refreshScreenAfterFoodOrRestaurantDelete(
      {int index, int parentIndex, String action}) async {
    if (action == restaurantDelete) {
      for (var catItems in catFoodItemsData) {
        for (var foodItems in catItems.aFoodItems) {
          foodItems.cartDetail.quantity = 0;
        }
      }
    } else {
      catFoodItemsData[parentIndex].aFoodItems[index].cartDetail.quantity = 0;
    }

    notifyListeners();
  }

  updateCartExists(int restaurantID) async {
    //restaurantData.cartExist = false;
    showLog("updateCartExists-");
    await initPref();
    prefs.remove(SharedPreferenceKeys.givenAddressForDelivery);
    prefs.remove(SharedPreferenceKeys.deliveryDataSharedPrefKey);
    //  await loadRestDetailsFromDb(restaurantID);
    restaurantData.cartExist = false;
    // restaurantDetailModelBoxData.restaurant.cartExist = false;
//    restaurantListApiModelBoxData.restaurant.asMap().forEach((key, value) {
//      if (value.restaurantDetails.restaurant.id != restaurantID) {
//        showLog(
//            "updateCartExists-${restaurantID} --${value.restaurantDetails.restaurant.id}");
//        value.restaurantDetails.restaurant.cartExist = true;
//      }
//    });
    await updateCartActionFromDb();
    // notifyListeners();
  }

  updateItemNotes({int index, int parentIndex, String itemNotes}) async {
    catFoodItemsData[parentIndex].aFoodItems[index].cartDetail.itemNote =
        itemNotes;

//    restaurantDetailModelBoxData.catFoodItems[parentIndex].aFoodItems[index]
//        .cartDetail.itemNote = itemNotes;

    await updateCartActionFromDb();

    notifyListeners();
  }

  updateCartAfterCancelExistCartRemoveDialog(
      {int index, int parentIndex}) async {
    showLog(
        "updateCartAfterCancelExistCartRemoveDialog ${index} --${parentIndex}");
//    var showPrice =
//        catFoodItemsData[parentIndex].aFoodItems[index].sellingPrice > 0
//            ? catFoodItemsData[parentIndex].aFoodItems[index].sellingPrice
//            : catFoodItemsData[parentIndex].aFoodItems[index].price;
//    catFoodItemsData[parentIndex].aFoodItems[index].showPrice =
//        showPrice.toString();
//    showLog("showPrice ${index} --${parentIndex} ${showPrice}");
//        double.parse(showPrice.toString()).toString();
    catFoodItemsData[parentIndex].aFoodItems[index].cartDetail.quantity = 0;
//    restaurantDetailModelBoxData
//        .catFoodItems[parentIndex].aFoodItems[index].cartDetail.quantity = 0;
    cartQuantity = 0;
    await updateCartActionFromDb();
    notifyListeners();
  }

  addAndRemoveFoodPrice(
      {int index, int parentIndex, bool addOrRemove, int restaurantID}) async {
    await initPref();
    // await loadRestDetailsFromDb(restaurantID);

    var quantity =
        catFoodItemsData[parentIndex].aFoodItems[index].cartDetail.quantity;
//    var quantity = restaurantDetailModelBoxData
//        .catFoodItems[parentIndex].aFoodItems[index].cartDetail.quantity;

    if (addOrRemove) {
      // Add
      catFoodItemsData[parentIndex].aFoodItems[index].cartDetail.quantity =
          quantity + 1;

//      restaurantDetailModelBoxData.catFoodItems[parentIndex].aFoodItems[index]
//          .cartDetail.quantity = quantity + 1;

      cartQuantity =
          catFoodItemsData[parentIndex].aFoodItems[index].cartDetail.quantity;

//      cartQuantity = restaurantDetailModelBoxData
//          .catFoodItems[parentIndex].aFoodItems[index].cartDetail.quantity;
    } else {
      if (quantity > 0) {
        // Remove
        catFoodItemsData[parentIndex].aFoodItems[index].cartDetail.quantity =
            quantity - 1;
        cartQuantity =
            catFoodItemsData[parentIndex].aFoodItems[index].cartDetail.quantity;
//        restaurantDetailModelBoxData.catFoodItems[parentIndex].aFoodItems[index]
//            .cartDetail.quantity = quantity - 1;
//        cartQuantity = restaurantDetailModelBoxData
//            .catFoodItems[parentIndex].aFoodItems[index].cartDetail.quantity;
      }
    }

    await updateCartActionFromDb();

    notifyListeners();
  }

  listenScrollController() {
    final double defaultTopMargin = 200.0 - 4.0;

    //pixels from top where scaling should start

    final double scaleStart = 96.0;
    //pixels from top where scaling should end

    final double scaleEnd = scaleStart / 2;

    double top = defaultTopMargin;

    double scale = 1.0;

    if (restaurantDetailsScrollListener.hasClients) {
      offset = restaurantDetailsScrollListener.offset;
      top -= offset;
      if (offset < defaultTopMargin - scaleStart) {
        //offset small => don't scale down
        showIcon = true;
      } else if (offset < defaultTopMargin - scaleEnd) {
        //offset between scaleStart and scaleEnd => scale down
        showIcon = true;
      } else {
        //offset passed scaleEnd => hide fab
        showIcon = false;
      }
    } else {
      // offset = 0.0;
    }
    // notifyListeners();
  }

  Future<bool> cartActionsRequest(
      {int foodId = 0,
      String action = "",
      BuildContext context,
      int index,
      int resturantId = 0,
      int parentIndex,
      String itemNotes = ""}) async {
    cartItemChanged = true;
    bool cartActionResponse = false;
    cartQuantityPriceProvider.updateProgress(true);
    try {
      deviceId = await fetchDeviceId();
      await ApiRepository(mContext: context).callCartActionRequest(
        dynamicMapValue: {
          deviceIDKey: deviceId,
          userIdKey: userId.toString(),
          restaurantIdKey: resturantId.toString(),
          foodIdKey: foodId.toString(),
          actionKey: action,
          itemNotesKey: itemNotes
        },
        mContext: context,
        fromWhere: 1,
        index: index,
        parentIndex: index,
      ).then((value) => {
            cartActionResponse = true,
            cartItemChanged = false,
            cartQuantityPriceProvider.updateCartQuantity(
              aCart: value.aCart,
              progress: false,
            ),
            // updateRestaurantModel(value.foodItemView, foodId),

//            cartData.totalQuantity = value.aCart.totalQuantity != null
//                ? value.aCart.totalQuantity
//                : null,
//            cartData.totalPrice =
//                value.aCart.totalPrice != null ? value.aCart.totalPrice : null,
            //  showLog("cartActionsRequest ${cartData}"),
          });

      notifyListeners();
      return cartActionResponse;
    } catch (e) {
      //  cartQuantityPriceProvider.updateCartQuantity(progress: false);
      // cartActionResponse = false;
      //  cartItemChanged = false;
      showLog("cartActionsRequest1 -- ${e}");
      return throw BadRequestException(e);
      //showLog("cartActionsRequest -- ${e}");
    }
  }

  updateRestaurantModel(List<ACommonFoodItem> foodItems, int foodID) {
//    showLog(
//        "updateRestaurantModel --${foodItems.length} ${foodItems[0].foodItem}");
    showLog("updateRestaurantModel11 - ");
    for (int cart = 0; cart <= foodItems.length - 1; cart++) {
      for (int outer = 0;
          outer <= cartBillDetailViewModel.cartOrderedItems.length - 1;
          outer++) {
        if (cartBillDetailViewModel.cartOrderedItems[outer].id ==
            foodItems[cart].id) {
          cartBillDetailViewModel.cartOrderedItems[outer].cartDetail.quantity =
              foodItems[cart].cartDetail.quantity;
        }
      }
    }
  }

  wishListRequest({int restaurantId = 0, BuildContext buildContext}) async {
    try {
      await ApiRepository(mContext: context)
          .callWishListRequest(dynamicMapValue: {
        userTypeKey: 'user',
        userIdKey: userId.toString(),
        restaurantIdKey: restaurantId.toString(),
      }, mContext: buildContext).then((value) => {
                showLog("-=-${value.message}"),
                if (value.message == "Added")
                  {
                    showLog("${value.message}"),
                    updateFavoritesIndexInRestDetail(true, restaurantId),
                    // restaurantData.favouriteStatus = true,
                    notifyListeners(),
                    addFavouritesInDb(value),
                  }
                else
                  {
                    updateFavoritesIndexInRestDetail(false, restaurantId),
                    //restaurantData.favouriteStatus = false,
                    notifyListeners(),
                    removeFavouritesInDb(restaurantId),
                  },
              });
    } catch (e) {
      showLog("addFavouritesInDb ${e}");
    }
  }

  updateFavoritesIndexInRestDetail(bool data, int restaurantID) async {
    restaurantData.favouriteStatus = data; //!restaurantData.favouriteStatus;

//    await loadRestDetailsFromDb(restaurantID);
//    restaurantDetailModelBoxData.restaurant.favouriteStatus = data;
//    await loadRestDetailsFromDb(restaurantID);
    notifyListeners();
  }

  removeFavouritesInDb(int restaurantId) async {
    try {
      favouritesBox = Hive.box<ARestaurant>(favouritesHive);
    } catch (e) {
      favouritesBox = await _openBox(favouritesBox, favouritesHive);
    }
    showLog("removeFavouritesInDb -- ${isFavouritesBoxExists}");
//    if (isFavouritesBoxExists) {
//      showLog("removeFavouritesInDb1 -- ${isFavouritesBoxExists}");
//      favouritesBox = Hive.box<ARestaurant>(favouritesHive);
//    } else {
//      showLog("removeFavouritesInDb2 -- ${isFavouritesBoxExists}");
//      favouritesBox = await Hive.openBox<ARestaurant>(favouritesHive);
//    }
    aRestaurantData = favouritesBox.values.toList();
    aRestaurantData.asMap().forEach((index, element) {
      if (element.id == restaurantId) {
        favouritesBox.deleteAt(index);
      }
    });

//    aRestaurantData = favouritesBox.values.toList();
//    aRestaurantData.asMap().forEach((index, element) {
//      if (element.id == restaurantId) {
//        favouritesBox.deleteAt(index);
//      }
//    });

    notifyListeners();
  }

  addFavouritesInDb(FavoritesRestaurantApiModel data) async {
    try {
      favouritesBox = Hive.box<ARestaurant>(favouritesHive);
    } catch (e) {
      favouritesBox = await _openBox(favouritesBox, favouritesHive);
    }
    //favouritesBox ?? await _openBox(favouritesBox, favouritesHive);
//    showLog("addFavouritesInDb -- ${isFavouritesBoxExists}");
//    if (isFavouritesBoxExists) {
//      showLog("addFavouritesInDb1-- ${isFavouritesBoxExists}");
//      await Hive.box<ARestaurant>(favouritesHive).addAll(data.aRestaurant);
//    } else {
//      showLog("addFavouritesInDb2 -- ${isFavouritesBoxExists}");
//      favouritesBox = await Hive.openBox<ARestaurant>(favouritesHive);
//      await favouritesBox.addAll(data.aRestaurant);
//    }
    await favouritesBox.addAll(data.aRestaurant);

    notifyListeners();
  }

  _openBox(Box box, String type) async {
    await Hive.openBox<ARestaurant>(type);
    return Hive.box<ARestaurant>(type);
  }

  buildMapLocation(BuildContext context) {
    listenScrollController();

    //starting fab position
//    if (!restaurantDetailsScrollListener.hasClients) {
//      restaurantDetailsScrollListener = ScrollController()
//        ..addListener(() {
//          // offset = restaurantDetailsScrollListener.offset;
//        });
//    }

    final double defaultTopMargin = MediaQuery.of(context).size.height > 800
        ? MediaQuery.of(context).size.height / 4
        : 200.0 - 4.0;
    //pixels from top where scaling should start

    final double scaleStart = 96.0;
    //pixels from top where scaling should end

    final double scaleEnd = scaleStart / 2;

    top = defaultTopMargin;

    if (restaurantDetailsScrollListener.hasClients) {
      offset = restaurantDetailsScrollListener.offset;
      top -= offset;
      if (offset < defaultTopMargin - scaleStart) {
        //offset small => don't scale down
        scale = 1.0;
      } else if (offset < defaultTopMargin - scaleEnd) {
        //offset between scaleStart and scaleEnd => scale down
        scale = (defaultTopMargin - scaleEnd - offset) / scaleEnd;
      } else {
        //offset passed scaleEnd => hide fab
        scale = 0.0;
      }
    } else {
      // offset = 0.0;
    }
    //notifyListeners();
  }

//  moveToRespectiveIndex(String index, BuildContext context) {
//    restaurantMenuScrollView.jumpTo(20.2);
//  }

  moveToMenuPosition(int index, BuildContext context) {
    final double defaultTopMargin = MediaQuery.of(context).size.height > 800
        ? MediaQuery.of(context).size.height / 4
        : 200.0 - 4.0;

    final double scaleStart = 96.0;
    //pixels from top where scaling should end

    final double scaleEnd = scaleStart / 2;
    double offset;
    double topValue;

    if (restaurantDetailsScrollListener.hasClients) {
      offset = restaurantDetailsScrollListener.offset;
      top += offset;
      topValue = top + offset;

      showLog(
          "restaurantDetailsScrollListenerScroll--topValue-${topValue}--offset-${offset}--top-${top}");

//      restaurantDetailsScrollListener.animateTo(500,
//          duration: new Duration(seconds: 2), curve: Curves.ease);

      restaurantDetailsScrollListener
          .jumpTo(restaurantDetailsScrollListener.position.maxScrollExtent);

//      for (int i = 0; i < catFoodItemsData.length; i++) {
//        restaurantDetailsScrollListener.animateTo(topValue * 200.0,
//            duration: new Duration(seconds: 2), curve: Curves.ease);
//        break;
//      }

//      restaurantDetailsScrollListener.animateTo(top*,
//          duration: new Duration(seconds: 2), curve: Curves.ease);
//      if (offset < defaultTopMargin - scaleStart) {
//        //offset small => don't scale down
//        showIcon = true;
//      } else if (offset < defaultTopMargin - scaleEnd) {
//        //offset between scaleStart and scaleEnd => scale down
//        showIcon = true;
//      } else {
//        //offset passed scaleEnd => hide fab
//        showIcon = false;
//      }

    }

//    for (int i = 0; i < catFoodItemsData.length; i++) {
//      restaurantDetailsScrollListener.animateTo(i * 500.0,
//          duration: new Duration(seconds: 2), curve: Curves.ease);
//      break;
//    }

//    notifyListeners();
  }

//  callApiFromMenuOrSearch({
//    String latitude = "",
//    String longitude = "",
//    String city = "",
//    String categoryID = "",
//    String dish = "",
//  }) async {
//    try {
//      setPageState(PaginationState.loading);
//      showLog("callApiRequestForRestaurantDetails 3 ${restaurantId}");
//      await ApiRepository(mContext: context)
//          .callApiRequestForRestaurantDetails(staticMapValue: {
//        deviceIDKey: deviceId,
//        longitudeKey: lat,
//        latitudeKey: long,
//        restaurantIdKey: restaurantId.toString(),
//        cityKey: city,
//        mainCategoryIdKey: mainCatID.toString(),
//        foodCountKey: foodCount.toString(),
//        categoryIdKey: categoryID ?? "",
//        dishKey: dish ?? ""
//      }).then((value) async => {
//                catFoodItemsData.addAll(value.catFoodItems),
//              });
//      restaurantDetailsScrollListener
//          .jumpTo(restaurantDetailsScrollListener.position.maxScrollExtent);
//      // currentPageNumber++;
//      setPageState(PaginationState.done);
//      //  setState(BaseViewState.Idle);
//    } catch (e) {
//      // setState(BaseViewState.Idle);
//      if (e.toString().startsWith("SocketException: Connection failed")) {
//        setPageState(PaginationState.noNetwork);
//      } else {
//        showLog("${e}");
//        setPageState(PaginationState.error);
//      }
//      setState(BaseViewState.Idle);
//    }
//
//    notifyListeners();
//  }

//  callAgainApiAtEndOfPage({
//    // int restaurantId,
//    String latitude = "",
//    String longitude = "",
//    String categoryID = "",
//    String dish = "",
//    int restaurantID = 0,
//    bool initCall = true,
//  }) async {
//    setPageState(PaginationState.loading);
//
//    showLog("callAgainApiAtEndOfPage11--- ${dish}");
//
//    if (categoryID != null || dish != null) {
//      currentPageNumber = 0;
//    }
//
//    await getTotalPages();
//    showLog(
//        "callApiRequestForRestaurantDetails 5 ${currentPageNumber} -- ${totalPages} -- ${categoryID}");
//
//    if (currentPageNumber <= totalPages) {
//      try {
//        showLog(
//            "callApiRequestForRestaurantDetails 3 ${restaurantId} -- ${dish}");
//        await ApiRepository(mContext: context)
//            .callApiRequestForRestaurantDetails(
//          staticMapValue: {
//            deviceIDKey: deviceId,
//            longitudeKey: long,
//            latitudeKey: lat,
//            restaurantIdKey: restaurantID.toString(),
//            cityKey: city,
//            mainCategoryIdKey: initCall ? "" : mainCatID.toString(),
//            foodCountKey: initCall ? "" : foodCount.toString(),
//            categoryIdKey: categoryID ?? "",
//            dishKey: dish ?? "",
//            userIdKey: userId.toString()
//          },
//        ).then((value) async => {
//                  if (value != null)
//                    {
//                      restaurantData = value.restaurant,
////                      if (initCall)
////                        {
////                          showLog(
////                              "restaurantDataLength-- ${value.catFoodItems.length}"),
////                          catFoodItemsData = value.catFoodItems,
////                        }
////                      else
////                        {
////                          showLog(
////                              "restaurantDataLength2-- ${value.catFoodItems.length}"),
////
////                        },
//                      catFoodItemsData.addAll(
//                          value.catFoodItems != null ? value.catFoodItems : []),
//                      mainCatID = catFoodItemsData.length != 0
//                          ? catFoodItemsData[catFoodItemsData.length - 1]
//                              .mainCat
//                          : 0,
//                      foodCount = catFoodItemsData.length != 0
//                          ? catFoodItemsData[catFoodItemsData.length - 1]
//                              .foodcount
//                          : 0,
//
////                  if (catFoodItemsData.length != 0)
////                    {
////                      if (catFoodItemsData[catFoodItemsData.length - 1]
////                              .continution ==
////                          0)
////                        {catFoodItemsData.addAll(value.catFoodItems)}
////                      else
////                        {
////                          aFoodItems.addAll(value
////                              .catFoodItems[catFoodItemsData.length - 1]
////                              .aFoodItems)
////                        }
////                    },
//                      searchCategory.addAll(value.aCateory ?? []),
//                      cartQuantityPriceProvider.updateCartQuantity(
//                        aCart: value.aCart,
//                        progress: false,
//                      ),
//                      //  cartData = value.aCart,
//
//                      totalPages = value.totalPages != null
//                          ? value.totalPages
//                          : totalPages,
//
//                      showLog(
//                          "callApiRequestForRestaurantDetails -- ${mainCatID} -- ${foodCount} --${totalPages}"),
//                      if (value.totalPages != null)
//                        {
//                          totalPagesModel = TotalPagesModel(
//                              id: 2,
//                              url: restaurantList,
//                              totalPages: totalPages),
//                          showLog(
//                              "totalPagesModel-- ${totalPagesModel.totalPages}"),
//                          await dbHelper.insert(
//                            totalPagesModel.toJson(),
//                            DbStatics.tableTotalPages,
//                          )
//                        },
//                      getTotalPages(),
//                    },
//                });
//
//        currentPageNumber++;
//        setPageState(PaginationState.done);
//        setState(BaseViewState.Idle);
//      } catch (e) {
//        cartQuantityPriceProvider.updateCartQuantity(
//          aCart: null,
//          progress: false,
//        );
//
//        showLog("Errrirrrr -- ${e}");
////        Fluttertoast.showToast(
////            msg: "$e",
////            toastLength: Toast.LENGTH_LONG,
////            gravity: ToastGravity.CENTER,
////            timeInSecForIosWeb: 1,
////            backgroundColor: Colors.grey[300],
////            textColor: Colors.black,
////            fontSize: 16.0);
//
//        setState(BaseViewState.Idle);
//        if (e.toString().startsWith("SocketException: Connection failed")) {
//          setPageState(PaginationState.noNetwork);
//        } else {
//          showLog("${e}");
//          setPageState(PaginationState.error);
//        }
//        setState(BaseViewState.Idle);
//      }
//    } else {
//      showLog("noUpdate 5 ${currentPageNumber} -- ${totalPages}");
//      setPageState(PaginationState.noUpdate);
//      setState(BaseViewState.Idle);
//    }
//    notifyListeners();
//  }

  getTotalPages() async {
    totalPages = await dbHelper.getTotalPagesForUrl(restaurantDetailsUrl);
  }

  void setPageState(PaginationState paginationState) {
    _paginationState = paginationState;
    notifyListeners();
  }

  @override
  void dispose() {
    restaurantDetailsScrollListener.dispose();
    Hive.close();
    super.dispose();
  }
}
