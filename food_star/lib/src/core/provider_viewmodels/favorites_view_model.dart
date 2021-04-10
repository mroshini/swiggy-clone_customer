import 'package:flutter/material.dart';
import 'package:foodstar/src/constants/api_urls.dart';
import 'package:foodstar/src/constants/sharedpreference_keys.dart';
import 'package:foodstar/src/core/models/api_models/favorites_restaurant_api_model.dart';
import 'package:foodstar/src/core/provider_viewmodels/common/base_change_notifier_model.dart';
import 'package:foodstar/src/core/service/api_repository.dart';
import 'package:foodstar/src/core/service/database/database_helper.dart';
import 'package:foodstar/src/core/service/hive_database/hive_constants.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesViewModel extends BaseChangeNotifierModel {
  BuildContext context;
  String accessToken;
  List<ARestaurant> aRestaurant = [];
  FavoritesRestaurantApiModel favoritesRestaurantApiModelData;
  Box favouritesBox;

  SharedPreferences prefs;
  DBHelper dbHelper;

  FavoritesViewModel({this.context}) {
    initDbHelper();
    // getLoginInfo();
  }

  getLoginInfo() async {
    await initPref();
    accessToken = prefs.getString(SharedPreferenceKeys.accessToken) ?? "";
  }

  initDbHelper() {
    dbHelper = DBHelper.instance;
  }

  initPref() async {
    if (prefs == null) prefs = await SharedPreferences.getInstance();
  }

  updateAfterBackPress() async {
    aRestaurant = favouritesBox.values.toList();
    notifyListeners();
  }

  initApiFavoritesApiCall(BuildContext context) async {
//    if (isFavouritesBoxExists) {
//      favouritesBox = await Hive.openBox<ARestaurant>(favouritesHive);
//      aRestaurant = favouritesBox.values.toList();
//    } else {
//      favouritesBox = Hive.box<ARestaurant>(favouritesHive);
//      aRestaurant = favouritesBox.values.toList();
//    }
//

    if (favouritesBox == null) {
      try {
        favouritesBox = Hive.box<ARestaurant>(favouritesHive);
      } catch (e) {
        favouritesBox = await Hive.openBox<ARestaurant>(favouritesHive);
      }
    }

    aRestaurant = favouritesBox.values.toList();

    if (aRestaurant.isNotEmpty) {
      // aRestaurant = favouritesBox.values;
      callFavouritesApi(context);
    } else {
      setState(BaseViewState.Busy);
      await callFavouritesApi(context);
      setState(BaseViewState.Idle);
    }

    notifyListeners();

    return null;
  }

  callFavouritesApi(BuildContext context) async {
    try {
      await ApiRepository(mContext: context)
          .favoritesRestaurantRequest(context)
          .then((value) async => {
                if (value != null)
                  {
                    // aRestaurant = value.aRestaurant,
                    await favouritesBox.clear(),
                    await favouritesBox.addAll(value.aRestaurant),
                    aRestaurant = favouritesBox.values.toList(),
                    showLog(
                        "DataoffavoritesRestaurantApiModel1 --${aRestaurant}"),
                  }
              });
    } catch (e) {
      showLog("DataoffavoritesRestaurantApiModel2 --${e}");
    }
    notifyListeners();
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }
}
