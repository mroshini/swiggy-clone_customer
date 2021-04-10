import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodstar/src/constants/api_params_keys.dart';
import 'package:foodstar/src/constants/api_urls.dart';
import 'package:foodstar/src/constants/route_path.dart';
import 'package:foodstar/src/constants/sharedpreference_keys.dart';
import 'package:foodstar/src/core/models/api_models/delivery_address_model.dart';
import 'package:foodstar/src/core/models/api_models/google_places_api_model.dart';
import 'package:foodstar/src/core/models/api_models/saved_address_api_model.dart';
import 'package:foodstar/src/core/provider_viewmodels/common/base_change_notifier_model.dart';
import 'package:foodstar/src/core/provider_viewmodels/map_address_location_view_model.dart';
import 'package:foodstar/src/core/service/api_repository.dart';
import 'package:foodstar/src/core/service/database/database_helper.dart';
import 'package:foodstar/src/core/service/hive_database/hive_constants.dart';
import 'package:foodstar/src/utils/google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SavedAddressViewModel extends BaseChangeNotifierModel {
  bool isFetchingData = true;
  BuildContext context;
  String accessToken = "";
  SharedPreferences prefs;
  int userId;
  String lat;
  String long;
  List<AAddress> listOfAddress = [];
  String address;
  MapAddressLocationViewModel mapModel;
  bool isLoading = false;
  Box saveEditAddressBox;
  DeliveryAddressSharedPrefModel deliveryData;
  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);
  bool isSearching = true;
  DBHelper dbHelper;
  List<GooglePlacesApiModel> googleSearchedPlaces;

  SavedAddressViewModel({this.context}) {
    showLog("SavedAddressViewModel");
    initDbHelper();
    // mapModel = Provider.of<MapAddressLocationViewModel>(context, listen: false);
    //checkUserLoggedInOrNot();
  }

  initPref() async {
    if (prefs == null) prefs = await SharedPreferences.getInstance();
  }

  initDbHelper() {
    dbHelper = DBHelper.instance;
  }

  checkUserLoggedInOrNot(
      {BuildContext context,
      Map<String, String> argumentsData,
      String latitude,
      String longitude}) async {
    await initPref();
    userId = prefs.getInt(SharedPreferenceKeys.userId) ?? 0;
    accessToken = prefs.getString(SharedPreferenceKeys.accessToken) ?? "";
    if (argumentsData[fromWhichScreen] == "2") {
      lat = argumentsData[latitudeKey];
      long = argumentsData[longitudeKey];
    } else {
      lat = prefs.getString(SharedPreferenceKeys.latitude) ?? "";
      long = prefs.getString(SharedPreferenceKeys.longitude) ?? "";
    }

    initSavedAddressRequest(context: context);
  }

  Future<String> editOrDeleteAddress(
      {Map<String, dynamic> dynamicMapValue,
      String oldAddress,
      @required BuildContext mContext}) async {
    try {
      saveEditAddressBox = Hive.box<AAddress>(savedEditAddressHive);
    } catch (e) {
      saveEditAddressBox = await _openBox(savedEditAddressHive);
    }
    var message;
    isLoading = true;
    try {
      await ApiRepository(mContext: context)
          .editOrDeleteAddressRequest(
              dynamicMapValue: dynamicMapValue, mContext: mContext)
          .then((value) async => {
                if (value != null)
                  {
                    isLoading = false,
                    message = value.message,
                    showLog(
                        "dynamicMapValue1--${dynamicMapValue[actionKey]}==${dynamicMapValue[addressKey]}"),
                    if (dynamicMapValue[actionKey] == addAddress)
                      {
                        showLog(
                            "dynamicMapValue--${dynamicMapValue[actionKey]}"),
                        await saveAddressInDB(value.aAddress),
                      }
                    else if (dynamicMapValue[actionKey] == editAddress)
                      {
                        await updateAddressInDB(
                            value.aAddress, dynamicMapValue[addressIdKey]),
                        await editAddressExistsInDeliveryAddressDataFromPref(
                          oldAddress: oldAddress.toString(),
                          data: DeliveryAddressSharedPrefModel(
                            latitude: value.aAddress[0].lat.toString(),
                            longitude: value.aAddress[0].lang.toString(),
                            address: value.aAddress[0].address.toString(),
                            state: value.aAddress[0].state.toString(),
                            building: value.aAddress[0].building.toString(),
                            landmark: value.aAddress[0].landmark.toString(),
                            addressType:
                                value.aAddress[0].addressType.toString(),
                            city: value.aAddress[0].city.toString(),
                            distance: value.aAddress[0].distance.toString(),
                          ),
                        ),
                      }
                    else
                      {
                        await deleteAddressFromDb(dynamicMapValue[addressIdKey])
                      },
                    listOfAddress = saveEditAddressBox.values.toList()
                  }
                else
                  {
                    isLoading = false,
                  }
              });
    } catch (e) {
      isLoading = false;
      showLog("ListofAddressese -- ${e}");
    }
    notifyListeners();
    return message;
  }

  getSearchResults(String query) async {
    String BaseUrlForSearch =
        'https://maps.googleapis.com/maps/api/places/autocomplete/json';
    String type = '(regions)';

    String request =
        '$BaseUrlForSearch?input=$query&key=$kGoogleApiKey&type=$type';

    http.Response response = await http.get(request);

    showLog("getSearchResults--${response}--${response.body}");
  }

  Future<void> handleSearchButton(
      BuildContext context, String fromWhichScreen) async {
    showLog("handleSearchButton--${fromWhichScreen}");
    try {
      //  final center = await getLocation();
      Prediction p = await PlacesAutocomplete.show(
        context: context,
        //  strictbounds: center == null ? false : true,
        apiKey: kGoogleApiKey,
        //onError: onError,
        mode: Mode.overlay,

        language: "en",
        // components: [Component(Component.country, 'in')],
//          language: "pt",
//          components: [new Component(Component.country, "mz")]
//          location: center == null
//              ? null
//              : Location(center.latitude, center.longitude),
        //    radius: center == null ? null : 10000
      );

      try {
        displayPrediction(
          p: p,
          fromWhichScreenData: fromWhichScreen == "3" ? "6" : fromWhichScreen,
          context: context,
        );
      } catch (e) {}
    } catch (e) {
      print("error message ${e}");
      return;
    }
  }

  displayPrediction(
      {Prediction p, String fromWhichScreenData, BuildContext context}) async {
    try {
      if (p != null) {
        var placeId = p.placeId;
        PlacesDetailsResponse detail =
            await _places.getDetailsByPlaceId(placeId);

        double lat = detail.result.geometry.location.lat.toDouble();
        double lng = detail.result.geometry.location.lng.toDouble();

        print(lat);
        print(lng);
        showLog("ValueFromConfrim11--${fromWhichScreenData}");

        Navigator.pushNamed(
            context, //mapScreen,
            changeUserAddressScreen,
            arguments: {
              fromWhichScreen:
                  fromWhichScreenData == "5" ? "2" : fromWhichScreenData,
              latKey: lat.toString(),
              longKey: lng.toString(),
            }).then((value) => {
              showLog("ValueFromConfrim --${value}"),
              if (value != null)
                {
                  Navigator.pop(context, value),
                }
              else
                {
                  updateAddressAfterBackPress(),
                },
            });
//        if (fromWhichScreenData == "6") {
//
//        } else {
//          Navigator.pushNamed(
//              context, //mapScreen,
//              changeUserAddressScreen,
//              arguments: {
//                fromWhichScreen:
//                    fromWhichScreenData == "5" ? "2" : fromWhichScreenData,
//                latKey: lat.toString(),
//                longKey: lng.toString(),
//              }).then((value) => {
//                showLog("ValueFromConfrim --${value}"),
//                if (value != null)
//                  {
//                    if (value == "null")
//                      {
//                        Navigator.pop(context, value),
//                      }
//                    else
//                      {}
//                  }
//                else
//                  {
//                    updateAddressAfterBackPress(),
//                  }
//              });
//        }

        //var address = await Geocoder.local.findAddressesFromQuery(p.description);

//        List<Placemark> address =
//            await geolocator.placemarkFromCoordinates(lat, lng);
//
//        Placemark place = address[0];
//
//        location =
//            place.subLocality == '' ? place.name : place.subLocality + ', ';
//
//        if (place.thoroughfare != null) {
//          location = location + place.thoroughfare + ', ';
//        }
//
//        location =
//            place.locality != null ? location + " " + place.locality : "";
//
//        showLog("editGivenAddressFromLatLng -- ${location}");
      }
    } catch (e) {
      print(e);
    }
    // return location;
  }

