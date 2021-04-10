import 'dart:convert';
import 'dart:core';

import 'package:android_intent/android_intent.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodstar/src/constants/api_params_keys.dart';
import 'package:foodstar/src/constants/api_urls.dart';
import 'package:foodstar/src/constants/sharedpreference_keys.dart';
import 'package:foodstar/src/core/models/api_models/current_order_api_model.dart';
import 'package:foodstar/src/core/models/api_models/home_restaurant_list_api_model.dart';
import 'package:foodstar/src/core/models/db_model/image_db_model.dart';
import 'package:foodstar/src/core/models/db_model/sort_filter_shared_pref_model.dart';
import 'package:foodstar/src/core/models/db_model/total_pages_model.dart';
import 'package:foodstar/src/core/provider_viewmodels/cart_quantity_view_model.dart';
import 'package:foodstar/src/core/provider_viewmodels/common/base_change_notifier_model.dart';
import 'package:foodstar/src/core/service/api_repository.dart';
import 'package:foodstar/src/core/service/database/database_helper.dart';
import 'package:foodstar/src/core/service/hive_database/hive_constants.dart';
import 'package:foodstar/src/utils/target_platform.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

//import 'package:android_intent/android_intent.dart';
//import 'package:flutter/material.dart';
//import 'package:foodstar/src/constants/api_params_keys.dart';
//import 'package:foodstar/src/constants/api_urls.dart';
//import 'package:foodstar/src/constants/sharedpreference_keys.dart';
//import 'package:foodstar/src/core/models/api_models/current_order_api_model.dart';
//import 'package:foodstar/src/core/models/api_models/home_restaurant_list_api_model.dart';
//import 'package:foodstar/src/core/models/db_model/image_db_model.dart';
//import 'package:foodstar/src/core/models/db_model/sort_filter_shared_pref_model.dart';
//import 'package:foodstar/src/core/models/db_model/total_pages_model.dart';
//import 'package:foodstar/src/core/provider_viewmodels/cart_quantity_view_model.dart';
//import 'package:foodstar/src/core/provider_viewmodels/common/base_change_notifier_model.dart';
//import 'package:foodstar/src/core/service/api_repository.dart';
//import 'package:foodstar/src/core/service/database/database_helper.dart';
//import 'package:foodstar/src/core/service/hive_database/hive_constants.dart';
//import 'package:foodstar/src/utils/target_platform.dart';
//
//import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:hive/hive.dart';
//import 'package:permission_handler/permission_handler.dart';
//import 'package:provider/provider.dart';
//import 'package:shared_preferences/shared_preferences.dart';

enum PaginationState { initial, noUpdate, loading, error, noNetwork, done }

class HomeRestaurantListViewModel extends BaseChangeNotifierModel {
  BuildContext context;
  int sortAndFilterParentSelectedIndex = 0;
  PaginationState _paginationState = PaginationState.initial;
  ScrollController restaurantListScrollController = ScrollController();

  //Geolocator geoLocator;

//  final Geolocator geolocator = Geolocator()
//    ..forceAndroidLocationManager = true;

//  final Geolocator geoLocator = Geolocator()
//    ..forceAndroidLocationManager = true;

  SharedPreferences prefs;
  DBHelper dbHelper;
  String latitude = "";
  String longitude = "";
  List<ASlider> bannerViewSliderData = [];
  ASlider bannerImagesData;
  List<Restaurant> closedRestaurants = [];
  List<Restaurant> openRestaurants = [];
  List<Restaurant> listOfRestaurantData = [];
  List<Restaurant> listOfRestaurantForNextPage = [];
  int totalPagesData = 0;
  int demoData = 0;
  int pageNumber = 0;
  List<RestaurantCity> restaurantCitiesData = [];
  List<Images> sliderImages = [];
  String cityValue = "";
  Position currentPosition;
  String currentAddress = "";
  List<AFilter> filter = [];
  List<ACuisines> cusinesList = [];
  AFilter insertFilterMap;
  List<AFilter> filterValuesMap;
  AFilter filterValues;
  bool showFilter = false;
  SortFilterSharedPrefModel storeSortAndFilterMap = SortFilterSharedPrefModel();
  SortFilterSharedPrefModel loadSortAndFilterMap = SortFilterSharedPrefModel();
  int radioGroupValueOne = -1;
  int radioGroupValueTwo = -1;
  int radioGroupValueThree = -1;
  TotalPagesModel totalPagesModel;
  String firstPage = "1";
  String accessToken = "";
  int userId = 0;
  CartQuantityViewModel cartQuantityPriceProvider;
  var deviceId;
  Box homeRestaurantsListBox;
  HomeRestaurantListApiModel homeRestaurantListDataFromBox;
  String addressType = "";

  String currencySymbol = '';

  List<ATrackOrder> trackOrder = [];
  List<ATrackOrder> payOrder = [];
  bool currentOrderLoading = false;
  String isLocationMarked = "";

  //final Geolocator geoLocator = Geolocator();

//  var location = new Location();
  //Map<String, double> userLocation;

  HomeRestaurantListViewModel({this.context, this.firstPage}) {
    initDbHelper();
    // getLocationLatAndLong();
    showLog(
        "storeSortAndFilterMap -- ${firstPage} ${storeSortAndFilterMap.sortBy} -- ${storeSortAndFilterMap.rating} -- ${storeSortAndFilterMap.cuisines}");
    cartQuantityPriceProvider =
        Provider.of<CartQuantityViewModel>(context, listen: false);
    initBox();

    // askLocationPermission();
    //getRestaurantData(firstStatus: firstStatus);
  }

  PaginationState get paginationState => _paginationState;

  void setPageState(PaginationState paginationState) {
    _paginationState = paginationState;
    notifyListeners();
  }

  initBox() async {
    try {
      if (homeRestaurantsListBox == null || !homeRestaurantsListBox.isOpen) {
        showLog("initBox --");
        homeRestaurantsListBox =
            await Hive.openBox<dynamic>(homeRestaurantListHive);
      } else {
        if (homeRestaurantsListBox != null && homeRestaurantsListBox.isOpen) {
          showLog("initBox2 --");

          homeRestaurantsListBox = Hive.box<dynamic>(homeRestaurantListHive);
        } else {
          showLog("initBox3 --");
          homeRestaurantsListBox =
              await Hive.openBox<dynamic>(homeRestaurantListHive);
        }
      }
    } catch (e) {
      showLog("initBox24 --");
      homeRestaurantsListBox =
          await Hive.openBox<dynamic>(homeRestaurantListHive);
    }
  }

  currentTrackOrderApiRequest(BuildContext mContext) async {
    await initPref();
    accessToken = prefs.getString(SharedPreferenceKeys.accessToken) ?? "";
    if (accessToken.isNotEmpty) {
      showLog("HomeRestaurantListViewModel-accessToken11--${accessToken}");
      try {
        await ApiRepository(mContext: context)
            .currentOrdersApiRequest(mContext)
            .then((value) => {
                  if (value != null)
                    {
                      trackOrder = value.aTrackOrder,
                      payOrder = value.aPayOrder,
                      currentOrderLoading = true,
                    }
                });
      } catch (e) {
        showLog("currentTrackOrderApiRequest--${e}");
      }
    } else {
      showLog("currentTrackOrderApiRequest1--${accessToken}");
    }
    notifyListeners();
  }

