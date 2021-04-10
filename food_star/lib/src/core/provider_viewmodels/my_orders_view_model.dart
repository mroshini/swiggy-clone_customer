import 'package:flutter/material.dart';
import 'package:foodstar/src/constants/api_urls.dart';
import 'package:foodstar/src/constants/sharedpreference_keys.dart';
import 'package:foodstar/src/core/models/api_models/my_orders_api_model.dart';
import 'package:foodstar/src/core/provider_viewmodels/common/base_change_notifier_model.dart';
import 'package:foodstar/src/core/service/api_repository.dart';
import 'package:foodstar/src/core/service/database/database_helper.dart';
import 'package:foodstar/src/core/service/hive_database/hive_constants.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyOrdersViewModel extends BaseChangeNotifierModel {
  BuildContext context;
  String accessToken;
  SharedPreferences prefs;
  DBHelper dbHelper;
  List<AOrder> aOrder = [];
  Box myOrdersBox;

  MyOrdersViewModel({this.context});

  getLoginInfo() async {
    await initPref();
    accessToken = prefs.getString(SharedPreferenceKeys.accessToken) ?? "";
  }

  initPref() async {
    if (prefs == null) prefs = await SharedPreferences.getInstance();
  }

  initApiMyOrdersApiCall(BuildContext context) async {
//    if (isFavouritesBoxExists) {
//      favouritesBox = await Hive.openBox<ARestaurant>(favouritesHive);
//      aRestaurant = favouritesBox.values.toList();
//    } else {
//      favouritesBox = Hive.box<ARestaurant>(favouritesHive);
//      aRestaurant = favouritesBox.values.toList();
//    }
//

    try {
      myOrdersBox = Hive.box<AOrder>(myOrdersHive);
    } catch (e) {
      myOrdersBox = await Hive.openBox<AOrder>(myOrdersHive);
    }

    aOrder = myOrdersBox.values.toList();

    if (aOrder.isNotEmpty) {
      // aRestaurant = favouritesBox.values;
      callMyOrdersApi(context);
    } else {
      setState(BaseViewState.Busy);
      await callMyOrdersApi(context);
      setState(BaseViewState.Idle);
    }

    notifyListeners();

    return null;
  }

  callMyOrdersApi(BuildContext mContext) async {
    try {
      await ApiRepository(mContext: context)
          .myOrdersApiModel(mContext)
          .then((value) async => {
                if (value != null)
                  {
                    // aOrder = value.aOrder,
                    await myOrdersBox.clear(),
                    await myOrdersBox.addAll(value.aOrder),
                    aOrder = myOrdersBox.values.toList(),
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
