import 'dart:io';

import 'package:flutter/material.dart';
import 'package:foodstar/src/constants/api_params_keys.dart';
import 'package:foodstar/src/constants/api_urls.dart';
import 'package:foodstar/src/constants/sharedpreference_keys.dart';
import 'package:foodstar/src/core/models/api_models/auth_common_response_model.dart';
import 'package:foodstar/src/core/models/api_models/edit_profile_model.dart';
import 'package:foodstar/src/core/models/api_models/login_response_model.dart';
import 'package:foodstar/src/core/models/api_models/register_response_model.dart';
import 'package:foodstar/src/core/models/db_model/country_code_db_model.dart';
import 'package:foodstar/src/core/service/api_repository.dart';
import 'package:foodstar/src/core/service/database/database_helper.dart';
import 'package:foodstar/src/utils/target_platform.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

//enum ResponseState { initial, loading, success, loaded, error }

enum AuthState {
  busy,
  idle,
  onBoard,
  initial,
  authenticated,
  unauthenticated,
  authSkiped,
}

enum ViewState { Idle, Busy }

class AuthViewModel extends ChangeNotifier {
  BuildContext context;
  SharedPreferences prefs;
  AuthState _authState;
  List<Countries> countries = List();
  List<DropdownMenuItem> countriesDropDown = [];
  CountryCodeDBModel countryCodeModel;
  DBHelper dbHelper;
  ViewState _state = ViewState.Idle;
  var response;
  String clientId = "";
  String clientSecret = "";
  String firebaseToken = "sdfdsfsdfsdf";
  var deviceId;
  bool googleSignInClicked = false;
  GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);

  ViewState get state => _state;

  AuthState get authState => _authState;

  AuthViewModel({this.context}) {
    _authState = AuthState.onBoard;
    // _authState = AuthState.unauthenticated;
    //  SharedPreferenceUtils.init();

    _loadFromPreference();
  }

  initPref() async {
    if (prefs == null) prefs = await SharedPreferences.getInstance();
  }

  saveOnBoardWatched() async {
    await initPref();
    prefs.setBool(SharedPreferenceKeys.onboard, true);
    _authState = AuthState.unauthenticated;
    notifyListeners();
  }

  setAuthState(AuthState state) {
    _authState = state;
    _saveToPreference();
    notifyListeners();

    showLog("setAuthState == ${_authState}");
  }

  saveAuthToken(String accessToken, int userId) async {
    await initPref();
    prefs.setString(SharedPreferenceKeys.accessToken, accessToken);
    prefs.setInt(SharedPreferenceKeys.userId, userId);
  }

  _loadFromPreference() async {
    await initPref();
    var accessToken = prefs.getString(SharedPreferenceKeys.accessToken) ?? null;
    var isAuthSkipped =
        prefs.getBool(SharedPreferenceKeys.loginSkipped) ?? false;

    showLog(
        "onboard == ${prefs.getBool(SharedPreferenceKeys.onboard) ?? false}");

    if (prefs.getBool(SharedPreferenceKeys.onboard) ?? false) {
      if (accessToken == null && isAuthSkipped) {
        _authState = AuthState.authSkiped;
      } else if (accessToken != null) {
        _authState = AuthState.authenticated; // show main with auth
      } else if (accessToken == null &&
          _authState == AuthState.unauthenticated) {
        _authState = AuthState.unauthenticated; // show login
      }
    } else {
      _authState = AuthState.onBoard;
    }

    showLog("_authState == ${_authState} ${accessToken}");
    notifyListeners();
  }

  _saveToPreference() async {
    await initPref();

    prefs.setBool(SharedPreferenceKeys.loginSkipped,
        _authState == AuthState.authSkiped ? true : false);

    showLog("_saveToPreference == ${_authState}");
  }

  getAuthCoreData() async {
    await initPref();
    clientId = CLIENTID; //prefs.getString(SharedPreferenceKeys.clientId) ?? "";
    clientSecret =
        CLIENTSECRET; //prefs.getString(SharedPreferenceKeys.clientSecret) ?? "";
    firebaseToken =
        prefs.getString(SharedPreferenceKeys.firebaseToken) ?? "dfdsfdsfsdf";
    deviceId = await fetchDeviceId();
  }

  Future<LoginResponseModel> signInWithGoogle(BuildContext context) async {
    try {
      setGoogleSignInLoader(true);
      var result;
      await googleSignIn.signIn();

      await initLoginRequest(
              dynamicAuthMap: {
            userNameKey: googleSignIn.currentUser.displayName,
            emailKey: googleSignIn.currentUser.email,
            groupIdKey: groupId,
            deviceKey: fetchTargetPlatform(),
            deviceIDKey: deviceId,
            userTypeKey: userType,
            mobileTokenKey: firebaseToken ?? " ",
            clientIdKey: clientId,
            clientSecretKey: clientSecret,
            grantTypeKey: passwordKey,
            socialTypeKey: google,
            socialIDKey: googleSignIn.currentUser.id,
            socialMediaImageKey: googleSignIn.currentUser.photoUrl,
          },
              url: socialLogin,
              urlType: post,
              context: context,
              fromGoolgleSignIn: true)
          .then(
        (value) => result = value,
      );
      setGoogleSignInLoader(false);
      return result;
    } catch (err) {
      print(err);
      setGoogleSignInLoader(false);
      return null;
    }
  }

  setGoogleSignInLoader(bool value) {
    googleSignInClicked = value;
    notifyListeners();
  }

  getCountriesDatFromTable() async {
    dbHelper = DBHelper.instance;
    await dbHelper.getCountriesDetails().then((value) => {
          showLog("getCountriesDatFromTable ${value.aCountries[0].name}"),
          for (int i = 0; i <= value.aCountries.length - 1; i++)
            {
              countriesDropDown.add(
                new DropdownMenuItem(
                  child: new Text(
                    "${value.aCountries[i].phoneCode} ${countryCodeModel.aCountries[i].name}",
                  ),
                  value: countryCodeModel.aCountries[i].phoneCode,
                ),
              ),
              countries.add(
                Countries(
                  id: value.aCountries[i].id,
                  name: value.aCountries[i].name,
                  phoneCode: value.aCountries[i].phoneCode,
                ),
              ),
            },
          showLog("getCountriesDatFromTable $countries"),
          countries.forEach((element) {
            showLog("countriesgetCountriesDatFromTable ${element.name}");
          })
        });
  }

  void setState(ViewState viewState) {
    _state = viewState;
    showLog("state: $viewState");
    notifyListeners();
  }

  Future<CommonMessageModel> initAuthApiRequest({
    Map<String, dynamic> dynamicAuthMap,
    Map<String, String> staticAuthMap,
    String url,
    int urlType,
    BuildContext parentContext,
  }) async {
    setState(ViewState.Busy);
    try {
      var result = await ApiRepository(mContext: context).authApiRequest(
          url: url,
          dynamicMapValue: dynamicAuthMap,
          staticMapValue: staticAuthMap,
          urlType: urlType,
          model: 3,
          context: parentContext);
      setState(ViewState.Idle);
      return result;
    } catch (e) {
      showLog("AuthViewModel,$e");
      // DialogHelper.showErrorDialog(context, errorMessage(e));
      setState(ViewState.Idle);
      return null;
      //  _showAlertDialog(context: context, errorMessage: e);
    }
  }

  Future<RegisterResponseModel> initRegisterApiRequest({
    Map<String, dynamic> dynamicAuthMap,
    Map<String, String> staticAuthMap,
    String url,
    int urlType,
    BuildContext context,
  }) async {
    setState(ViewState.Busy);
    try {
      var result = await ApiRepository(mContext: context).authApiRequest(
        url: url,
        dynamicMapValue: dynamicAuthMap,
        staticMapValue: staticAuthMap,
        urlType: urlType,
        model: 1,
        context: context,
      );

      setState(ViewState.Idle);
      return result;
    } catch (e) {
      showLog("AuthViewModel,$e");
      // DialogHelper.showErrorDialog(context, errorMessage(e));
      setState(ViewState.Idle);
      return null;
      //  _showAlertDialog(context: context, errorMessage: e);
    }
  }

  Future<EditProfileApiModel> editProfileRequest({
    Map<String, dynamic> dynamicAuthMap,
    Map<String, String> staticAuthMap,
    String url,
    int urlType,
    File fileName,
  }) async {
    setState(ViewState.Busy);
    try {
      var result = await ApiRepository(mContext: context).editProfileRequest(
        url: url,
        dynamicMapValue: dynamicAuthMap,
        staticAuthMap: staticAuthMap,
        urlType: urlType,
        fileName: fileName,
      );

      setState(ViewState.Idle);
      return result;
    } catch (e) {
      showLog("AuthViewModel,$e");
      // DialogHelper.showErrorDialog(context, errorMessage(e));
      setState(ViewState.Idle);
      return null;
      //  _showAlertDialog(context: context, errorMessage: e);
    }
  }

  Future<LoginResponseModel> initLoginRequest({
    Map<String, dynamic> dynamicAuthMap,
    Map<String, String> staticAuthMap,
    String url,
    int urlType,
    BuildContext context,
    bool fromGoolgleSignIn = false,
  }) async {
    if (!fromGoolgleSignIn) {
      setState(ViewState.Busy);
    }
    try {
      var result = await ApiRepository(mContext: context).authApiRequest(
        url: url,
        dynamicMapValue: dynamicAuthMap,
        staticMapValue: staticAuthMap,
        urlType: urlType,
        model: 2,
        context: context,
      );
      setState(ViewState.Idle);
      return result;
    } catch (e) {
      showLog("AuthViewModel,$e");
      // DialogHelper.showErrorDialog(context, errorMessage(e));
      setState(ViewState.Idle);
      return null;
      //  _showAlertDialog(context: context, errorMessage: e);
    }
  }

  String errorMessage(error) {
    var errorMessage = error.toString();
    return errorMessage.substring(1, errorMessage.toString().length - 1);
  }

  void _showAlertDialog({BuildContext context, String errorMessage}) {
    // flutter defined function

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
            'error',
            style: Theme.of(context).textTheme.display1,
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog

            FlatButton(
              child: new Text("ok"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