  updateIndex(int index) {
    sortAndFilterParentSelectedIndex = index;
    notifyListeners();
  }

  showSortFilter(bool mShowFilter) {
    showFilter = mShowFilter;
    notifyListeners();
  }

  initDbHelper() {
    dbHelper = DBHelper.instance;
  }

  updateLocationDependsOnUserChanged(
      {String lat, String lang, String currentAddressData}) async {
    await initPref();
    showLog(
        "updateLocationDependsOnUserChanged $lat --$lang --$currentAddressData");
    prefs.setString(SharedPreferenceKeys.latitude, lat);
    prefs.setString(SharedPreferenceKeys.longitude, lang);
    prefs.setString(
        SharedPreferenceKeys.currentLocationMarked, currentAddressData);

//    latitude = prefs.getString(SharedPreferenceKeys.latitude) ?? "";
//    longitude = prefs.getString(SharedPreferenceKeys.longitude) ?? "";
//    currentAddress =
//        prefs.getString(SharedPreferenceKeys.currentLocationMarked) ?? "";

    await getLocationLatAndLong();

    notifyListeners();
  }

  @override
  void dispose() {
    homeRestaurantsListBox.close();
    restaurantListScrollController.dispose();
    super.dispose();
  }

  getSortFilterFromPref() async {
    await initPref();
    loadSortAndFilterMap = SortFilterSharedPrefModel.fromJson(
      await json.decode(prefs.getString(filterKey) ?? ""),
    );

    showLog(
        "loadSortAndFilterMap --$sortAndFilterParentSelectedIndex -- ${loadSortAndFilterMap.sortBy} --${loadSortAndFilterMap.rating} --${loadSortAndFilterMap.cuisines}");

    notifyListeners();
  }

  updateRadioGroupValueOne(int value) {
    radioGroupValueOne = value ?? 0;
    notifyListeners();
  }

  updateRadioGroupValueTwo(int value) {
    radioGroupValueTwo = value ?? 0;
    notifyListeners();
  }

  updateRadioGroupValueThree(int value) {
    showLog("updateRadioGroupValueThree--${value}");
    radioGroupValueThree = value ?? 0;
    notifyListeners();
  }

  updateSortAndFilterMap(
      {String sortBy, String rating, String cuisines}) async {
    await initPref();
    storeSortAndFilterMap.sortBy = sortBy;
    storeSortAndFilterMap.rating = rating;
    storeSortAndFilterMap.cuisines = cuisines;
    showLog("storeSortAndFilterMap11 -- ${sortBy} --${rating} -- ${cuisines}");

    showLog(
        "storeSortAndFilterMap -- ${storeSortAndFilterMap.sortBy} --${storeSortAndFilterMap.rating} -- ${storeSortAndFilterMap.cuisines}");
    prefs.setString(
      filterKey,
      json.encode(storeSortAndFilterMap),
    );

    getSortFilterFromPref();
    notifyListeners();
  }

  initPref() async {
    if (prefs == null) prefs = await SharedPreferences.getInstance();
  }

  removeLocationData() async {
    await initPref();
    prefs.remove(SharedPreferenceKeys.currentLocationMarked);
  }

  getAccessToken() async {
    await initPref();

    accessToken = prefs.getString(SharedPreferenceKeys.accessToken) ?? "";
    notifyListeners();
  }

  getLocationLatAndLong() async {
    await initPref();
    await initBox();
    accessToken = prefs.getString(SharedPreferenceKeys.accessToken) ?? "";
    latitude = prefs.getString(SharedPreferenceKeys.latitude) ?? "";
    longitude = prefs.getString(SharedPreferenceKeys.longitude) ?? "";
    currentAddress =
        prefs.getString(SharedPreferenceKeys.currentLocationMarked) ?? "";

    if (currentAddress.isEmpty) {
      currentAddress =
          prefs.getString(SharedPreferenceKeys.currentLocationMarked) ?? "";
    }

    addressType = prefs.getString(SharedPreferenceKeys.addressType) ?? "";
    userId = prefs.getInt(SharedPreferenceKeys.userId) ?? 0;
    cityValue = prefs.getString(SharedPreferenceKeys.city) ?? "";
    currencySymbol = prefs.getString(SharedPreferenceKeys.currencySymbol) ?? "";
    await loadRestaurantsListFromBox();
    notifyListeners();

    //  await getLocation(firstStatus: "1");

    showLog(
        "updateLocationDependsOnUserChanged11 $latitude --$longitude --$currentAddress");
  }

  storeCityValue(String city) async {
    await initPref();
    await prefs.setString(SharedPreferenceKeys.city, city);
    cityValue = prefs.getString(SharedPreferenceKeys.city) ?? "";
  }

  updateDbValuesAfterChangeLocation() async {
    await initBox();
    await homeRestaurantsListBox.clear();
    showLog("updateDbValuesAfterChangeLocation/");

    notifyListeners();
  }

  int categoriesIndex = 0;
  bool isAllClicked = true;

  updateCategoriesIndex(dynamic index) {
    categoriesIndex = index;
    //notifyListeners();
  }

  isAllMenuSelectedOrNot(bool value) {
    isAllClicked = value;
    notifyListeners();
  }

  getRestaurantDataApiRequest(
      {String firstStatus = "1",
      String city = "",
      bool showProgress = false,
      bool fromFilter = false,
      String latitude,
      String longitude,
      String cusines,
      BuildContext buildContext}) async {
    // await initBox();
    await initPref();
    await getLocationLatAndLong();
    deviceId = await fetchDeviceId();
    //await prefs.setString(SharedPreferenceKeys.city, city);
    cityValue = prefs.getString(SharedPreferenceKeys.city) ?? "";
    pageNumber = 0;
    showLog("fromFilter1--${fromFilter}");
    await this.callHomeRestaurantsListRequest(
      firstStatus: firstStatus,
      firstInit: true,
      city: city,
      fromFilter: fromFilter,
      context: buildContext,
      cusines: cusines,
      showProgress: showProgress,
    );

    restaurantListScrollController.addListener(() async {
      if (restaurantListScrollController.position.pixels ==
          restaurantListScrollController.position.maxScrollExtent) {
        showLog("restaurantListScrollController --}");

        await callHomeRestaurantsListRequest(
          firstStatus: "0",
          city: city,
          firstInit: false,
          context: buildContext,
          fromFilter: fromFilter,
          cusines: cusines,
          showProgress: showProgress,
        );
      }
    });

    restaurantListScrollController.addListener(() async {
      if (restaurantListScrollController.position.pixels ==
          restaurantListScrollController.position.minScrollExtent) {
        showLog("restaurantListScrollController --}");
        pageNumber = 0;
        await callHomeRestaurantsListRequest(
          firstStatus: "0",
          city: city,
          firstInit: false,
        );
      }
    });
  }

//  getRestaurantData(
//      {String firstStatus = "1",
//      String city = "",
//      bool noRestaurant,
//      bool fromFilter = false}) async {
//    await initPref();
//    await getLocationLatAndLong();
//    await prefs.setString(SharedPreferenceKeys.city, city);
//    showLog(
//        "getRestaurantDatalatitudefilter ${firstStatus} ${latitude} -- ${longitude} -- ${currentAddress}-- ${city} -- ${bannerViewSliderData.length}");
//    getImagesFromTable().then((value) => {bannerViewSliderData = value});
//    notifyListeners();
//    pageNumber = 0;
//    listOfRestaurantData.clear();
//    setState(BaseViewState.Busy);
//
//    cityValue = prefs.getString(SharedPreferenceKeys.city) ?? "";
//
//    await this.callInitialPageRestaurantList(
//        firstStatus: firstStatus,
//        firstInit: true,
//        city: city,
//        fromFilter: fromFilter);
//
//    restaurantListScrollController.addListener(() async {
//      if (restaurantListScrollController.position.pixels ==
//          restaurantListScrollController.position.maxScrollExtent) {
//        showLog("restaurantListScrollController --}");
//
//        await callInitialPageRestaurantList(
//          firstStatus: "0",
//          city: city,
//        );
//      }
//    });
//  }

