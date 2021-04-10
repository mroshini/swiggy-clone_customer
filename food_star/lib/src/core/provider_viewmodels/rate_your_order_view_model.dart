import 'package:flutter/material.dart';
import 'package:foodstar/src/constants/api_urls.dart';
import 'package:foodstar/src/core/models/api_models/auth_common_response_model.dart';
import 'package:foodstar/src/core/provider_viewmodels/common/base_change_notifier_model.dart';
import 'package:foodstar/src/core/service/api_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

//enum ResponseState { initial, loading, success, loaded, error }

class RateYourOrderViewModel extends BaseChangeNotifierModel {
  BuildContext context;
  SharedPreferences prefs;
  String accessToken = "";
  double boyRating = 0.0;
  double restRating = 0.0;

  RateYourOrderViewModel({this.context});

  Future<CommonMessageModel> updateRatingOrSkip(
      {BuildContext buildContext, Map<String, dynamic> dynamicMapValue}) async {
    setState(BaseViewState.Busy);
    CommonMessageModel response;
    try {
      var result = await ApiRepository(mContext: context)
          .updateRatingForOrder(
              dynamicMapValue: dynamicMapValue, context: buildContext)
          .then((value) async => {response = value});
      setState(BaseViewState.Idle);
      return response;
    } catch (e) {
      showLog("AuthViewModel,$e");
      setState(BaseViewState.Idle);
      return null;
    }
  }

  String parseErrorMessage(String value) {
    return value.substring(1, value.length - 1);
  }
}
