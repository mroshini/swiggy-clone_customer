import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:foodstar/src/constants/sharedpreference_keys.dart';
import 'package:foodstar/src/core/models/api_models/user_model.dart';
import 'package:http/http.dart' show Client;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  Client _client = Client();
  SharedPreferences sharedPreferences;

  Future<UserModel> authenticate({
    @required String mobile,
    @required String password,
  }) async {
    var params = Map<String, dynamic>();
    params['mobile'] = mobile;
    params['password'] = password;

//    final response = await _client.post(login, body: params);
//    if (response.statusCode == 200) {
//      var baseObj = BaseModel.fromJson(json.decode(response.body));
//      await persistAuthToken(baseObj.data.token);
//      return baseObj.data.user;
//    } else {
//      return null;
//    }
  }

  Future<void> persistAuthToken(String token) async {
    sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(SharedPreferenceKeys.accessToken, token);
    return;
  }

  Future<String> getAuthToken() async {
    sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(SharedPreferenceKeys.accessToken);
  }

  Future<void> removeAuthToken() async {
    sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove(SharedPreferenceKeys.accessToken);
    return;
  }
}