  clearAllFilters() {
    radioGroupValueTwo = 0;
    radioGroupValueOne = 0;
    radioGroupValueThree = 0;
//    prefs.remove(filterKey);
    getSortFilterFromPref();
    notifyListeners();
  }

  storeFilterDataFromApi(List<AFilter> filterData) async {
    await initPref();
    showLog("storeFilterDataFromApi ${filterData.length}");
    prefs.setString(
      filterResponseFromApi,
      json.encode(filterData),
    );
    // getFilterDataFromSharedPref();
  }

  getFilterDataFromSharedPref() async {
    await initPref();
    showLog(
        "getFilterDataFromSharedPref ${prefs.getString(filterResponseFromApi)}");
//    List<dynamic> filterData =
//        json.decode(prefs.getString(filterResponseFromApi)) ?? [];
//    showLog("getFilterDataFromSharedPrefdecode  ${filterData.length}");
//    List<AFilter> filData = [];
    // filter = filterData;
    //var fil=json.encode(prefs.getString(filterResponseFromApi));

//    List.generate(fil.length, (i) {
//      showLog("getFilterDataFromSharedPref1 ${filData[i].filterValues}");
//      filData.add(
//        AFilter(
//          filterName: fil[i]['filterName'],
//          filterValues: fil[i]['filterValues'],
//        ),
//      );
//    });
    //
//    for (int i = 0; i <= filterData.length - 1; i++) {
//      filData.add(
//        AFilter(
//          filterName: filterData[i].filterName,
//          filterValues: filterData[i].filterValues,
//        ),
//      );
//    }
  }

//  wishListRequest({int restaurantId = 0,BuildContext context}) async {
//    try {
//      await ApiRepository(mContext: context)
//          .callWishListRequest(mContext: ,dynamicMapValue: {
//        userTypeKey: 'user',
//        userIdKey: userId.toString(),
//        restaurantIdKey: restaurantId.toString(),
//
//      });
//    } catch (e) {}
//  }

  updateFavoritesIndex(int index) {
    listOfRestaurantData[index].favouriteStatus =
        !listOfRestaurantData[index].favouriteStatus;
    notifyListeners();
  }

//2  initLocationPermission({String firstStatus}) async {
//    await Permission.locationWhenInUse.status
//        .then((value) => {updateStatus(value, firstStatus)});
//
////    await Provider.of<HomeRestaurantListViewModel>(context, listen: false)
////        .askLocationPermission();
//  }

//  updateStatus(PermissionStatus value, String firstStatus) async {
//    print(" updateStatus --$value");
//    await getLocationLatAndLong();
//
//    if (value == PermissionStatus.granted) {
//      if (currentAddress.isEmpty) {
//        print(
//            "checkGeolocationPermissionStatus 1 ${currentAddress} -- ${latitude} -- ${longitude} ");
//        await getCurrentLocation(firstStatus: firstStatus);
//      } else {
//        print(
//            "checkGeolocationPermissionStatus 2 ${currentAddress} -- ${latitude} -- ${longitude} ");
//        //  getRestaurantData(firstStatus: firstStatus);
//        getRestaurantDataApiRequest(firstStatus: firstStatus);
//      }
//      print("checkGeolocationPermissionStatus ");
//    } else if (value == PermissionStatus.denied) {
//      if (await Permission.locationWhenInUse.isPermanentlyDenied) {
//        // The user opted to never again see the permission request dialog for this
//        // app. The only way to change the permission's status now is to let the
//        // user manually enable it in the system settings.
//        openAppSettings();
//      } else {
//        SystemChannels.platform.invokeMethod('SystemNavigator.pop');
//      }
//    }
//    setState(BaseViewState.Idle);
//  }

//1  askLocationPermission({String firstStatus}) async {
//    geoLocator = Geolocator()..forceAndroidLocationManager = true;
//
//    await [Permission.locationWhenInUse].request().then((value) => {
//          setState(BaseViewState.Busy),
//          print(" askLocationPermission -- $value"),
//          initLocationPermission(firstStatus: firstStatus),
//        });
//
//    if (await Permission.locationWhenInUse.isPermanentlyDenied) {
//      // The user opted to never again see the permission request dialog for this
//      // app. The only way to change the permission's status now is to let the
//      // user manually enable it in the system settings.
//      openAppSettings();
//    }
//  }

//  Future getCurrentLocation({String firstStatus}) async {
//    await initPref();
//    await getLocationLatAndLong();
//    try {
//      GeolocationStatus geolocationStatus =
//          await geoLocator.checkGeolocationPermissionStatus();
//
//      print("--${await geoLocator.checkGeolocationPermissionStatus()} ");
//
//      if (geolocationStatus == GeolocationStatus.granted && latitude.isEmpty) {
//        print("getCurrentLocation1");
//        await geoLocator
//            .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
//            .then((Position position) async {
//          currentPosition = position;
//          print(
//              "getCurrentLocation1 -- ${currentPosition.latitude} --${currentPosition.longitude}");
//          prefs.setString(SharedPreferenceKeys.latitude,
//              currentPosition.latitude.toString());
//          prefs.setString(SharedPreferenceKeys.longitude,
//              currentPosition.longitude.toString());
//
//          latitude = prefs.getString(SharedPreferenceKeys.latitude) ?? "";
//          longitude = prefs.getString(SharedPreferenceKeys.longitude) ?? "";
//
//          // _getAddressFromLatLng();
//          //  getRestaurantData(firstStatus: firstStatus);
//          getRestaurantDataApiRequest(firstStatus: firstStatus);
//        }).catchError((err) {
//          print("Error $err");
//        });
//      } else {
//        print("getCurrentLocation2");
//        //getRestaurantData(firstStatus: firstStatus);
//        getRestaurantDataApiRequest(firstStatus: firstStatus);
//      }
//    } catch (e) {}
//  }

