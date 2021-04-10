import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:foodstar/src/constants/api_params_keys.dart';
import 'package:foodstar/src/constants/api_urls.dart';
import 'package:foodstar/src/constants/common_strings.dart';
import 'package:foodstar/src/constants/sharedpreference_keys.dart';
import 'package:foodstar/src/core/models/api_models/already_searched_keyword_model.dart';
import 'package:foodstar/src/core/models/api_models/app_essensial_core_data_model.dart';
import 'package:foodstar/src/core/models/api_models/auth_common_response_model.dart';
import 'package:foodstar/src/core/models/api_models/cart_action_api_model.dart';
import 'package:foodstar/src/core/models/api_models/cart_bill_detail_api_model.dart';
import 'package:foodstar/src/core/models/api_models/current_order_api_model.dart';
import 'package:foodstar/src/core/models/api_models/edit_profile_model.dart';
import 'package:foodstar/src/core/models/api_models/favorites_restaurant_api_model.dart';
import 'package:foodstar/src/core/models/api_models/home_restaurant_list_api_model.dart';
import 'package:foodstar/src/core/models/api_models/login_response_model.dart';
import 'package:foodstar/src/core/models/api_models/my_orders_api_model.dart';
import 'package:foodstar/src/core/models/api_models/onlinepayment_api_model.dart';
import 'package:foodstar/src/core/models/api_models/promo_code_api_model.dart';
import 'package:foodstar/src/core/models/api_models/register_response_model.dart';
import 'package:foodstar/src/core/models/api_models/restaurant_details_api_model.dart';
import 'package:foodstar/src/core/models/api_models/saved_address_api_model.dart';
import 'package:foodstar/src/core/models/api_models/search_api_model.dart';
import 'package:foodstar/src/core/models/api_models/search_restaurant_dish_model.dart';
import 'package:foodstar/src/core/models/api_models/track_order_api_model.dart';
import 'package:foodstar/src/core/models/api_models/user_profile_model.dart';
import 'package:foodstar/src/core/models/db_model/country_code_db_model.dart';
import 'package:foodstar/src/core/service/api_base_helper.dart';
import 'package:foodstar/src/core/service/app_exception.dart';
import 'package:foodstar/src/core/service/database/database_helper.dart';
import 'package:foodstar/src/ui/shared/show_snack_bar.dart';
import 'package:foodstar/src/utils/common_navigation.dart';
import 'package:foodstar/src/utils/target_platform.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiRepository {
  ApiBaseHelper apiHelper;
  SharedPreferences prefs;
  String clientId;
  String clientSecret;
  BuildContext mContext;
  DBHelper dbHelper;

  ApiRepository({this.mContext}) {
    apiHelper = Provider.of<ApiBaseHelper>(mContext, listen: false);
  }

  initDbHelper() {
    dbHelper = DBHelper.instance;
  }

  initPref() async {
    if (prefs == null) prefs = await SharedPreferences.getInstance();
  }

  //url type 1-post,2-get, 3-put
  fetchAppEssentialCorerData({BuildContext context}) async {
    initDbHelper();
    Countries countryCodeData;
    var coreDataMap = {deviceKey: fetchTargetPlatform()};

    final response = await apiHelper.apiRequest(
        url: coreData,
        dynamicMapValue: coreDataMap,
        urlType: post,
        context: context);

    showLog('AppEssentialsCoreDataModel ${response}');

    compute(appEssentialsCoreDataModelFromJson, response)
        .then((value) async => {
              storeCoreData(value),
              for (int i = 0; i <= value.aCountries.length - 1; i++)
                {
                  countryCodeData = Countries(
                    id: value.aCountries[i].id,
                    name: value.aCountries[i].name,
                    phoneCode: value.aCountries[i].phoneCode,
                  ),
                },
            });
  }

  Future<CartActionApiModel> getCartQuantityWhileOpenApp(
    Map<String, dynamic> dynamicMapValue,
  ) async {
    try {
      final response = await apiHelper.apiRequest(
          url: userData, dynamicMapValue: dynamicMapValue, urlType: post);
      return compute(cartActionApiModelFromJson, response);
    } catch (e) {
      return null;
    }
  }

  Future<RestaurantDetailsApiModel> callApiRequestForRestaurantDetails({
    Map<String, String> staticMapValue,
    dynamic model,
    @required BuildContext mContext,
  }) async {
    showLog("RestaurantDetailsModel");
    try {
      final response = await apiHelper.apiRequest(
          url: restaurantDetailsUrl,
          staticMapValue: staticMapValue,
          urlType: getUrl,
          context: mContext);
      return compute(restaurantDetailsApiModelFromJson, response);
    } catch (e) {
      var errorMessage = parseErrorMessage(e.toString());
      showLog("cartActionApiModelFromJson == ${errorMessage}");
//      if (errorMessage == "Fooditems Not found") {
//        showInfoAlertDialog(
//            context: mContext,
//            response: parseErrorMessage(errorMessage),
//            onClicked: () {
//              Navigator.pop(mContext);
//            });
//        return null;
//      } else {}
      return null;
    }
  }

  Future<SavedAddressApiModel> editOrDeleteAddressRequest({
    Map<String, dynamic> dynamicMapValue,
    @required BuildContext mContext,
  }) async {
    try {
      final response = await apiHelper.apiRequest(
          url: editSavedAddress,
          dynamicMapValue: dynamicMapValue,
          urlType: post,
          context: mContext);

      showLog("RestaurantDetailsModel $response");

      return compute(savedAddressApiModelFromJson, response);
    } catch (error) {
      var errorMessage = parseErrorMessage(error.toString());
      showLog("cartActionApiModelFromJson == ${errorMessage}");

      return null;
    }
  }

  Future<SavedAddressApiModel> initSavedAddressRequest({
    Map<String, String> staticMapValue,
    @required BuildContext mContext,
  }) async {
    try {
      final response = await apiHelper.apiRequest(
        url: savedAddress,
        staticMapValue: staticMapValue,
        urlType: getUrl,
        context: mContext,
      );

      showLog("RestaurantDetailsModel $response");

      return compute(savedAddressApiModelFromJson, response);
    } catch (error) {
      return null;
    }
  }

  Future<CartActionApiModel> callCartActionRequest({
    Map<String, dynamic> dynamicMapValue,
    dynamic model,
    BuildContext context,
    int fromWhere,
    int index,
    int parentIndex,
    @required BuildContext mContext,
  }) async {
    showLog("RestaurantDetailsModel");
    try {
      final response = await apiHelper.apiRequest(
          url: cartAction,
          dynamicMapValue: dynamicMapValue,
          urlType: post,
          context: mContext);

      showLog("RestaurantDetailsModel $response");

      return compute(cartActionApiModelFromJson, response);
    } catch (error) {
      throw BadRequestException(parseErrorMessage(error.toString()));
    }
  }

  Future<CartActionApiModel> restDeleteIfAlreadyExits({
    Map<String, dynamic> dynamicMapValue,
    BuildContext context,
  }) async {
    showLog("RestaurantDetailsModel");
    try {
      var deviceID = dynamicMapValue[deviceIDKey];
      var userID = dynamicMapValue[userIdKey];
      final response = await apiHelper.apiRequest(
          url: cartAction,
          dynamicMapValue: {
            deviceIDKey: deviceID,
            foodIdKey: "",
            userIdKey: userID,
            actionKey: restaurantDelete,
          },
          urlType: post,
          context: context);

      showLog("RestaurantDetailsModel $response");

      // callCartActionRequest(dynamicMapValue: dynamicMapValue);

      return compute(cartActionApiModelFromJson, response);
    } catch (e) {
      return null;
    }
  }

  Future<FavoritesRestaurantApiModel> callWishListRequest({
    Map<String, dynamic> dynamicMapValue,
    @required BuildContext mContext,
  }) async {
    showLog("RestaurantDetailsModel");
    final response = await apiHelper.apiRequest(
        url: userFavAction,
        dynamicMapValue: dynamicMapValue,
        urlType: post,
        context: mContext);

    showLog("RestaurantDetailsModel $response");

    return compute(favoritesRestaurantApiModelFromJson, response);
  }

  Future<CurrentOrderApiModel> currentOrdersApiRequest(
      BuildContext context) async {
    try {
      final response = await apiHelper.apiRequest(
          url: currentOrderDetails,
          staticMapValue: {userTypeKey: user, typeKey: user},
          urlType: getUrl,
          context: mContext);

      return compute(currentOrderApiModelFromJson, response);
    } catch (e) {
      showLog('initProceedConfirmOrder--${e}');
      throw BadRequestException(parseErrorMessage(e.toString()));
    }
  }

  Future<OnlinePaymentApiModel> initOnlinePaymentRequest(
    Map<String, dynamic> dynamicMapValue,
    BuildContext mContext,
  ) async {
    try {
      final response = await apiHelper.apiRequest(
          url: proceedOrder,
          dynamicMapValue: dynamicMapValue,
          urlType: post,
          context: mContext);

      return compute(onlinePaymentApiModelFromJson, response);
    } catch (e) {
      showLog('initProceedConfirmOrder--${e}');
      throw BadRequestException(parseErrorMessage(e.toString()));
    }
  }

  Future<PromoCodeApiModel> availablePromosRequest(
    BuildContext mContext,
  ) async {
    try {
      final response = await apiHelper.apiRequest(
          url: availablePromosForUSer,
          staticMapValue: {userTypeKey: user},
          urlType: getUrl,
          context: mContext);

      return compute(promoCodeApiModelFromJson, response);
    } catch (e) {
      showLog('initProceedConfirmOrder--${e}');
      throw BadRequestException(parseErrorMessage(e.toString()));
    }
  }

  Future<CommonMessageModel> cancelOrder({
    BuildContext mContext,
    Map<String, dynamic> dynamicMapValue,
  }) async {
    try {
      final response = await apiHelper.apiRequest(
          url: orderStatusChangeUrl,
          dynamicMapValue: dynamicMapValue,
          urlType: put,
          context: mContext);

      return compute(commonMessageModelFromJson, response);
    } catch (e) {
      showLog('initProceedConfirmOrder--${e}');
      throw BadRequestException(parseErrorMessage(e.toString()));
    }
  }

  Future<OnlinePaymentApiModel> initProceedConfirmOrder(
    Map<String, dynamic> dynamicMapValue,
    BuildContext mContext,
  ) async {
    try {
      final response = await apiHelper.apiRequest(
          url: proceedOrder,
          dynamicMapValue: dynamicMapValue,
          urlType: post,
          context: mContext);

      return compute(onlinePaymentApiModelFromJson, response);
    } catch (e) {
      showLog('initProceedConfirmOrder--${e}');
      throw BadRequestException(parseErrorMessage(e.toString()));
    }
  }

  Future<AlreadySearchedKeywordsApiModel> callAlreadySearchedKeywordsRequest(
    Map<String, String> staticMapValue,
    BuildContext mContext,
  ) async {
    final response = await apiHelper.apiRequest(
      url: savedSearchKeywords,
      staticMapValue: staticMapValue,
      urlType: getUrl,
      context: mContext,
    );

    return compute(alreadySearchedKeywordsApiModelFromJson, response);
  }

  Future<SearchApiModel> callSearchRestaurantDishRequest(
      Map<String, String> staticMapValue, BuildContext context) async {
    final response = await apiHelper.apiRequest(
        url: searchRestaurantDish,
        staticMapValue: staticMapValue,
        urlType: getUrl,
        context: context);

    return compute(searchApiModelFromJson, response);
  }

  Future<CommonMessageModel> clearRecentAndTopSearch(
    Map<String, String> staticMapValue,
    BuildContext context,
  ) async {
    final response = await apiHelper.apiRequest(
        url: saveSearchKeyword,
        dynamicMapValue: staticMapValue,
        urlType: post,
        context: context);

    return compute(commonMessageModelFromJson, response);
  }

  Future<SearchRestaurantDishApiModel> saveSearchKeyWordRequest(
      Map<String, String> staticMapValue, BuildContext context) async {
    final response = await apiHelper.apiRequest(
        url: saveSearchKeyword,
        dynamicMapValue: staticMapValue,
        urlType: post,
        context: context);

    return compute(searchRestaurantDishApiModelFromJson, response);
  }

  Future<HomeRestaurantListApiModel> callApiRequestForRestaurant(
      {Map<String, String> staticMapValue,
      String url,
      dynamic model,
      BuildContext context}) async {
    final response = await apiHelper.apiRequest(
        url: url,
        staticMapValue: staticMapValue,
        urlType: getUrl,
        context: context);

    showLog("callApiRequestForRestaurant $response");

    return compute(homeRestaurantListApiModelFromJson, response);
  }

  storeCoreData(AppEssentialsCoreDataModel coreData) async {
    // showLog('AppEssentialsCoreDataModel ${clientID} ${clientSecret}');
    await initPref();
//    prefs.setString(SharedPreferenceKeys.clientId, clientID);
//    prefs.setString(SharedPreferenceKeys.clientSecret, clientSecret);
    prefs.setString(
        SharedPreferenceKeys.currencySymbol, coreData.currencySymbol);
    prefs.setString(
        SharedPreferenceKeys.androidPlayStoreLink, coreData.androidLink);
    prefs.setString(SharedPreferenceKeys.appleStoreLink, coreData.iosLink);
  }

  Future<dynamic> authApiRequest({
    String url,
    Map<String, dynamic> dynamicMapValue,
    Map<String, String> staticMapValue,
    int urlType,
    int model,
    BuildContext context,
  }) async {
    try {
      final response = await apiHelper.apiRequest(
          url: url,
          dynamicMapValue: dynamicMapValue,
          staticMapValue: staticMapValue,
          urlType: urlType,
          context: context);

      showLog("authApiRequest -- ${response}");
      if (model == 1) {
        return compute(registerResponseModelFromJson, response);
      } else if (model == 2) {
        //login
        return compute(loginResponseModelFromJson, response);
      } else {
        return compute(commonMessageModelFromJson, response);
      }
    } catch (e) {
      showLog("authApiRequestCatch ${e.toString()}");
      String errormessage = e.toString();

      showInfoAlertDialog(
          context: context,
          response: parseErrorMessage(errormessage),
          onClicked: () {
            Navigator.pop(context);
          });
      showLog(
          "authApiRequestCatch1 ${errormessage.substring(1, errormessage.length - 1)}");
    }
  }

  String parseErrorMessage(String value) {
    return value.substring(1, value.length - 1);
  }

  Future<FavoritesRestaurantApiModel> favoritesRestaurantRequest(
      BuildContext context) async {
    final response = await apiHelper.apiRequest(
        url: savedFavorites,
        staticMapValue: {userTypeKey: user},
        urlType: getUrl,
        context: context);

    showLog("favoritesRestaurantApiModelFromJson -- ${response}");
    return compute(favoritesRestaurantApiModelFromJson, response);
  }

  Future<TrackOrderApiModel> trackOrderDetailsApiRequest(
      {Map<String, String> staticMapValue,
      @required BuildContext context}) async {
    final response = await apiHelper.apiRequest(
      url: trackOrderDetails,
      urlType: getUrl,
      staticMapValue: staticMapValue,
      context: context,
    );

    showLog("favoritesRestaurantApiModelFromJson -- ${response}");
    return compute(trackOrderApiModelFromJson, response);
  }

  Future<MyOrdersApiModel> myOrdersApiModel(BuildContext context) async {
    final response = await apiHelper.apiRequest(
      url: myOrders,
      urlType: getUrl,
      staticMapValue: {
        userTypeKey: user,
        typeKey: user,
      },
      context: context,
    );

    showLog("favoritesRestaurantApiModelFromJson -- ${response}");
    return compute(myOrdersApiModelFromJson, response);
  }

  Future<dynamic> userProfileDetailsRequest(
      {String updatedAt, BuildContext context}) async {
    final response = await apiHelper.apiRequest(
        url: userProfileDetails,
        staticMapValue: {
          userTypeKey: userType,
          updatedAtKey: updatedAt,
        },
        urlType: getUrl,
        context: context);
    return compute(userProfileModelFromJson, response);
  }

  Future<CommonMessageModel> updateRatingForOrder(
      {Map<String, dynamic> dynamicMapValue, BuildContext context}) async {
    final response = await apiHelper.apiRequest(
      url: skipUpdateRatingUrl,
      dynamicMapValue: dynamicMapValue,
      urlType: post,
      context: context,
    );
    return compute(
      commonMessageModelFromJson,
      response,
    );
  }

  Future<dynamic> verifyEmailRequestFromProfile(
      String email, BuildContext context) async {
    try {
      final response = await apiHelper.apiRequest(
        url: verifyEmailRequestUrl,
        dynamicMapValue: {userTypeKey: userType, emailKey: email},
        context: context,
        urlType: post,
      ); //put);

      showLog("userProfileDetailsRequest -- ${response}");
      return compute(commonMessageModelFromJson, response);
    } catch (e) {
      showInfoAlertDialog(
          context: context,
          response: parseErrorMessage(e.toString()),
          onClicked: () {
            Navigator.pop(context);
          });
    }
  }

  Future<dynamic> editProfileRequest(
      {Map<String, dynamic> dynamicMapValue,
      Map<String, String> staticAuthMap,
      String url,
      int urlType,
      File fileName,
      BuildContext context}) async {
    try {
      final response = await apiHelper.apiRequest(
          url: url,
          dynamicMapValue: dynamicMapValue,
          staticMapValue: staticAuthMap,
          urlType: urlType,
          fileName: fileName,
          context: context);

      showLog("editProfileRequest -- ${response}");
      return compute(editProfileApiModelFromJson, response);
    } catch (e) {
      showInfoAlertDialog(
          context: context,
          response: parseErrorMessage(e.toString()),
          onClicked: () {
            Navigator.pop(context);
          });
    }
  }

  Future<CommonMessageModel> logoutRequest({BuildContext context}) async {
    final response = await apiHelper.apiRequest(
        url: logoutUrl,
        dynamicMapValue: {userTypeKey: user},
        urlType: post, //put,
        context: context);

    showLog("editProfileRequest -- ${response}");
    return compute(commonMessageModelFromJson, response);
  }

  //Future<CartBillDetailsApiModel>
  Future<dynamic> callCartBillDetailsRequest({
    Map<String, String> staticMapValue,
    BuildContext mContext,
  }) async {
    showLog("RestaurantDetailsModel");
    try {
      final response = await apiHelper.apiRequest(
        url: cartBillDetail,
        staticMapValue: staticMapValue,
        urlType: getUrl,
        context: mContext,
      );

      showLog("RestaurantDetailsModel $response");

      return compute(cartBillDetailsApiModelFromJson, response);
    } on SocketException catch (error) {
      showLog("SocketException $error");
      // showSnackbar(message: CommonStrings.noInternet, context: mContext);
    } catch (error) {
      String errormessage = error.toString();
      showLog("RestaurantDetailsModelError $errormessage--${error}");

//      showInfoAlertDialog(
//          context: mContext,
//          response: parseErrorMessage(errormessage),
//          onClicked: () {
//            Navigator.pop(mContext);
//          });

      if (parseErrorMessage(errormessage).startsWith("No items in cart")) {
        return storeErrorMessage(parseErrorMessage(errormessage));
      } else {}

      if (error is SocketException) {
        showSnackbar(message: CommonStrings.noInternet, context: mContext);
      } else {
        showSnackbar(
            message: parseErrorMessage(errormessage), context: mContext);
      }

      return parseErrorMessage(errormessage);
    }
  }

  storeErrorMessage(String message) async {
    await initPref();
    prefs.setString(SharedPreferenceKeys.errorMsg, message);
  }
}
