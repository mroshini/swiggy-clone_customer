import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:foodstar/src/constants/api_params_keys.dart';
import 'package:foodstar/src/constants/api_urls.dart';
import 'package:foodstar/src/constants/common_strings.dart';
import 'package:foodstar/src/constants/route_path.dart';
import 'package:foodstar/src/constants/sharedpreference_keys.dart';
import 'package:foodstar/src/core/models/api_models/cart_bill_detail_api_model.dart';
import 'package:foodstar/src/core/models/api_models/delivery_address_model.dart';
import 'package:foodstar/src/core/models/api_models/food_items_api_model.dart';
import 'package:foodstar/src/core/models/api_models/onlinepayment_api_model.dart';
import 'package:foodstar/src/core/models/api_models/promo_code_api_model.dart';
import 'package:foodstar/src/core/models/api_models/saved_address_api_model.dart';
import 'package:foodstar/src/core/provider_viewmodels/cart_quantity_view_model.dart';
import 'package:foodstar/src/core/provider_viewmodels/common/base_change_notifier_model.dart';
import 'package:foodstar/src/core/provider_viewmodels/restaurant_details_view_model.dart';
import 'package:foodstar/src/core/service/api_repository.dart';
import 'package:foodstar/src/core/service/app_exception.dart';
import 'package:foodstar/src/ui/shared/show_snack_bar.dart';
import 'package:foodstar/src/utils/common_navigation.dart';
import 'package:foodstar/src/utils/target_platform.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartBillDetailViewModel extends BaseChangeNotifierModel {
  BuildContext context;
  var deviceId;
  String accessToken = "";
  SharedPreferences prefs;
  int userId;
  List<ACommonFoodItem> cartOrderedItems = [];
  CartBillDetailsApiModel cartBillData;
  String lat;
  String long;
  String message;

  String mobileNumber = "";
  String givenAddressForDelivery = "";
  bool changeMobileNumber = false;
  bool saveMobileNumber = false;
  bool mobileNumberEdited = false;
  List<AAddress> listOfAddress = [];
  bool isLoading = false;
  CartQuantityViewModel cartQuantityPriceProvider;
  RestaurantDetailsViewModel restaurantDetailsViewModel;
  DeliveryAddressSharedPrefModel deliveryData;
  bool cartItemChanged = false;
  String cityValue;
  String currencySymbol;
  String errorMessage;
  String currentAddress;
  bool removeOrAddItemLoader = false;
  var gotResult = false;
  Razorpay razorPay;
  BuildContext mContext;
  List<APromocode> availablePromoCodes;
  String orderIDAfterPaymentSuccess;
  String couponCode = "";

  // var options;
  String paymentMethod = "";
  String email;
  String name;
  Map<String, dynamic> onlinePayResponseFromServer;
  String orderIDValue;
  bool paymentLoader = false;
  bool cancelOrderLoader = false;

  // Box cartBox;

  // CartBillDetailsApiModel cartBoxData;

  updatePaymentLoader(bool value) {
    paymentLoader = value;
    notifyListeners();
  }

  double deliveryBoxHeight = 200;

  CartBillDetailViewModel({this.context}) {
    // givenAddressForDelivery = "";

    cartQuantityPriceProvider =
        Provider.of<CartQuantityViewModel>(context, listen: false);

    restaurantDetailsViewModel =
        Provider.of<RestaurantDetailsViewModel>(context, listen: false);
  }

  updateHeight(double height) {
    if (givenAddressForDelivery.length > 50) {
      deliveryBoxHeight = 220;
    } else {
      deliveryBoxHeight = height;
    }
    notifyListeners();
  }

  initRazorPay(BuildContext context) {
    razorPay = Razorpay();
    // context = context;

    razorPay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    razorPay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    razorPay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  checkoutOptions({Map<String, dynamic> data, BuildContext mContext}) async {
    this.mContext = mContext;
    await initPref();
    await prefs.setString(
        SharedPreferenceKeys.orderIDSharedPrefKey, data[orderIDKey].toString());
    onlinePayResponseFromServer = data;
    var razorPayOrderID = data[orderIDfromRazorPay];

    showLog(
        "onlinePayResponseFromServer--${data[orderIDfromRazorPay]} --${data[grandTotalKey]}");
    // showLog("cartBillDataGrandTotal--${cartBillData.grandTotal}");

    var options = {
      'key': RZPKEY,
//      'amount': cartBillData.grandTotal != null
//          ? (double.parse('${cartBillData.grandTotal}').roundToDouble() * 100)
//              .toString()
//          : "",
      'amount': data[grandTotalKey] != null
          ? (double.parse('${data[grandTotalKey]}').roundToDouble() * 100)
          : "",

      'name': name,
      'description': 'To pay',
      'order_id': '${razorPayOrderID}', //'${data[orderIDfromRazorPay]}',
      'prefill': {
        'contact': mobileNumber,
        'email': email,
      },
    };

    try {
      razorPay.open(options);
    } catch (e) {}
  }

  refreshAfterDeleteUnAvailableItems({
    String ids,
  }) {
    if (ids.contains(",")) {
      showLog("refreshAfterDeleteUnAvailableItemsIF--${ids}");
      // List<int> unAvailableIds;

      var unAvailableIds = ids.split(',');
      showLog("refreshAfterDeleteUnAvailableItemsIF--${unAvailableIds}");

//      ids.split(",").map((e) => {
//            // e.trim(),
//            showLog("refreshAfterDeleteUnAvailableItemsIF--${e}"),
//            // unAvailableIds.add(int.parse(e)),
//          });
      showLog("refreshAfterDeleteUnAvailableItemsIF--${unAvailableIds}");

      for (var id in unAvailableIds) {
        showLog("refreshAfterDeleteUnAvailableItemsIIdd--${id}");
        for (var cartItems in cartOrderedItems) {
          if (id == cartItems.id.toString()) {
            showLog(
                "refreshAfterDeleteUnAvailableItemsIF--${cartItems.id}--${id}");
            cartOrderedItems.remove(cartItems);
            break;
          } else {}
        }
      }
    } else {
      showLog("refreshAfterDeleteUnAvailableItemselse--${ids}");
      var id = int.parse(ids);
      for (var cartItems in cartOrderedItems) {
        if (id == cartItems.id) {
          showLog("refreshAfterDeleteUnAvailableItemselseeee--${cartItems}");
          cartOrderedItems.remove(cartItems);
          break;
        }
      }
      cartBillData.unavailableFoodIds = "";
    }

    notifyListeners();
  }

  saveDeliveryMobileNumber({String number, int status}) async {
    await initPref();
    String mobile =
        prefs.getString(SharedPreferenceKeys.deliveryReferenceMobileNumber) ??
            "";
    if (mobile.isEmpty) {
      prefs.setString(
          SharedPreferenceKeys.deliveryReferenceMobileNumber, number);
    } else {
      if (status == 1) {
        //1-from edit or 2 -from saved
        prefs.setString(
            SharedPreferenceKeys.deliveryReferenceMobileNumber, number);
      } else {
//        if (mobile == number) {
//        } else {
//          prefs.setString(
//              SharedPreferenceKeys.deliveryReferenceMobileNumber, number);
//        }
      }
    }

    mobileNumber =
        prefs.getString(SharedPreferenceKeys.deliveryReferenceMobileNumber) ??
            "";
    notifyListeners();
  }

  Future<String> cancelOrder({
    BuildContext buildContext,
    Map<String, dynamic> dynamicMapValue,
  }) async {
    updateCancelOrderLoader(true);
    String message;
    try {
      await ApiRepository(mContext: context)
          .cancelOrder(dynamicMapValue: dynamicMapValue, mContext: buildContext)
          .then((value) => {
                if (value != null)
                  {
                    message = value.message,
                    updateCancelOrderLoader(false),
                    //  availablePromoCodes = value.aPromocode,
                  }
              });

      return message;
    } catch (e) {
      updateCancelOrderLoader(false);
      return null;
    }
  }

  updateCancelOrderLoader(bool value) {
    cancelOrderLoader = value;
    notifyListeners();
  }

  callAvailablePromosRequest({BuildContext context}) async {
    showLog("callAvailablePromosRequest--${accessToken}");
    if (accessToken.isNotEmpty || accessToken != null) {
      try {
        await ApiRepository(mContext: context)
            .availablePromosRequest(context)
            .then((value) => {
                  if (value != null)
                    {
                      availablePromoCodes = value.aPromocode,
                    }
                });
      } catch (e) {}
    }
  }

  setPaymentType() async {
    await initPref();
    if (prefs.getInt(SharedPreferenceKeys.paymentType) == null) {
      paymentMethod = "";
    } else {
      paymentMethod = prefs.getInt(SharedPreferenceKeys.paymentType) == 0
          ? CommonStrings.onlinePayment
          : CommonStrings.cash;
    }
    notifyListeners();
  }

  removeOrderId() async {
    await initPref();
    prefs.remove(SharedPreferenceKeys.orderIDSharedPrefKey);
  }

  _handlePaymentSuccess(PaymentSuccessResponse response) async {
    // Do something when payment succeeds
    showLog(
        "_handlePaymentSuccess--${response.orderId}--${response.paymentId}");
    await initPref();
    orderIDValue = prefs.getString(SharedPreferenceKeys.orderIDSharedPrefKey);
    var successResponse;
    try {
      // updateLoader(true);
      updatePaymentLoader(true);
      await proceedOrderRequest(
        {
          // orderNoteKey: onlinePayResponseFromServer[orderNoteKey],
          deviceKey: fetchTargetPlatform(),
          paymentTypeKey: razorPayPaymentType,
          // mobileNumKey: onlinePayResponseFromServer[mobileNumKey],
          actionKey: paySuccess,
          orderIDKey: orderIDValue,
          userTypeKey: user
        },
        mContext,
      ).then((value) async => {
            updateCartData(),
            //  isLoading = false,
            showLog("OrderID--${value.aOrder.id}"),

            Navigator.of(mContext)
                .popAndPushNamed(successOrder, arguments: "${value.aOrder.id}"),
            showLog("OrderID1--${value.aOrder.id}"),
            updateSuccessOrFailure(value.aOrder.id),
            //  updateLoader(false),
            updatePaymentLoader(false),
          });
    } on BadRequestException catch (e) {
      showLog("error--${e}");
      showInfoAlertDialog(
          context: mContext,
          response: e.toString(),
          onClicked: () {
            Navigator.pop(mContext);
          });
      updateSuccessOrFailure(null);
      // updateLoader(false);
    } catch (e) {
      showLog("error--${e}");

      updateSuccessOrFailure(null);
    }
    updateLoader(false);

    updatePaymentLoader(false);
    await removeData();
    await removeOrderId();
    notifyListeners();
  }

  updateSuccessOrFailure(String orderID) {
    context = context;
    // orderIDAfterPaymentSuccess = orderID;
    notifyListeners();
  }

  void _handlePaymentError(PaymentFailureResponse response) async {
    // Do something when payment fails
    //currentTrackOrderApiRequest(mContext);

    await removeData();
    await removeOrderId();
    navigateToHome(context: mContext);

    showLog(
        "_handlePaymentError--${mobileNumber}--${email}--${cartBillData.grandTotal}-- ${response.message}");

    //checkoutOptions();
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet was selected
    showLog("_handleExternalWallet--${response.walletName}");
  }

  currentTrackOrderApiRequest(BuildContext context) async {
    if (accessToken.isNotEmpty) {
      try {
        await ApiRepository(mContext: context)
            .currentOrdersApiRequest(context)
            .then((value) => {
                  if (value != null)
                    {
//              trackOrder = value.aTrackOrder,
//              payOrder = value.aPayOrder,
//              currentOrderLoading = true,
                    }
                });
      } catch (e) {
        showLog("currentTrackOrderApiRequest--${e}");
      }
      notifyListeners();
    }
  }

  initPref() async {
    if (prefs == null) prefs = await SharedPreferences.getInstance();
  }

  updateLoader(bool value) {
    isLoading = value;

    notifyListeners();
  }

//  initBox() async {
//    try {
//      if (cartBox == null || !cartBox.isOpen) {
//        showLog("initBox --");
//        cartBox = await Hive.openBox(cartHive);
//      } else {
//        if (cartBox != null && cartBox.isOpen) {
//          showLog("initBox2 --");
//
//          cartBox = Hive.box(cartHive);
//        } else {
////          showLog("initBox3 --");
////          restaurantDetailsBox = await Hive.openBox<HomeRestaurantListApiModel>(
////              homeRestaurantListHive);
//        }
//      }
//    } catch (e) {
//      showLog("initBox24 --");
//      cartBox = await Hive.openBox(cartHive);
//    }
//  }

  refreshScreenAfterFoodOrRestaurantDelete({String action, int index}) async {
    if (action == restaurantDelete) {
      cartOrderedItems = [];
      removeData();
    } else {
      cartOrderedItems.removeAt(index);
    }

    notifyListeners();
  }

  setFoodItemsNotAvailable({int index}) async {
    cartOrderedItems[index].availability.status = 0;
    notifyListeners();
  }

  setRestaurantNotAvailable({int index}) async {
    for (var cartItems in cartOrderedItems) {
      cartItems.availability.status = 0;
    }
    cartBillData.restaurant.availability.status = 0;

    notifyListeners();
  }

  getDeliveryAddressDataFromPref() async {
    await initPref();
    if (prefs.containsKey(SharedPreferenceKeys.deliveryDataSharedPrefKey)) {
      deliveryData = DeliveryAddressSharedPrefModel.fromJson(
        await json.decode(
            prefs.getString(SharedPreferenceKeys.deliveryDataSharedPrefKey) ??
                ""),
      );

      givenAddressForDelivery = deliveryData.address;

      if (givenAddressForDelivery.length > 50) {
        deliveryBoxHeight = 220;
      } else {
        deliveryBoxHeight = 200;
      }
      notifyListeners();
    }
  }

  updateAddress(DeliveryAddressSharedPrefModel address) async {
    await initPref();
    if (address != null) {
      showLog(
          "updateAddress ${address.latitude}-- ${address.distance} -- ${address.addressId} ");
      givenAddressForDelivery = address.address;

      prefs.setString(
        SharedPreferenceKeys.deliveryDataSharedPrefKey,
        json.encode(address),
      );
//      await prefs.setString(SharedPreferenceKeys.givenAddressForDelivery,
//          givenAddressForDelivery);
      showLog("updateAddress ${address.latitude}-- ${address.distance}");
      await getDeliveryAddressDataFromPref();
//      givenAddressForDelivery =
//          prefs.getString(SharedPreferenceKeys.givenAddressForDelivery);
    } else {
      await getDeliveryAddressDataFromPref();
    }
    notifyListeners();
  }

  dynamic addToDeliveryFee(dynamic value) {
    return cartBillData.deliveryCharge + value;
  }

  Future<String> getErrorMessage() async {
    await initPref();
    return prefs.getString(SharedPreferenceKeys.errorMsg) ?? "";
  }

  checkUserLoggedInOrNot(
      {BuildContext context, bool showShimmer = true}) async {
    await initPref();
    getDeliveryAddressDataFromPref();
    userId = prefs.getInt(SharedPreferenceKeys.userId) ?? 0;
    accessToken = prefs.getString(SharedPreferenceKeys.accessToken) ?? "";
    lat = prefs.getString(SharedPreferenceKeys.latitude) ?? "";
    long = prefs.getString(SharedPreferenceKeys.longitude) ?? "";

//    cityValue =
//        accessToken = prefs.getString(SharedPreferenceKeys.accessToken) ?? "";
    lat = prefs.getString(SharedPreferenceKeys.latitude) ?? "";
    long = prefs.getString(SharedPreferenceKeys.longitude) ?? "";
    userId = prefs.getInt(SharedPreferenceKeys.userId) ?? 0;
    cityValue = prefs.getString(SharedPreferenceKeys.city) ?? "";
    currencySymbol = prefs.getString(SharedPreferenceKeys.currencySymbol) ?? "";
    currentAddress =
        prefs.getString(SharedPreferenceKeys.currentLocationMarked) ?? "";
    context = context;
    initCartBillDetailRequest(
      addressData: {
        addressChangeKey: "0",
        latKey: lat,
        longKey: long,
      },
      showShimmer: showShimmer,
      mContext: context,
    );

    // initSavedAddressRequest();
  }

  editMobileNumber(bool value) {
    changeMobileNumber = value;

    notifyListeners();
  }

  saveMobileNumberStatus(bool value) {
    saveMobileNumber = value;
    notifyListeners();
  }

  Future<OnlinePaymentApiModel> proceedOrderRequest(
      Map<String, dynamic> dynamicMapValue, BuildContext mContext) async {
    var successMessage;
    //updateLoader(true);
    updatePaymentLoader(true);
    try {
      await ApiRepository(mContext: context)
          .initProceedConfirmOrder(dynamicMapValue, mContext)
          .then((value) => {
                successMessage = value,
                //  updateLoader(false),
                updatePaymentLoader(false),
              });
      return successMessage;
    } catch (e) {
      showLog("proceedOrderRequestBadRequestException--${e}");
      throw BadRequestException(e);
    }
  }

//  Future<OnlinePaymentApiModel> onlinePaymentRequest(
//      Map<String, dynamic> dynamicMapValue, BuildContext mContext) async {
//    updateLoader(true);
//    var result;
//    try {
//      await ApiRepository(mContext: context)
//          .initOnlinePaymentRequest(dynamicMapValue, mContext)
//          .then((value) => {
//                result = value,
//                updateLoader(false),
//              });
//      return result;
//    } catch (e) {
//      showLog("proceedOrderRequestBadRequestException--${e}");
//      throw BadRequestException(e);
//    }
//  }

  isMobileNumberEdited() {
    mobileNumberEdited = true;
    notifyListeners();
  }

//  updateNumber(String value) {
//    mobileNumber = value;
//    notifyListeners();
//  }

//  initSavedAddressRequest() async {
//    //loggedin
//
//    if (accessToken.isNotEmpty) {
//      setState(BaseViewState.Busy);
//      try {
//        await ApiRepository(mContext: context)
//            .initSavedAddressRequest(staticMapValue: {
//          latitudeKey: lat,
//          longitudeKey: long,
//        }).then((value) => {
//                  listOfAddress = value.aAddress,
//                  showLog("givenAddressForDelivery $givenAddressForDelivery"),
//                });
//      } catch (e) {}
//
//      setState(BaseViewState.Idle);
//      notifyListeners();
//    }
//  }

  bool removeCouponLoader = false;

//  getDeliveryAddressDataFromPref() async {
//    await initPref();
//    if (prefs.containsKey(SharedPreferenceKeys.deliveryDataSharedPrefKey)) {
//      deliveryData = DeliveryAddressSharedPrefModel.fromJson(
//        await json.decode(
//            prefs.getString(SharedPreferenceKeys.deliveryDataSharedPrefKey) ??
//                ""),
//      );
//    }
//  }

  Future<String> initCartBillDetailRequest(
      {Map<String, String> addressData,
      BuildContext mContext,
      bool removeCoupon = false,
      bool showShimmer = true}) async {
    await initPref();
    deviceId = await fetchDeviceId();
    userId = prefs.getInt(SharedPreferenceKeys.userId) ?? 0;
    accessToken = prefs.getString(SharedPreferenceKeys.accessToken) ?? "";

    if (!removeCoupon) {
      if (addressData == null && showShimmer) {
        showLog("initCartBillDetailRequestaddressData1---${addressData}");

        setState(BaseViewState.Busy);
      } else {
        showLog("initCartBillDetailRequestaddressData2---${addressData}");
        if (addressData[addressChangeKey] != null &&
            addressData[addressChangeKey] != "1") {
          if (showShimmer) {
            setState(BaseViewState.Busy);
          }
        }
      }
      await callCartRequest(addressData: addressData, mContext: mContext)
          .then((value) => {
                message = value,
              });
    } else {
      removeCouponLoader = true;
      notifyListeners();
      await callCartRequest(
              addressData: deliveryData == null
                  ? {
                      promoCodeKey: "",
                      addressChangeKey: "0",
                      removePromoKey: "1",
                    }
                  : {
                      latKey: deliveryData.latitude.toString(),
                      longKey: deliveryData.longitude.toString(),
                      addressKey: deliveryData.address,
                      stateKey: deliveryData.state,
                      addressChangeKey: "2",
                      buildingKey: deliveryData.building,
                      landmarkKey: deliveryData.landmark,
                      addressTypeKey: deliveryData.addressType,
                      cityKey: deliveryData.city,
                      promoCodeKey: "",
                      removePromoKey: "1",
                      distance: deliveryData.distance,
                      durationTextKey: deliveryData.durationText,
                    },
              mContext: mContext)
          .then((value) => {
                message = value,
                //  showLog("callCartRequest--${message}"),
              });
    }

    // await initBox();

    // message = car);
    removeCouponLoader = false;
    setState(BaseViewState.Idle);

//    try {
//      await ApiRepository(mContext: context)
//          .callCartBillDetailsRequest(staticMapValue: {
//        deviceIDKey: deviceId,
//        userIdKey: userId.toString(),
//        addressChangeKey: addressData[addressChangeKey] ?? "0",
//        addressKey: addressData[addressKey] ?? "",
//        distanceKey: addressData[distanceKey] ?? "",
//        durationTextKey: "",
//        promoCodeKey: "",
//        latKey: addressData[latKey] ?? "",
//        longKey: addressData[longKey] ?? "",
//        stateKey: addressData[stateKey] ?? "",
//        addressIdKey: addressData[addressIdKey],
//        buildingKey: addressData[buildingKey] ?? "",
//        addressTypeKey: addressData[addressTypeKey] ?? "",
//        landmarkKey: addressData[landmarkKey] ?? "",
//        cityKey: cityValue, //addressData[cityKey] ?? "",
//      }, mContext: mContext).then((value) async => {
//                showLog("givenAddressForDelivery11qq ${value}"),
//                cartBillData = value != null ? value : "",
//                mobileNumber = value.phoneNumber != null
//                    ? value.phoneNumber.toString()
//                    : "",
//                message = value.message,
//
//                cartOrderedItems =
//                    value.aCartItems != null ? value.aCartItems : [],
//                await cartQuantityPriceProvider.updateCartQuantity(
//                    aCart: value.aCart, progress: false),
//
//                showLog("CartItems1 ${cartOrderedItems.length}"),
//                if (addressData[addressChangeKey] != "0")
//                  {
//                    showLog("givenAddressForDelivery ${value.address}"),
//                    givenAddressForDelivery = value.address.toString(),
////                        prefs.setString(
////                            SharedPreferenceKeys.givenAddressForDelivery,
////                            givenAddressForDelivery)
//                  }
//                else
//                  {},
////                if (value != null)
////                  {
////
////                  }
////                else
////                  {message = null
////
////                  }
//              });
//    } catch (e) {
//      showLog("CartItems $e");
//      cartOrderedItems = [];
//    }

//    cartBoxData = await cartBox.get(0) as CartBillDetailsApiModel;

    //  showLog("callCartRequest--${cartBoxData.phoneNumber}");

//    if (cartBoxData != null) {
//      // showLog("callCartRequest--${cartBoxData.phoneNumber}");
//      await loadFromDb();
//      await callCartRequest(addressData: addressData, mContext: mContext)
//          .then((value) => {
//                message = value,
//                //  showLog("callCartRequest--${message}"),
//              }); // message = car);
//    } else {
//      if (addressData[addressChangeKey] != "1") {
//        setState(BaseViewState.Busy);
//      }
//      //setState(BaseViewState.Busy);
//      await callCartRequest(addressData: addressData, mContext: mContext)
//          .then((value) => {
//                message = value,
//              }); // message = value);
//      //await loadFromDb();
//      setState(BaseViewState.Idle);
//    }

    notifyListeners();
    return message;
  }

  bool isCartItemChanged = false;

  showLoader(bool value) {
    isCartItemChanged = value;
    notifyListeners();
  }

//  Future loadFromDb() async {
//    //await initBox();
//    //cartBoxData = await cartBox.get(0) as CartBillDetailsApiModel;
//    if (cartBoxData != null) {
//      cartBillData = cartBoxData;
//      mobileNumber = cartBillData.phoneNumber.toString();
//      message = cartBillData.message;
//      cartOrderedItems = cartBillData.aCartItems;
//
//      await cartQuantityPriceProvider.updateCartQuantity(
//          aCart: cartBillData.aCart, progress: false);
//    }
//
//    notifyListeners();
//  }

  Future<String> callCartRequest(
      {Map<String, String> addressData, BuildContext mContext}) async {
    await initPref();
    var data;

    try {
      await ApiRepository(mContext: context)
          .callCartBillDetailsRequest(staticMapValue: {
        deviceIDKey: deviceId,
        userIdKey: userId.toString(),
        addressChangeKey: addressData[addressChangeKey] == null
            ? "0"
            : addressData[addressChangeKey],
        addressKey: addressData[addressKey] ?? "",
        distanceKey: addressData[distanceKey] ?? "",
        durationTextKey: addressData[durationTextKey] ?? "",
        promoCodeKey: addressData[promoCodeKey] ?? "",
        latKey: addressData[latKey] ?? "",
        longKey: addressData[longKey] ?? "",
        stateKey: addressData[stateKey] ?? "",
        addressIdKey: addressData[addressIdKey],
        buildingKey: addressData[buildingKey] ?? "",
        addressTypeKey: addressData[addressTypeKey] ?? "",
        landmarkKey: addressData[landmarkKey] ?? "",
        cityKey: addressData[cityKey] ?? "",
        removePromoKey: addressData[removePromoKey] ?? "",
      }, mContext: mContext).then((value) async => {
                // showLog("givenAddressForDelivery11qq ${value}"),
//                await initBox(),
//                await cartBox.clear(),
//                data = value as CartBillDetailsApiModel,
//
//                await cartBox.add(data),
//                await loadFromDb(),
//                message = "success",

                cartBillData = value != null ? value : "",
                couponCode = cartBillData.selectedCouponCode,
                showLog(
                    "durationTextKeydurationTextKey--${cartBillData.restaurant.promoStatus}--${accessToken}"),

                if (value.aUser != null)
                  {
                    await saveDeliveryMobileNumber(
                        number: value.aUser.phoneNumber != null
                            ? value.aUser.phoneNumber.toString()
                            : "",
                        status: 2),
                    //mobileNumber = ,
                    email = value.aUser.email,
                    name = value.aUser.username,
                  },
                message = value.message,

                cartOrderedItems =
                    value.aCartItems != null ? value.aCartItems : [],
                await cartQuantityPriceProvider.updateCartQuantity(
                    aCart: value.aCart, progress: false),

                // givenAddressForDelivery = cartBillData.address,
//        if(cartBillData.address != ""){
//          prefs.remove(SharedPreferenceKeys.deliveryDataSharedPrefKey),
//        },

//                showLog("CartItems1 ${cartOrderedItems.length}"),

                if (addressData[addressChangeKey] != "0" &&
                    addressData[addressChangeKey] != null)
                  {
                    showLog("givenAddressForDelivery ${value.address}"),
                    givenAddressForDelivery = value.address.toString(),
//                        prefs.setString(
//                            SharedPreferenceKeys.givenAddressForDelivery,
//                            givenAddressForDelivery)
                  }
                else
                  {},

                if (addressData[removePromoKey] == "1")
                  {
                    removeCoupon(),
                  },

                notifyListeners()

//                if (value != null)
//                  {
//
//                  }
//                else
//                  {message = null
//
//                  }
              });
    } on SocketException catch (error) {
      showSnackbar(message: CommonStrings.noInternet, context: mContext);
    } catch (e) {
      message = null;
      showLog("CartItems $e");
      var error = prefs.getString(SharedPreferenceKeys.errorMsg) ?? "";
      showLog("CartItems11 $error");
      if (error.startsWith("No items in cart")) {
        cartOrderedItems = [];
        prefs.remove(SharedPreferenceKeys.errorMsg);
        removeData();
      } else if (e == null) {
        cartOrderedItems = [];
//        prefs.remove(SharedPreferenceKeys.givenAddressForDelivery);
//        prefs.remove(SharedPreferenceKeys.deliveryDataSharedPrefKey);
      }
      //cartOrderedItems = [];
    }

    notifyListeners();
    return message;
  }

  removeCoupon() async {
    await initPref();
    prefs.remove(SharedPreferenceKeys.availablePromoCoupons);
    couponCode = "";
    notifyListeners();
  }

  initAddItemFromCart({int index, int parentIndex}) {
    cartOrderedItems[index].cartDetail.quantity =
        cartOrderedItems[index].cartDetail.quantity + 1;
    cartBillData.itemPrice =
        cartBillData.itemPrice + cartOrderedItems[index].sellingPrice;
    cartBillData.grandTotal =
        cartBillData.grandTotal + cartOrderedItems[index].sellingPrice;
    notifyListeners();
  }

  deleteItem({int index, int parentIndex}) {
    cartOrderedItems[index].cartDetail.quantity = 0;
    notifyListeners();
  }

//  updateCartAfterCancelExistCartRemoveDialog({int index, int parentIndex}) {
//    showLog("SearchViewModel");
//    listOfDishData[parentIndex].foodItemView[index].cartQuantity = 0;
//    notifyListeners();
//  }

  addAndRemoveFoodPrice(
      {int index,
      int parentIndex,
      bool addOrRemove,
      bool isbottomSheet = false,
      int foodId}) async {
    await initPref();

    var foodOriginalPrice = cartOrderedItems[index].sellingPrice > 0
        ? cartOrderedItems[index].sellingPrice
        : cartOrderedItems[index].price;

    int quantity = cartOrderedItems[index].cartDetail.quantity;

    showLog("updateFoodPrice -- ${cartOrderedItems[index].showPrice}");

    if (addOrRemove) {
      // Add
      //foodPrice = foodPrice + newFoodPrice;
//      cartOrderedItems[index].showPrice = (double.parse(
//                cartOrderedItems[index].showPrice,
//              ) +
//              foodOriginalPrice.toDouble())
//          .toString();

      showLog("Quantity--${quantity}");

      cartBillData.itemPrice = cartBillData.itemPrice + foodOriginalPrice;

      cartBillData.grandTotal =
          cartBillData.grandTotal + cartOrderedItems[index].sellingPrice;

      cartOrderedItems[index].cartDetail.quantity = quantity + 1;
    } else {
//      if (double.parse(
//            cartOrderedItems[index].showPrice,
//          ) >
//          foodOriginalPrice.toDouble()) {
//        cartOrderedItems[index].showPrice = (double.parse(
//                  cartOrderedItems[index].showPrice,
//                ) -
//                foodOriginalPrice.toDouble())
//            .toString();
//      }
      showLog("QuantityNegative--${quantity}");

      if (quantity > 0) {
        // Remove

        cartBillData.itemPrice = cartBillData.itemPrice - foodOriginalPrice;
        cartBillData.grandTotal =
            cartBillData.grandTotal - cartOrderedItems[index].sellingPrice;

        cartOrderedItems[index].cartDetail.quantity = quantity - 1;

        if (cartOrderedItems[index].cartDetail.quantity == 0) {
          showLog("updateFoodPrice1 -- ${index}");
          cartOrderedItems.removeAt(index);
          await removeData();
          await removeItem(foodId);
        }
      }
    }

    notifyListeners();
  }

  removeItem(int foodID) {
//    cartOrderedItems.removeAt(index);
//
//    if (cartOrderedItems.length == 0) {
//      cartOrderedItems = [];
//    }
    showLog("FoooodddID 1-- ${foodID}");
    if (cartOrderedItems.length == 0) {
      cartQuantityPriceProvider.quantity = "0";
    }

    for (int outer = 0;
        outer <= restaurantDetailsViewModel.catFoodItemsData.length - 1;
        outer++) {
      for (int inner = 0;
          inner <=
              restaurantDetailsViewModel
                      .catFoodItemsData[outer].aFoodItems.length -
                  1;
          inner++) {
        if (restaurantDetailsViewModel
                .catFoodItemsData[outer].aFoodItems[inner].id ==
            foodID) {
          showLog("FoooodddID -- ${foodID}");
          restaurantDetailsViewModel.catFoodItemsData[outer].aFoodItems[inner]
              .cartDetail.quantity = 0;
        } else {
          showLog("FoooodddID3 -- ${foodID}");
        }
      }
    }
    notifyListeners();
  }

  removeFromCart(
      {int index,
      int parentIndex,
      bool addOrRemove,
      bool isbottomSheet = false}) {
    if (cartOrderedItems[index].cartDetail.quantity == 0 && !isbottomSheet) {
      showLog("updateFoodPrice1 -- ${index}");
      cartOrderedItems.removeAt(index);
    }
    notifyListeners();
  }

  updateCouponValue(String value) async {
    await initPref();
    couponCode =
        value; //prefs.getString(SharedPreferenceKeys.availablePromoCoupons);
    notifyListeners();
  }

  updateCartData() async {
    await initPref();
    cartOrderedItems = [];
    cartQuantityPriceProvider.quantity = "0";
    removeData();

    // await removeFromDisk();
    notifyListeners();
  }

  removeData() async {
    await initPref();
    await prefs.remove(SharedPreferenceKeys.deliveryDataSharedPrefKey);
    await prefs.remove(SharedPreferenceKeys.givenAddressForDelivery);
    await prefs.remove(SharedPreferenceKeys.availablePromoCoupons);
    await prefs.remove(SharedPreferenceKeys.paymentType);
    await prefs.remove(SharedPreferenceKeys.orderIDSharedPrefKey);
    await prefs.remove(SharedPreferenceKeys.deliveryReferenceMobileNumber);
    removeCoupon();
    notifyListeners();
  }

  updateItemNotes({int index, int parentIndex, String itemNotes}) {
    cartOrderedItems[index].cartDetail.itemNote = itemNotes;
    notifyListeners();
  }

  Future<bool> cartActionsRequest(
      {String foodId = "",
      String action = "",
      BuildContext mContext,
      String itemNotes = "",
      String restaurantID = ""}) async {
    try {
      removeOrAddItemLoader = true;
      cartQuantityPriceProvider.updateProgress(true);

      await initPref();

      userId = prefs.getInt(SharedPreferenceKeys.userId) ?? 0;
      deviceId = await fetchDeviceId();
      showLog("removeOrAddItemLoader1");
      await ApiRepository(mContext: context).callCartActionRequest(
        dynamicMapValue: {
          deviceIDKey: deviceId,
          userIdKey: userId.toString(),
          foodIdKey: foodId.toString(),
          restaurantIdKey: restaurantID,
          actionKey: action,
          itemNotesKey: itemNotes
        },
        mContext: mContext,
        fromWhere: 3,
      ).then((value) async => {
            showLog("removeOrAddItemLoader2"),
            await cartQuantityPriceProvider.updateCartQuantity(
              aCart: value.aCart,
              progress: false,
            ),
            // cartBillData=value,
            //  cartBillData.itemOriginalPrice = value.foodItemView. != null ? value : "",
            cartBillData.grandTotal =
                cartQuantityPriceProvider.cartQuantityData.totalPrice,
            updateRestaurantModel(value.foodItemView, foodId),
            removeOrAddItemLoader = false,
            gotResult = true,
          });
      return gotResult;
      notifyListeners();
    } catch (e) {
      showLog("cartActionsRequestFromSearch $e");
//      cartQuantityPriceProvider.updateCartQuantity(
//        aCart: null,
//        progress: false,
//      );
      //  updateRestaurantModel(null, foodId);
//      removeOrAddItemLoader = false;
//      gotResult = false;
      throw BadRequestException(e.toString());
    }
  }

  initLoader(bool value) {
    removeOrAddItemLoader = value;
    notifyListeners();
  }

  updateRestaurantModel(List<ACommonFoodItem> foodItems, String foodID) {
//    showLog(
//        "updateRestaurantModel --${foodItems.length} ${foodItems[0].foodItem}");

    showLog("updateRestaurantModel11 - ");

    for (int cart = 0; cart <= foodItems.length - 1; cart++) {
      for (int outer = 0;
          outer <= restaurantDetailsViewModel.catFoodItemsData.length - 1;
          outer++) {
        for (int inner = 0;
            inner <=
                restaurantDetailsViewModel
                        .catFoodItemsData[outer].aFoodItems.length -
                    1;
            inner++) {
          if (restaurantDetailsViewModel
                  .catFoodItemsData[outer].aFoodItems[inner].id ==
              foodItems[cart].id) {
            restaurantDetailsViewModel.catFoodItemsData[outer].aFoodItems[inner]
                .cartDetail.quantity = foodItems[cart].cartDetail.quantity;
          }
        }
      }
    }

//    if (foodItems != null) {
//
//    } else {
//      showLog("updateRestaurantModel11--- ${foodID}");
//      for (int outer = 0;
//          outer <= restaurantDetailsViewModel.catFoodItemsData.length - 1;
//          outer++) {
//        for (int inner = 0;
//            inner <=
//                restaurantDetailsViewModel
//                        .catFoodItemsData[outer].aFoodItems.length -
//                    1;
//            inner++) {
//          if (restaurantDetailsViewModel
//                  .catFoodItemsData[outer].aFoodItems[inner].id ==
//              foodID) {
//            restaurantDetailsViewModel.catFoodItemsData[outer].aFoodItems[inner]
//                .cartDetail.quantity = 0;
//          }
//        }
//      }
//    }

    notifyListeners();
  }

//  removeFromDisk() async {
//    await initBox();
//    await cartBox.clear();
//  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

//  updateFoodItemsDataChangeDoneFromCart() {
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

}