  bool _serviceEnabled;

//  PermissionStatus _permissionGranted;
//  LocationData _locationData;

  static LatLng latLng;

  // var geolocator = Geolocator();

  Future<void> getLocation(
      {String firstStatus, BuildContext buildContext, String cusines}) async {
    await initPref();
    await getLocationLatAndLong();

    bool isServiceEnabled = await isLocationServiceEnabled();
    //await initBox();

    if (isServiceEnabled) {
      LocationPermission permission = await checkPermission();

      if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        showLog("LocationPermission.always--${permission}");
        await getLatitudeAndLongitude(
            firstStatus: firstStatus,
            buildContext: buildContext,
            cusines: cusines);
      } else if (permission == LocationPermission.denied) {
        showLog("LocationPermission.denied--${permission}");
        await requestPermission();
        await getLatitudeAndLongitude(
            firstStatus: firstStatus,
            buildContext: buildContext,
            cusines: cusines);
      } else if (permission == LocationPermission.deniedForever) {
        showLog("LocationPermission.deniedForever--${permission}");
        await openAppSettingsIfPermissionDenied();
      } else {
        showLog("LocationPermission.Else--${permission}");
      }

//      switch (permission) {
//        case LocationPermission.denied:
//          showLog("LocationPermission.denied--${permission}");
//          await openAppSettingsIfPermissionDenied();
//          break;
//        case LocationPermission.deniedForever:
//          showLog("LocationPermission.denied--${permission}");
//          await openAppSettingsIfPermissionDenied();
//          break;
//        case LocationPermission.always:
//          showLog("LocationPermission.denied--${permission}");
////        await Geolocator()
////            .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
////            .then((Position _position) {
////          if (_position != null) {
////            setState(() {
////              latLng = LatLng(
////                _position.latitude,
////                _position.longitude,
////              );
////            });
////            _getAddressFromLatLng();
////          }
////        });
//          await getLatitudeAndLongitude(
//              firstStatus: firstStatus,
//              buildContext: buildContext,
//              cusines: cusines);
//          break;
//        case LocationPermission.whileInUse:
//          showLog("LocationPermission.denied--${permission}");
//          await getLatitudeAndLongitude(
//              firstStatus: firstStatus,
//              buildContext: buildContext,
//              cusines: cusines);
//          break;
//        default:
//          break;
//      }
    } else {
      await _gpsService(context: buildContext);
    }
//
//    PermissionStatus permission = await PermissionHandler()
//        .checkPermissionStatus(PermissionGroup.location);
//
//    print('getLocation1');
//    if (permission == PermissionStatus.denied) {
//      print('getLocationDenied');
//      await PermissionHandler().requestPermissions([
//        PermissionGroup.location,
//        PermissionGroup.locationAlways,
//      ]);
//      // .requestPermissions([PermissionGroup.locationAlways]);
//      // openAppSettings();
//    }
//
//    print('getLocation2--${latitude}// ${longitude}');
//
//    print('getLocation4');
//    GeolocationStatus geolocationStatus =
//        await geolocator.checkGeolocationPermissionStatus();
//    //await geoLocator.checkGeolocationPermissionStatus();
//    print('getLocationStatus--${geolocationStatus}');
//
//    switch (geolocationStatus) {
//      case GeolocationStatus.denied:
//        print('denied');
//        break;
//      case GeolocationStatus.disabled:
//      case GeolocationStatus.restricted:
//        print('restricted');
//        break;
//      case GeolocationStatus.unknown:
//        print('unknown');
//        break;
//      case GeolocationStatus.granted:
//        // PermissionHandler().openAppSettings();
////        if (latitude != "") {
////          print('getLocation3');
////          getRestaurantDataApiRequest(firstStatus: firstStatus);
////        }
//        print('granted--${latitude}--${longitude}');
////        await Geolocator()
////            .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
////            .then((Position _position) {
////          if (_position != null) {
////            latLng = LatLng(
////              _position.latitude,
////              _position.longitude,
////            );
////
////            prefs.setString(
////                SharedPreferenceKeys.latitude, latLng.latitude.toString());
////            prefs.setString(
////                SharedPreferenceKeys.longitude, latLng.longitude.toString());
////
//////            latitude = prefs.getString(SharedPreferenceKeys.latitude) ?? "";
//////            longitude = prefs.getString(SharedPreferenceKeys.longitude) ?? "";
////
////            latitude = latLng.latitude.toString();
////            longitude = latLng.longitude.toString();
////            showLog("latLng --${latLng} --");
////
////            _getAddressFromLatLng();
////
////            getRestaurantDataApiRequest(
////                firstStatus: firstStatus,
////                buildContext: buildContext,
////                cusines: cusines);
////          }
////        });
//        await initPref();
//        isLocationMarked =
//            prefs.getString(SharedPreferenceKeys.currentLocationMarked) ?? "";
//        showLog("currentLocationMarked--${isLocationMarked}");
//
//        // await Geolocator()
//        await geolocator
//            .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
//            .then((Position _position) {
//          if (_position != null) {
//            latLng = LatLng(
//              _position.latitude,
//              _position.longitude,
//            );
//
//            latitude = prefs.getString(SharedPreferenceKeys.latitude) ?? "";
//            longitude = prefs.getString(SharedPreferenceKeys.longitude) ?? "";
//            showLog('latitudelatitude--${latitude} -//-${longitude}');
//            if (latitude.isNotEmpty && longitude.isNotEmpty) {
//              latitude = prefs.getString(SharedPreferenceKeys.latitude) ?? "";
//              longitude = prefs.getString(SharedPreferenceKeys.longitude) ?? "";
//            } else {
//              prefs.setString(
//                  SharedPreferenceKeys.latitude, latLng.latitude.toString());
//              prefs.setString(
//                  SharedPreferenceKeys.longitude, latLng.longitude.toString());
//
//              latitude = latLng.latitude.toString();
//              longitude = latLng.longitude.toString();
//            }
//
////            latitude = prefs.getString(SharedPreferenceKeys.latitude) ?? "";
////            longitude = prefs.getString(SharedPreferenceKeys.longitude) ?? "";
//
//            showLog("latLng --${latLng} --");
//
//            _getAddressFromLatLng();
//
//            getRestaurantDataApiRequest(
//                firstStatus: firstStatus,
//                buildContext: buildContext,
//                cusines: cusines);
//          }
//        });
////        if (isLocationMarked.isEmpty) {
////          //await Geolocator()
////
////          await Geolocator()
////              .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
////              .then((Position _position) {
////            if (_position != null) {
////              latLng = LatLng(
////                _position.latitude,
////                _position.longitude,
////              );
////
////              prefs.setString(
////                  SharedPreferenceKeys.latitude, latLng.latitude.toString());
////              prefs.setString(
////                  SharedPreferenceKeys.longitude, latLng.longitude.toString());
////
//////            latitude = prefs.getString(SharedPreferenceKeys.latitude) ?? "";
//////            longitude = prefs.getString(SharedPreferenceKeys.longitude) ?? "";
////
////              latitude = latLng.latitude.toString();
////              longitude = latLng.longitude.toString();
////              showLog("latLng --${latLng} --");
////
////              _getAddressFromLatLng();
////
////              getRestaurantDataApiRequest(
////                  firstStatus: firstStatus,
////                  buildContext: buildContext,
////                  cusines: cusines);
////            }
////          });
////        } else {
////          getRestaurantDataApiRequest(
////              firstStatus: firstStatus,
////              buildContext: buildContext,
////              cusines: cusines);
////        }
//
//        break;
//    }
  }

  openAppSettingsIfPermissionDenied() async {
    await openAppSettings();
    await openLocationSettings();
  }

  getLatitudeAndLongitude(
      {String firstStatus, BuildContext buildContext, String cusines}) async {
    await initPref();
    isLocationMarked =
        prefs.getString(SharedPreferenceKeys.currentLocationMarked) ?? "";
    showLog("currentLocationMarked--${isLocationMarked}");

    await getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) => {
              latLng = LatLng(
                position.latitude,
                position.longitude,
              ),
            });

    latitude = prefs.getString(SharedPreferenceKeys.latitude) ?? "";
    longitude = prefs.getString(SharedPreferenceKeys.longitude) ?? "";
    showLog('latitudelatitude--${latitude} -//-${longitude}');
    if (latitude.isNotEmpty && longitude.isNotEmpty) {
      latitude = prefs.getString(SharedPreferenceKeys.latitude) ?? "";
      longitude = prefs.getString(SharedPreferenceKeys.longitude) ?? "";
    } else {
      prefs.setString(
          SharedPreferenceKeys.latitude, latLng.latitude.toString());
      prefs.setString(
          SharedPreferenceKeys.longitude, latLng.longitude.toString());

      latitude = latLng.latitude.toString();
      longitude = latLng.longitude.toString();
    }

    showLog("latLng --${latLng} --");

    await _getAddressFromLatLng();

    getRestaurantDataApiRequest(
        firstStatus: firstStatus, buildContext: buildContext, cusines: cusines);
  }

  Future _gpsService({BuildContext context}) async {
    if (!(await isLocationServiceEnabled())) {
      _checkGps(context: context);
      return null;
    } else {
      return true;
    }
  }

  Future _checkGps({BuildContext context}) async {
    if (!(await isLocationServiceEnabled())) {
      if (Theme.of(context).platform == TargetPlatform.android) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Can't get gurrent location"),
                content: Text(
                  'Please make sure you enable GPS and try again',
                  style: Theme.of(context).textTheme.display2,
                ),
                actions: <Widget>[
                  FlatButton(
                      child: Text('Ok'),
                      onPressed: () {
                        final AndroidIntent intent = AndroidIntent(
                            action:
                                'android.settings.LOCATION_SOURCE_SETTINGS');
                        intent.launch();
                        Navigator.of(context, rootNavigator: true).pop();
                        _gpsService(context: context);
                      })
                ],
              );
            });
      }
    }
  }

  openAppSettings() {
    //  AppSettings.openLocationSettings();
  }

