import 'package:flutter/material.dart';
import 'package:foodstar/src/constants/sharedpreference_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeManager with ChangeNotifier {
  SharedPreferences prefs;
  bool _darkMode;

  bool get darkMode => _darkMode;

  ThemeManager() {
    _darkMode = false;
    _loadFromPreference();
  }

  changeTheme() {
    _darkMode = !_darkMode;
    _saveToPreference();
    notifyListeners();
  }

  initPref() async {
    if (prefs == null) prefs = await SharedPreferences.getInstance();
  }

  _loadFromPreference() async {
    await initPref();
    _darkMode = prefs.getBool(SharedPreferenceKeys.theme) ?? false;
    notifyListeners();
  }

  _saveToPreference() async {
    await initPref();
    prefs.setBool(SharedPreferenceKeys.theme, _darkMode);
  }
}