//  Future<Null> displayPrediction(Prediction p) async {
//    if (p != null) {
//      PlacesDetailsResponse detail =
//          await _places.getDetailsByPlaceId(p.placeId);
//
//      var placeId = p.placeId;
//      double lat = detail.result.geometry.location.lat;
//      double lng = detail.result.geometry.location.lng;
//
//      var address = await Geocoder.local.findAddressesFromQuery(p.description);
//
//      print(lat);
//      print(lng);
//      print(address);
//    }
//  }

  updateLoader(bool value) {
    isLoading = value;
    notifyListeners();
  }

  _openBox(String type) async {
    await Hive.openBox<AAddress>(type);
    return Hive.box<AAddress>(type);
  }

  saveAddressInDB(List<AAddress> addressResponse) async {
    await initBox();
    showLog("${addressResponse.length}");
    await saveEditAddressBox.addAll(addressResponse);
    showLog("saveAddressInDB -${saveEditAddressBox.values.toList().length}");

    listOfAddress = saveEditAddressBox.values.toList();
    showLog("saveAddressInDBxx -${listOfAddress.length}");

    notifyListeners();
  }

  updateAddressInSpecificIndex({AAddress address, int index}) async {
    saveEditAddressBox.put(index, address);
    listOfAddress = saveEditAddressBox.values.toList();
    notifyListeners();
  }

  updateAddressAfterBackPress() async {
    listOfAddress = saveEditAddressBox.values.toList();

//    if (index != null) {
//      // saveEditAddressBox.put(index,);
//    }

    notifyListeners();
  }

  editAddressExistsInDeliveryAddressDataFromPref(
      {DeliveryAddressSharedPrefModel data, String oldAddress}) async {
    await initPref();
    showLog(
        "editAddressExistsInDeliveryAddressDataFromPref1-- ${data.address}-- ${data.city}-- ${oldAddress}");

    if (prefs.containsKey(SharedPreferenceKeys.deliveryDataSharedPrefKey)) {
      deliveryData = DeliveryAddressSharedPrefModel.fromJson(
        await json.decode(
            prefs.getString(SharedPreferenceKeys.deliveryDataSharedPrefKey) ??
                ""),
      );

      showLog(
          "editAddressExistsInDeliveryAddressDataFromPref-- ${deliveryData.address}-- ${data.address}");
      if (deliveryData.address == oldAddress) {
        showLog(
            "editAddressExistsInDeliveryAddressDataFromPref11--${oldAddress} -- ${deliveryData.address}-- ${data.address}");
        prefs.setString(
          SharedPreferenceKeys.deliveryDataSharedPrefKey,
          json.encode(data),
        );
      }

      //givenAddressForDelivery = deliveryData.address;
    }
  }

  updateAddressInDB(List<AAddress> addressResponse, String addressID) async {
    await initBox();
    listOfAddress = saveEditAddressBox.values.toList();
    showLog("updateAddressInDB-- ${addressResponse}-- $accessToken");

    listOfAddress.asMap().forEach((key, value) {
      if (value.id == int.parse(addressID)) {
        showLog("updateAddressInDB-- ${listOfAddress.length}-- $accessToken");
        saveEditAddressBox.put(key, addressResponse[0]);
      }
    });

    notifyListeners();
  }

  deleteAddressFromDb(String addressID) async {
    await initBox();
    listOfAddress = saveEditAddressBox.values.toList();
    listOfAddress.asMap().forEach((key, value) {
      if (value.id == int.parse(addressID)) {
        saveEditAddressBox.deleteAt(key);
      }
    });
    listOfAddress = saveEditAddressBox.values.toList();
    notifyListeners();
  }

  updateAddressList(int index) async {
    showLog("updateAddressList--${index}");
    listOfAddress = saveEditAddressBox.values.toList();
    listOfAddress.removeAt(index);

    //listOfAddress = saveEditAddressBox.values.toList();
    notifyListeners();
  }

  saveUserCurrentLocationFromFoodStarMenu(
      {String lat, String long, String address, String addressType}) async {
    await initPref();
    prefs.setString(SharedPreferenceKeys.latitude, lat);
    prefs.setString(SharedPreferenceKeys.longitude, long);
    prefs.setString(SharedPreferenceKeys.currentLocationMarked, address);
    prefs.setString(SharedPreferenceKeys.addressType, addressType);

//    await dbHelper.deleteTableRecordsAfterLogout(
//        DbStatics.tableTopAndRecentSearchedKeyWords);

    prefs.remove(SharedPreferenceKeys.city);
  }

  initSavedAddressRequest({BuildContext context}) async {
    //loggedin
    await initBox();
    showLog("listOfAddress22-- ${listOfAddress.length}-- $accessToken");
    if (accessToken.isNotEmpty) {
      listOfAddress = saveEditAddressBox.values.toList();
      showLog("listOfAddress221-- ${listOfAddress.length}-- $accessToken");

      if (listOfAddress.isNotEmpty) {
        listOfAddress = saveEditAddressBox.values.toList();
        showLog("listOfAddress22-- ${listOfAddress.length}");
        callAllAddressApi(context);
      } else {
        setState(BaseViewState.Busy);

        await callAllAddressApi(context);
        setState(BaseViewState.Idle);
      }
      notifyListeners();
    }
  }

  callAllAddressApi(BuildContext mContext) async {
    try {
      await ApiRepository(mContext: context)
          .initSavedAddressRequest(staticMapValue: {
        latitudeKey: lat,
        longitudeKey: long,
        userTypeKey: user,
      }, mContext: mContext).then((value) => {
                // listOfAddress = value.aAddress,
                saveListOfAddressInDb(value.aAddress),
                showLog("ListofAddresses -- ${listOfAddress}"),
              });
    } catch (e) {
      showLog("ListofAddressese -- ${e}");
    }
  }

  saveListOfAddressInDb(List<AAddress> value) async {
    await initBox();
    await saveEditAddressBox.clear();
    //showLog("saveListOfAddressInDb -- ${value.length}");
    await saveEditAddressBox.addAll(value);

    listOfAddress = saveEditAddressBox.values.toList();
    showLog("saveListOfAddressInDb1 -- ${listOfAddress.length}");
    notifyListeners();
  }

  initBox() async {
    if (saveEditAddressBox == null || !saveEditAddressBox.isOpen) {
      try {
        showLog("saveListOfAddressInDb11");
        saveEditAddressBox = Hive.box<AAddress>(savedEditAddressHive);
      } catch (e) {
        showLog("saveListOfAddressInDb155");
        saveEditAddressBox = await _openBox(savedEditAddressHive);
      }
    } else {
      saveEditAddressBox = Hive.box<AAddress>(savedEditAddressHive);
    }
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }
}
