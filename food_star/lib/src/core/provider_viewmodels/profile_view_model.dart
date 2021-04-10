import 'dart:io';

import 'package:flutter/material.dart';
import 'package:foodstar/src/constants/api_urls.dart';
import 'package:foodstar/src/constants/sharedpreference_keys.dart';
import 'package:foodstar/src/core/models/api_models/auth_common_response_model.dart';
import 'package:foodstar/src/core/models/api_models/edit_profile_model.dart';
import 'package:foodstar/src/core/models/db_model/profile_db_model.dart';
import 'package:foodstar/src/core/models/sample_models/my_account_data.dart';
import 'package:foodstar/src/core/models/sample_models/my_account_model.dart';
import 'package:foodstar/src/core/provider_viewmodels/auth/auth_view_model.dart';
import 'package:foodstar/src/core/provider_viewmodels/common/base_change_notifier_model.dart';
import 'package:foodstar/src/core/provider_viewmodels/home_restaurant_list_view_model.dart';
import 'package:foodstar/src/core/service/api_repository.dart';
import 'package:foodstar/src/core/service/database/database_helper.dart';
import 'package:foodstar/src/core/service/database/database_statics.dart';
import 'package:foodstar/src/core/service/hive_database/hive_constants.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

//enum ResponseState { initial, loading, success, loaded, error }

class ProfileViewModel extends BaseChangeNotifierModel {
  BuildContext context;
  UserProfileDbModel userInfo;
  SharedPreferences prefs;
  DBHelper dbHelper;
  String name = "";
  String emailAddress = "";
  String number = "";
  String sampleImageSource = "";
  int emailVerifiedStatus = 0;
  int phoneCode = 0;
  String lastUpdatedAt = "0";
  var response;
  String accessToken = "";
  String socialType;
  bool isLogoutButtonClicked = false;
  List<MyAccountHeaderModel> myAccountData = MyAccountData().beforeLogin;
  bool clearAllData = false;
  HomeRestaurantListViewModel homeRestaurantListViewModel;

  ProfileViewModel({this.context}) {
    initDbHelper();

    // getLoginInfo();
  }

  getLoginInfo() async {
    await initPref();
    accessToken = prefs.getString(SharedPreferenceKeys.accessToken) ?? "";
    accessToken = "";
    notifyListeners();
  }

  initDbHelper() {
    dbHelper = DBHelper.instance;
  }

  logoutUser() async {
    await initPref();

    // clearAllData = true;
    // await prefs.remove(SharedPreferenceKeys.accessToken);
    prefs.setString(SharedPreferenceKeys.accessToken, "");

    Provider.of<HomeRestaurantListViewModel>(context, listen: false)
        .accessToken = "";
    await Provider.of<AuthViewModel>(context, listen: false)
        .googleSignIn
        .signOut();
    // await prefs.remove(SharedPreferenceKeys.accessToken);
    await prefs.remove(SharedPreferenceKeys.userId);
    await prefs.remove(SharedPreferenceKeys.givenAddressForDelivery);
    await prefs.remove(SharedPreferenceKeys.errorMsg);
    await prefs.remove(SharedPreferenceKeys.deliveryDataSharedPrefKey);
    await prefs.remove(SharedPreferenceKeys.errorMsg);
    await prefs.remove(SharedPreferenceKeys.paymentType);
    await prefs.remove(SharedPreferenceKeys.availablePromoCoupons);
    await prefs.remove(SharedPreferenceKeys.currentLocation);
    await prefs.remove(SharedPreferenceKeys.currentLocationMarked);

    await dbHelper.deleteTableRecordsAfterLogout(DbStatics.tableProfile);
    await dbHelper.deleteTableRecordsAfterLogout(
        DbStatics.tableTopAndRecentSearchedKeyWords);

    await Hive.deleteBoxFromDisk(favouritesHive);
    await Hive.deleteBoxFromDisk(myOrdersHive);
    await Hive.deleteBoxFromDisk(savedEditAddressHive);
    //clearAllData = false;
    notifyListeners();
  }

  getLogoutData() async {
    accessToken = "";
    showLog("getLogoutData--${accessToken}");
    notifyListeners();
  }

  getUserProfileDetails(BuildContext buildContext) async {
    await initPref();
    setState(BaseViewState.Busy);
    accessToken = prefs.getString(SharedPreferenceKeys.accessToken) ?? "";

    if (accessToken.isNotEmpty) {
      if (socialType == null) {
        myAccountData = MyAccountData().afterLogin;
      } else {
        myAccountData = MyAccountData().afterSocialLogin;
      }

      var response = await getProfileDataFromDb();
      showLog("UserProfileDbModel  ${response}");
      if (lastUpdatedAt == "0") {
        // call api then load data from db
        setState(BaseViewState.Busy);
        await callProfileApi(buildContext);
        await getProfileDataFromDb();
        setState(BaseViewState.Idle);
      } else {
        setState(BaseViewState.Idle);
        await getProfileDataFromDb();
        await callProfileApi(buildContext);
        setState(BaseViewState.Idle);
      }
    } else {
      myAccountData = MyAccountData().beforeLogin;
      setState(BaseViewState.BeforeLogin);
    }

    notifyListeners();

    // await getProfileDataFromDb();
  }

