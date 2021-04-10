import 'dart:io';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:foodstar/src/constants/api_params_keys.dart';
import 'package:foodstar/src/constants/api_urls.dart';
import 'package:foodstar/src/constants/route_path.dart';
import 'package:foodstar/src/constants/sharedpreference_keys.dart';
import 'package:foodstar/src/core/models/api_models/auth_common_response_model.dart';
import 'package:foodstar/src/core/service/app_exception.dart';
import 'package:foodstar/src/ui/shared/show_snack_bar.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiBaseHelper {
  var header = {'Accept': 'application/json', 'Authorization': ''};
  var response;
  var _accessToken = "";
  SharedPreferences prefs;

  //bool _isFetching = false;

  //bool get isFetching => _isFetching;

  //await Future.wait(waitList);

  apiRequest(
      {String url,
      Map<String, dynamic> dynamicMapValue,
      Map<String, String> staticMapValue,
      int urlType,
      File fileName,
      BuildContext context}) async {
    //pr = new ProgressDialog(context, type: ProgressDialogType.circle);

    if (url == cartAction && dynamicMapValue[actionKey] == deleteItem) {}

    var prefs = await SharedPreferences.getInstance();
    _accessToken = prefs.getString('${SharedPreferenceKeys.accessToken}') ?? '';

    try {
      header['Authorization'] = 'Bearer $_accessToken';
      showLog(
          'Api Request: Url:$baseUrl$url, dynamicMapValue:$dynamicMapValue,staticMapValue:${staticMapValue}, headers:$header }');

      if (urlType == 1) {
        response = await http.post('$baseUrl$url',
            body: dynamicMapValue, headers: header);
      } else if (urlType == 2) {
        final uri = Uri.https(
            '$baseUrlGetRequest', '$baseGetUrlPath$url', staticMapValue);
        response = await http.get(uri, headers: header);
      } else if (urlType == 3) {
        response = await http.put('$baseUrl$url',
            body: dynamicMapValue, headers: header);
      } else if (urlType == 4) {
        if (dynamicMapValue[imageFilePathKey] != "") {
          var request =
              http.MultipartRequest('POST', Uri.parse('$baseUrl$url'));
          request.headers.addAll(header);
          request.fields[userNameKey] = dynamicMapValue[userNameKey];
          request.fields[emailKey] = dynamicMapValue[emailKey];
          request.fields[phoneCodeKey] = dynamicMapValue[phoneCodeKey];
          request.fields[phoneNumberKey] = dynamicMapValue[phoneNumberKey];
          request.fields[userTypeKey] = dynamicMapValue[userTypeKey];

          var filePath = dynamicMapValue[imageFilePathKey];

          // MultipartFile.fromPath(key, path)

          showLog(
              "${filePath} -- ${request.fields[userNameKey]} -- ${request.fields[emailKey]} --${request.fields[phoneNumberKey]} ");

          request.files
              .add(await http.MultipartFile.fromPath(avatarKey, filePath));

          showLog("MultipartFile -- ${request}");

          var streamedResponse = await request.send();
          response = await http.Response.fromStream(streamedResponse);
        } else {
          showLog("ElseMultipartFile -- ${dynamicMapValue}");
          response = await http.post('$baseUrl$url',
              body: dynamicMapValue, headers: header);
        }
      } else {
        response = await http.post('$baseUrl$url',
            body: dynamicMapValue, headers: header);
      }

      showLog('Response status: ${response.statusCode}');
      showLog('Response body: ${response.body}');

      return _returnResponse(
          response: response,
          url: url,
          from: 1,
          context: context,
          map: dynamicMapValue,
          staticMap: staticMapValue);
    } on SocketException catch (e) {
      showLog('No network connection11--${e}');
      showSnackbar(message: 'No network connection', context: context);
    } catch (e) {
      showLog('No network connection--${e}');
      if (e.toString().startsWith("SocketException")) {
        showLog('No network connection11--${e}');
        showSnackbar(message: 'No network connection', context: context);
      }

      //showSnackbar(message: 'No network connection', context: context);
      // throw (SocketException());

      // customSnackBar(context: context, title: "", message: "");
      // throw SocketException("No network connection");
//      return _checkConnectivity(
//          url: url,
//          dynamicMap: dynamicMapValue,
//          staticMap: staticMapValue,
//          context: context);
    }
  }

  dynamic _returnResponse(
      {http.Response response,
      String url,
      int from,
      BuildContext context,
      showProgress,
      Map<String, dynamic> map,
      Map<String, String> staticMap}) {
    switch (response.statusCode) {
      case 200:
        var responseJson = response.body;
        return responseJson != null ? responseJson : '';
      case 201:
        var responseJson = response.body;
        return responseJson != null ? responseJson : '';
      case 304:
        throw {showLog('no update available'), response.toString()};
      case 422:
//        var errorMessage= _showCommonErrorMessage(response.body);
        var errorMessage;
//        errorMessage.then((response) {
//          showLog('errorMessage11: ${response.message}');
//          DialogHelper.showErrorDialog(context, response.message);
//
//          Fluttertoast.showToast(
//              msg: "${response.message}",
//              toastLength: Toast.LENGTH_LONG,
//              gravity: ToastGravity.CENTER,
//              timeInSecForIosWeb: 1,
//              backgroundColor: Colors.grey[300],
//              textColor: Colors.black,
//              fontSize: 16.0);
//        });
        return _showCommonErrorMessage(response.body).then((value) => {
              errorMessage = value.message,
              throw {BadRequestException(errorMessage.toString())}
            });

//        throw BadRequestException(errorMessage.toString());

      case 401:
        removeAccessToken();
        Navigator.pushReplacementNamed(context, login);
        return null;
//        break;
//
//      // throw response.toString();
//      case 403:
//        throw {
//          UnauthorisedException(response.body.toString()),
//        };
//      case 426:
//        {
//          showLog(
//              "inside api handler : error response 426 api version changed");
//          showLog(
//              "inside api handler : error response 426 api version changed");
//          break;
//        }
      case 500:
        throw {
          // customSnackBar(context: context, title: "", message: ""),
        };
      default:
//        throw FetchDataException(
//            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
        showLog('no update available  ${response.body}');
    }
  }

  removeAccessToken() async {
    await initPref();

    prefs.setString(SharedPreferenceKeys.accessToken, "");
  }

  initPref() async {
    if (prefs == null) prefs = await SharedPreferences.getInstance();
  }

  Future<CommonMessageModel> _showCommonErrorMessage(response) {
    return compute(commonMessageModelFromJson, response);
  }

  _showAlertDialog({BuildContext context, String errorMessage}) async {
    // flutter defined function
/*
    showDialog(
      context: context,
      builder: (context) {
        // return object of type Dialog

        return AlertDialog(
          title: new Text(
            errorMessage,
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
    );*/
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Error message'),
          );
        });
  }

  _checkConnectivity(
      {String url,
      Map<String, dynamic> dynamicMap,
      Map<String, String> staticMap,
      BuildContext context}) async {
    // Simple check to see if we have internet
    showLog("The statement 'this machine is connected to the Internet' is: ");
    showLog(await DataConnectionChecker().hasConnection);
    // returns a bool

    // We can also get an enum value instead of a bool
    showLog(
        "Current status: ${await DataConnectionChecker().connectionStatus}");
    // showLogs either DataConnectionStatus.connected
    // or DataConnectionStatus.disconnected

    // This returns the last results from the last call
    // to either hasConnection or connectionStatus
    showLog("Last results: ${DataConnectionChecker().lastTryResults}");

    // actively listen for status updates
    // this will cause DataConnectionChecker to check periodically
    // with the interval specified in DataConnectionChecker().checkInterval
    // until listener.cancel() is called
    var listener = DataConnectionChecker().onStatusChange.listen((status) {
      switch (status) {
        case DataConnectionStatus.connected:
//          {
//            showLog('Data connection is available.');
//            customSnackBar(
//              context: context,
//              title:   S.of(context).connection_available,
//              message: S.of(context).kindly_restart_the_app_if_not_connected);
//            return RestartWidget.restartApp(context);
//          }
          break;
        case DataConnectionStatus.disconnected:
          showLog('You are disconnected from the internet.');
          break;
      }
    });

    // close listener after 30 seconds, so the program doesn't run forever
    await Future.delayed(Duration(seconds: 30), () => listener.cancel());
  }

