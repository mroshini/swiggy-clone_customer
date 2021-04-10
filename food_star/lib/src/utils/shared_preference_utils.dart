import 'dart:async' show Future;

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceUtils {
  static SharedPreferences _prefs;
  static Future<SharedPreferences> get _instance async =>
      _prefs ??= await SharedPreferences.getInstance();

  // call this method from iniState() function of mainApp().
  static Future<SharedPreferences> init() async {
    _prefs = await _instance;
    return _prefs;
  }

  static String getString(String key, [String defValue]) {
    return _prefs.getString(key) ?? defValue ?? "";
  }

  static Future<bool> setString(String key, String value) async {
    var prefs = await _instance;
    return prefs?.setString(key, value) ?? Future.value(false);
  }

  static bool getBool(String key, [String defValue]) {
    return _prefs.getBool(key) ?? defValue ?? false;
  }

  static Future<bool> setBool(String key, bool value) async {
    var prefs = await _instance;
    return prefs?.setBool(key, value) ?? Future.value(false);
  }
}