  initPref() async {
    if (prefs == null) prefs = await SharedPreferences.getInstance();
  }

  getProfileDataFromDb() async {
    await dbHelper.getProfileData().then((value) => {
          if (value != null)
            {
              name = value.username,
              lastUpdatedAt = value.updatedAt == "" ? "0" : value.updatedAt,
              emailAddress = value.email,
              emailVerifiedStatus = value.emailVerified,
              sampleImageSource = value.src,
              number = value.phoneNumber.toString(),
              phoneCode = value.phoneCode,
              socialType = value.socialType,
              showLog(
                  "getProfileDataFromDb -- ${name} --${lastUpdatedAt} --${emailVerifiedStatus} ${emailAddress} ${sampleImageSource}-- ${socialType}")
            }
        });

    if (socialType == null) {
      myAccountData = MyAccountData().afterLogin;
    } else {
      myAccountData = MyAccountData().afterSocialLogin;
    }

    notifyListeners();
  }

  callProfileApi(BuildContext buildContext) async {
    //setState(ViewState.Busy);
    try {
      var result = await ApiRepository(mContext: context)
          .userProfileDetailsRequest(updatedAt: lastUpdatedAt, context: context)
          .then((value) async => {
                await storeProfileDataInDb(value),
                await getUserProfileDetails(buildContext)
              });
      return result;
    } catch (e) {
      showLog("AuthViewModel,$e");
      // setState(ViewState.Idle);
      return null;
      //  _showAlertDialog(context: context, errorMessage: e);
    }
  }

  storeProfileDataInDb(dynamic value) async {
    if (value != null) {
      userInfo = UserProfileDbModel(
          username: value.user.username,
          email: value.user.email,
          phoneNumber: value.user.phoneNumber,
          src: value.user.src,
          phoneCode: value.user.phoneCode,
          emailVerified: value.user.emailVerified,
          updatedAt: value.user.updatedAt,
          socialType: value.user.socialType);
      await dbHelper.insert(userInfo.toJson(), DbStatics.tableProfile);
    }
  }

  Future<CommonMessageModel> verifyEmailRequest(
      String emailAddress, BuildContext buildContext) async {
    setState(BaseViewState.Busy);
    try {
      var result = await ApiRepository(mContext: context)
          .verifyEmailRequestFromProfile(emailAddress, buildContext);
      setState(BaseViewState.Idle);
      return result;
    } catch (e) {
      showLog("AuthViewModel,$e");
      setState(BaseViewState.Idle);
      return null;
      //  _showAlertDialog(context: context, errorMessage: e);
    }
  }

  Future<EditProfileApiModel> editProfileRequest(
      {Map<String, dynamic> dynamicAuthMap,
      Map<String, String> staticAuthMap,
      String url,
      int urlType,
      File fileName,
      BuildContext buildContext}) async {
    setState(BaseViewState.Busy);
    try {
      var result = await ApiRepository(mContext: context).editProfileRequest(
          url: url,
          dynamicMapValue: dynamicAuthMap,
          staticAuthMap: staticAuthMap,
          urlType: urlType,
          fileName: fileName,
          context: buildContext);

      setState(BaseViewState.Idle);
      return result;
    } catch (e) {
      showLog("AuthViewModel,$e");
      setState(BaseViewState.Idle);

      return null;
      //  _showAlertDialog(context: context, errorMessage: e);
    }
  }

  String parseErrorMessage(String value) {
    return value.substring(1, value.length - 1);
  }

  logoutApiRequest(
      {Map<String, dynamic> dynamicAuthMap,
      Map<String, String> staticAuthMap,
      String url,
      int urlType,
      File fileName,
      BuildContext buildContext}) async {
    showProgressForLogout(true);
    try {
      var result = await ApiRepository(mContext: context)
          .logoutRequest(context: buildContext)
          .then((value) async => {
                await logoutUser(),
              });

      showProgressForLogout(false);
    } catch (e) {
      showLog("AuthViewModel,$e");
      showProgressForLogout(false);

      //  _showAlertDialog(context: context, errorMessage: e);
    }
  }

  showProgressForLogout(bool value) async {
    isLogoutButtonClicked = value;
    notifyListeners();
  }
}