//  Future<LoginModel> _refreshToken(url, map, BuildContext context) async {
//    var prefs = await SharedPreferences.getInstance();
//
//    var _refreshToken = prefs.getString('$refreshTokenKey') ?? '';
//    var _clientId = prefs.getInt('$clientIdSharedPreferenceKey') ?? 0;
//    var _clientSecret =
//        prefs.getString('$clientSecretSharedPreferenceKey') ?? '';
//
//    var refreshTknMap = {
//      'refresh_token': _refreshToken,
//      'client_id': _clientId.toString(),
//      'client_secret': _clientSecret,
//      'grant_type': 'refresh_token',
//    };
//
//    showLog('Refresh token Api Request: Url:$baseUrl$refreshTokenUrl, '
//        'Body:$refreshTknMap, headers:$header}');
//
//    var responseData = await http.post('$baseUrl$refreshTokenUrl',
//        body: refreshTknMap, headers: header);
//
//    showLog('Response status: ${responseData.statusCode}');
//    showLog('Response body: ${responseData.body}');
//
//    if (responseData.statusCode == 200) {
//      return compute(loginModelFromJson, responseData.body);
//    }
//    if (responseData.statusCode == 401) {
//      customSnackBar(
//        context: context,
//        title:   S.of(context).session_expired,
//        message: S.of(context).please_login_again);
//
//
//        removeValues(context, DbHelper.instance,deletePhotos: false);
//
//
//
//      await Future.delayed(Duration(seconds: 2), () {
//         Navigator.pop(context);
//        SideDrawerModel drawerChild =
//        Provider.of<SideDrawerModel>(context, listen: false);
//         return drawerChild.setDrawerChild(LoginRoute(), "Login",5);
//      });
//    } else
//      return null;
//  }
}