//  Future getCurrentLocationFromLocator({String firstStatus}) async {
//    await initPref();
//    // await getLocationLatAndLong();
//    try {
////      GeolocationStatus geolocationStatus =
////          await geoLocator.checkGeolocationPermissionStatus();
//
////      print("--${await geoLocator.checkGeolocationPermissionStatus()} ");
//
//      _serviceEnabled = await location.serviceEnabled();
//      if (!_serviceEnabled) {
//        _serviceEnabled = await location.requestService();
//        if (!_serviceEnabled) {
//          print("getCurrentLocation2--${_serviceEnabled}");
//          return;
//        }
//      }
//
//      _permissionGranted = await location.hasPermission();
//      if (_permissionGranted == PermissionStatus.denied) {
//        _permissionGranted = await location.requestPermission();
//        if (_permissionGranted != PermissionStatus.granted) {
//          print("getCurrentLocation1--${_locationData}");
//          _locationData = await location.getLocation();
//          print("getCurrentLocation2--${_locationData}");
//          location.onLocationChanged.listen((LocationData currentLocation) {
//            // Use current location
//            prefs.setString(SharedPreferenceKeys.latitude,
//                currentLocation.latitude.toString());
//            prefs.setString(SharedPreferenceKeys.longitude,
//                currentLocation.longitude.toString());
//
//            latitude = prefs.getString(SharedPreferenceKeys.latitude) ?? "";
//            longitude = prefs.getString(SharedPreferenceKeys.longitude) ?? "";
//
//            _getAddressFromLatLng(
//                currentLocation.latitude, currentLocation.longitude);
//            getRestaurantDataApiRequest(firstStatus: firstStatus);
//          });
//          return;
//        }
//      }
//
////      location
////          .onLocationChanged()
////          .listen((Map<String, double> currentLocation) {
////        print(currentLocation["latitude"]);
////        print(currentLocation["longitude"]);
////        print(currentLocation["accuracy"]);
////        print(currentLocation["altitude"]);
////        print(currentLocation["speed"]);
////        print(currentLocation["speed_accuracy"]);
////
////
////      });
//
////      if (geolocationStatus == GeolocationStatus.granted && latitude.isEmpty) {
////        print("getCurrentLocation1");
////
////        userLocation = await location.getLocation();
////        print("getCurrentLocation1--${userLocation}");
////        location
////            .onLocationChanged()
////            .listen((Map<String, double> currentLocation) {
////          print(currentLocation["latitude"]);
////          print(currentLocation["longitude"]);
////          print(currentLocation["accuracy"]);
////          print(currentLocation["altitude"]);
////          print(currentLocation["speed"]);
////          print(currentLocation["speed_accuracy"]);
////
////          prefs.setString(SharedPreferenceKeys.latitude,
////              currentLocation["latitude"].toString());
////          prefs.setString(SharedPreferenceKeys.longitude,
////              currentLocation["longitude"].toString());
////
////          latitude = prefs.getString(SharedPreferenceKeys.latitude) ?? "";
////          longitude = prefs.getString(SharedPreferenceKeys.longitude) ?? "";
////          _getAddressFromLatLng(
////              currentLocation["latitude"], currentLocation["longitude"]);
////        });
////
////        getRestaurantDataApiRequest(firstStatus: firstStatus);
////        //print("getCurrentLocation1--${userLocation}");
//////        await geoLocator
//////            .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
//////            .then((Position position) async {
//////          currentPosition = position;
//////          print(
//////              "getCurrentLocation1 -- ${currentPosition.latitude} --${currentPosition.longitude}");
//////          prefs.setString(SharedPreferenceKeys.latitude,
//////              currentPosition.latitude.toString());
//////          prefs.setString(SharedPreferenceKeys.longitude,
//////              currentPosition.longitude.toString());
//////
//////          latitude = prefs.getString(SharedPreferenceKeys.latitude) ?? "";
//////          longitude = prefs.getString(SharedPreferenceKeys.longitude) ?? "";
//////
//////          // _getAddressFromLatLng();
//////          //  getRestaurantData(firstStatus: firstStatus);
//////          getRestaurantDataApiRequest(firstStatus: firstStatus);
//////        }).catchError((err) {
//////          print("Error $err");
//////        });
////      } else {
////        print("getCurrentLocation2");
////        //getRestaurantData(firstStatus: firstStatus);
////        getRestaurantDataApiRequest(firstStatus: firstStatus);
////      }
//    } catch (e) {}
//  }

  _getAddressFromLatLng({double latitude, double longitude}) async {
    await initPref();
    var location;
    try {
//      List<Placemark> p = await geoLocator.placemarkFromCoordinates(
//          currentPosition.latitude, currentPosition.longitude);
      currentAddress =
          prefs.getString(SharedPreferenceKeys.currentLocationMarked) ?? "";

      showLog("currentAddresscurrentAddress --${currentAddress} --");

      if (currentAddress.isEmpty) {
        if (latLng != null) {
          List<Placemark> placemarks =
              await placemarkFromCoordinates(latLng.latitude, latLng.longitude);
//          List<Placemark> p = await geolocator.placemarkFromCoordinates(
//              latLng.latitude, latLng.longitude);

          Placemark place = placemarks[0];

          location = place.subLocality == '' ? place.name : place.subLocality;

          location =
              place.locality != null ? location + ',' + place.locality : "";

//          await prefs.setString(
//              SharedPreferenceKeys.currentLocation, "$location");
          await prefs.setString(
              SharedPreferenceKeys.currentLocationMarked, '$location');

          showLog(
              "currentLocationMarked --${place.subLocality} -- ${place.name} -- ${location}");

//          currentAddress =
//              prefs.getString(SharedPreferenceKeys.currentLocation) ?? "";
          currentAddress =
              prefs.getString(SharedPreferenceKeys.currentLocationMarked) ?? "";
        }
      } else {
        currentAddress =
            prefs.getString(SharedPreferenceKeys.currentLocationMarked) ?? "";
      }
    } catch (e) {
      print(e);
    }

    notifyListeners();
  }

  callHomeRestaurantsListRequest({
    String city,
    String firstStatus = "1",
    bool firstInit = false,
    Map<String, String> sortFilter,
    bool fromFilter = false,
    BuildContext context,
    String cusines,
    bool showProgress = false,
  }) async {
    showLog("fromFilter2--${fromFilter}");
//    if (fromFilter) {
//      listOfRestaurantData.clear();
//    }

    await initBox();

    homeRestaurantListDataFromBox =
        await homeRestaurantsListBox.get(0) as HomeRestaurantListApiModel;

    await loadRestaurantsListFromBox();

    if (homeRestaurantListDataFromBox != null && !fromFilter) {
      showLog(
          "homeRestaurantsListBox.get(0)${homeRestaurantListDataFromBox.restaurant.length}");

      await loadRestaurantsListFromBox();
      if (firstInit && showProgress) {
        if (homeRestaurantListDataFromBox.restaurant.length == 0) {
          setState(BaseViewState.Busy);
          await initialPageApiCall(
              firstStatus: firstStatus,
              firstInit: firstInit,
              fromFilter: fromFilter,
              buildContext: context,
              cusines: cusines);
          //setState(BaseViewState.Idle);
        } else {
          await initialPageApiCall(
              firstStatus: firstStatus,
              firstInit: firstInit,
              fromFilter: fromFilter,
              buildContext: context,
              cusines: cusines);
          // setState(BaseViewState.Idle);
        }
        //load from database and call api without progress
//        await initialPageApiCall(
//            firstStatus: firstStatus, firstInit: firstInit);
      } else {
        //load from db and show circular progress to fetch data for next page
        setPageState(PaginationState.loading);

        await initialPageApiCall(
            firstStatus: firstStatus,
            firstInit: firstInit,
            fromFilter: fromFilter,
            buildContext: context,
            cusines: cusines);

        setPageState(PaginationState.done);
      }
    } else {
      setState(BaseViewState.Busy);
      await initialPageApiCall(
          firstStatus: firstStatus,
          firstInit: firstInit,
          fromFilter: fromFilter,
          buildContext: context,
          cusines: cusines);
      //  setState(BaseViewState.Idle);
    }
    await loadRestaurantsListFromBox();
    setPageState(PaginationState.done);
    setState(BaseViewState.Idle);
    notifyListeners();
  }

  loadRestaurantsListFromBox() async {
    homeRestaurantListDataFromBox =
        await homeRestaurantsListBox.get(0) as HomeRestaurantListApiModel;
    openRestaurants.clear();
    closedRestaurants.clear();

    if (homeRestaurantListDataFromBox != null) {
      showLog(
          "homeRestaurantListDataFromBoxhomeRestaurantListDataFromBox-- ${homeRestaurantListDataFromBox.restaurant.length}--  ${homeRestaurantListDataFromBox.totalPages}--${homeRestaurantListDataFromBox.aCuisines.length}");
      showLog("loadRestaurantsListFromBox1-${listOfRestaurantData.length}");

      homeRestaurantListDataFromBox.restaurant.forEach((element) {
//        if (openRestaurants.contains(element.id)) {
//          showLog(
//              "availability1- ${element.id} -${element.availability.status}--${element.availability.text}");
//          if (element.availability.status == 1) {
//            showLog("availability3-${element.id}");
//            openRestaurants.add(element);
//            showLog("availability2-${openRestaurants.length}");
//          } else {
//            showLog("availability3-${element.id}");
//            closedRestaurants.add(element);
//            showLog("availability3-${closedRestaurants.length}");
//          }
//        } else {
//          showLog("Else-${openRestaurants.length}");
//        }
//
//        if (element.availability.status == 1) {
//          showLog("availability3-${element.id}");
//
//          if (openRestaurants.contains(element.id)) {
//            openRestaurants.add(element);
//          }
//
//          showLog("availability2-${openRestaurants.length}");
//        } else {
//          showLog("availability3-${element.id}");
//          if (closedRestaurants.contains(element.id)) {
//            closedRestaurants.add(element);
//          }
//
//          showLog("availability3-${closedRestaurants.length}");
//        }
        if (element.availability.status == 1) {
          showLog("availability3-${element.id}");
          openRestaurants.add(element);
          showLog("availability2-${openRestaurants.length}");
        } else {
          showLog("availability3-${element.id}");
          closedRestaurants.add(element);
          showLog("availability4-${closedRestaurants.length}");
        }
      });
      openRestaurants.addAll(closedRestaurants);

//      if (openRestaurants.length == 0) {
//        homeRestaurantListDataFromBox.restaurant.forEach((element) {
//          if (element.availability.status == 1) {
//            openRestaurants.add(element);
//            showLog("availabilityEmpty-${openRestaurants.length}");
//          } else {
//            closedRestaurants.add(element);
//            showLog("availabilityEmpty-${closedRestaurants.length}");
//          }
//        });
//        openRestaurants.addAll(closedRestaurants);
//      } else {
//        homeRestaurantListDataFromBox.restaurant.forEach((element) {
//          if (openRestaurants.contains(element.id)) {
//            showLog(
//                "availability1- ${element.id} -${element.availability.status}--${element.availability.text}");
//            if (element.availability.status == 1) {
//              showLog("availability3-${element.id}");
//              openRestaurants.add(element);
//              showLog("availability2-${openRestaurants.length}");
//            } else {
//              showLog("availability3-${element.id}");
//              closedRestaurants.add(element);
//              showLog("availability3-${closedRestaurants.length}");
//            }
//          } else {
//            showLog("Else-${openRestaurants.length}");
//          }
//        });
//
//        openRestaurants.addAll(closedRestaurants);
//      }

//
//      homeRestaurantListDataFromBox.restaurant.forEach((element) {
////        if (element.availability.status == 1) {
////          openRestaurants.add(element);
////          showLog("availability2-${openRestaurants.length}");
////        } else {
////          closedRestaurants.add(element);
////          showLog("availability3-${closedRestaurants.length}");
////        }
//
//        if (openRestaurants.isEmpty) {
//          if (element.availability.status == 1) {
//            openRestaurants.add(element);
//            showLog("availability2-${openRestaurants.length}");
//          } else {
//            closedRestaurants.add(element);
//            showLog("availability3-${closedRestaurants.length}");
//          }
//        } else {
//          if (openRestaurants.contains(element.id)) {
//            showLog(
//                "availability1-${element.availability.status}--${element.availability.text}");
//            if (element.availability.status == 1) {
//              openRestaurants.add(element);
//              showLog("availability2-${openRestaurants.length}");
//            } else {
//              closedRestaurants.add(element);
//              showLog("availability3-${closedRestaurants.length}");
//            }
//          } else {
//            showLog("Else-${openRestaurants.length}");
//          }
//        }
//      });

      showLog("availability3-${openRestaurants.length}");

      //listOfRestaurantData = homeRestaurantListDataFromBox.restaurant;
      listOfRestaurantData = openRestaurants;

      showLog(
          "loadRestaurantsListFromBox1-${homeRestaurantListDataFromBox.aCuisines.length}");

      totalPagesData = homeRestaurantListDataFromBox.totalPages;
      bannerViewSliderData = homeRestaurantListDataFromBox.aSlider;
      demoData = homeRestaurantListDataFromBox.demo;
      restaurantCitiesData = homeRestaurantListDataFromBox.restaurantCities;
      filter = homeRestaurantListDataFromBox.aFilter;
      cusinesList = homeRestaurantListDataFromBox.aCuisines;
    }

    setPageState(PaginationState.done);
    setState(BaseViewState.Idle);

    notifyListeners();
  }

//  callInitialPageRestaurantList(
//      {String city,
//      String firstStatus = "1",
//      bool firstInit = false,
//      Map<String, String> sortFilter,
//      bool fromFilter = false}) async {
//    await getTotalPages();
//    deviceId = await fetchDeviceId();
//    if (fromFilter || firstStatus == "1") {
//      pageNumber = 0;
//    }
//
//    setPageState(PaginationState.loading);
//    if (pageNumber <= totalPagesData) {
//      try {
//        await ApiRepository(mContext: context).callApiRequestForRestaurant(
//            url: restaurantList,
//            staticMapValue: {
//              latitudeKey: latitude ?? "",
//              longitudeKey: longitude ?? "",
//              cityKey: cityValue,
//              userIdKey: userId.toString(),
//              deviceIDKey: deviceId.toString(),
//              pageKey: pageNumber.toString(),
//              firstStatusKey: firstStatus,
//              sortByKey: loadSortAndFilterMap.sortBy != null
//                  ? loadSortAndFilterMap.sortBy.toString()
//                  : "",
//              ratingKey: loadSortAndFilterMap.rating != null
//                  ? loadSortAndFilterMap.rating.toString()
//                  : "",
//              cuisinesKey: loadSortAndFilterMap.cuisines != null
//                  ? loadSortAndFilterMap.cuisines.toString()
//                  : "",
//            }).then((value) async => {
//              listOfRestaurantData.addAll(value.restaurant),
//              //listOfRestaurantData = value.restaurant,
//              totalPagesData =
//                  value.totalPages != null ? value.totalPages : totalPagesData,
//              bannerViewSliderData =
//                  value.aSlider != null ? value.aSlider : bannerViewSliderData,
//              demoData = value.demo,
//              restaurantCitiesData = value.restaurantCities,
//              filter = value.aFilter,
//
//              cartQuantityPriceProvider.updateCartQuantity(
//                  aCart: value.aCart, progress: false),
//
//              // storeFilterDataFromApi(filter),
//              if (value.aSlider != null && bannerViewSliderData.length != 0)
//                {
//                  for (int i = 0; i <= value.aSlider.length - 1; i++)
//                    {
//                      bannerImagesData = ASlider(
//                        id: value.aSlider[i].id,
//                        image: value.aSlider[i].image,
//                        src: value.aSlider[i].src,
//                        type: 1,
//                      ),
//                      //showLog("listOfRestaurantData, ${bannerImagesData.src}"),
//                      await dbHelper.insert(
//                        bannerImagesData.toJson(),
//                        DbStatics.tableImages,
//                      )
//                    },
//                },
//
//              if (value.totalPages != null)
//                {
//                  totalPagesModel = TotalPagesModel(
//                      id: 1, url: restaurantList, totalPages: totalPagesData),
//                  showLog("totalPagesModel-- ${totalPagesModel.totalPages}"),
//                  await dbHelper.insert(
//                      totalPagesModel.toJson(), DbStatics.tableTotalPages)
//                },
//              getImagesFromTable(),
//              getTotalPages(),
//              //  await getLocationLatAndLong(),
//              // getFiltersDatFromTable()
//            });
//
//        pageNumber++;
//        showLog("PageeeeNumber-- ${pageNumber}");
//        setPageState(PaginationState.done);
//        setState(BaseViewState.Idle);
//        notifyListeners();
//      } catch (e) {
//        showLog("HomeRestaurantListViewModel exception,$e");
//        Fluttertoast.showToast(
//            msg: "$e",
//            toastLength: Toast.LENGTH_LONG,
//            gravity: ToastGravity.CENTER,
//            timeInSecForIosWeb: 1,
//            backgroundColor: Colors.grey[300],
//            textColor: Colors.black,
//            fontSize: 16.0);
//        if (e.toString().startsWith("SocketException:")) {
//          setPageState(PaginationState.noNetwork);
//        } else {
//          setPageState(PaginationState.error);
//        }
//        setPageState(PaginationState.done);
//        setState(BaseViewState.Idle);
//
//        notifyListeners();
//
//        //  _showAlertDialog(context: context, errorMessage: e);
//      }
//    } else {
//      if (!firstInit) {
//        setPageState(PaginationState.noUpdate);
//      }
//      setState(BaseViewState.Idle);
//      // notifyListeners();
//    }
//    notifyListeners();
//  }

  initialPageApiCall({
    String city,
    String firstStatus = "1",
    bool firstInit = false,
    Map<String, String> sortFilter,
    bool fromFilter = false,
    BuildContext buildContext,
    String cusines,
    bool showProgress,
  }) async {
    // await initBox();

//    if (fromFilter) {
//      if (loadSortAndFilterMap.sortBy == null &&
//          loadSortAndFilterMap.rating == null &&
//          loadSortAndFilterMap.cuisines == null) {
//        loadSortAndFilterMap.sortBy = loadSortAndFilterMap.sortBy == null
//            ? filter[0].filterValues[0].name
//            : loadSortAndFilterMap.sortBy;
//        loadSortAndFilterMap.rating = loadSortAndFilterMap.rating == null
//            ? filter[1].filterValues[0].name
//            : loadSortAndFilterMap.sortBy;
//        loadSortAndFilterMap.cuisines = loadSortAndFilterMap.cuisines == null
//            ? filter[2].filterValues[0].name
//            : loadSortAndFilterMap.sortBy;
//      }
//    } else {
//      loadSortAndFilterMap.cuisines = cusines;
//    }

    showLog("FromFilterData---${fromFilter}");

//    if (!fromFilter) {
//
//    } else {
//      // loadSortAndFilterMap.cuisines = cusines;
//    }

    if (cusines == "All" || loadSortAndFilterMap.cuisines == 'All') {
      loadSortAndFilterMap.cuisines = null;
    } else {
      loadSortAndFilterMap.cuisines =
          cusines == null ? loadSortAndFilterMap.cuisines : cusines;
    }

    if (pageNumber <= totalPagesData) {
      try {
        await ApiRepository(mContext: context)
            .callApiRequestForRestaurant(
                url: restaurantList,
                staticMapValue: {
                  latitudeKey: latitude ?? "",
                  longitudeKey: longitude ?? "",
                  cityKey: cityValue,
                  userIdKey: userId.toString(),
                  deviceIDKey: deviceId.toString(),
                  pageKey: pageNumber.toString(),
                  firstStatusKey: firstStatus,
                  sortByKey: loadSortAndFilterMap.sortBy != null
                      ? loadSortAndFilterMap.sortBy.toString()
                      : "",
                  ratingKey: loadSortAndFilterMap.rating != null
                      ? loadSortAndFilterMap.rating.toString()
                      : "",
                  cuisinesKey: loadSortAndFilterMap.cuisines != null
                      ? loadSortAndFilterMap.cuisines.toString()
                      : "",
                },
                context: buildContext)
            .then((value) async => {
                  await initBox(),
                  // store to db
                  if (firstInit)
                    {
                      showLog(
                          "111 ${value.restaurant.length}--${value.aCuisines.length}"),
                      await homeRestaurantsListBox.clear(),
                      await homeRestaurantsListBox.add(value),
                      await loadRestaurantsListFromBox(),
                    }
                  else
                    {
                      listOfRestaurantForNextPage.clear(),
                      showLog("222 ${value.restaurant.length}"),
//                      homeRestaurantListDataFromBox.restaurant
//                          .asMap()
//                          .forEach((key, value) {
//                        showLog(
//                            "homeRestaurantList ${homeRestaurantListDataFromBox.restaurant.length}-- ${value.id}--  ");
//                      }),
                      value.restaurant.asMap().forEach((key, current) async {
                        showLog(
                            "homeRestaurantListDataFromBox// ${listOfRestaurantData.contains(current)}- ");
                        if (listOfRestaurantData.contains('${current.id}')) {
                          listOfRestaurantForNextPage.add(
                            Restaurant(
                              id: current.id,
                              name: current.name,
                              location: current.location,
                              logo: current.logo,
                              partnerId: current.partnerId,
                              deliveryTime: current.deliveryTime,
                              budget: current.budget,
                              rating: current.rating,
                              resDesc: current.resDesc,
                              src: current.src,
                              cuisine: current.cuisine,
                              cuisineText: current.cuisineText,
                              distance: current.distance,
                              mode: current.mode,
                              favouriteStatus: current.favouriteStatus,
                              availability: current.availability,
                              promoStatus: current.promoStatus,
                            ),
                          );
//                        if (!listOfRestaurantData.contains(current)) {
//                          listOfRestaurantForNextPage.add(
//                            Restaurant(
//                              id: current.id,
//                              name: current.name,
//                              location: current.location,
//                              logo: current.logo,
//                              partnerId: current.partnerId,
//                              deliveryTime: current.deliveryTime,
//                              budget: current.budget,
//                              rating: current.rating,
//                              resDesc: current.resDesc,
//                              src: current.src,
//                              cuisine: current.cuisine,
//                              cuisineText: current.cuisineText,
//                              distance: current.distance,
//                              mode: current.mode,
//                              favouriteStatus: current.favouriteStatus,
//                              availability: current.availability,
//                              promoStatus: current.promoStatus,
//                            ),
//                          );
//                        }

                        }
                      }),
                      showLog(
                          "homeRestaurantListDataFromBox//112 --${filter.length}"),
                      homeRestaurantListDataFromBox.restaurant
                          .addAll(listOfRestaurantForNextPage),
                      await loadRestaurantsListFromBox(),
                    },

                  cartQuantityPriceProvider.updateCartQuantity(
                      aCart: value.aCart, progress: false),
                });

        pageNumber++;
        showLog("PageeeeNumber-- ${pageNumber}");
      } catch (e) {
        showLog("HomeRestaurantListViewModel exception,$e");
//        Fluttertoast.showToast(
//            msg: "$e",
//            toastLength: Toast.LENGTH_LONG,
//            gravity: ToastGravity.CENTER,
//            timeInSecForIosWeb: 1,
//            backgroundColor: Colors.grey[300],
//            textColor: Colors.black,
//            fontSize: 16.0);
        if (e.toString().startsWith("SocketException:")) {
          setPageState(PaginationState.noNetwork);
        } else {
          setPageState(PaginationState.error);
        }
      }
    } else {
      showLog("noupdatess");
    }
    notifyListeners();
  }

  getTotalPages() async {
    totalPagesData = await dbHelper.getTotalPagesForUrl(restaurantList);
  }

  Future<List<ASlider>> getImagesFromTable() async {
    await dbHelper.getSliderImages().then((value) => {
          if (value != null)
            {
              for (int i = 0; i <= value.foodImages.length - 1; i++)
                {
                  bannerViewSliderData.add(
                    ASlider(
                      id: value.foodImages[i].id,
                      image: value.foodImages[i].image,
                      src: value.foodImages[i].src,
                    ),
                  ),
                  showLog("getImagesFromTable,${bannerViewSliderData[i].image}")
                }
            }
          else
            {bannerViewSliderData = []}
        });

    return bannerViewSliderData;
  }

  getFiltersDatFromTable() async {
    await dbHelper
        .getSortFilterData()
        .then((value) => {if (value != null) {} else {}});
  }
}
